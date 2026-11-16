"""FB5 VBIC validation (research PDK): 11-stage ECL ring (copied from val_fb5.py) with the VBIC hp model vs the GP hp model.
IBM 5HP published: 16 ps/gate (Harame et al., IBM J. R&D 47(2/3) 2003). VBIC instances use substrate=0 and a floating dt node (self-heating on). Measurement window starts at td=1 ns (the VBIC deck chatters around v(y0p)=v(y0n) during the first ps, which fooled the rise=4 trigger)."""
import re, os, subprocess, tempfile
ROOT = os.path.abspath(os.path.join(os.path.dirname(os.path.abspath(__file__)), '..'))
H = open(os.path.join(ROOT, 'models', 'fb5_hbt.lib')).read()
V = open(os.path.join(ROOT, 'models', 'fb5_hbt_vbic.lib')).read()
gpm = re.search(r'\.MODEL fb5npn_hp NPN.*', H).group(0); vbm = re.search(r'\.MODEL fb5npn_hp_v NPN.*', V).group(0)
def cml_ring(iee, swing, model, dev, n=11):
    RL = swing / iee; d = f"* cml ring\n{model}\nVcc vcc 0 3.3\n"
    for i in range(n):
        j = (i + 1) % n
        # stage i: inputs xp/xn (after emitter followers), outputs yp/yn
        d += f"Rp{i} vcc y{i}p {RL}\nRn{i} vcc y{i}n {RL}\nQa{i} y{i}n x{i}p t{i} 0 {dev}\nQb{i} y{i}p x{i}n t{i} 0 {dev}\nI{i} t{i} 0 {iee}\n"
        # emitter followers drive next stage; last stage crosses wires for odd inversion
        p, q = (f'y{i}p', f'y{i}n') if i < n - 1 else (f'y{i}n', f'y{i}p')   # stages are non-inverting: one crossing closes an oscillating loop
        d += f"Qf{i}p vcc {p} x{j}p 0 {dev}\nQf{i}n vcc {q} x{j}n 0 {dev}\nIfp{i} x{j}p 0 {iee/2}\nIfn{i} x{j}n 0 {iee/2}\n"
    d += f"Ikick y0p 0 PULSE(0 {iee} 20p 5p 5p 30p 1)\n.control\ntran 0.2p 8n\nmeas tran t1 when v(y0p)=v(y0n) rise=4 td=1n\nmeas tran t2 when v(y0p)=v(y0n) rise=9 td=1n\n.endc\n.end\n"
    d = re.sub(r'^(Q\S+)(.*)@', lambda m: m.group(1) + m.group(2) + m.group(1), d, flags=re.M)   # unique thermal node per VBIC device
    with tempfile.TemporaryDirectory() as td:
        open(f'{td}/r.sp', 'w').write(d); o = subprocess.run(['ngspice', '-b', 'r.sp'], cwd=td, capture_output=True, text=True).stdout
    t = [re.search(rf'{k}\s*=\s*(\S+)', o) for k in ('t1', 't2')]
    return (float(t[1].group(1)) - float(t[0].group(1))) / 5 / (2 * n) * 1e12 if all(t) else float('nan')
for iee in (0.3e-3, 0.6e-3, 1.0e-3, 1.5e-3):
    g = cml_ring(iee, 0.28, gpm, 'fb5npn_hp'); v = cml_ring(iee, 0.28, vbm, 'dt_@ fb5npn_hp_v')
    print(f'ECL ring (11 stages, 280 mV swing, Iee {iee*1e3:.1f} mA, EF {iee*0.5e3:.2f} mA): GP {g:.1f} ps/gate, VBIC {v:.1f} ps/gate  (IBM 5HP: 16 ps)', flush=True)
