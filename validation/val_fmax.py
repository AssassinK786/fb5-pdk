#!/usr/bin/env python3
"""FB5 fT / fMAX extraction (research PDK).

What is measured (not assumed):
  fT   = frequency where the common-emitter short-circuit current gain |h21| = 1.
  fMAX = frequency where Mason's unilateral gain U = 1, from two-port Y parameters
         U = |y21-y12|^2 / (4*(Re y11 * Re y22 - Re y12 * Re y21)).
Y parameters come from two AC runs at the SAME DC bias:
  run A: v1=1 (base), v2=0 (collector AC short) -> y11,y21 and h21
  run B: v1=0 (base AC short), v2=1 (collector) -> y12,y22
Self-check: U computed from Y must equal U computed from Z=inv(Y) (Mason's U is a
two-port invariant); this catches sign / port-orientation mistakes.

All paths are repo-relative; no external scripts or absolute PDK paths are needed.
Usage: python3 val_fmax.py > val_fmax.txt
       python3 val_fmax.py --sensitivity   (extra root-cause parameter sweeps)
"""
import os, re, subprocess, math, tempfile, numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
GP_LIB  = os.path.join(ROOT, 'models', 'fb5_hbt.lib')
VB_LIB  = os.path.join(ROOT, 'models', 'fb5_hbt_vbic.lib')
FREQ    = 'dec 30 1e7 3e11'
VBS     = [0.80, 0.83, 0.85, 0.86, 0.87, 0.88, 0.89, 0.90, 0.92, 0.94]

def model_cards(path):
    s = open(path).read()
    out = {}
    for m in re.finditer(r'\.MODEL\s+(\w+)\s+\w+\s*(level\s*=\s*\d+)?\s*\((.*?)\)', s, re.S):
        out[m.group(1)] = dict(kv.split('=') for kv in m.group(3).split())
    return out

def card(name, p):
    lvl = ' level=4' if name.endswith('_v') else ''
    return f'.MODEL QX NPN{lvl} (' + ' '.join(f'{k}={v}' for k, v in p.items()) + ')'

def parse(path):
    d = {}
    for ln in open(path, errors='ignore'):
        m = re.match(r'^(\d+)\t([-\d.eE+]+)\t([-\d.eE+]+)', ln)
        if m: d[int(m.group(1))] = (float(m.group(2)), float(m.group(3)))
    return d

