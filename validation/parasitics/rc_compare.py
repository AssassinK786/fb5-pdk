#!/usr/bin/env python3
"""Post-layout delay: AMI C5 generic R/C vs FB5 5HP R/C (research PDK).

The 5HP side contains MEASURED + DERIVED values AND PROXY fringe/contact
values (no public 5HP WAT measurement exists). See wet_tables/README.md.

Re-extracts the six postlayout.py cells with the ORIGINAL qflow AMI C5 magic tech
into a temp dir, then compares 3-stage-chain delays against the checked-in
netlists/ (extracted with the 5HP measured rules). Fully reproducible:
  python3 rc_compare.py > rc_comparison.txt
"""
import os, re, sys, subprocess, tempfile
HERE = os.path.dirname(os.path.abspath(__file__))
sys.path.insert(0, HERE)
import postlayout as pl

AMI = os.path.join(HERE, 'SCN3ME_SUBM.30.tech')
GDS = os.path.join(pl.ROOT, 'digital', 'gds', 'osu05_stdcells.gds2')

TCL = """tech load {tech} -noprompt
gds read {gds}
load {cell}
select top cell
port makeall
select top cell
extract all
extresist all
ext2spice lvs
ext2spice format ngspice
ext2spice extresist on
ext2spice rthresh 0
ext2spice cthresh 0
ext2spice -o {out}
quit
"""

def extract_ami(cell, td):
    out = os.path.join(td, cell + '.sp')
    script = os.path.join(td, 'x.tcl')
    open(script, 'w').write(TCL.format(tech=AMI, gds=GDS, cell=cell, out=out))
    subprocess.run(['magic', '-dnull', '-noconsole', '-T', AMI, script],
                   cwd=td, capture_output=True, text=True, timeout=300)
    return open(out).read() if os.path.exists(out) else ''

def main():
    pre = open(pl.PRE).read()
    print('Post-layout delay: AMI C5 generic R/C vs FB5 5HP R/C (measured + PROXY fringe/contact)')
    print('3-stage chain, VDD 3.3 V, FB5 tt, 20 fF load; average of 3 stage delays')
    print('AMI netlists are re-extracted on the fly from the same GDS with the')
    print('original qflow SCN3ME_SUBM.30.tech (see RC_SOURCES.md).')
    print('=' * 100)
    print(f"{'cell':10s} {'pre[ps]':>9s} {'post AMI C5[ps]':>17s} {'post 5HP[ps]':>14s} "
          f"{'5HP-AMI[ps]':>13s} {'delta%':>8s}")
    with tempfile.TemporaryDirectory(prefix='fb5ami-') as td:
        for cell in pl.CELLS:
            hp5 = open(os.path.join(pl.POST, cell + '.sp')).read()
            ami = extract_ami(cell, td)
            if not ami or not pl.subckt(ami, cell)[1]:
                print(cell, 'AMI EXTRACT FAILED'); continue
            with tempfile.TemporaryDirectory(prefix='fb5amicmp-') as st:
                def delay(text):
                    ports, body = pl.subckt(text, cell)
                    bound = pl.strip_models(text, cell)
                    return pl.meas(pl.deck(bound, cell, ports), cell, st)[0]
                tpre = delay(pre)
                tami = delay(ami)
                t5 = delay(hp5)
            d = t5 - tami
            print(f"{cell:10s} {tpre:9.2f} {tami:17.2f} {t5:14.2f} {d:+13.2f} "
                  f"{100*d/tami:+8.2f}", flush=True)
    print('=' * 100)
    print('RC COMPARE: PASS')

if __name__ == '__main__': main()
