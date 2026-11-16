#!/usr/bin/env python3
"""FB5 reproduction of Glenn, Case, Harame, Meyerson, Poisson, "12-GHz Gilbert mixers using a manufacturable Si/SiGe
epitaxial-base bipolar technology", IEEE BCTM 1995, pp. 186-189.  research PDK.
Topology from the paper's Fig. 1: emitter-follower RF and LO buffers, Gilbert core with R1 across the RF-pair emitters
(JLG16 R1 = 13 ohm, JLG18 R1 = 0), resistor loads, emitter-follower IF outputs, all ports internally 50-ohm terminated,
NPN current sources; 5 V, ~250 mW.  Resistor values are not published: device currents follow the paper's rule
(every HBT at peak fT current; fb5npn_hp peaks at ~1 mA per 0.5x2.5 um emitter), RL is tuned once to JLG18's 10.4 dB.
Bench = paper's: single-ended RF (-25 dBm) and LO (0 dBm), single-ended IF out (100 MHz) into 50 ohm, unused ports 50 ohm.
usage: gilbert.py all      (runs op / gain-vs-frequency / two-tone / noise for JLG16 and JLG18, writes results.txt)"""
import sys, os, subprocess, math, numpy as np, concurrent.futures as cf
HERE = os.path.dirname(os.path.abspath(__file__)); FB5 = os.path.abspath(os.path.join(HERE, '..', '..'))
NGS = os.environ.get('NGSPICE') or 'ngspice'
RL = float(os.environ.get('GM_RL', '207'))        # the only tuned value (JLG18 low-f gain -> 10.4 dB)
AR = float(os.environ.get('GM_AR', '4'))
CPAR = float(os.environ.get('GM_CPAR', '0'))      # sensitivity only: extra wiring cap (F) on load and quad-emitter nodes       # RF-pair area = current per side in mA (quad = AR/2)
FIF = 100e6

