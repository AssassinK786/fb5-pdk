"""FB5 CMOS corner cards (research PDK, not a foundry deliverable).

Typical = MOSIS IBM SiGe 5AM/5HP lot T4AB (5AM_NI) BSIM3 card, the median of 20
MOSIS IBM SIGE05 lot reports. Corners = typical +-3 sigma of those same 20 IBM
lots: sigma(Vth_short) N/P = 12/13 mV, sigma(Idss) = 14.5/12.8 uA/um,
sigma(tox) = 1.1 A. VDD = 3.3 V; drawn L >= 0.6 um on the SCMOS lambda=0.30 um grid.

Self-contained: the device measurement helper is implemented here (the original
fit used an external helper script that is not part of this repo). Two modes:
  python3 build_corners.py > build_corners.txt     # verify shipped fb5.lib (default)
  python3 build_corners.py --write                 # regenerate fb5.lib
Verification compares the three fitted parameters (TOX, VTH0, U0) of every
corner/device against fb5.lib; a fresh fit differs only in the 6th digit of
VTH0 because of the Vt interpolation grid, so a 0.1 % tolerance is used and the
validated shipped card is NOT silently overwritten.
"""
import os, re, sys, subprocess, tempfile, numpy as np

HERE = os.path.dirname(os.path.abspath(__file__))
raw = open(os.path.join(HERE, 't4ab_raw.lib')).read()
blk = {t: re.search(rf'(?is)\.model cmos{t} .*?\)', raw).group(0) for t in 'np'}

def dev(card, t, w, l, v):
    """(Vt, Idss[mA]). Vt = constant-current threshold at |Vds|=0.1 V,
    Id = 1e-7*(W/L) A. Idss = |Id| at |Vgs|=|Vds|=v in mA."""
    sgn = 1 if t == 'n' else -1
    model = 'mn' if t == 'n' else 'mp'
    head = (f'* dev\n{card}\nM1 d g s b {model} W={w}u L={l}u\n'
            f'Vd d 0 0\nVg g 0 0\nVs s 0 0\nVb b 0 0\n')
    d = head.replace('Vd d 0 0', f'Vd d 0 {sgn*0.1}')
    d += f'.control\ndc Vg 0 {sgn*1.2} {sgn*0.005}\nwrdata vt.txt i(Vd)\n.endc\n.end\n'
    with tempfile.TemporaryDirectory() as td:
        open(os.path.join(td, 'a.sp'), 'w').write(d)
        subprocess.run(['ngspice', '-b', 'a.sp'], cwd=td, stdout=subprocess.DEVNULL, stderr=subprocess.DEVNULL)
        a = np.loadtxt(os.path.join(td, 'vt.txt'), ndmin=2)
    vg, ids = np.abs(a[:, 0]), np.abs(a[:, 1])
    crit = 1e-7 * (w / l)
    k = int(np.where(ids >= crit)[0][0])
    if k > 0:
        vt = float(np.interp(np.log(crit), np.log(ids[k-1:k+1]), vg[k-1:k+1]))
    else:
        vt = float(vg[k])
    d = head.replace('Vd d 0 0', f'Vd d 0 {sgn*v}').replace('Vg g 0 0', f'Vg g 0 {sgn*v}')
    d += '.control\nop\nprint i(Vd)\n.endc\n.end\n'
    with tempfile.TemporaryDirectory() as td:
        open(os.path.join(td, 'a.sp'), 'w').write(d)
        o = subprocess.run(['ngspice', '-b', 'a.sp'], cwd=td, capture_output=True, text=True).stdout
    m = re.search(r'i\(vd\)\s*=\s*([-\d.eE+]+)', o)
    return vt, (abs(float(m.group(1))) * 1e3 if m else float('nan'))

def setp(b, k, v): return re.sub(rf'(?im)(\b{k}\s*=\s*)([-0-9.eE+]+)', lambda g: g.group(1) + f'{v:.6g}', b, count=1)
def getp(b, k): return float(re.search(rf'(?im)\b{k}\s*=\s*([-0-9.eE+]+)', b).group(1))
SIG = {'n': (0.012, 14.5), 'p': (0.013, 12.8)}; STOX = 1.1e-10
CORN = {'tt': (0, 0, 0), 'ff': (-1, -1, -1), 'ss': (1, 1, 1), 'fs': (-1, 1, 0), 'sf': (1, -1, 0)}
def both(n, p): return n.replace('.MODEL CMOSN', '.model mn').replace('.model cmosn', '.model mn') + '\n' + p.replace('.MODEL CMOSP', '.model mp').replace('.model cmosp', '.model mp')
def meas(n, p, t):
    vt, idd = dev(both(n, p), t, 20, 0.5, 3.3); return vt, idd / 20 * 1e3   # V, uA/um