def ac(tag, modelcard, vb, v1, v2, vce=1.8):
    keys = ['h21', 'y11r', 'y11i', 'y21r', 'y21i'] if v1 == 1 else ['y12r', 'y12i', 'y22r', 'y22i']
    e = {'h21': 'abs(i(Vc)/i(Vb))',
         'y11r': 'real(-i(Vb))', 'y11i': 'imag(-i(Vb))', 'y21r': 'real(-i(Vc))', 'y21i': 'imag(-i(Vc))',
         'y12r': 'real(-i(Vb))', 'y12i': 'imag(-i(Vb))', 'y22r': 'real(-i(Vc))', 'y22i': 'imag(-i(Vc))'}
    ctl = ['op', 'print i(Vc) i(Vb) > op.txt', f'ac {FREQ}']
    for k in keys: ctl.append(f'print frequency {e[k]} > {k}.txt')
    inst = 'Q1 c b 0 0 dt QX' if 'level=4' in modelcard else 'Q1 c b 0 QX'
    deck = (f'* {tag}\n{modelcard}\n{inst}\n'
            f'Vb b 0 DC {vb} AC {v1}\nVc c 0 DC {vce} AC {v2}\n.control\n'
            + '\n'.join(ctl) + '\n.endc\n.end\n')
    with tempfile.TemporaryDirectory() as td:
        sp = os.path.join(td, 'a.sp'); open(sp, 'w').write(deck)
        subprocess.run(['ngspice', '-b', '-o', os.path.join(td, 'log'), sp],
                       cwd=td, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        out = {k: parse(os.path.join(td, k + '.txt')) for k in keys}
        op = open(os.path.join(td, 'op.txt'), errors='ignore').read()
    g = lambda r: abs(float(r.group(1))) if r else float('nan')
    out['ic'] = g(re.search(r'i\(vc\)\s*=\s*([-\d.eE+]+)', op))
    out['ib'] = g(re.search(r'i\(vb\)\s*=\s*([-\d.eE+]+)', op))
    return out

def crossing(f, y, level):
    for i in range(1, len(f)):
        if y[i-1] <= 0 or y[i] <= 0 or y[i-1] == y[i]: continue
        if (y[i-1] - level) * (y[i] - level) <= 0:
            t = math.log(y[i-1] / level) / math.log(y[i-1] / y[i])
            return math.exp(math.log(f[i-1]) + t * math.log(f[i] / f[i-1]))
    return float('nan')

def extract(modelcard, vb, vce=1.8, tag='x'):
    A = ac(tag + 'A', modelcard, vb, 1, 0, vce)
    B = ac(tag + 'B', modelcard, vb, 0, 1, vce)
    idx = sorted(A['h21'])
    f = np.array([A['h21'][i][0] for i in idx]); h = np.array([A['h21'][i][1] for i in idx])
    g = lambda k, d: np.array([d[k][i][1] for i in idx])
    y11 = g('y11r', A) + 1j*g('y11i', A); y21 = g('y21r', A) + 1j*g('y21i', A)
    y12 = g('y12r', B) + 1j*g('y12i', B); y22 = g('y22r', B) + 1j*g('y22i', B)
    Uy = np.abs(y21-y12)**2 / (4*(y11.real*y22.real - y12.real*y21.real))
    Y  = np.moveaxis(np.array([[y11, y12], [y21, y22]]), -1, 0)
    Z  = np.linalg.inv(Y)
    z11, z12, z21, z22 = Z[:,0,0], Z[:,0,1], Z[:,1,0], Z[:,1,1]
    Uz = np.abs(z21-z12)**2 / (4*(z11.real*z22.real - z12.real*z21.real))
    ok = np.isfinite(Uy) & (Uy > 0)
    inv_err = float(np.max(np.abs(Uy[ok]/Uz[ok] - 1)))
    m = (f > 2e10) & (f < 1.2e11) & ok
    slope = -float(np.polyfit(np.log10(f[m]), np.log10(Uy[m]), 1)[0]) if m.sum() > 3 else float('nan')
    return dict(ic=A['ic']*1e3, beta=A['ic']/A['ib'],
                ft=crossing(f, h, 1.0)/1e9, fmax=crossing(f, Uy, 1.0)/1e9,
                fmax_z=crossing(f, Uz, 1.0)/1e9, inv_err=inv_err, slope=slope, f=f, U=Uy)

def main():
    gp = model_cards(GP_LIB); vb = {}
    try: vb = model_cards(VB_LIB)
    except FileNotFoundError: pass
    models = [('fb5npn_hp', gp['fb5npn_hp']), ('fb5npn_hb', gp['fb5npn_hb'])]
    if 'fb5npn_hp_v' in vb:
        models += [('fb5npn_hp_v', vb['fb5npn_hp_v']), ('fb5npn_hb_v', vb['fb5npn_hb_v'])]
    ngver = subprocess.run(['ngspice','-v'], capture_output=True, text=True).stdout
    m = re.search(r'ngspice-[\d.]+', ngver)
    print(f'FB5 HBT fT / fMAX extraction  (VCE 1.8 V, TNOM 27 C, {m.group(0) if m else "unknown"})')
    print('fT  = |h21| = 1 crossing;  fMAX = Mason U = 1 crossing (Y params, 2 AC runs).')
    print('Mason U is a two-port invariant: U(Y) must equal U(Z=invY).')
    print('=' * 100)
    for nm, p in models:
        rows = [extract(card(nm, p), v, tag=nm+str(j)) for j, v in enumerate(VBS)]
        print(f'\n{name_label(nm)}')
        print(f'{"Vb[V]":>6} {"Ic[mA]":>9} {"beta":>7} {"fT[GHz]":>9} {"fMAX[GHz]":>10} {"U(Z)[GHz]":>11}')
        for v, r in zip(VBS, rows):
            print(f'{v:6.2f} {r["ic"]:9.3f} {r["beta"]:7.1f} {r["ft"]:9.2f} {r["fmax"]:10.2f} {r["fmax_z"]:11.2f}')
        pk = max(rows, key=lambda r: r['ft']); pf = max(rows, key=lambda r: r['fmax'])
        print(f'  PEAK fT   {pk["ft"]:.2f} GHz @ Ic {pk["ic"]:.3f} mA (beta {pk["beta"]:.1f}); fMAX there {pk["fmax"]:.2f} GHz')
        print(f'  PEAK fMAX {pf["fmax"]:.2f} GHz @ Ic {pf["ic"]:.3f} mA')
        print(f'  self-check: max|U(Y)/U(Z)-1| = {pk["inv_err"]:.2e}; U high-f rolloff -{pk["slope"]:.2f} dec/dec')
    print('\n' + '=' * 100)
    print('VCE sensitivity (shipped hp GP card, Vb=0.87):')
    for vce in (1.0, 1.5, 1.8, 2.5, 3.0):
        r = extract(card('fb5npn_hp', gp['fb5npn_hp']), 0.87, vce, tag='vce')
        print(f'  VCE {vce:4.1f} V : fT {r["ft"]:7.2f} GHz, fMAX {r["fmax"]:7.2f} GHz')
    print('\nNOTE: fMAX is strongly bias-dependent. IBM publishes peak values at the peak-fT')
    print('current (5HP: Ic ~0.6 mA for a minimum-area device, IBM J. R&D 47(2/3) 2003 Table 2);')
    print('the FB5 unit device peaks near 1 mA, a known current-density gap (IKF not refitted).')
    if '--sensitivity' in __import__('sys').argv: sensitivity(gp['fb5npn_hp'])

def name_label(nm):
    return {'fb5npn_hp':'fb5npn_hp (Gummel-Poon, high-performance)',
            'fb5npn_hb':'fb5npn_hb (Gummel-Poon, high-breakdown)',
            'fb5npn_hp_v':'fb5npn_hp_v (VBIC)',
            'fb5npn_hb_v':'fb5npn_hb_v (VBIC)'}.get(nm, nm)

def sensitivity(base):
    print('\n' + '=' * 100)
    print('ROOT-CAUSE SENSITIVITY (shipped hp card, Vb=0.87, VCE=1.8): one parameter changed at a time')
    cases = [('current card (RB=124)', {}),
             ('RB=77 (OLD card, pre-fix)', {'RB':'77','RBM':'15'}),
             ('RB=100', {'RB':'100','RBM':'20'}),
             ('CJC=6.5f (old fit_hbt.py x1.3)', {'CJC':'6.5f'}),
             ('XCJC=1.0 (all Cjc intrinsic)', {'XCJC':'1.0'}),
             ('CJS=0 (no substrate cap)', {'CJS':'0f'}),
             ('RE=0 RC=0', {'RE':'0','RC':'0'}),
             ('TF+10%', {'TF':'3.08p'})]
    print(f'{"case":38s} {"fT[GHz]":>9} {"fMAX[GHz]":>11} {"Ic[mA]":>9}')
    for nm, ov in cases:
        p = dict(base); p.update(ov)
        r = extract(card('fb5npn_hp', p), 0.87, tag='sens')
        print(f'{nm:38s} {r["ft"]:9.2f} {r["fmax"]:11.2f} {r["ic"]:9.3f}')
    print('\nReading: the OLD fit_hbt.py derived RB = fT/(8*pi*fMAX_target^2*(1.3*CJC)) and')
    print('printed fMAX_target as the result: fMAX was an INPUT, not a measurement. That')
    print('1.3x Cbc fudge forced RB=77 ohm, ~38% below IBM\'s measured Rb(100uA)=124 ohm,')
    print('so the old card really had fMAX 74.4 GHz instead of the claimed 60 GHz.')
    print('The fix: RB=124 ohm from measurement; fMAX is now EXTRACTED (63.9 GHz, IBM: 65).')
    print('CJS (collector-substrate) sits behind RC and adds an f^2 loss the simple')
    print('analytic fMAX=sqrt(fT/(8 pi RB Cbc)) formula ignores.')

if __name__ == '__main__': main()
