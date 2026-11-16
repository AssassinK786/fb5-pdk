#!/usr/bin/env python3
"""FB5 post-layout simulation (research PDK, not a foundry deliverable).

Compares a 3-stage standard-cell chain simulated from:
  pre-layout  : digital/spice/fb5_osu_cells.sp  (schematic netlist, ad/pd/as/ps = 0)
  post-layout : netlists/<CELL>.sp             (magic extraction: W/L, AS/AD/PS/PD,
                                                wire R and coupling/substrate C)

Both netlists are bound to the FB5 BSIM3 tt models (nfet/pfet -> fb5n/fb5p).
Subckt port lists are parsed from each netlist, so cells with different pin
orders (INVX1 vs INVX2 vs NAND2X1) are instantiated correctly by name.

Usage: python3 postlayout.py > postlayout.txt
"""
import os, re, sys, subprocess, tempfile

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
PRE  = os.path.join(ROOT, 'digital', 'spice', 'fb5_osu_cells.sp')
POST = os.path.join(HERE, 'netlists')
MODELS = os.path.join(ROOT, 'models', 'fb5_tt_cards.sp')
CELLS = ['INVX1', 'INVX2', 'INVX4', 'INVX8', 'NAND2X1', 'NOR2X1']

def subckt(text, cell):
    """Return (port list, subckt text) for <cell>, or (None, None)."""
    s = text
    m = re.search(r'^\.subckt\s+' + re.escape(cell) + r'\s+([^\n]*)\n(.*?)^\s*\.ends\b',
                  s, re.M | re.S | re.I)
    if not m: return None, None
    return m.group(1).split(), m.group(0)

def strip_models(s, cell):
    """Keep only <cell>'s subckt, bind nfet/pfet to FB5 models."""
    ports, body = subckt(s, cell)
    if body is None: return None
    return re.sub(r'\bnfet\b', 'fb5n', re.sub(r'\bpfet\b', 'fb5p', body), flags=re.I)

def xline(ports, inp, out):
    """Build an X instance line from a parsed port list, mapping by pin name."""
    mp = {'VDD': 'vdd', 'GND': '0', 'VPWR': 'vdd', 'VSS': '0',
          'Y': out, 'YN': out, 'Q': out, 'A': inp, 'B': inp, 'C': inp, 'D': inp,
          'S': inp, 'R': inp, 'EN': inp, 'CLK': inp}
    nodes = [mp.get(p.upper(), inp) for p in ports]
    return ' '.join(nodes)

def deck(bound, cell, ports):
    x = lambda i, a, b: 'X%d %s %s' % (i, xline(ports, a, b), cell)
    return f"""* FB5 post-layout chain: {cell} (3 stages, 20 fF load)
.include {MODELS}
{bound}
Vdd vdd 0 3.3
Vin in 0 PULSE(0 3.3 0 100p 100p 2n 4n)
{x(1,'in','n1')}
{x(2,'n1','n2')}
{x(3,'n2','out')}
Cload out 0 20f
.options reltol=1e-4 abstol=1e-12 vntol=1e-7
.tran 1p 4n
.control
run
meas tran t1 TRIG v(in) VAL=1.65 RISE=1 TARG v(n1) VAL=1.65 FALL=1
meas tran t2 TRIG v(n1) VAL=1.65 FALL=1 TARG v(n2) VAL=1.65 RISE=1
meas tran t3 TRIG v(n2) VAL=1.65 RISE=1 TARG v(out) VAL=1.65 FALL=1
.endc
.end
"""

def meas(deck_text, tag, td):
    p = os.path.join(td, tag + '.sp'); open(p, 'w').write(deck_text)
    r = subprocess.run(['ngspice', '-b', p], cwd=td, capture_output=True, text=True, timeout=300)
    o = r.stdout
    vals = [float(v) for v in re.findall(r'^t[123]\s*=\s*([\d.eE+-]+)', o, re.M)]
    return (sum(vals) / len(vals) * 1e12) if len(vals) == 3 else float('nan'), o

def rc_stats(cell):
    s = open(os.path.join(POST, cell + '.sp')).read()
    R = [float(v) for v in re.findall(r'^R\S+\s+\S+\s+\S+\s+([\d.eE+-]+)', s, re.M)]
    C = [float(v) for v in re.findall(r'^C\S+\s+\S+\s+\S+\s+([\d.eE+-]+)f', s, re.M)]
    return len(R), len(C), sum(C), sum(R)

def main():
    pre = open(PRE).read()
    print('FB5 pre-layout vs post-layout simulation (VDD 3.3 V, tt, 27 C)')
    print('pre  : digital/spice/fb5_osu_cells.sp (schematic, no AS/AD/PS/PD)')
    print('post : magic ext2spice with R/C from validation/parasitics/netlists/')
    print('bench: 3-stage chain, 20 fF load, average of 3 propagation delays')
    print('=' * 100)
    print(f"{'cell':10s} {'R':>4s} {'C':>4s} {'sumC[fF]':>9s} {'pre[ps]':>9s} {'post[ps]':>9s} {'delta':>9s} {'%':>7s}")
    bad = []
    with tempfile.TemporaryDirectory(prefix='fb5pl-') as td:
        for cell in CELLS:
            pp = os.path.join(POST, cell + '.sp')
            if not os.path.exists(pp): bad.append(cell + ' (no extracted netlist)'); continue
            ports_pre, _ = subckt(pre, cell)
            bound_pre = strip_models(pre, cell)
            bound_post = strip_models(open(pp).read(), cell)
            if bound_pre is None or bound_post is None: bad.append(cell + ' (subckt parse)'); continue
            tpre, o1 = meas(deck(bound_pre, cell, ports_pre), cell + '_pre', td)
            ports_post, _ = subckt(open(pp).read(), cell)
            tpost, o2 = meas(deck(bound_post, cell, ports_post), cell + '_post', td)
            nr, nc, sc, sr = rc_stats(cell)
            delta = tpost - tpre
            pct = 100 * delta / tpre if tpre else float('nan')
            print(f"{cell:10s} {nr:4d} {nc:4d} {sc:9.2f} {tpre:9.2f} {tpost:9.2f} {delta:+9.2f} {pct:+7.1f}", flush=True)
    print('=' * 100)
    print('POSTLAYOUT: PASS' if not bad else 'POSTLAYOUT: FAIL -> ' + '; '.join(bad))
    sys.exit(0 if not bad else 1)

if __name__ == '__main__': main()