def params(block): return {k: float(v) for k, v in re.findall(r'([A-Za-z0-9_]+)\s*=\s*([-0-9.eE+]+)', block)}

ref = {t: meas(blk['n'], blk['p'], t) for t in 'np'}
print('typical T4AB card: N Vt %.3f Idss %.0f | P Vt %.3f Idss %.0f uA/um' % (*ref['n'], *ref['p']))
out = {}
for c, (sn, sp, so) in CORN.items():
    b = dict(blk)
    for t, s in (('n', sn), ('p', sp)):
        bb = setp(b[t], 'TOX', getp(b[t], 'TOX') + so * 3 * STOX)
        tv = ref[t][0] + s * 3 * SIG[t][0]; ti = ref[t][1] - s * 3 * SIG[t][1]
        sgn = 1 if t == 'n' else -1
        for it in range(10):
            b2 = dict(b); b2[t] = bb
            vt, idd = meas(b2['n'], b2['p'], t)
            if abs(vt - tv) < 0.002 and abs(idd / ti - 1) < 0.003: break
            bb = setp(bb, 'VTH0', getp(bb, 'VTH0') + sgn * (tv - vt))
            b2[t] = bb; vt, idd = meas(b2['n'], b2['p'], t)
            bb = setp(bb, 'U0', getp(bb, 'U0') * (ti / idd) ** 1.2)
        b[t] = bb
        print(f'{c} {t}: Vt {vt:.3f} (tgt {tv:.3f}) Idss {idd:.1f} (tgt {ti:.1f}) TOX {getp(bb,"TOX")*1e10:.1f} A', flush=True)
    out[c] = b

if '--write' in sys.argv:
    L = ['* FB5 CMOS BSIM3 corners (research PDK, not a foundry deliverable). See build_corners.py.',
         '* Typical = MOSIS IBM SiGe 5AM/5HP lot T4AB (5AM_NI), median of 20 IBM SIGE05 lot reports.',
         '* Corners = typical +-3 sigma of those 20 IBM lots: Vth N/P 12/13 mV, Idss 14.5/12.8 uA/um, tox 1.1 A.',
         '* VDD 3.3 V; drawn L >= 0.6 um (SCMOS lambda 0.30 um). BSIM3v3.1 LEVEL 8, single card per device type.',
         '* Use: .lib "fb5.lib" tt  (or ff ss fs sf); devices fb5n / fb5p (4-terminal), give AS/AD/PS/PD for junction caps.']
    for c, b in out.items():
        L += [f'.lib {c}', b['n'].replace('CMOSN', 'fb5n').replace('cmosn', 'fb5n'), b['p'].replace('CMOSP', 'fb5p').replace('cmosp', 'fb5p'), f'.endl {c}', '']
    open(os.path.join(HERE, 'fb5.lib'), 'w').write('\n'.join(L) + '\n'); print('wrote fb5.lib')
else:
    shipped = open(os.path.join(HERE, 'fb5.lib')).read()
    secs = dict((c, re.search(rf'\.lib {c}\n(.*?)\.endl', shipped, re.S).group(1)) for c in CORN)
    worst = (0.0, '')
    for c, b in out.items():
        for t, key in (('n', 'fb5n'), ('p', 'fb5p')):
            fit = params(b[t]); got = params(re.search(rf'\.MODEL {key} \w+ \((.*?)\)', secs[c], re.S).group(1))
            for k in ('TOX', 'VTH0', 'U0'):
                d = abs(fit[k] - got[k]) / max(abs(got[k]), 1e-30)
                if d > worst[0]: worst = (d, f'{c}/{key}/{k} fit {fit[k]:.6g} vs shipped {got[k]:.6g}')
    print(f'check: max relative deviation of fitted TOX/VTH0/U0 = {worst[0]*100:.4f} % ({worst[1]})')
    print('check: PASS (fb5.lib unchanged)' if worst[0] < 1e-3 else 'check: FAIL (re-run with --write or inspect)')
    sys.exit(0 if worst[0] < 1e-3 else 1)
