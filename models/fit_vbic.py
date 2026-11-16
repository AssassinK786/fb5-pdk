"""FB5 VBIC fit (research PDK). Maps the Gummel-Poon cards of fb5_hbt.lib (fit_hbt.py) to ngspice VBIC (BJT level=4) and adds
avalanche (AVC1/AVC2 tuned for open-base BVceo 3.3 V hp / 5.5 V hb), self-heating (RTH/CTH) and a small substrate parasitic PNP.
Mapping: IBEI=IS/BF, IBEN=ISE, NEN=NE, IBCI=IS/BR, VEF=VAF, VER=VAR, RBX/RBI = 0.3/0.7 of RB, RCX/RCI = 0.3/0.7 of RC,
CJE/PE/ME, CJC/PC/MC, CJCP/PS/MS from CJS/VJS/MJS, TF/XTF/VTF/ITF/TR copied. GP RB current crowding (IRB/RBM) has no VBIC
equivalent (VBIC RBI is modulated by charge, QBM default). ESTIMATE values: RTH 3000/3500 K/W, CTH, ISP, WSP, AVC1=2, RBX/RCX split.
Writes fb5_hbt_vbic.lib; usage: python3 fit_vbic.py > fit_vbic.txt (run from models/).
GP fT targets 47 / 28 GHz from published IBM SiGe 5HP data (see fit_hbt.py docstring)."""
import subprocess, tempfile, re, os, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
GP = open(os.path.join(HERE, 'fb5_hbt.lib')).read()
def gp(name): return dict(kv.split('=') for kv in re.search(rf'\.MODEL {name} NPN \((.*)\)', GP).group(1).split())
def f(x): return float(re.sub(r'([0-9.]+)([a-zA-Z]+)$', lambda m: m.group(1) + {'f':'e-15','p':'e-12','n':'e-9','u':'e-6','m':'e-3','k':'e3'}[m.group(2)[0].lower()], x))
def vbic(g, avc2, rth, cth):
    v = dict(IS=g['IS'], IBEI=f"{f(g['IS'])/f(g['BF']):.4g}", NF=g['NF'], NR=1.0, IKF=g['IKF'], IBEN=g['ISE'], NEN=g['NE'],
             IBCI=f"{f(g['IS'])/f(g['BR']):.4g}", IBCN=g['ISE'], NCN=2.0, IKR=g['IKR'], VEF=g['VAF'], VER=g['VAR'],
             RBX=f"{0.3*f(g['RB']):.3g}", RBI=f"{0.7*f(g['RB']):.3g}", RE=g['RE'], RCX=f"{0.3*f(g['RC']):.3g}", RCI=f"{0.7*f(g['RC']):.3g}",
             CJE=g['CJE'], PE=g['VJE'], ME=g['MJE'], CJC=g['CJC'], PC=g['VJC'], MC=g['MJC'], CJCP=g['CJS'], PS=g['VJS'], MS=g['MJS'],
             TF=g['TF'], XTF=g['XTF'], VTF=g['VTF'], ITF=g['ITF'], TR=g['TR'], AVC1=2.0, AVC2=f'{avc2:.4g}',
             ISP='1e-19', WSP=1.0, NFP=1.0, RS=50, RTH=rth, CTH=cth, EA=1.11, XIS=3, XII=3, XIN=3)
    return v
def card(name, v): return f".MODEL {name} NPN level=4 (" + ' '.join(f'{k}={x}' for k, x in v.items()) + ")"
def run(d, out):
    with tempfile.TemporaryDirectory() as td:
        open(f'{td}/a.sp', 'w').write(d); subprocess.run(['ngspice', '-b', 'a.sp'], cwd=td, capture_output=True)
        return np.loadtxt(f'{td}/{out}', ndmin=2)
# instance: VBIC gets 5 nodes (c b e s dt, substrate grounded); GP 3 nodes
def inst(vb): return 'Q1 c b 0 0 dt QX' if vb else 'Q1 c b 0 QX'
def ftc(cd, vb, ic, vce=1.8):
    lo, hi = 1e-9, 1e-3
    for _ in range(30):
        ib = (lo * hi) ** 0.5
        icx = abs(run(f"* op\n{cd}\nVc c 0 {vce}\nIb 0 b {ib}\n{inst(vb)}\n.control\nop\nwrdata o.txt i(Vc)\n.endc\n.end\n", 'o.txt').ravel()[1])
        lo, hi = (ib, hi) if icx < ic else (lo, ib)
    a = run(f"* ac\n{cd}\nVc c 0 {vce}\nIb 0 b dc {ib} ac 1\n{inst(vb)}\n.control\nac dec 50 1e7 5e11\nwrdata h.txt i(Vc)\n.endc\n.end\n", 'h.txt')
    fr, h = a[:, 0], np.hypot(a[:, 1], a[:, 2]); k = np.where(h < 1)[0]
    return icx, icx / ib, (np.interp(1, [h[k[0]], h[k[0]-1]], [fr[k[0]], fr[k[0]-1]]) if len(k) and k[0] else float('nan'))