def netlist(r1, flo, rf_tones=(), p_rf=-25.0, p_lo=0.0, model='fb5npn_hp', lo_static=0.0, analysis=''):
    """r1: JLG16 13 / JLG18 0. rf_tones: RF frequencies. lo_static: DC LO offset (V) for the hard-switched noise estimate."""
    vlo = math.sqrt(2 * 50 * 1e-3 * 10 ** (p_lo / 10)) * 2          # source EMF for available power p_lo
    vrf = math.sqrt(2 * 50 * 1e-3 * 10 ** (p_rf / 10)) * 2
    vt = 'vbic' in model
    def q(name, c, b, e, area, m=model):
        return f"{name} {c} {b} {e} 0 {'dt_'+name+' ' if m.endswith('_v') else ''}{m} area={area}\n"
    rfsrc = ' '.join(f"sin(0 {vrf:.5g} {f:.6g})" for f in rf_tones[:1])
    s = f"""* FB5 Gilbert mixer, Glenn et al. BCTM 1995 Fig. 1, R1={r1} ohm, RL={RL}, AR={AR}
.include {FB5}/models/fb5_hbt.lib
.include {FB5}/models/fb5_hbt_vbic.lib
.lib {FB5}/passives/fb5_passives.lib devices
.lib {FB5}/passives/fb5_passives.lib res_typ
VCC vcc 0 5
* bias: reference diode (hb) 1 mA/unit, current sources = hb devices with 200 ohm/area emitter degeneration
XRREF vcc ref rp w=10 l={ (5-0.2-0.86)/1e-3/214.2*10*0.687:.2f}
QREF ref ref eref 0 fb5npn_hb area=1
RER eref 0 200
VRFB vrfb 0 3.0
VLOB vlob 0 4.6
"""
    def cs(name, node, area):
        return q('Q' + name, node, 'ref', 'e' + name, area, 'fb5npn_hb') + f"R{name} e{name} 0 {200/area:.4g}\n"
    # ports: source EMF + 50 ohm, coupling (bench bias-tee), internal 50 ohm termination to bias
    s += f"VSRF srf 0 {'dc 0 ' + rfsrc if rfsrc else 'dc 0'} ac 1\n"
    if len(rf_tones) > 1:     # two-tone: resistive combiner, Thevenin = (V1+V2)/2 behind 50 ohm
        s = s.replace(f"VSRF srf 0 dc 0 {rfsrc} ac 1\n", f"VSRF srf 0 dc 0 sin(0 {2*vrf:.5g} {rf_tones[0]:.6g}) ac 1\n"
                      f"VSRF2 srf2 0 dc 0 sin(0 {2*vrf:.5g} {rf_tones[1]:.6g})\nRSRF srf prfp 100\nRSRF2 srf2 prfp 100\n")
    else: s += "RSRF srf prfp 50\n"
    s += "CRFP prfp rfp 10n\nRTRFP rfp vrfb 50\n"
    s += f"RSRFN 0 prfn 50\nCRFN prfn rfn 10n\nRTRFN rfn vrfb 50\n"
    s += f"VSLO slo 0 dc 0 {'sin(0 %.5g %.6g)' % (vlo, flo) if flo else ''}\nRSLO slo plop 50\nCLOP plop lop 10n\nRTLOP lop lob_p 50\n"
    s += f"RSLON 0 plon 50\nCLON plon lon 10n\nRTLON lon lob_n 50\n"
    s += f"VLOP lob_p vlob {lo_static/2}\nVLON lob_n vlob {-lo_static/2}\n"
    # RF emitter followers (area 4, 4 mA) -> RF pair (area 8, 8 mA each side) with R1 across the emitters
    s += q('QEFR1', 'vcc', 'rfp', 'brp', 4) + cs('CSR1', 'brp', 4) + q('QEFR2', 'vcc', 'rfn', 'brn', 4) + cs('CSR2', 'brn', 4)
    s += q('QR1', 'c1', 'brp', 'er1', AR) + q('QR2', 'c2', 'brn', 'er2', AR) + cs('CS1', 'er1', AR) + cs('CS2', 'er2', AR)
    s += f"R1 er1 er2 {max(r1, 1e-3)}\n"
    # LO emitter followers (area 4) -> switching quad (area 4, 4 mA each)
    s += q('QEFL1', 'vcc', 'lop', 'blp', 4) + cs('CSL1', 'blp', 4) + q('QEFL2', 'vcc', 'lon', 'bln', 4) + cs('CSL2', 'bln', 4)
    s += q('Q1', 'op', 'blp', 'c1', AR/2) + q('Q2', 'on', 'bln', 'c1', AR/2) + q('Q3', 'op', 'bln', 'c2', AR/2) + q('Q4', 'on', 'blp', 'c2', AR/2)
    s += f"RLP vcc op {RL}\nRLN vcc on {RL}\n"
    if CPAR: s += f"CPOP op 0 {CPAR}\nCPON on 0 {CPAR}\nCPC1 c1 0 {CPAR}\nCPC2 c2 0 {CPAR}\n"
    # IF emitter followers (area 6) + 50 ohm series back-termination; external 50 ohm load (IF+) / 50 ohm termination (IF-)
    s += q('QEFI1', 'vcc', 'op', 'eip', 6) + cs('CSI1', 'eip', 6) + q('QEFI2', 'vcc', 'on', 'ein', 6) + cs('CSI2', 'ein', 6)
    s += "RTIFP eip ifp 50\nCIFP ifp ifo 10n\nRLOAD ifo 0 50\nRTIFN ein ifn 50\nCIFN ifn ifno 10n\nRLOADN ifno 0 50\n"
    s += ".options savecurrents\n" if 'op' in analysis else ''
    return s + analysis + "\n.end\n"

def run(net, tag):
    d = os.path.join(HERE, f'runs_ar{AR:g}' + (f'_cp{CPAR*1e15:g}f' if CPAR else '')); os.makedirs(d, exist_ok=True)
    p = os.path.join(d, tag + '.sp'); open(p, 'w').write(net)
    env = dict(os.environ, OMP_WAIT_POLICY='passive')
    r = subprocess.run([NGS, '-b', p], capture_output=True, text=True, env=env, cwd=d, timeout=3000)
    open(os.path.join(d, tag + '.log'), 'w').write(r.stdout + r.stderr)
    return r.stdout + r.stderr

