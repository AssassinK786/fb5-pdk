"""FB5 HBT small-signal characterization (research PDK). Common emitter, VCE fixed (default 1.8 V = VCB ~1 V as in the IBM tables).
Bias: DC sweep of VBE, interpolated to the target Ic. Two AC runs (ac 1 V on base, then on collector, other port AC-shorted) give
the full Y matrix. From it:
  fT   = unity crossing of |h21| = |y21/y11|
  fMAX = Mason U = |y21-y12|^2 / (4 (g11 g22 - g12 g21)); reported as f*sqrt(U) at 10 GHz (-20 dB/dec extrapolation, as in
         on-wafer practice) and as the direct U = 1 crossing.
  rbb' = effective small-signal base resistance: h11 = 1/y11 (output AC-shorted) is fitted with a circle over the frequency range
         where |h21| < beta/3 (i.e. above f_beta); the high-frequency real-axis intercept of the circle is rbb' + RE, minus RE
         (the card value) gives rbb'. For GP cards the extrinsic B-C capacitance ((1-XCJC)*Cbc, on the external base node)
         is de-embedded first (circle taken on an XCJC=1 copy at the same bias; VBIC: CJEP moved into CJC); without it the intercept reads ~15 % low.
         Checked on a constant-RB card (RB 124, no IRB): circle 123.3-123.6 ohm at 0.1/1 mA; VBIC RBX-only 124: 123.1 ohm.
         VBIC RBI is divided by qb (~1.33 at 100 uA because VER = 3), so RBX + RBI > rbb'.
Usage: python3 char_hbt.py [lib ...]   (lib defaults to fb5_hbt.lib + fb5_hbt_vbic.lib)"""
import subprocess, tempfile, re, sys, os, numpy as np
os.environ.setdefault('OMP_WAIT_POLICY', 'passive'); os.environ.pop('PDK', None)
SI = {'f': 1e-15, 'p': 1e-12, 'n': 1e-9, 'u': 1e-6, 'm': 1e-3, 'k': 1e3}
def num(x):
    m = re.match(r'^([-+0-9.eE]+)([a-zA-Z]*)$', str(x)); return float(m.group(1)) * (SI.get(m.group(2)[:1].lower(), 1) if m.group(2) else 1)
def cards(path):
    return {m.group(1): m.group(0) for m in re.finditer(r'^\.MODEL (\S+) NPN.*$', open(path).read(), re.M)}
def params(card): return dict(kv.split('=') for kv in re.search(r'\((.*)\)', card).group(1).split())
def run(deck, outs):
    with tempfile.TemporaryDirectory() as td:
        open(f'{td}/a.sp', 'w').write(deck); subprocess.run(['ngspice', '-b', 'a.sp'], cwd=td, capture_output=True)
        return [np.loadtxt(f'{td}/{o}', ndmin=2) for o in outs]
def q(name, card): return f"Q1 c b 0 0 dt {name}\nRdt dt 0 1e9" if 'level=4' in card else f"Q1 c b 0 {name}"
def gummel(name, card, vce=1.8):
    a, = run(f"* g\n{card}\nVc c 0 {vce}\nVb b 0 0.6\n{q(name, card)}\n.control\ndc Vb 0.55 1.05 0.5m\nwrdata g.txt i(Vc) i(Vb)\n.endc\n.end\n", ['g.txt'])
    return a[:, 0], np.abs(a[:, 1]), np.abs(a[:, 3])
def yparams(name, card, vbe, vce=1.8, f0=1e7, f1=1e12):
    ac = f"ac dec 40 {f0} {f1}"
    a, = run(f"* y1\n{card}\nVc c 0 {vce} ac 0\nVb b 0 dc {vbe} ac 1\n{q(name, card)}\n.control\n{ac}\nwrdata y.txt i(Vb) i(Vc)\n.endc\n.end\n", ['y.txt'])
    b, = run(f"* y2\n{card}\nVc c 0 dc {vce} ac 1\nVb b 0 dc {vbe} ac 0\n{q(name, card)}\n.control\n{ac}\nwrdata y.txt i(Vb) i(Vc)\n.endc\n.end\n", ['y.txt'])
    f = a[:, 0]; c = lambda m, k: -(m[:, k] + 1j * m[:, k + 1])
    return f, c(a, 1), c(a, 4), c(b, 1), c(b, 4)          # f, y11, y21, y12, y22
def circle_fit(z):
    x, y = z.real, z.imag; A = np.c_[x, y, np.ones_like(x)]; s = np.linalg.lstsq(A, -(x**2 + y**2), rcond=None)[0]
    xc, yc = -s[0] / 2, -s[1] / 2; r = np.sqrt(xc**2 + yc**2 - s[2]); return xc, yc, r
