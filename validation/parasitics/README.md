# FB5 parasitic extraction and post-layout simulation

This directory closes the loop **layout GDS -> extracted R/C -> SPICE -> ngspice**:

| step | tool | output |
|---|---|---|
| build a routed top-level layout | KLayout \`pya\` (\`build_chain.py\`) | \`fb5_inv_chain.gds\` |
| extract device geometry, wire R, coupling/substrate C | magic 8.3 \`extract\` + \`extresist\` + \`ext2spice\` (\`extract.py\`) | \`netlists/<CELL>.sp\` (32 cells), \`extract.txt\` |
| cell-level pre/post-layout simulation | ngspice (\`postlayout.py\`) | \`postlayout.txt\` |
| top-level routed post-layout simulation | ngspice (\`chain.py\`) | \`chain.txt\` |
| AMI C5 vs 5HP R/C comparison | \`rc_compare.py\` | \`rc_comparison.txt\` |

## Tech file

\`SCN3ME_SUBM.30.tech\` is the public **MOSIS SCMOS rev 7.2 SUBM** magic tech
shipped with qflow (AMI/onsemi C5 generic rules), vendored as the baseline.
\`SCN3ME_SUBM.30.5hp.tech\` is generated from it by \`fb5_5hp_rc.py\` and is the
**default** for extraction: its \`extract\` section uses IBM 5HP measured values.
See **\`RC_SOURCES.md\`** for the full data retrieval, the magic-unit calibration
and the list of parameters with no public 5HP measurement.

| item | 5HP (used) | AMI C5 baseline | source |
|---|---|---|---|
| M1/M2/M3 sheet R | 0.08 / 0.05 / 0.04 ohm/sq | 0.09 / 0.09 / 0.06 | 20 MOSIS SIGE05 WET lots |
| n+ diffusion sheet R | 72 ohm/sq | 82.4 | IBM J.R&D 2003 Table 4 |
| BEOL->sub area C | 0.03 fF/um^2 (measured) | 0.032 | IBM Table 4 |
| M1/M2/M3->sub C | 0.0288 / 0.0144 / 0.0096 fF/um^2 | 0.031 / 0.016 / 0.010 | 1.2 um SiO2 BEOL |
| fringe/perimeter C | **no 5HP measurement -> PROXY** | 22.2 aF/lambda etc. | scaled by 5HP area-C ratio, NOT measured |
| contact/via R | **no 5HP measurement -> PROXY** | 0.73-141 ohm | scaled by 5HP sheet-R ratio, NOT measured |

The full MOSIS WAT-format table with per-row MEASURED / DERIVED / MISSING status is
`wet_tables/fb5_wet.tsv` (see `wet_tables/README.md` and `RC_SOURCES.md` section 8).
**21 of 38 rows are MISSING**: no public 5HP WAT report exists, so fringe/contact are
first-order PROXY values and must not be quoted as 5HP measured.

\`digital/lef/fb5_lef.map\` gives the LEF -> GDS layer map. The unit calibration:
magic areacap is aF/lambda^2 (lambda=0.3 um), so fF/um^2 x 90 = magic value.

## Extraction results (\`extract.txt\`)

32 laid-out standard cells (the 7 \`PAD*\` cells are abstract-only and have no GDS
geometry -> skipped, as documented in \`digital/lef/README.md\`):

    353 MOSFETs, ~760 wire resistors, ~1100 parasitic capacitors, sum(C) 1125.9 fF
    (element counts vary by +/-1 between magic runs for complex cells; total C is stable)

Example \`netlists/INVX1.sp\`:

    .subckt INVX1 A Y vdd gnd
    M1000 Y A.t1 vdd vdd pfet w=6u l=0.6u   + ad=9p pd=15u as=9p ps=15u
    M1001 Y A.t0 gnd gnd nfet w=3u l=0.6u   + ad=4.5p pd=9u as=4.5p ps=9u
    R0 A.n0 A.t1 680.15      <-- poly gate resistance
    R1 A.n0 A.t0 89.2005
    R2 A A.n0 38.1905
    C0 vdd Y 0.29016f        <-- coupling / substrate / fringe C
    ...

The pre-layout SPICE (\`digital/spice/fb5_osu_cells.sp\`) has \`ad=0p pd=0u as=0p ps=0u\`
and no R/C at all, so the difference is entirely layout-derived.

## Post-layout simulation results

\`postlayout.py\` - 3-stage chains, VDD 3.3 V, FB5 tt models, 20 fF load,
average propagation delay. Port lists are parsed from each netlist because
subckt pin order differs from cell to cell.

| cell | sum(C) fF | pre ps | post ps | delta |
|---|---|---|---|---|
| INVX1 | 15.54 | 70.26 | 104.19 | +48.3 % |
| INVX2 | 15.26 | 59.35 | 88.82 | +49.7 % |
| INVX4 | 18.41 | 55.65 | 80.42 | +44.5 % |
| INVX8 | 29.95 | 53.52 | 90.36 | +68.8 % |
| NAND2X1 | 20.09 | 102.71 | 137.64 | +34.0 % |
| NOR2X1 | 18.89 | 116.47 | 151.79 | +30.3 % |

\`chain.py\` - a real placed-and-routed 3-inverter block (3 x INVX1 at 12 um
pitch, metal1 Y->A wiring, shared vdd/gnd rails, labels on GDS 109/0):

| view | delay (in->out, 3 stages) | per stage |
|---|---|---|
| pre-layout schematic | 210.77 ps | 70.26 ps |
| cell-level R/C | 312.57 ps | 104.19 ps |
| cells + extracted routing C | 321.12 ps | 107.04 ps |

The incremental +8.6 ps comes from the extracted interconnect capacitance
(10 caps, 19.97 fF). Both netlists are bound to the FB5 BSIM3 tt models by
renaming \`nfet\`/\`pfet\` to \`fb5n\`/\`fb5p\`.

## Known limitations

* **The fringe/perimeter capacitance and contact/via resistance in the 5HP tech are
  PROXY values, not 5HP measurements.** 21 of the 38 rows in \`wet_tables/fb5_wet.tsv\`
  are MISSING because no public IBM SIGE05 WAT report exists. See \`wet_tables/README.md\`
  and \`RC_SOURCES.md\` section 8. Do not quote them as 5HP measured data.
* \`extresist\` emits wire R for the **cell-level** extractions but not for the
  top-level routing with this tech; the routed-chain view therefore adds
  interconnect **C** but not interconnect **R**. Treat it as a lower bound.
* The routed chain is a hand-built demo, not the output of a place-and-route
  tool. No DEF/LEF-based P&R flow, no extraction of the HBT/passives, no
  antenna/density rules.
* magic reports "Input off lambda grid ... grid redefined" when reading the
  KLayout-generated GDS (1 nm dbu vs magic's lambda grid); extraction is
  unaffected, but coordinates are snapped to the 0.3 um lambda grid in
  \`build_chain.py\`.
* \`ext2spice\` child subckts in the hierarchical chain output have no R;
  \`chain.py\` substitutes the full cell-level extracted \`INVX1\` subckt before
  simulating (documented in the script).

## Reproduce

    cd validation/parasitics
    python3 fb5_5hp_rc.py --report       # show WAT table + MEASURED/DERIVED/PROXY status
    python3 fb5_5hp_rc.py               # regenerate the 5HP extraction tech from the table
    # to remove the PROXY values: fill wet_tables/fb5_wet.tsv with real WAT numbers,
    # set status=MEASURED, then re-run this list
    python3 extract.py --all > extract.txt
    python3 postlayout.py > postlayout.txt
    python3 chain.py > chain.txt
    python3 rc_compare.py > rc_comparison.txt
    # or from the repo root:  make check-parasitics
