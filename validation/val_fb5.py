"""FB5 validation (research PDK): HBT beta / fT / fMAX, CMOS gate delay, ECL ring.
All paths are repo-relative; no external scripts required.
Targets (published IBM SiGe 5HP):
  beta ~100, peak fT 47-50 GHz, peak fmax 65 GHz (Microwave Journal 2002 Table 1;
  IBM J. R&D 47(2/3) 2003 Table 2), ECL ring 16 ps/gate and CMOS gate 90 ps
  (IBM J. R&D 47(2/3) 2003 Table 1).
Usage: python3 val_fb5.py > val_fb5.txt
"""
import os, re, sys, subprocess, tempfile, numpy as np
HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..'))
sys.path.insert(0, HERE)
import val_fmax as rf

GP = rf.model_cards(os.path.join(ROOT, 'models', 'fb5_hbt.lib'))
CMOS = open(os.path.join(ROOT, 'models', 'fb5_tt_cards.sp')).read()

def ng(deck):
    with tempfile.TemporaryDirectory() as td:
        open(os.path.join(td, 'a.sp'), 'w').write(deck)
        return subprocess.run(['ngspice', '-b', 'a.sp'], cwd=td,
                              capture_output=True, text=True).stdout

# --- HBT: beta / fT / fMAX from the shared Y-parameter extractor -----------------
print('HBT (VCE 1.8 V, peak-fT bias):')
for nm in ('fb5npn_hp', 'fb5npn_hb'):
    cd = rf.card(nm, GP[nm])
    rows = [rf.extract(cd, vb, tag=nm + str(j)) for j, vb in enumerate(rf.VBS)]
    r = max(rows, key=lambda x: x['ft'])
    print(f'HBT {nm}: Ic {r["ic"]:.3f} mA beta {r["beta"]:.1f} fT {r["ft"]:.2f} GHz '
          f'fMAX {r["fmax"]:.2f} GHz  (target beta ~100, fT 47-50 / 28 GHz, fmax 65 / ~50 GHz)')

# --- CMOS gate delay (self-contained, L 0.5 um, VDD 3.3 V) ----------------------
# Wn 0.8 / Wp 1.6 um, FO1 inverter and FO2 NAND2 loads, 50% crossing, 100 ps input slew.
def gate(cell, fanout, wn=0.8, wp=1.6, l=0.5):
    s = f'* {cell} FO{fanout}\n{CMOS}\nVdd vdd 0 3.3\nVin in 0 PULSE(0 3.3 0 100p 100p 2n 4n)\n'
    if cell == 'inv':
        s += f'M1 o1 in vdd vdd fb5p W={wp}u L={l}u\nM2 o1 in 0 0 fb5n W={wn}u L={l}u\n'
    else:
        s += (f'M1 o1 in vdd vdd fb5p W={wp}u L={l}u\nM2 o1 in vdd vdd fb5p W={wp}u L={l}u\n'
              f'M3 o1 in n1 0 fb5n W={wn}u L={l}u\nM4 n1 in 0 0 fb5n W={wn}u L={l}u\n')
    for k in range(fanout):
        s += (f'Mp{k} ox{k} o1 vdd vdd fb5p W={wp}u L={l}u\n'
              f'Mn{k} ox{k} o1 0 0 fb5n W={wn}u L={l}u\n')
    s += ('.meas tran tpd TRIG v(in) VAL=1.65 RISE=1 TARG v(o1) VAL=1.65 FALL=1\n'
          '.meas tran tpu TRIG v(in) VAL=1.65 FALL=1 TARG v(o1) VAL=1.65 RISE=1\n'
          '.tran 1p 4n\n.end\n')
    o = ng(s)
    a = re.search(r'tpd\s*=\s*([\d.eE+-]+)', o); b = re.search(r'tpu\s*=\s*([\d.eE+-]+)', o)
    return (float(a.group(1)) + float(b.group(1))) / 2 * 1e12 if a and b else float('nan')

print(f'CMOS (fb5 tt, L 0.5, 3.3 V): inv FO1 {gate("inv",1):.0f} ps, '
      f'NAND2 FO2 {gate("nand",2):.0f} ps  (IBM 5HP table: 90 ps)')

# --- ECL ring (11 stages, 280 mV swing) ------------------------------------------
hp = re.search(r'\.MODEL fb5npn_hp NPN.*', open(os.path.join(ROOT,'models','fb5_hbt.lib')).read()).group(0)
def cml_ring(iee, swing=0.28, n=11):
    RL = swing / iee
    d = f'* cml ring\n{hp}\nVcc vcc 0 3.3\n'
    for i in range(n):
        j = (i + 1) % n
        d += (f'Rp{i} vcc y{i}p {RL}\nRn{i} vcc y{i}n {RL}\n'
              f'Qa{i} y{i}n x{i}p t{i} 0 fb5npn_hp\nQb{i} y{i}p x{i}n t{i} 0 fb5npn_hp\nI{i} t{i} 0 {iee}\n')
        p, q = (f'y{i}p', f'y{i}n') if i < n - 1 else (f'y{i}n', f'y{i}p')
        d += (f'Qf{i}p vcc {p} x{j}p 0 fb5npn_hp\nQf{i}n vcc {q} x{j}n 0 fb5npn_hp\n'
              f'Ifp{i} x{j}p 0 {iee/2}\nIfn{i} x{j}n 0 {iee/2}\n')
    d += (f'Ikick y0p 0 PULSE(0 {iee} 20p 5p 5p 30p 1)\n'
          '.control\ntran 0.2p 8n\nmeas tran t1 when v(y0p)=v(y0n) rise=4 td=1n\n'
          'meas tran t2 when v(y0p)=v(y0n) rise=9 td=1n\n.endc\n.end\n')
    o = ng(d)
    t = [re.search(rf'{k}\s*=\s*(\S+)', o) for k in ('t1', 't2')]
    return (float(t[1].group(1)) - float(t[0].group(1))) / 5 / (2 * n) * 1e12 if all(t) else float('nan')
for iee in (0.3e-3, 0.6e-3, 1.0e-3, 1.5e-3):
    print(f'ECL ring (11 stages, 280 mV swing, Iee {iee*1e3:.1f} mA, EF {iee*0.5e3:.2f} mA): '
          f'{cml_ring(iee):.1f} ps/gate  (IBM 5HP: 16 ps)', flush=True)
