# FB5 - free BiCMOS PDK, 0.5 um SiGe, 3.3 V (IBM SiGe 5HP / 5AM class) - research PDK, not a foundry PDK
Built only from public data: 20 MOSIS IBM SIGE05 lot reports (CMOS, passives); IBM's published 5HP figures for the SiGe HBT
(Dunn et al., IBM J. Res. & Dev. 47(2/3) 2003 Table 2; Bacon et al., Microwave Journal Feb 2002 Tables 1-2; Harame et al.,
IEEE TED 2001; IBM technology-summary slides); MOSIS SCMOS rev 7.2 rules (incl. the NPN analog option) for layout;
OSU 0.5 um standard cells re-characterized with FB5 models. See models/fit_hbt.py and validation/README.md for exact sources.
| dir | contents |
|---|---|
| models/fb5.lib | CMOS BSIM3 corners tt ff ss fs sf (fb5n / fb5p), typical = lot T4AB, corners = +-3 sigma of 20 lots |
| models/fb5_hbt.lib | SiGe NPN Gummel-Poon: fb5npn_hp (peak fT 46.7 GHz, EXTRACTED fMAX 63.9 GHz, beta ~98, BVceo 3.3 V) and fb5npn_hb (28.2 / 47.7 GHz / 5.5 V), emitter 0.5 x 2.5 um. RB(hp)=124 ohm = IBM measured Rb@100uA |
| models/fb5_hbt_vbic.lib | Optional VBIC (ngspice level=4) fb5npn_hp_v / fb5npn_hb_v: fT 47 / 28 GHz, fMAX 60 / 52 GHz (extracted), plus avalanche (BVceo 3.3 / 5.5 V), self-heating (RTH ESTIMATE), substrate PNP. Instance `Qx c b e s dt model`. Fit: models/fit_vbic.py, fit_vbic.txt; ring: validation/val_vbic.py |
| passives/fb5_passives.lib | `devices` + `res_typ/low/high`: RP 214, RN 20.2, RI 1593 ohm/sq poly resistors; MIM 1.27 fF/um2; decap 1.51; NMOS varactor 1.38 |
| digital/ | OSU cells re-characterized at tt 3.3 V / ff 3.6 V / ss 3.0 V; GDS, SPICE, Verilog; **digital/lef/ = tech LEF + 40 MACRO cell LEF + layer map + checker** (P&R flow scripts still NOT bundled) |
| klayout/ | layers (SCMOS + pbase 58), fb5.drc (CMOS + NPN rules 16.x), fb5.lvs (MOS + NPN extraction), PCells nmos/pmos/rpoly/cpoly/gring/npn |
| validation/ | val_fmax.py = Y-parameter fT/fMAX extraction (Mason U); HBT beta/fT/fMAX, CMOS 70-130 ps vs IBM 90 ps, ECL ring 10-19 ps vs IBM 16 ps; **parasitics/ = magic R/C extraction + post-layout simulation**; gilbert_glenn95/ = first paper circuit (SiGe Gilbert mixer, BCTM 1995) |
Gaps vs a foundry kit: VBIC model (BVceo, self-heating, substrate PNP), inductors, IBM's real (proprietary) layout rules and NPN
geometry (SCMOS-rule NPN is larger: emitter 2.4 x 2.4 um drawn), measured mismatch, density / ESD rules, and HBT current
density (FB5 unit device peaks at ~1 mA, IBM 5HP minimum-area device peaks at 0.6 mA). Drawn minimum gate length is
0.6 um (SCMOS lambda 0.30 um grid) despite the 0.5 um process-class name. No measured S-parameters/noise/thermal
data: the HBT is a fit to published fT/fMAX/BVceo/beta targets, not a scaled physical model. LEF/tech LEF and
parasitic extraction are now provided (digital/lef/, validation/parasitics/). Metal sheet R and
area/interlevel C were re-derived from IBM 5HP measured data (20 MOSIS SIGE05 WET lots +
IBM J. Res. & Dev. 2003 Tables 4/6/7 + the 1.2 um SiO2 BEOL); fringe/perimeter C and
contact/via R have no public 5HP measurement and are explicitly-labelled PROXY values — see
`validation/parasitics/RC_SOURCES.md`. Still no chip-level P&R/DEF flow, and the top-level
routing extraction captures C but not wire R (see their READMEs).

Exact citations, every assumed number and third-party asset list: SOURCES.md, ESTIMATES.md, NOTICE.
**License:** Apache License 2.0 (see LICENSE and NOTICE; third-party material keeps its own terms). FB5 is a
predictive research PDK, not a foundry deliverable. Run `make check` to reproduce/verify all
model cards, LEFs, extracted netlists and all validation reports from a clean checkout (`make check-parasitics`
re-runs just the extraction/post-layout flow).