def tran(r1, flo, tones, p_rf=-25, model='fb5npn_hp', tag='t', window=20e-9, reltol=1e-4):
    tset = 3e-9; fmax = max(flo, *tones)
    step = min(1 / fmax / 40, 4e-12)
    an = f""".options reltol={reltol} abstol=1e-12 vntol=1e-7 method=trap
.tran {step:.3g} {tset+window:.4g} 0 {step:.3g}
.control
run
wrdata {tag}.dat v(ifo)
.endc"""
    run(netlist(r1, flo, tones, p_rf=p_rf, model=model, analysis=an), tag)
    a = np.loadtxt(os.path.join(HERE, f'runs_ar{AR:g}' + (f'_cp{CPAR*1e15:g}f' if CPAR else ''), tag + '.dat'))
    t, v = a[:, 0], a[:, 1]
    if t[-1] < (tset + window) * 0.999: raise RuntimeError(tag + ': transient aborted')
    tu = np.linspace(tset, tset + window, 8192, endpoint=False)
    vu = np.interp(tu, t, v)
    return lambda f: 2 * abs(np.sum(vu * np.exp(-2j * np.pi * f * tu))) / len(tu)

def dbm(a): return 10 * math.log10(a * a / 100 / 1e-3) if a > 0 else -300     # amplitude on 50 ohm -> dBm

def gain(r1, frf, model='fb5npn_hp'):
    tag = f"g_r{r1}_{frf/1e9:.2f}_{model}"
    A = tran(r1, frf - FIF, (frf,), model=model, tag=tag)
    return dbm(A(FIF)) - (-25.0)

def two_tone(r1, flo, p_rf):
    tag = f"ip3_r{r1}_{flo/1e9:.2f}_{p_rf}"
    A = tran(r1, flo, (flo + 100e6, flo + 120e6), p_rf=p_rf, tag=tag, window=50e-9, reltol=1e-4)
    pf = (dbm(A(100e6)) + dbm(A(120e6))) / 2; pim = (dbm(A(80e6)) + dbm(A(140e6))) / 2
    oip3 = pf + (pf - pim) / 2
    return pf, pim, oip3

def compress(r1, frf):
    """output 1 dB compression: sweep RF input power, single tone"""
    out = []
    for p in np.arange(-25, 6, 2.0):
        A = tran(r1, frf - FIF, (frf,), p_rf=p, tag=f"c_r{r1}_{frf/1e9:.1f}_{p}")
        out.append((p, dbm(A(FIF))))
    g0 = out[0][1] - out[0][0]
    for (p0, o0), (p1, o1) in zip(out, out[1:]):
        c0, c1 = o0 - p0 - g0, o1 - p1 - g0
        if c1 <= -1 < c0 or c1 <= -1:
            x = (-1 - c0) / (c1 - c0) if c1 != c0 else 0
            return p0 + x * (p1 - p0), o0 + x * (o1 - o0)
    return float('nan'), float('nan')

def noise(r1):
    """hard-switched static estimate: LO held at +0.4 V DC (quad fully steered), .noise RF source -> IF load at 100 MHz.
    Square-wave switching keeps the total output noise and reduces signal gain by 2/pi -> F_SSB ~ F_static * pi^2/4."""
    an = """.control
noise v(ifo) VSRF lin 3 99e6 101e6 1
setplot noise1
print inoise_spectrum
.endc"""
    o = run(netlist(r1, 0, (), lo_static=0.4, analysis=an), f"n_r{r1}")
    ino = float([l for l in o.splitlines() if l.startswith('1\t')][0].split()[2])   # V/rtHz at 100 MHz, w.r.t. source EMF
    # input-referred noise is w.r.t. the source EMF; source resistor 50 ohm contributes 4kT*50 V^2
    kT = 1.380649e-23 * 300.15
    f_static = ino ** 2 / (4 * kT * 50)
    return 10 * math.log10(f_static), 10 * math.log10(f_static * math.pi ** 2 / 4)

def op():
    an = """.control
op
show q : vce vbe ic
print v(op) v(c1) v(c2) v(brp) v(er1) v(blp) v(eip) v(ref) v(rfp) v(lop)
print -i(vcc)
.endc"""
    return run(netlist(0, 0, (), analysis=an), 'op') + run(netlist(13, 0, (), analysis=an), 'op16')