def bvceo(cd, vb, ib=1e-6):
    # open-base-like: fixed small IB, sweep VCE; BVceo = VCE where Ic reaches 10x its value at VCE=1 V (runaway)
    a = run(f"* bv\n{cd}\nVc c 0 0\nIb 0 b {ib}\n{inst(vb)}\n.control\ndc Vc 0.5 8 0.02\nwrdata o.txt i(Vc)\n.endc\n.end\n", 'o.txt')
    v, ic = a[:, 0], np.abs(a[:, 1]); i1 = np.interp(1.0, v, ic); k = np.where(ic > 10 * i1)[0]
    return (v[k[0]] if len(k) else float('nan')), v, ic, i1
def gummel(cd, vb):
    a = run(f"* g\n{cd}\nVc c 0 1.0\nVb b 0 0.6\n{inst(vb)}\n.control\ndc Vb 0.6 1.0 0.025\nwrdata o.txt i(Vc) i(Vb)\n.endc\n.end\n", 'o.txt')
    return a[:, 0], np.abs(a[:, 1]), np.abs(a[:, 3])
SPEC = {'fb5npn_hp': (3.3, 3000, '1n', 47), 'fb5npn_hb': (5.5, 3500, '1n', 28)}
out = {}
for nm, (bvt, rth, cth, ftt) in SPEC.items():
    g = gp(nm); lo, hi = 2.0, 60.0                  # BVceo rises with AVC2: bisect
    for _ in range(14):
        a2 = (lo + hi) / 2; bv = bvceo(card('QX', vbic(g, a2, rth, cth)), True)[0]
        lo, hi = (a2, hi) if (bv < bvt or bv != bv) and bv == bv else (lo, a2)
        if bv != bv: hi = a2
    v = vbic(g, a2, rth, cth); tf0 = f(g['TF'])
    for _ in range(3):   # retune TF so VBIC peak fT matches target (VBIC RBI/RCI split and Kirk/qsat shift the peak)
        pk = max(ftc(card('QX', v), True, ic)[2] for ic in (0.7e-3, 1.0e-3, 1.5e-3)) / 1e9
        tf = f(v['TF']) / (1 + (ftt / pk - 1) * 1.3); v['TF'] = f'{tf*1e12:.3g}p'
    out[nm] = v; print(f'  TF retuned {tf0*1e12:.3g}p -> {v["TF"]}')
    print(f'== {nm}: AVC1=2 AVC2={a2:.3g} (tuned for BVceo {bvt} V), RTH={rth} K/W CTH={cth} (ESTIMATE)')
    for lab, cd, vb in (('GP  ', f".MODEL QX NPN ({' '.join(k+'='+x for k,x in g.items())})", False), ('VBIC', card('QX', v), True)):
        rows = [ftc(cd, vb, ic) for ic in (0.3e-3, 0.7e-3, 1.0e-3, 1.5e-3, 3e-3, 6e-3)]
        print(f'  {lab} fT vs Ic (VCE 1.8 V): ' + ', '.join(f'{r[0]*1e3:.1f}mA {r[2]/1e9:.1f}G' for r in rows))
        pk = max(r[2] for r in rows); print(f'  {lab} peak fT {pk/1e9:.1f} GHz ({(pk/1e9/ftt-1)*100:+.1f} % vs {ftt}); beta @1mA {rows[2][1]:.0f}')
        vbe, ic, ib = gummel(cd, vb)
        print(f'  {lab} Gummel (VCE 1 V): ' + ', '.join(f'VBE {x:.2f} Ic {c:.2e} B {c/b:.0f}' for x, c, b in list(zip(vbe, ic, ib))[4::4]))
        bv, vv, icv, i1 = bvceo(cd, vb)
        print(f'  {lab} BVceo (IB 1 uA, Ic=10x Ic@1V={i1*1e6:.0f} uA): {bv:.2f} V; Ic(VCE): ' + ', '.join(f'{x:.1f}V {np.interp(x, vv, icv)*1e3:.2f}mA' for x in (1, 2, 3, 3.3, 4, 5, 5.5, 6, 7)))
    print(flush=True)
L = ['* FB5 SiGe HBT VBIC models (research PDK), ngspice BJT level=4. Generated by fit_vbic.py from the GP cards in fb5_hbt.lib.',
     '* Instance: Qx c b e s dt fb5npn_hp_v  (s = substrate, dt = self-heating thermal node; leave dt floating or tie via 0-ohm to probe).',
     '* ESTIMATE: RTH/CTH, ISP/WSP (substrate PNP), AVC1, RBX/RBI and RCX/RCI splits. Avalanche tuned for BVceo 3.3 V (hp) / 5.5 V (hb).']
for nm, v in out.items(): L.append(card(nm + '_v', v))
open(os.path.join(HERE, 'fb5_hbt_vbic.lib'), 'w').write('\n'.join(L) + '\n')