## What's new (2026-11-14): LEF / tech LEF, parasitic extraction, post-layout simulation
- **LEF / tech LEF** (`digital/lef/`): `fb5_tech.lef` (layers, vias, viarules, SITE core 2.4x30 um, LEF 5.4) and
  `fb5_stdcell.lef` (40 MACROs, self-contained), derived from qflow's `osu050_stdcells.lef`. The PDK's
  `osu05_stdcells.gds2` is **byte-identical** to qflow osu050, so the abstraction matches the shipped layout exactly.
  `fb5_lef.map` maps LEF layers to GDS numbers; `check_lef.py` (KLayout) validates readability and cross-checks cell
  names against liberty/Verilog/SPICE/GDS. `make check-lef` runs it.
- **Parasitic extraction** (`validation/parasitics/`): magic 8.3 + `SCN3ME_SUBM.30.5hp.tech`
  (generated from the vendored qflow tech by `fb5_5hp_rc.py`, using **IBM 5HP measured R/C**)
  extracts W/L, AS/AD/PS/PD, wire R and coupling/substrate C from the stdcell GDS for all 32 laid-out cells:
  **353 MOSFETs, ~760 wire resistors, ~1100 parasitic capacitors, sum(C) 1125.9 fF**
  (per-element counts vary by +/-1 between magic runs; total C is stable). `netlists/<CELL>.sp` are ngspice subckts with ports.
  `RC_SOURCES.md` documents the data retrieval and the unit calibration; `rc_comparison.txt`
  shows the AMI C5 -> 5HP delta (<0.1 % for cell-level delay, because device junction C
  already came from the 5HP BSIM3 card and metal sheet R only matters on long wires).
  `make check-parasitics` regenerates everything.
- **Post-layout simulation**: `postlayout.py` compares 3-stage chains pre/post-layout (INVX1 +49 %, INVX8 +69 %,
  NAND2X1 +35 %, NOR2X1 +31 % delay). `chain.py` builds a real placed-and-routed 3-inverter block and extracts it:
  pre-layout 210.8 ps -> cell-level R/C 312.6 ps -> cells + routing C 321.1 ps (in->out, 3 stages, 20 fF load).

## What's new (2026-11-14): R/C re-derived from IBM 5HP measured data
The original extraction rules were **AMI/onsemi C5 generic SCMOS** values (M1/M2/M3
0.09/0.09/0.05 ohm/sq), not 5HP. `validation/parasitics/RC_SOURCES.md` documents the
retrieval: 20 MOSIS IBM SIGE05 WET lots (metal sheet R 0.08/0.05/0.04), IBM J. Res. & Dev.
47(2/3) 2003 Tables 4/6/7 (n+ diffusion 72 ohm/sq, BEOL parasitic C 0.03 fF/um2, MIM
0.7 / MOSCAP 1.5 fF/um2, last metal 14 mOhm/sq), and the 1.2 um SiO2 BEOL geometry.
A magic-unit calibration (300x300 lambda M1 square -> 277740 aF) fixes the conversion
fF/um2 x 90 = magic areacap. **`wet_tables/fb5_wet.tsv`** (38-row MOSIS WAT table, per-row
MEASURED / DERIVED / MISSING status) is now the single source; `fb5_5hp_rc.py` reads it and
generates `SCN3ME_SUBM.30.5hp.tech` plus the tech LEF RESISTANCE/CAPACITANCE.
**A full filesystem scan + 5 web-search rounds found no public IBM SIGE05 WAT report**;
only WAT reports for other processes (AMI C5 SCN05 V11L, 0.35 um CMOS-class MOSIS lot N88Y, 1.2/1.6um CMOS).
So **21 of 38 WAT rows are MISSING**: fringe/perimeter C and contact/via R are now
**explicitly-labelled PROXY** values (first-order 5HP-geometry scaling of AMI measured
values), **NOT 5HP measurements**; HBT Cje/Cjc/Cjs remain ESTIMATEs. A first-hand WAT
CAPACITANCE/CONTACT table for **AMI C5 (105 lots)** is bundled as
`wet_tables/ami_c5_wat_reference.txt` (from the sibling `fp5-pdk`); it also identifies the
build-time MOSIS archive where the IBM SIGE05 WET reports live. Fill the tsv with those
5HP numbers (status=MEASURED) and re-run `make check-parasitics` for a true measured fit,
with no code change.
Cell-level delay changes <0.7 % (device junction C already came from the 5HP BSIM3 card);
sum(C) 1168.1 -> 1165.5 fF (measured/derived) -> **1125.9 fF** (with PROXY refit).

## What's new (2026-11-14): fMAX is now measured, not assumed
An independent Y-parameter / Mason-U extraction (validation/val_fmax.py, val_fmax.txt) showed the old card's fMAX was 74.4 GHz
while the docs claimed ~60 GHz. Cause: models/fit_hbt.py derived `RB = fT/(8 pi fMAX_target^2 * 1.3*CJC)` and printed
fMAX_target as if it were a result. fMAX was an INPUT; the 1.3x Cbc fudge forced RB=77 ohm, ~38% below the published
measured Rb. Fixed: RB=124 ohm from Bacon et al. Table 1, TF retuned to published fT, fMAX EXTRACTED from the netlist.

