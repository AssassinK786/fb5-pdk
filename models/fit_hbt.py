"""FB5 SiGe HBT fit (research PDK) - Gummel-Poon cards fitted to published IBM SiGe 5HP figures.

Sources (all public):
  [1] J. S. Dunn et al., "Foundation of rf CMOS and SiGe BiCMOS technologies",
      IBM J. Res. & Dev. 47(2/3), March/May 2003, Table 2 (p. 105):
      5HP: peak fT 50 GHz, peak fmax 65 GHz, Ic at peak fT 0.6 mA (min area),
      BVCEO 3.3 V, BVCBO 10.5 V; High-BV npn peak fT 29 GHz, BVCEO 5.5 V.
      5HPE (a DIFFERENT, lower-speed variant): peak fT 45 GHz, peak fmax 50 GHz.
  [2] P. Bacon et al. (IBM), "Low Phase Noise SiGe VCOs for Wireless Applications",
      Microwave Journal, Feb 2002, Table 1/2 (https://www.microwavejournal.com/articles/3389-...):
      5HP/5AM (0.5 um): AE 0.5 x 2.5 um, beta 100, VA 65 V, BVCEO 3.35 V,
      Rb@100uA 124 ohm, fT 47 GHz, fmax 65 GHz, NFmin 0.8 dB;
      standard NPN fT 47 GHz / BVCEO 3.35 V; high-breakdown NPN fT 28 GHz / BVCEO 5.5 V.

Design decisions (2026-11-14):
  * fT is fitted with TF; fMAX is NOT assumed. It is EXTRACTED from two-port Y
    parameters as the Mason unilateral-gain U=1 crossing (see val_fmax.py).
    The old fit derived RB = fT/(8*pi*fmax_target^2*(1.3*CJC)) and then printed
    fmax_target as if it were a result: fMAX was an input, and the 1.3x Cbc fudge
    forced RB=77 ohm, ~38% below the measured 124 ohm -> the shipped card gave
    fMAX 74 GHz instead of ~65 GHz.
  * RB is now taken from the measured value in [2] (hp, 124 ohm). No published
    Rb exists for the high-breakdown device; its RB=96 ohm remains an ESTIMATE.
  * fT targets: 47 GHz (hp, [2]) and 28 GHz (hb, [2]). Beta ~100, emitter
    0.5 x 2.5 um. BVceo is NOT modelled by Gummel-Poon; the VBIC cards add it.
Usage: python3 fit_hbt.py > fit_hbt.txt   (writes fb5_hbt.lib)
"""
import subprocess, tempfile, os, re, numpy as np, math

def run(deck, out):
    # ngspice wrdata writes <out> into the working directory; retry a few times
    # because the batch .control block occasionally misses the file.
    for _ in range(3):
        with tempfile.TemporaryDirectory() as td:
            open(os.path.join(td, 'a.sp'), 'w').write(deck)
            subprocess.run(['ngspice', '-b', 'a.sp'], cwd=td, capture_output=True, text=True)
            p = os.path.join(td, out)
            if os.path.exists(p):
                try: return np.loadtxt(p, ndmin=2)
                except (ValueError, OSError): pass
    return None

def card(p): return '.MODEL QX NPN (' + ' '.join(f'{k}={v}' for k, v in p.items()) + ')'

def op_ic(cd, vb, vce=1.8):
    d = (f'* op\n{cd}\nQ1 c b 0 QX\nVb b 0 {vb}\nVc c 0 {vce}\n'
         '.control\nop\nprint i(Vc) i(Vb)\n.endc\n.end\n')
    with tempfile.TemporaryDirectory() as td:
        open(os.path.join(td, 'a.sp'), 'w').write(d)
        r = subprocess.run(['ngspice','-b','a.sp'], cwd=td, capture_output=True, text=True)
        t = r.stdout
    g = lambda pat: (abs(float(re.search(pat, t).group(1))) if re.search(pat, t) else float('nan'))
    return g(r'i\(vc\)\s*=\s*([-\d.eE+]+)'), g(r'i\(vb\)\s*=\s*([-\d.eE+]+)')


def bias_vb(cd, ic, vce=1.8):
    lo, hi = 0.60, 1.05
    for _ in range(40):
        vb = (lo + hi) / 2
        icx, _ = op_ic(cd, vb, vce)
        lo, hi = (vb, hi) if icx < ic else (lo, vb)
    return (lo + hi) / 2

def ac_pair(cd, vb, vce=1.8):
    def one(tag, a1, a2):
        d = (f'* {tag}\n{cd}\nQ1 c b 0 QX\nVb b 0 DC {vb} AC {a1}\nVc c 0 DC {vce} AC {a2}\n'
             f'.control\nac dec 50 1e7 5e11\nwrdata {tag}.txt i(Vb) i(Vc)\n.endc\n.end\n')
        a = run(d, tag + '.txt')
        # wrdata repeats the frequency column for each vector:
        # f, Re i(Vb), Im i(Vb), f, Re i(Vc), Im i(Vc)
        f, ib, icv = a[:,0], a[:,1]+1j*a[:,2], a[:,4]+1j*a[:,5]
        return f, ib, icv
    f, ibA, icA = one('A', 1, 0)
    _, ibB, icB = one('B', 0, 1)
    h21 = np.abs(icA / ibA)                  # v1 = 1, collector AC short
    y11, y21 = -ibA, -icA
    y12, y22 = -ibB, -icB
    U = np.abs(y21-y12)**2 / (4*(y11.real*y22.real - y12.real*y21.real))
    return f, h21, U

