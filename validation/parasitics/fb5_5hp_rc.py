#!/usr/bin/env python3
"""FB5 IBM 5HP R/C - table-driven generator (research PDK, not a foundry deliverable).

Reads wet_tables/fb5_wet.tsv (MOSIS WAT format: PROCESS PARAMETERS +
CAPACITANCE PARAMETERS) and generates SCN3ME_SUBM.30.5hp.tech from the
vendored qflow AMI C5 magic tech.

magic 'extract' units (experimentally calibrated, see RC_SOURCES.md):
  resist   = milliohm/sq     areacap/overlap = aF/lambda^2
  perimc/sideoverlap = aF/lambda            contact = milliohm
  lambda = 0.30 um  =>  aF/um^2 * 0.09 , aF/um * 0.30 , ohm * 1000

STATUS HONESTY: rows with status MISSING have NO public 5HP measurement.
They are filled with explicitly-labelled PROXY values (documented in
wet_tables/README.md and RC_SOURCES.md) - these are NOT measurements.
Supply the real WAT numbers in the tsv (status=MEASURED) to replace them.

Usage: python3 fb5_5hp_rc.py [--report] [--no-proxy]
"""
import os, re, sys

HERE = os.path.dirname(os.path.abspath(__file__))
SRC  = os.path.join(HERE, 'SCN3ME_SUBM.30.tech')        # AMI C5 baseline
DST  = os.path.join(HERE, 'SCN3ME_SUBM.30.5hp.tech')    # generated, checked in
TSV  = os.path.join(HERE, 'wet_tables', 'fb5_wet.tsv')

LAM_UM = 0.30
EPS0, EPS_OX = 8.854e-12, 3.9

CONV = {                     # WAT physical unit -> magic rule unit
    'area':   0.09,          # aF/um^2  -> aF/lambda^2
    'fringe': 0.30,          # aF/um    -> aF/lambda
    'sheet':  1000.0,        # ohm/sq   -> milliohm/sq
    'contact':1000.0,        # ohm      -> milliohm
}

def parallel_plate_fF_um2(t_um):
    return EPS0 * EPS_OX / (t_um * 1e-6) * 1e3

def load_wet():
    rows = {}
    with open(TSV, encoding='utf-8-sig') as f:
        for ln in f:
            ln = ln.rstrip('\n')
            if not ln.strip() or ln.lstrip().startswith('#'): continue
            c = ln.split('\t')
            if c[0].strip() == 'key': continue
            if len(c) < 8: continue
            rows[c[0].strip()] = dict(wat_row=c[1], pair=c[2], unit=c[3],
                                      ami=c[4].strip(), hp5=c[5].strip(),
                                      status=c[6].strip(), source=c[7].strip(),
                                      note=(c[8].strip() if len(c) > 8 else ''))
    return rows

WET = load_wet()

def num(key, col):
    v = WET[key][col]
    return None if v in ('-', '') else float(v)

def group(key):
    return key.split('_')[0]

# ---- sheet resistance (MEASURED) --------------------------------------------
RSH_METAL = {'m1': num('sheet_m1','hp5'), 'm2': num('sheet_m2','hp5'), 'm3': num('sheet_m3','hp5')}
RSH_LM    = num('sheet_lm','hp5')
RSH_NDIFF = num('sheet_ndiff','hp5')
RSH_NDIFF_AMI = num('sheet_ndiff','ami')

# ---- area / interlevel capacitance (DERIVED from 1.2um ILD) ----------------
CAP_M1_SUB = num('area_m1sub','hp5') / 1000.0    # aF/um2 -> fF/um2
CAP_M2_SUB = num('area_m2sub','hp5') / 1000.0
CAP_M3_SUB = num('area_m3sub','hp5') / 1000.0
CAP_INTER  = num('area_m2m1','hp5') / 1000.0
CAP_BEOL_SUB = 0.03                              # [2] IBM Table 4 measured, fF/um2
ILD_UM = 1.2

def area_token(key):
    """'2.790' style token for the AMI value; new magic value for the 5HP value."""
    ami = num(key,'ami'); hp5 = num(key,'hp5')
    if ami is None or hp5 is None: return None
    return ('%.3f' % (ami * CONV['area'])), \
           ('%.2f' % (hp5 * CONV['area']))

AREA_MAP = {}
for k in ('area_m1sub','area_m2sub','area_m3sub','area_m2m1'):
    t = area_token(k)
    if t: AREA_MAP[t[0]] = t[1]

# ---- fringe/perimeter: PROXY (NO 5HP measurement) --------------------------
# Scale AMI-measured fringe by the 5HP/AMI area-cap ratio of the same pair.
def ratio(key):
    a, h = num(key,'ami'), num(key,'hp5')
    return (h / a) if (a and h) else 1.0

K = {'m1': ratio('area_m1sub'), 'm2': ratio('area_m2sub'),
     'm3': ratio('area_m3sub'), 'inter': ratio('area_m2m1')}
FRINGE_TOKENS = ('22.200','17.400','11.400','8.400','9.600','15.600','15','18')

def fringe_scale(line):
    if '(m3,fm3,rm3' in line: return K['m3']
    if '(m2,fm2,rm2' in line and '(m1,fm1,rm1' in line: return K['inter']
    if '(m2,fm2,rm2' in line: return K['m2']
    if '(m1,fm1,rm1' in line: return K['m1']
    return None