| device | published IBM 5HP | old card (claimed / measured) | new card (measured) |
|---|---|---|---|
| fb5npn_hp GP | fT 47-50 GHz, fMAX 65 GHz | 45 / 60 GHz -> 74.4 GHz | fT 46.7, fMAX 63.9 GHz |
| fb5npn_hb GP | fT 28-29 GHz | 28 / 50 GHz -> 47.7 GHz | fT 28.2, fMAX 47.7 GHz |
| fb5npn_hp_v VBIC | fT 47 GHz, fMAX 65 GHz | 45 / ~60 | fT 47.1, fMAX 60.4 GHz |
| fb5npn_hb_v VBIC | fT 28 GHz | 28 / ~50 | fT 28.1, fMAX 51.9 GHz |

Sources: Dunn et al., IBM J. Res. & Dev. 47(2/3) 2003 Table 2 (5HP: peak fT 50, peak fmax 65, Ic@peak 0.6 mA,
BVCEO 3.3 V; High-BV npn peak fT 29 GHz, BVCEO 5.5 V; 5HPE is a different 45/50 GHz variant) and Bacon et al.,
Microwave Journal Feb 2002 Table 1 (5HP: fT 47, fmax 65, Rb@100uA 124 ohm, VA 65 V, BVCEO 3.35 V, AE 0.5x2.5 um, beta 100).
All model cards, fit/validation reports and the Gilbert regression were regenerated. Gilbert gain changes <0.15 dB,
bandwidth improves (JLG18 16.1 -> 13.1 GHz); ECL ring is now 10-19 ps/gate. val_fb5.py / val_vbic.py / fit_vbic.py
now use repo-relative paths and need no external scripts.

## What's new (2026-11-05)
- **First paper circuit:** validation/gilbert_glenn95 reproduces Glenn, Case, Harame et al., "12-GHz Gilbert mixers ..." (IEEE BCTM 1995;
  IBM HBT-2, fT 47 GHz) with fb5npn_hp. Two values are fitted: RF-pair current and RL. The rest is predicted.

  | | paper JLG16 / JLG18 | FB5 JLG16 / JLG18 (2026-11-14 card) |
  |---|---|---|
  | gain | 5.4 / 10.4 dB | 5.6 / 10.3 (tuned) dB |
  | -3 dB BW | 12.0 / 6.5 GHz | 18.6 / 13.1 GHz |
  | OIP3 at 5 GHz | 9.5 / 7.9 dBm | 7.7 / 5.5 dBm |
  | OP1dB | -0.1 / -2.0 dBm | -3.6 / -4.6 dBm |
  | SSB NF, low f | 16.5 / 14 dB | 18.2 / 16.8 dB (estimate) |

  Gain agrees, NF is 1.7-2.8 dB high, linearity is 2-4 dB low and bandwidth is still 1.6-2x high, most likely because the
  device size and 1995 profile are unknown (wiring capacitance was ruled out). GP and VBIC agree within 0.3 dB.
- **Digital libs:** OSU cells re-characterized with an external script (`run_recharz_fb5.sh`, NOT bundled; see ESTIMATES.md). tt 3.3 / ff 3.6 / ss 3.0 V,
  39 cells each, INVX1 ss/tt 1.21-1.24 and ff/tt 0.84-0.86. Liberty headers fixed: nom_voltage and operating-condition voltage were
  5 V in all three libs and are now the corner supply. default_max_transition 2.0 added. The Oct-19 libs are in digital/lib/old_2026-10-19.
  TBUFX1/X2 are scaled copies.
- **Inductor:** `passives/inductor/fit_ronkainen.py` fits the pi model to Ronkainen 1997 Table 2 (L1 9-section subckt).
  Q error before / after: Qpeak 2.76 @ 1.1 GHz -> 3.59 @ 6.5 GHz (reference 3.76 @ 6.3 GHz), cost 15 -> 0.11. The fit needs a series-loss
  factor kR 4.85 and an essentially absent substrate shunt, because that subckt has almost no substrate path. So it constrains
  series loss, not FB5's substrate values. FB5 defaults are unchanged. New kR / kC knobs give a pessimistic corner. L stays Mohan (7.3 vs 6.25-6.68 nH).

### Independent HBT check

`models/char_hbt.py` measures the HBT cards independently of the fit: rbb' from the h11 (1/y11) circle at
Ic = 100 uA, peak fT, and fMAX from Mason's U (f*sqrt(U) extrapolation and the U = 1 crossing) versus Ic.
`models/char_hbt_before_2026-11-14.txt` records the old cards (rbb' 76 ohm, extrapolated fMAX 106 GHz for hp), and
`models/char_hbt_after_2026-11-14.txt` a check of a 124-ohm refit. Run: `python3 models/char_hbt.py`.