def point(name, card, ic, vce=1.8, g=None):
    vb, icv, ibv = g if g is not None else gummel(name, card, vce)
    vbe = float(np.interp(np.log(ic), np.log(icv), vb)); i = np.argmin(abs(vb - vbe))
    f, y11, y21, y12, y22 = yparams(name, card, vbe, vce)
    h21 = np.abs(y21 / y11); h11 = 1 / y11
    k = np.where(h21 < 1)[0]; ft = np.exp(np.interp(0, np.log(h21[[k[0], k[0] - 1]]), np.log(f[[k[0], k[0] - 1]]))) if len(k) else np.nan
    U = np.abs(y21 - y12)**2 / (4 * (y11.real * y22.real - y12.real * y21.real))
    fmax10 = 1e10 * np.sqrt(np.interp(1e10, f, U))
    ku = np.where((U < 1) & (f > 1e9))[0]; fmaxx = np.exp(np.interp(0, np.log(U[[ku[0], ku[0] - 1]]), np.log(f[[ku[0], ku[0] - 1]]))) if len(ku) else np.nan
    beta = h21[0]; sel = (h21 < beta / 3) & (h21 > 1.5)
    cd2 = None
    if 'level=4' not in card and 'XCJC=' in card:       # de-embed the extrinsic Cbc (GP XCJC split puts (1-XCJC)*Cbc directly
        cd2 = re.sub(r'XCJC=\S+', 'XCJC=1', card)        # on the base terminal, which pulls the circle intercept low): XCJC=1 copy
    elif 'level=4' in card and 'CJEP=' in card:          # VBIC: same for the extrinsic B-C cap CJEP (bx-cx): move it into CJC
        pp = params(card); cd2 = re.sub(r'CJEP=\S+', 'CJEP=0', re.sub(r'\bCJC=\S+', f"CJC={num(pp['CJC']) + num(pp['CJEP']):.4g}", card))
    if cd2:
        _, a11, a21, _, _ = yparams(name, cd2, vbe, vce); h11 = 1 / a11; h = np.abs(a21 / a11); sel = (h < h[0] / 3) & (h > 1.5)
    xc, yc, r = circle_fit(h11[sel]); re_ = num(params(card).get('RE', 0))
    rbb = xc - np.sqrt(max(r**2 - yc**2, 0)) - re_        # high-frequency real-axis intercept minus RE
    return dict(ic=icv[i], vbe=vbe, beta=float(np.interp(vbe, vb, icv / ibv)), ft=ft, fmax=fmax10, fmaxx=fmaxx, rbb=rbb, ib=float(np.interp(vbe, vb, ibv)))
def gp_rbb(p, ib):
    rb, rbm, irb = num(p['RB']), num(p.get('RBM', p['RB'])), num(p.get('IRB', 0))
    if not irb: return rbm + (rb - rbm) / (1 + 0)
    z = (-1 + np.sqrt(1 + 144 * ib / (np.pi**2 * irb))) / (24 / np.pi**2 * np.sqrt(ib / irb))
    return rbm + 3 * (rb - rbm) * (np.tan(z) - z) / (z * np.tan(z)**2)
ICS = (0.1e-3, 0.3e-3, 0.7e-3, 1.0e-3, 1.5e-3, 2.0e-3, 3e-3)
def sweep(name, card, ics=ICS, vce=1.8):
    g = gummel(name, card, vce); return [point(name, card, ic, vce, g) for ic in ics]
def report(name, card, ics=ICS, vce=1.8):
    rows = sweep(name, card, ics, vce); p = params(card)
    print(f'== {name} (VCE {vce} V, 0.5x2.5 um unit emitter)')
    print('   Ic mA   VBE   beta   fT GHz  fMAX GHz (f*sqrtU@10G / U=1)  rbb\' ohm (h11 circle)' + ('   GP formula' if 'level=4' not in card else ''))
    for r in rows:
        extra = f'   {gp_rbb(p, r["ib"]):6.1f}' if 'level=4' not in card else ''
        print(f'  {r["ic"]*1e3:6.2f} {r["vbe"]:.3f} {r["beta"]:6.1f} {r["ft"]/1e9:7.1f}   {r["fmax"]/1e9:6.1f} / {r["fmaxx"]/1e9:6.1f}            {r["rbb"]:6.1f}{extra}')
    pf = max(rows, key=lambda r: r['ft']); pm = max(rows, key=lambda r: r['fmax'])
    print(f'  peak fT {pf["ft"]/1e9:.1f} GHz @ {pf["ic"]*1e3:.2f} mA; peak fMAX {pm["fmax"]/1e9:.1f} GHz @ {pm["ic"]*1e3:.2f} mA; rbb\'(100 uA) {rows[0]["rbb"]:.1f} ohm; beta(1 mA) {rows[3]["beta"]:.1f}', flush=True)
    return rows
if __name__ == '__main__':
    libs = sys.argv[1:] or [os.path.join(os.path.dirname(os.path.abspath(__file__)), x) for x in ('fb5_hbt.lib', 'fb5_hbt_vbic.lib')]
    for lib in libs:
        print(f'# {lib}')
        for n, c in cards(lib).items(): report(n, c)
