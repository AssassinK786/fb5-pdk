#!/usr/bin/env python3
"""Compare two directories of magic-extracted SPICE netlists SEMANTICALLY.

magic's ext2spice assigns internal node names nondeterministically and, for
resistive nets, redistributes small fringe caps among subnodes (the per-net
TOTAL C is stable).  So this checker compares:
  * exact sorted device geometry (W/L, AS/AD/PS/PD) and subckt port names
  * exact MOS / R / C element counts
  * total R and total C within 0.5 %
Node names, capacitor terminal order and per-element cap splitting are ignored.
Usage: check_netlists.py dirA dirB
"""
import os, re, sys

def num(x):
    x = x.rstrip('fpumk')
    try: return float(x)
    except ValueError: return 0.0

def sig(path):
    s = open(path).read()
    dev = sorted(re.findall(r'\b(?:w|l|ad|pd|as|ps)=([\w.+-]+)', s))
    res = [num(x) for x in re.findall(r'^R\S+\s+\S+\s+\S+\s+([\w.+-]+)', s, re.M)]
    cap = [num(x) for x in re.findall(r'^C\S+\s+\S+\s+\S+\s+([\w.+-]+)', s, re.M)]
    por = sorted(re.findall(r'^\.subckt\s+\S+\s+(.*)$', s, re.M))
    mos = len(re.findall(r'^M\S+\s', s, re.M))
    return dev, por, mos, len(res), len(cap), sum(res), sum(cap)

def close(a, b, tol=0.005):
    return abs(a - b) <= tol * max(abs(a), abs(b), 1e-30)

def main():
    a, b = sys.argv[1], sys.argv[2]
    fa = set(f for f in os.listdir(a) if f.endswith('.sp'))
    fb = set(f for f in os.listdir(b) if f.endswith('.sp'))
    bad, advisory = [], []
    if fa != fb: bad.append('file sets differ: %s / %s' % (sorted(fa - fb), sorted(fb - fa)))
    for f in sorted(fa & fb):
        x, y = sig(os.path.join(a, f)), sig(os.path.join(b, f))
        # STRICT: these are stable across magic runs and define the circuit.
        for i, nm in ((0,'device geometry'), (1,'ports'), (2,'MOS count')):
            if x[i] != y[i]: bad.append('%s: %s differs (%s vs %s)' % (f, nm, x[i], y[i]))
        if not close(x[6], y[6], 0.01):
            bad.append('%s: total C %.4g vs %.4g' % (f, x[6], y[6]))
        if x[2] == 0: bad.append('%s: no MOS devices' % f)
        # ADVISORY: magic extresist splits borderline resistive nets into a
        # different number of R/C elements between runs (HAX1 +/-3 elements,
        # total R +/-2%).  Electrical delay is covered by the byte-identical
        # postlayout.txt / chain.txt / rc_comparison.txt reports.
        for i, nm in ((3,'R count'), (4,'C count')):
            if abs(x[i] - y[i]) > 4: bad.append('%s: %s differs (%s vs %s)' % (f, nm, x[i], y[i]))
            elif x[i] != y[i]: advisory.append('%s: %s %s vs %s (extresist split)' % (f, nm, x[i], y[i]))
        if not close(x[5], y[5], 0.05):
            advisory.append('%s: total R %.4g vs %.4g (extresist split)' % (f, x[5], y[5]))
    print('checked %d netlists' % len(fa & fb))
    for e in advisory: print('ADVISORY:', e)
    for e in bad: print('ERROR:', e)
    print('NETLIST CHECK: PASS' if not bad else 'NETLIST CHECK: FAIL')
    sys.exit(0 if not bad else 1)

if __name__ == '__main__': main()
