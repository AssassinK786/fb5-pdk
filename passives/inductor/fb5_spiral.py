"""FB5 spiral inductor model generator (research PDK).
L: modified Wheeler (Mohan, Hershenson, Boyd, Lee, IEEE JSSC 34(10) 1999): L = K1 mu0 n^2 davg / (1 + K2 rho),
   rho = (dout - din) / (dout + din); K1/K2 square 2.34/2.75, hexagon 2.33/3.82, octagon 2.25/3.55.
Lumped single-pi model (topology of IBM SiGe kit slides; Yue/Wong-type): series L + Rs(f, skin effect), Cs (underpass overlap),
each port: Cox (spiral to substrate through dielectric) in series with Rsub || Csub.
Technology (FB5 = IBM 5HP class): thick top metal 4 um Al (rho 2.7 uOhm.cm -> 0.0068 ohm/sq; MOSIS lots M4 0.01 ohm/sq),
dielectric to substrate 8.7 um (IBM thick-metal module), underpass on M2, oxide-to-underpass 3 um, substrate 15 ohm.cm (IBM slide),
substrate thickness for Csub/Rsub per area: ESTIMATE (Gsub ~ 1e-7 S/um^2, Csub ~ 1e-5 fF/um^2 per Yue/Wong-style fits).
Ronkainen 1997 check (fit_ronkainen.py -> fit_ronkainen.txt, 2026-11-05): with the Ronkainen stack the published 9-section
subckt of L1 is reproduced (Q within ~5 %, Qpeak 3.59 vs 3.76 at 6.5 vs 6.3 GHz) by kR 4.85, kC 0.34, Gs ~6e-9 S/um^2, Csub ~0:
that subckt puts all loss in series R (43.6 ohm vs 10 ohm DC estimate) and almost no substrate shunt, so it constrains kR, not
Gs/Csub. FB5 defaults (kR 1, kC 1, Gs 1e-7, Cs_sub 1e-5) are therefore kept; use kR ~2-5 as a pessimistic series-loss corner.
usage: python3 fb5_spiral.py n w s dout [shape]   -> writes spiral_<...>.sp subckt and prints L, Q(f), f_SR"""
import sys, math, numpy as np
MU0 = 4e-7 * math.pi; EPS = 8.854e-12 * 3.9
SH = {'square': (2.34, 2.75, 4.0), 'hexagon': (2.33, 3.82, 6 * math.tan(math.pi / 6)), 'octagon': (2.25, 3.55, 8 * math.tan(math.pi / 8))}
def model(n, w, s, dout, shape='octagon', t=4e-6, rho_m=2.7e-8, tox=8.7e-6, tox_u=3e-6, Gs=1e-7, Cs_sub=1e-5, kR=1.0, kC=1.0):
    K1, K2, per = SH[shape]
    din = dout - 2 * n * w - 2 * (n - 1) * s
    if din <= 0: raise SystemExit('geometry does not fit')
    davg = (dout + din) / 2; rho = (dout - din) / (dout + din)
    L = K1 * MU0 * n ** 2 * davg / (1 + K2 * rho)
    length = per * davg * n                                   # total trace length (approx: perimeter factor x davg x turns)
    area = length * w
    Rdc = kR * rho_m * length / (w * t)                        # kR: excess series loss (underpass, vias, crowding)
    Cs = n * w * w * EPS / tox_u                              # underpass overlap
    Cox = kC * area * EPS / tox / 2                                # split to the two ports
    Rsub = 2 / (Gs * area * 1e12); Csub = Cs_sub * 1e-15 * area * 1e12 / 2
    return dict(L=L, Rdc=Rdc, Cs=Cs, Cox=Cox, Rsub=Rsub, Csub=Csub, t=t, w=w, rho_m=rho_m, din=din, length=length)
def rs_f(m, f):
    delta = math.sqrt(m['rho_m'] / (math.pi * f * MU0)); teff = m['t'] if delta > m['t'] else delta * (1 - math.exp(-m['t'] / delta))
    return m['Rdc'] * m['t'] / teff
def q_of_f(m, f):                                             # one port grounded: Y11 of the pi model
    w = 2 * math.pi * f
    Zs = rs_f(m, f) + 1j * w * m['L']; Ys = 1 / Zs + 1j * w * m['Cs']
    Zsub = 1 / (1 / m['Rsub'] + 1j * w * m['Csub']); Yp = 1 / (1 / (1j * w * m['Cox']) + Zsub)
    Y11 = Ys + Yp; return Y11.imag * -1 / Y11.real if Y11.real else float('nan'), Y11
if __name__ == '__main__':
    n = float(sys.argv[1]); w, s, dout = (float(x) * 1e-6 for x in sys.argv[2:5]); shape = sys.argv[5] if len(sys.argv) > 5 else 'octagon'
    m = model(n, w, s, dout, shape)
    fs = np.logspace(8, 11, 400); qs = [q_of_f(m, f)[0] for f in fs]
    imag = [-1 / q_of_f(m, f)[1] for f in fs]; Leff = [z.imag / (2 * math.pi * f) for z, f in zip([1 / q_of_f(m, f)[1] for f in fs], fs)]
    fsr = next((f for f, le in zip(fs, Leff) if le < 0), float('nan')); k = int(np.nanargmax(qs))
    name = f'spiral_n{sys.argv[1]}_w{sys.argv[2]}_s{sys.argv[3]}_d{sys.argv[4]}_{shape}'.replace('.', 'p')
    open(name + '.sp', 'w').write(f"""* {name}: FB5 spiral (Mohan L + pi model), L={m['L']*1e9:.3f} nH Rdc={m['Rdc']:.3f} ohm
.subckt {name} p1 p2 sub
Ls p1 x {m['L']:.4e}
Rs x p2 {rs_f(m, 2e9):.4f}
Cs p1 p2 {m['Cs']:.4e}
Cox1 p1 n1 {m['Cox']:.4e}
Rsub1 n1 sub {m['Rsub']:.4e}
Csub1 n1 sub {m['Csub']:.4e}
Cox2 p2 n2 {m['Cox']:.4e}
Rsub2 n2 sub {m['Rsub']:.4e}
Csub2 n2 sub {m['Csub']:.4e}
.ends
""")
    print(f"{name}: L {m['L']*1e9:.2f} nH, Rdc {m['Rdc']:.2f} ohm, Qmax {qs[k]:.1f} at {fs[k]/1e9:.2f} GHz, Q@2GHz {q_of_f(m, 2e9)[0]:.1f}, f_SR {fsr/1e9:.1f} GHz, din {m['din']*1e6:.0f} um")