def crossing(f, y, level):
    for i in range(1, len(f)):
        if y[i-1] <= 0 or y[i] <= 0 or y[i-1] == y[i]: continue
        if (y[i-1]-level)*(y[i]-level) <= 0:
            t = math.log(y[i-1]/level)/math.log(y[i-1]/y[i])
            return math.exp(math.log(f[i-1]) + t*math.log(f[i]/f[i-1]))
    return float('nan')

def rf(cd, ic, vce=1.8):
    vb = bias_vb(cd, ic, vce)
    icx, ibx = op_ic(cd, vb, vce)
    f, h21, U = ac_pair(cd, vb, vce)
    return icx, icx/ibx, crossing(f, h21, 1.0), crossing(f, U, 1.0), vb

BASE = dict(IS='5e-18', BF=145, NF=1.0, VAF=60, IKF='18m', ISE='4e-17', NE=1.6, BR=5, VAR=3, IKR='1m',
            RB='124', IRB='0.4m', RBM='25', RE=6, RC=35, CJE='9f', VJE=0.9, MJE=0.3,
            CJC='5f', VJC=0.6, MJC=0.3, XCJC=0.5, CJS='8f', VJS=0.6, MJS=0.3,
            TF='2.8p', XTF=6, VTF=2.0, ITF='20m', TR='50p', EG=1.11, XTI=3, XTB=1.5)
ICS = (0.3e-3, 0.5e-3, 0.7e-3, 1.0e-3, 1.5e-3, 3e-3, 6e-3)

def fit(tag, ftgt, over):
    p = dict(BASE); p.update(over)
    tf = float(p['TF'].rstrip('p'))
    for it in range(8):
        p['TF'] = f'{tf:.4g}p'
        res = [rf(card(p), ic) for ic in ICS]
        pk = max(r[2] for r in res)
        if abs(pk/ftgt - 1) < 0.008: break
        tf *= (pk/ftgt) ** 1.1
    # measure fMAX at the peak-fT bias (published values are peak values)
    best = max(res, key=lambda r: r[2])
    icx, beta, ft, fmax, vb = best
    print(f'{tag}: TF {p["TF"]}, RB {p["RB"]} (RBM {p["RBM"]}); '
          + ', '.join(f'Ic {r[0]*1e3:.2f}mA beta {r[1]:.0f} fT {r[2]/1e9:.1f}G' for r in res))
    print(f'  peak fT {ft/1e9:.2f} GHz @ Ic {icx*1e3:.3f} mA (beta {beta:.0f}, Vb {vb:.3f}); '
          f'EXTRACTED fMAX (Mason U=1) {fmax/1e9:.2f} GHz')
    return p, ft, fmax

hp, hpft, hpfm = fit('fb5npn_hp (0.5x2.5 um, BVceo 3.3 V, fT target 47 GHz, published fmax 65 GHz)', 47e9, {})
hb, hbft, hbfm = fit('fb5npn_hb (0.5x2.5 um, BVceo 5.5 V, fT target 28 GHz, assumed fmax 50 GHz)', 28e9,
                     dict(VAF=90, RC=120, CJC='3.5f', IKF='8m', ITF='8m', TF='4.03p', RB='96', RBM='19'))

L = ['* FB5 SiGe HBT models (research PDK): Gummel-Poon fitted to published IBM SiGe 5HP figures (fit_hbt.py).',
     '* Emitter 0.5 x 2.5 um. hp RB=124 ohm = measured Rb@100uA (Bacon, Microwave Journal 2002);',
     '* hb RB=96 ohm is an ESTIMATE (no published Rb for the high-breakdown NPN).',
     '* fT fitted with TF; fMAX is EXTRACTED from Y-parameters (Mason U=1), see fit_hbt.txt / val_fmax.txt.',
     '* BVceo (3.3 V hp / 5.5 V hb) is NOT modelled by Gummel-Poon: keep VCE below it; use the VBIC cards.']
for nm, p in (('fb5npn_hp', hp), ('fb5npn_hb', hb)):
    L.append('.MODEL ' + nm + ' NPN (' + ' '.join(f'{k}={v}' for k, v in p.items()) + ')')
open('fb5_hbt.lib','w').write('\n'.join(L) + '\n')
print('\nwrote fb5_hbt.lib:'); print(open('fb5_hbt.lib').read())
print(f'Published targets [1][2]: hp fT 47-50 GHz, fmax 65 GHz; hb fT 28-29 GHz. '
      f'Measured here: hp {hpft/1e9:.1f}/{hpfm/1e9:.1f}, hb {hbft/1e9:.1f}/{hbfm/1e9:.1f} GHz.')
