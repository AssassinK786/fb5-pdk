#!/usr/bin/env python3
"""Fit the fb5_spiral.py pi-model loss/substrate parameters to Ronkainen et al., IEE Proc. Circuits Devices Syst. 144(1) 1997,
Table 2: 9-section SPICE subcircuit fitted to measured S-parameters of inductor L1 (rectangular, 6 turns, W 15, S 3, 285 um,
1 um Al-Si M2 35 mohm/sq, 1.2 um oxide, 40-70 ohm.cm substrate, 0.8 um BiCMOS).  research PDK.
The subckt is used as the 'measured' reference (ROUT/COUT, cut off in the scan, assumed = RIN/CIN).
L itself stays the Mohan value (geometry; not fitted).  Free: kR (series-loss factor), kC (oxide-capacitance factor),
Gs (substrate conductance per um^2), Cs_sub (substrate capacitance per um^2); objective = log-error of L_eff and Q, 0.1-6 GHz."""
import math, numpy as np, fb5_spiral as S
F = np.array([0.1, 0.2, 0.5, 1, 1.5, 2, 3, 4, 5, 6]) * 1e9
def ron_y11(f):
    w = 2 * np.pi * f; L, R, RM, CM, RIN, CIN, CP = 7.017938e-10, 4.848719, 6.395118e5, 3.606225e-16, 1.481793e5, 1.047327e-16, 3.311041e-14
    Y = np.zeros((9, 9), complex)
    def add(a, b, y):
        Y[a, a] += y
        if b is not None: Y[b, b] += y; Y[a, b] -= y; Y[b, a] -= y
    add(0, None, 1 / (RIN + 1 / (1j * w * CIN)) + 1j * w * CP)       # port 2 grounded: CP and ROUT/COUT go to ground
    for k in range(9):
        add(k, k + 1 if k < 8 else None, 1 / (R + 1j * w * L))
        if k < 8: add(k + 1, None, 1 / (RM + 1 / (1j * w * CM)))
    I = np.zeros(9, complex); I[0] = 1; return 1 / np.linalg.solve(Y, I)[0]
def lq(y, f): return (1 / y).imag / (2 * np.pi * f), -y.imag / y.real
GEOM = (6, 15e-6, 3e-6, 285e-6, 'square'); STACK = dict(t=1e-6, rho_m=3.5e-8, tox=1.2e-6)
def curves(p):
    m = S.model(*GEOM, **STACK, **p); return [lq(S.q_of_f(m, f)[1], f) for f in F]
TGT = [lq(ron_y11(f), f) for f in F]
def cost(x):
    p = dict(kR=math.exp(x[0]), kC=math.exp(x[1]), Gs=math.exp(x[2]), Cs_sub=math.exp(x[3]))
    e = 0
    for (l, q), (lt, qt) in zip(curves(p), TGT):
        e += (math.log(abs(l) / lt) if l > 0 else 5) ** 2 + (math.log(q / qt) if q > 0 else 5) ** 2
    return e
def nelder(fun, x0, step=0.7, it=4000):
    n = len(x0); pts = [np.array(x0, float)] + [np.array(x0, float) + step * np.eye(n)[i] for i in range(n)]
    v = [fun(p) for p in pts]
    for _ in range(it):
        o = np.argsort(v); pts = [pts[i] for i in o]; v = [v[i] for i in o]
        c = np.mean(pts[:-1], axis=0); xr = c + (c - pts[-1]); fr = fun(xr)
        if fr < v[0]:
            xe = c + 2 * (c - pts[-1]); fe = fun(xe); pts[-1], v[-1] = (xe, fe) if fe < fr else (xr, fr)
        elif fr < v[-2]: pts[-1], v[-1] = xr, fr
        else:
            xc = c + 0.5 * (pts[-1] - c); fc = fun(xc)
            if fc < v[-1]: pts[-1], v[-1] = xc, fc
            else: pts = [pts[0] + 0.5 * (p - pts[0]) for p in pts]; v = [fun(p) for p in pts]
    return pts[int(np.argmin(v))], min(v)
if __name__ == '__main__':
    p0 = dict(kR=1.0, kC=1.0, Gs=1e-7, Cs_sub=1e-5)
    x, e = nelder(cost, [0, 0, math.log(1e-7), math.log(1e-5)])
    for _ in range(3): x, e = nelder(cost, x, step=0.3)
    pf = dict(kR=math.exp(x[0]), kC=math.exp(x[1]), Gs=math.exp(x[2]), Cs_sub=math.exp(x[3]))
    out = ["Ronkainen L1 (Table 2 subckt) vs fb5_spiral pi model, Ronkainen stack (1 um Al 35 mohm/sq, 1.2 um oxide)",
           f"before: kR 1, kC 1, Gs 1e-7 S/um2, Cs_sub 1e-5 fF/um2  (cost {cost([0, 0, math.log(1e-7), math.log(1e-5)]):.2f})",
           f"after : kR {pf['kR']:.2f}, kC {pf['kC']:.3f}, Gs {pf['Gs']:.3g} S/um2, Cs_sub {pf['Cs_sub']:.3g} fF/um2  (cost {e:.3f})",
           "f GHz | Ronkainen L nH  Q | before L  Q | after L  Q"]
    b, a = curves(p0), curves(pf)
    for f, t, bb, aa in zip(F, TGT, b, a):
        out.append(f"{f/1e9:5.1f} | {t[0]*1e9:6.2f} {t[1]:5.2f} | {bb[0]*1e9:6.2f} {bb[1]:5.2f} | {aa[0]*1e9:6.2f} {aa[1]:5.2f}")
    def peak(fn):
        fs = np.logspace(8, 10.3, 400); qs = [fn(f) for f in fs]; k = int(np.nanargmax(qs)); return qs[k], fs[k] / 1e9
    qt = peak(lambda f: lq(ron_y11(f), f)[1])
    mb, ma = S.model(*GEOM, **STACK, **p0), S.model(*GEOM, **STACK, **pf)
    out.append(f"Qpeak (f, GHz, searched to 20 GHz): Ronkainen {qt[0]:.2f} @ {qt[1]:.2f}; before {peak(lambda f: S.q_of_f(mb, f)[0])[0]:.2f} @ "
               f"{peak(lambda f: S.q_of_f(mb, f)[0])[1]:.2f}; after {peak(lambda f: S.q_of_f(ma, f)[0])[0]:.2f} @ {peak(lambda f: S.q_of_f(ma, f)[0])[1]:.2f}")
    open('fit_ronkainen.txt', 'w').write('\n'.join(out) + '\n'); print('\n'.join(out))
