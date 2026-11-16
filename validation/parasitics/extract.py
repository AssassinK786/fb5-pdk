#!/usr/bin/env python3
"""FB5 post-layout netlist / parasitic extraction (research PDK, not a foundry deliverable).

Uses magic 8.3 + SCN3ME_SUBM.30.5hp.tech (generated from the vendored qflow
SCMOS tech by fb5_5hp_rc.py from wet_tables/fb5_wet.tsv: IBM 5HP measured+
derived R/C, plus explicitly-labelled PROXY fringe/contact; see RC_SOURCES.md) to
extract, from digital/gds/osu05_stdcells.gds2:
  * MOSFET W/L and junction AS/AD/PS/PD (device geometry from layout)
  * wire resistance R (extresist: poly / metal1 / metal2 / metal3 sheet rho)
  * parasitic capacitance C (areacap / perimc / overlap / sideoverlap rules;
    substrate, coupling and fringe caps to gnd/vdd and between nets)

Output: netlists/<CELL>.sp - ngspice subcircuits with .subckt ports, R and C.
Usage:  python3 extract.py [--cells INVX1,NAND2X1] > extract.txt
        python3 extract.py --all          (all 39 liberty cells)
"""
import os, re, sys, subprocess, tempfile, shutil

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
TECH = os.path.join(HERE, 'SCN3ME_SUBM.30.5hp.tech')  # IBM 5HP measured R/C; see RC_SOURCES.md
GDS  = os.path.join(ROOT, 'digital', 'gds', 'osu05_stdcells.gds2')
LIB  = os.path.join(ROOT, 'digital', 'lib', 'fb5_osu_tt_3p3v3p3v.lib') if False else os.path.join(ROOT, 'digital', 'lib', 'fb5_osu_tt_3p3v.lib')
OUT  = os.path.join(HERE, 'netlists')

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

def cells_from_liberty():
    # PAD* cells are LEF/liberty abstractions with no geometry in the GDS;
    # skip them (documented in digital/lef/README.md).
    return [c for c in re.findall(r'^\s*cell\s*\(\s*([^)]+)\)', open(LIB).read(), re.M)
            if not c.startswith('PAD')]

def extract_one(cell, workdir):
    script = os.path.join(workdir, 'extract_cell.tcl')
    open(script, 'w').write(TCL.format(tech=TECH, gds=GDS, cell=cell, out=os.path.join(OUT, cell + '.sp')))
    r = subprocess.run(['magic', '-dnull', '-noconsole', '-T', TECH, script],
                       cwd=workdir, capture_output=True, text=True, timeout=300)
    return r

def summarise(path):
    s = open(path).read()
    R = [float(v) for v in re.findall(r'^R\S+\s+\S+\s+\S+\s+([\d.eE+-]+)', s, re.M)]
    C = [float(v) for v in re.findall(r'^C\S+\s+\S+\s+\S+\s+([\d.eE+-]+)f', s, re.M)]
    M = len(re.findall(r'^M\S+\s', s, re.M))
    ports = re.search(r'^\.subckt\s+\S+\s+(.*)$', s, re.M)
    return dict(mos=M, nr=len(R), nc=len(C), sumc=sum(C), maxr=max(R, default=0.0),
                ports=(ports.group(1).strip() if ports else ''))

def main():
    global TECH
    os.makedirs(OUT, exist_ok=True)
    if '--tech' in sys.argv:   # reproduce the AMI C5 baseline for comparison
        TECH = os.path.abspath(sys.argv[sys.argv.index('--tech') + 1])
    cells = cells_from_liberty()
    if '--cells' in sys.argv:
        want = set(sys.argv[sys.argv.index('--cells') + 1].split(','))
        cells = [c for c in cells if c in want]
    print('FB5 post-layout extraction (magic %s, %s)' %
          (subprocess.run(['magic','--version'],capture_output=True,text=True).stdout.strip().split('\n')[0],
           os.path.basename(TECH)))
    print('source GDS : %s' % GDS.replace(ROOT + '/', ''))
    print('cells      : %d (7 PAD* cells skipped: abstract-only, no GDS geometry)' % len(cells))
    print('=' * 96)
    tot = dict(mos=0, nr=0, nc=0, sumc=0.0)
    bad = []
    # A FRESH workdir per cell: magic's extresist otherwise picks up stray
    # .ext files from the previous cell and the extracted R/C count drifts.
    for cell in cells:
        with tempfile.TemporaryDirectory(prefix='fb5ext-') as td:
            extract_one(cell, td)
        p = os.path.join(OUT, cell + '.sp')
        if not os.path.exists(p) or os.path.getsize(p) < 50:
            bad.append(cell + ' (no netlist)'); continue
        s = summarise(p)
        if s['mos'] == 0: bad.append(cell + ' (no MOS devices)')
        if not s['ports']: bad.append(cell + ' (no .subckt ports)')
        for k in tot: tot[k] += s[k]
        print(f"{cell:12s} MOS {s['mos']:2d}  sum(C) {s['sumc']:8.2f} fF  "
              f"max(R) {s['maxr']:8.1f} ohm  ports: {s['ports']}", flush=True)
    print('=' * 96)
    print(f"TOTAL: {len(cells)} cells, {tot['mos']} MOSFETs, sum(C) {tot['sumc']:.1f} fF")
    print('Note: magic extresist element counts vary by +/-1 between runs for some')
    print('      complex cells (DFFSR); total C and max R are stable, so the report')
    print('      lists those physical quantities instead of raw element counts.')
    print('EXTRACT: PASS' if not bad else 'EXTRACT: FAIL -> ' + '; '.join(bad))
    sys.exit(0 if not bad else 1)

if __name__ == '__main__': main()
