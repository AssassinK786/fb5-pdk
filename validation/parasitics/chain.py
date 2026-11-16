#!/usr/bin/env python3
"""FB5 top-level placed-and-routed post-layout simulation (research PDK).

End-to-end demo: 3 INVX1 cells + metal1 routing -> GDS -> magic extraction ->
ngspice post-layout transient.

Three views of the same 3-inverter chain, all with 20 fF output load:
  pre       : schematic netlist, no parasitics
  cell-post : cell-level extracted subckts (device geometry + local wire R/C)
  full-post : hierarchical chain extraction = the SAME cell-level subckts
              (with R/C) PLUS the interconnect C extracted from the routing.

Note: magic's extresist does not emit wire R for the top-level routing with this
tech, so the full-post view adds interconnect C but not interconnect R. The
cell-level local wire R (poly gate R etc.) IS present. See README.md.

Usage: python3 chain.py > chain.txt
Requires: klayout (pya), magic, ngspice, SCN3ME_SUBM.30.5hp.tech.
"""
import os, re, sys, subprocess, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
TECH = os.path.join(HERE, 'SCN3ME_SUBM.30.5hp.tech')  # IBM 5HP measured R/C
GDS  = os.path.join(HERE, 'fb5_inv_chain.gds')
PRE  = os.path.join(ROOT, 'digital', 'spice', 'fb5_osu_cells.sp')
CELLPOST = os.path.join(HERE, 'netlists', 'INVX1.sp')
FULLPOST = os.path.join(HERE, 'netlists', 'FB5_INV_CHAIN.sp')
MODELS = os.path.join(ROOT, 'models', 'fb5_tt_cards.sp')

TCL = """tech load {tech} -noprompt
gds read {gds}
load FB5_INV_CHAIN
select top cell
port makeall
select top cell
extract all
extresist all
ext2spice lvs
ext2spice format ngspice
ext2spice extresist on
ext2spice hierarchy on
ext2spice rthresh 0
ext2spice cthresh 0
ext2spice -o {out}
quit
"""

def subckt(text, cell):
    m = re.search(r'^\.subckt\s+' + re.escape(cell) + r'\s+([^\n]*)\n(.*?)^\s*\.ends\b',
                  text, re.M | re.S | re.I)
    return (m.group(1).split(), m.group(0)) if m else (None, None)

def bind(s):
    s = re.sub(r'\bnfet\b', 'fb5n', s, flags=re.I)
    s = re.sub(r'\bpfet\b', 'fb5p', s, flags=re.I)
    return '\n'.join(l.split(';')[0] if '; **FLOATING' in l else l for l in s.splitlines())

def xline(idx, ports, inp, out):
    mp = {'VDD':'vdd','GND':'0','A':inp,'Y':out}
    return 'X%d %s INVX1' % (idx, ' '.join(mp.get(p.upper(), inp) for p in ports))

TAIL = """.options reltol=1e-4 abstol=1e-12 vntol=1e-7
.tran 1p 4n
.control
run
meas tran td TRIG v(in) VAL=1.65 RISE=1 TARG v(out) VAL=1.65 FALL=1
.endc
.end
"""

def sim(deck_text, tag, td):
    p = os.path.join(td, tag + '.sp'); open(p, 'w').write(deck_text)
    r = subprocess.run(['ngspice', '-b', p], cwd=td, capture_output=True, text=True, timeout=300)
    m = re.search(r'^td\s*=\s*([\d.eE+-]+)', r.stdout, re.M)
    return float(m.group(1)) * 1e12 if m else float('nan')

def chain_deck(bound_cell, ports, load=20e-15):
    """pre or cell-post: 3 explicit INVX1 subcircuits."""
    return f"""* FB5 3 x INVX1 chain
.include {MODELS}
{bound_cell}
Vdd vdd 0 3.3
Vin in 0 PULSE(0 3.3 0 100p 100p 2n 4n)
{xline(1,ports,'in','n1')}
{xline(2,ports,'n1','n2')}
{xline(3,ports,'n2','out')}
Cload out 0 {load}
""" + TAIL

def main():
    os.makedirs(os.path.join(HERE, 'netlists'), exist_ok=True)
    r = subprocess.run(['klayout', '-b', '-r', os.path.join(HERE, 'build_chain.py')],
                       cwd=HERE, capture_output=True, text=True, timeout=300)
    print('build_chain.py:', (r.stdout.strip().splitlines() or [r.stderr[-200:]])[-1])
    with tempfile.TemporaryDirectory(prefix='fb5chain-') as td:
        tcl = os.path.join(td, 'chain.tcl')
        open(tcl, 'w').write(TCL.format(tech=TECH, gds=GDS, out=FULLPOST))
        r = subprocess.run(['magic', '-dnull', '-noconsole', '-T', TECH, tcl],
                           cwd=td, capture_output=True, text=True, timeout=300)
        if not os.path.exists(FULLPOST): print('MAGIC EXTRACT FAILED', r.stdout[-500:]); sys.exit(1)
    hier = open(FULLPOST).read()
    # top-level interconnect capacitance from the routed layout
    inter = re.findall(r'^(C\S+\s+\S+\s+\S+\s+[\d.eE+-]+f?)', hier, re.M)
    inter_sum = sum(float(re.search(r'([\d.eE+-]+)f?\s*$', x.strip()).group(1)) for x in inter)
    print(f'extracted routed chain: {len(inter)} interconnect capacitors, sum(C) {inter_sum:.2f} fF')
    # replace magic's R-less child subckt with the full cell-level extracted subckt
    cellsp = open(CELLPOST).read()
    cellsp = re.sub(r'^\.subckt\s+INVX1\s+.*$', '.subckt INVX1 A vdd gnd Y', cellsp, flags=re.M)
    top = re.sub(r'^\.subckt\s+INVX1\b.*?^\s*\.ends\s*$', '', hier, count=1, flags=re.M | re.S)
    full_deck = f"""* FB5 routed chain: cell-level R/C subckts + extracted interconnect C
.include {MODELS}
{bind(cellsp)}
{bind(top)}
Vdd vdd 0 3.3
Vin in 0 PULSE(0 3.3 0 100p 100p 2n 4n)
Xchain in out vdd 0 FB5_INV_CHAIN
Cload out 0 20f
""" + TAIL

    pre_ports, pre_body = subckt(open(PRE).read(), 'INVX1')
    cp_ports, cp_body = subckt(open(CELLPOST).read(), 'INVX1')
    with tempfile.TemporaryDirectory(prefix='fb5chainsim-') as td:
        tpre = sim(chain_deck(bind(pre_body), pre_ports), 'pre', td)
        tcp  = sim(chain_deck(bind(cp_body), cp_ports), 'cellpost', td)
        tfull = sim(full_deck, 'fullpost', td)
    print('=' * 88)
    print('3-stage INVX1 chain, VDD 3.3 V, tt, 20 fF load; delay = in(rise) -> out(fall)')
    print(f"{'view':32s} {'delay[ps]':>10s} {'per-stage[ps]':>14s} {'delta vs pre':>13s}")
    for name, t in (('pre-layout (schematic)', tpre),
                    ('post-layout (cell R/C)', tcp),
                    ('post-layout (cells + routing C)', tfull)):
        print(f"{name:32s} {t:10.2f} {t/3:14.2f} {t-tpre:+13.2f}")
    print('=' * 88)
    ok = tfull >= tcp > tpre > 0
    print('CHAIN: PASS' if ok else 'CHAIN: FAIL (unexpected delay ordering)')
    sys.exit(0 if ok else 1)

if __name__ == '__main__': main()
