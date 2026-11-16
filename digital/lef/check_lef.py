#!/usr/bin/env python3
"""FB5 LEF validation. Run with:  klayout -b -r check_lef.py
Prints 'LEF CHECK: PASS' on success; raises on any inconsistency."""
import os, re, sys
import pya

HERE = os.path.dirname(os.path.abspath(__file__))
ROOT = os.path.abspath(os.path.join(HERE, '..', '..'))
LEF = os.path.join(HERE)

def read_lef(name):
    ly = pya.Layout(); opt = pya.LoadLayoutOptions()
    opt.lefdef_config.read_lef_with_def = False
    ly.read(os.path.join(LEF, name), opt)
    return ly

def names(path, pat):
    return set(x.upper() for x in re.findall(pat, open(path, errors='ignore').read(), re.I | re.M))

errs = []
tech = read_lef('fb5_tech.lef')
cell = read_lef('fb5_stdcell.lef')
if tech.cells() != 0: errs.append('tech LEF unexpectedly contains cells')
macros = set(c.name.upper() for c in cell.each_cell())
if len(macros) != 40: errs.append('expected 40 MACROs, got %d' % len(macros))

lib = names(os.path.join(ROOT, 'digital/lib/fb5_osu_tt_3p3v.lib'), r'^\s*cell\s*\(\s*([^)]+)\)')
ver = names(os.path.join(ROOT, 'digital/verilog/osu05_stdcells.v'), r'^module\s+(\w+)')
spc = names(os.path.join(ROOT, 'digital/spice/fb5_osu_cells.sp'), r'^\.subckt\s+(\S+)')
gds = pya.Layout(); gds.read(os.path.join(ROOT, 'digital/gds/osu05_stdcells.gds2'))
gdsnames = set(c.name.upper() for c in gds.each_cell())

if lib - macros: errs.append('liberty cells missing from LEF: %s' % sorted(lib - macros))
if macros - lib != {'FILL'}: errs.append('LEF-only cells: %s' % sorted(macros - lib))
if ver - macros: errs.append('Verilog modules missing from LEF: %s' % sorted(ver - macros))
if spc - macros: errs.append('SPICE subckts missing from LEF: %s' % sorted(spc - macros))
pads = {x for x in macros if x.startswith('PAD')}
if pads - gdsnames != pads: errs.append('PAD* macros unexpectedly found in GDS')
if not (gdsnames - macros) <= {'IIT_STDCELLS'}:
    errs.append('unexpected GDS cells: %s' % sorted(gdsnames - macros))

# every LAYER referenced inside a MACRO must be declared in the tech LEF
declared = set(x.upper() for x in re.findall(r'^LAYER\s+(\S+)', open(os.path.join(LEF,'fb5_tech.lef')).read(), re.M))
used = set(x.upper() for x in re.findall(r'^\s*LAYER\s+(\S+)\s*;', open(os.path.join(LEF,'fb5_stdcell.lef')).read(), re.M))
if used - declared: errs.append('MACRO references undeclared LEF layers: %s' % sorted(used - declared))

print('MACROs: %d | liberty: %d | Verilog: %d | SPICE: %d | GDS cells: %d' %
      (len(macros), len(lib), len(ver), len(spc), len(gdsnames)))
print('declared LEF layers: %s' % ', '.join(sorted(declared)))
print('PAD* abstract-only (no GDS geometry): %s' % ', '.join(sorted(pads)))
for e in errs: print('ERROR:', e)
print('LEF CHECK: PASS' if not errs else 'LEF CHECK: FAIL (%d errors)' % len(errs))
if errs: sys.exit(1)