# ---- contact/via resistance: PROXY (NO 5HP measurement) -------------------
CONTACT_MAGIC = {}    # contact type -> new milliohm
for typ, ck, rk in (('ndc','contact_ndc','sheet_ndiff'),
                    ('m2c','contact_m2c','sheet_m2'),
                    ('m3c','contact_m3c','sheet_m3')):
    ami_c, hp5_c = num(ck,'ami'), num(ck,'hp5')
    if WET[ck]['status'] == 'MEASURED' and hp5_c is not None:
        CONTACT_MAGIC[typ] = int(round(hp5_c * CONV['contact']))
    else:
        a, h = num(rk,'ami'), num(rk,'hp5')
        s = (h / a) if (a and h) else 1.0        # first-order proxy only
        CONTACT_MAGIC[typ] = int(round(ami_c * s * CONV['contact']))
# pdc / pc / p2c: no 5HP counterpart sheet R -> keep AMI (documented)
for typ, ck in (('pdc','contact_pdc'), ('pc','contact_pc'), ('p2c','contact_p2c')):
    CONTACT_MAGIC[typ] = int(round(num(ck,'ami') * CONV['contact']))

USE_PROXY = '--no-proxy' not in sys.argv

HEADER = [
    '# ---- FB5 IBM 5HP R/C overrides (generated by fb5_5hp_rc.py from',
    '#      wet_tables/fb5_wet.tsv; see RC_SOURCES.md) ----',
    '# MEASURED : 20 MOSIS SIGE05 WET lots [1] / IBM J.R&D 2003 Tables 4,6,7 [2]',
    '# DERIVED  : 1.2 um SiO2 BEOL geometry [3], validated by IBM Table 4',
    '# PROXY    : fringe capacitance and via/contact resistance have NO public',
    '#            5HP measurement. They are first-order scalings of AMI C5',
    '#            measured values and are NOT 5HP measurements. Replace the',
    '#            WAT table with real data (status=MEASURED) to remove them.',
    '# -------------------------------------------------------------------------',
]

def generate():
    lines = open(SRC).read().splitlines()
    out, in_ext = [], False
    for ln in lines:
        if ln.strip() == 'extract':
            in_ext = True; out.append(ln); out.extend(HEADER); continue
        if in_ext and ln.strip() == 'end':
            in_ext = False; out.append(ln); continue
        if in_ext:
            m = re.match(r'^(\s*resist \(m([123]),[^/]*\)/metal[123]\s+)([\d.]+)', ln)
            c = re.match(r'^(\s*contact\s+(\w+)\s+4\s+)([\d.]+)', ln)
            if m and WET['sheet_m' + m.group(2)]['status'] == 'MEASURED':
                ln = m.group(1) + str(int(RSH_METAL['m' + m.group(2)] * CONV['sheet']))
            elif c and USE_PROXY and c.group(2) in CONTACT_MAGIC:
                ln = c.group(1) + str(CONTACT_MAGIC[c.group(2)])
            elif re.match(r'^\s*resist \(ndiff,', ln) and RSH_NDIFF:
                ln = re.sub(r'(/active\s+)[\d.]+', r'\g<1>' + str(int(RSH_NDIFF * CONV['sheet'])), ln)
            else:
                for old, new in AREA_MAP.items():
                    ln = re.sub(r'(?<![\d.])' + re.escape(old) + r'(?![\d])', new, ln)
                if USE_PROXY and re.match(r'^\s*(perimc|sideoverlap)\b', ln):
                    s = fringe_scale(ln)
                    if s is not None:
                        for t in FRINGE_TOKENS:
                            m2 = re.search(r'(?<![\d.])' + re.escape(t) + r'(?![\d])', ln)
                            if m2:
                                ln = ln[:m2.start()] + ('%.2f' % (float(t) * s)) + ln[m2.end():]
                                break
        out.append(ln)
    open(DST, 'w').write('\n'.join(out) + '\n')

def report():
    print('FB5 5HP R/C: WAT table status (wet_tables/fb5_wet.tsv)')
    print('=' * 112)
    print(f"{'key':18s} {'WAT row':22s} {'AMI C5':>10s} {'5HP':>10s} {'status':10s} source")
    for k, v in WET.items():
        print(f"{k:18s} {v['wat_row'][:22]:22s} {v['ami']:>10s} {v['hp5']:>10s} "
              f"{v['status']:10s} {v['source']}")
    print('=' * 112)
    print('magic conversions:', CONV)
    print('area token map (AMI -> 5HP):', AREA_MAP)
    print('fringe PROXY scale factors:', {k: round(v,4) for k,v in K.items()})
    print('contact magic values (milliohm):', CONTACT_MAGIC)
    n_missing = sum(1 for v in WET.values() if v['status'] == 'MISSING')
    print(f"WARNING: {n_missing} WAT rows have NO public 5HP measurement.")
    print('WARNING: fringe/contact values above are PROXY, NOT 5HP measurements.')

if __name__ == '__main__':
    if '--report' in sys.argv: report()
    else:
        generate(); print('wrote', os.path.relpath(DST, HERE))