if __name__ == '__main__':
    what = sys.argv[1] if len(sys.argv) > 1 else 'all'
    if what == 'op': print(op()); sys.exit()
    if what == 'bw':    # quick -3 dB bandwidth (sensitivity runs): gilbert.py bw R1
        fr = [0.4, 1, 2, 4, 6, 8, 10, 12, 14, 16, 20, 25]
        with cf.ProcessPoolExecutor(12) as ex: g = list(ex.map(gain, [float(sys.argv[2])] * len(fr), [f * 1e9 for f in fr]))
        g0 = g[0]; bw = next((f0 + (g0 - 3 - a) / (b - a) * (f1 - f0) for f0, f1, a, b in zip(fr, fr[1:], g, g[1:]) if a >= g0 - 3 > b), float('nan'))
        print(f"CPAR {CPAR*1e15:g} fF R1 {sys.argv[2]}: gain {g0:.2f} dB BW {bw:.2f} GHz"); sys.exit()
    if what == 'gain': print(gain(float(sys.argv[2]), float(sys.argv[3]) * 1e9, sys.argv[4] if len(sys.argv) > 4 else 'fb5npn_hp')); sys.exit()
    freqs = [0.4, 1.0, 2.0, 3.0, 4.0, 5.0, 6.0, 8.0, 10.0, 12.0, 14.0, 16.0, 20.0, 25.0, 30.0]
    res = {}
    with cf.ProcessPoolExecutor(12) as ex:
        jobs = {(r1, f): ex.submit(gain, r1, f * 1e9) for r1 in (13, 0) for f in freqs}
        jobs.update({('v', r1, f): ex.submit(gain, r1, f * 1e9, 'fb5npn_hp_v') for r1 in (13, 0) for f in (1.0, 5.0, 10.0)})
        jobs.update({('ip', r1, f, p): ex.submit(two_tone, r1, f * 1e9, p) for r1 in (13, 0) for f in (1.5, 5.0, 10.0) for p in (-25, -19)})
        jobs.update({('cp', r1, f): ex.submit(compress, r1, f * 1e9) for r1 in (13, 0) for f in (1.5, 5.0, 10.0)})
        jobs.update({('nf', r1): ex.submit(noise, r1) for r1 in (13, 0)})
        for k, j in jobs.items(): res[k] = j.result()
    L = [f"FB5 Gilbert mixer vs Glenn et al. BCTM 1995 (RL = {RL} ohm, tuned to JLG18 10.4 dB; RF pair {AR:g} mA/side, quad {AR/2:g} mA each)", ""]
    for r1, name in ((13, 'JLG16'), (0, 'JLG18')):
        g = [res[(r1, f)] for f in freqs]; g0 = np.mean(g[:2])
        # -3 dB bandwidth by log interpolation
        bw = float('nan')
        for (f0, a), (f1, b) in zip(zip(freqs, g), zip(freqs[1:], g[1:])):
            if a >= g0 - 3 > b: bw = f0 + (g0 - 3 - a) / (b - a) * (f1 - f0); break
        L.append(f"{name} (R1={r1}): gain vs RF frequency (GHz: dB) " + ', '.join(f"{f}: {x:.2f}" for f, x in zip(freqs, g)))
        L.append(f"{name}: low-f gain {g0:.2f} dB, -3 dB BW {bw:.2f} GHz, GBW {10**(g0/20)*bw:.1f} GHz")
        L.append(f"{name}: VBIC hp_v gain at 1/5/10 GHz " + ', '.join(f"{res[('v', r1, f)]:.2f}" for f in (1.0, 5.0, 10.0)))
        for f in (1.5, 5.0, 10.0):
            a, b = res[('ip', r1, f, -25)], res[('ip', r1, f, -19)]
            slope = (b[1] - a[1]) / 6
            ip, op1 = res[('cp', r1, f)]
            L.append(f"{name} LO {f} GHz: OIP3 {a[2]:.1f} / {b[2]:.1f} dBm (Pin -25/-19 dBm/tone, IM3 slope {slope:.2f}), "
                     f"IP1dB {ip:.1f} dBm, OP1dB {op1:.1f} dBm")
        nf = res[('nf', r1)]
        L.append(f"{name}: NF static (LO hard-switched) {nf[0]:.1f} dB -> SSB mixer estimate {nf[1]:.1f} dB (100 MHz)")
        L.append("")
    open(os.path.join(HERE, f'results_ar{AR:g}_rl{RL:g}.txt'), 'w').write('\n'.join(L)); print('\n'.join(L))
