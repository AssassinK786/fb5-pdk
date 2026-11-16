# FB5 sources (exact provenance)

FB5 is built **only from public data**. No IBM foundry design kit, no confidential
rule deck, no measured wafer/S-parameter database was used. Every number below
traces to a public source. Where a value is an assumption rather than a source,
it is listed in ESTIMATES.md.

## 1. CMOS

| claim | source | in repo |
|---|---|---|
| Typical BSIM3 card | MOSIS IBM SiGe 5AM/5HP lot **T4AB (5AM_NI)** parametric report, BSIM3 level 49 converted to level 8 | `models/t4ab_raw.lib`, `models/fb5.lib` (.lib tt), `models/fb5_tt_cards.sp` |
| gate oxide 92-93 A, sigma 1.1 A | median / spread of **20 MOSIS IBM SIGE05 lot reports** | `models/build_corners.py` (STOX), `docs/FB5_design_manual.md` §1 |
| Vth short N/P 0.66 / -0.48 V, sigma 12 / 13 mV | same 20 lots | `models/build_corners.py` (SIG), `docs/FB5_design_manual.md` §1 |
| Idsat N/P 453 / -238 uA/um (W/L 20/0.5, 3.3 V) | same 20 lots (fit uses 452 / -237) | `docs/FB5_design_manual.md` §1, `models/build_corners.py` docstring |
| corner construction | typical +-3 sigma of the **same 20 IBM lots**; TOX/VTH0/U0 adjusted to hit typ+delta | `models/build_corners.py`, `models/build_corners.txt` |
| VDD 3.3 V | IBM SIGE05 / 5HP process node | `docs/FB5_design_manual.md` §1 |

Note: `build_corners.py` before 2026-11-14 carried a stale header claiming
"AMI/onsemi C5, lot T89Y, 105 C5 lots, Vdd 5 V". That was copy-paste from a
different 0.5 um PDK and was wrong; the code always used the IBM T4AB card and
the 20-lot IBM sigmas. `models/fb5.lib` numeric cards are unchanged.

## 2. SiGe HBT

| claim | source | in repo |
|---|---|---|
| 5HP peak fT 50 GHz, peak fmax 65 GHz, Ic@peak 0.6 mA (min area), BVCEO 3.3 V, BVCBO 10.5 V; High-BV npn peak fT 29 GHz, BVCEO 5.5 V, BVCBO 14 V | J. S. Dunn et al., "Foundation of rf CMOS and SiGe BiCMOS technologies", **IBM J. Res. & Dev. 47(2/3), March/May 2003, Table 2 (p. 105)**. https://hsisl.korea.ac.kr/wp-content/uploads/2018/03/IBMjrd2003.pdf | `models/fit_hbt.py` docstring, `validation/README.md` |
| 5HP fT 47 GHz, fmax 65 GHz, **Rb@100uA 124 ohm**, VA 65 V, BVCEO 3.35 V, beta 100, AE 0.5 x 2.5 um, NFmin 0.8 dB; standard NPN fT 47 / BVCEO 3.35, high-breakdown NPN fT 28 / BVCEO 5.5 | P. Bacon et al. (IBM), "Low Phase Noise SiGe Voltage-controlled Oscillators for Wireless Applications", **Microwave Journal, Feb 2002, Tables 1-2**. https://www.microwavejournal.com/articles/3389-low-phase-noise-sige-voltage-controlled-oscillators-for-wireless-applications | `models/fit_hbt.py`, `models/fb5_hbt.lib` (RB=124), `validation/README.md` |
| 5HPE is a different 45 / 50 GHz variant | Dunn et al. 2003 Table 2 | `models/fit_hbt.py` docstring |
| ECL differential ring 16 ps/gate (5HP) | Dunn et al. 2003 Table 1 ("Ring oscillators: ECL differential, typically 5HP-16 ps"); also IBM 5HP technology table | `validation/val_fb5.py`, `validation/README.md` |
| CMOS gate delay 90 ps at 3.3 V | IBM 5HP technology table / Dunn et al. 2003 | `validation/val_fb5.py` |
| background / trends | D. L. Harame et al., "Current status and future trends of SiGe BiCMOS technology", **IEEE TED 48(11), 2001**; IBM technology-summary slides | `models/fit_hbt.py` docstring |
| HBT-2 profile fT 47 GHz, fmax 60 GHz, BVceo 3.0 V | J. Glenn, M. Case, D. Harame, B. Meyerson, R. Poisson, "12-GHz Gilbert mixers using a manufacturable Si/SiGe epitaxial-base bipolar technology", **IEEE BCTM 1995, pp. 186-189** | `validation/gilbert_glenn95/` |
| radiation/tolerance background (5HP available through MOSIS) | R. Reed et al., NSREC 2001, "Single Event Upset Test Results on a Prescalar Fabricated in IBM's 5HP ...", NASA NEPP | context only |

## 3. Passives

| claim | source | in repo |
|---|---|---|
| RP 214, RN 20.2, RI 1593 ohm/sq; MIM 1.27, decap 1.51, NMOS varactor 1.38 fF/um^2; metal sheet resistances | median of **20 MOSIS IBM SIGE05 lot reports**; 1-sigma spreads in the file header | `passives/fb5_passives.lib` |
| spiral inductor pi model / substrate values | Ronkainen et al., IEE Proc. G 1997 Table 2 (fit in `fit_ronkainen.py`); L from Mohan et al., IEEE JSSC 1999 | `passives/inductor/` |
| HBT mismatch sigma(dIc/Ic) = 4 %.um/sqrt(AE) | M. M. Pratapgarhwala, MS thesis, Georgia Tech, 2005 (measured on **National BiCMOS8 SiGe**, not IBM 5HP) | `models/fb5_hbt_mm.lib`, `docs/FB5_design_manual.md` |

## 4. Layout / digital

| claim | source | in repo |
|---|---|---|
| GDS layer numbering, DRC rules (incl. NPN analog option 16.1-16.11), lambda 0.30 um, drawn L >= 0.6 um | public **MOSIS SCMOS rev 7.2 SUBM** rules as encoded in the qflow Magic tech `SCN3ME_SUBM.30.tech` | `klayout/layers.txt`, `klayout/fb5.drc`, `klayout/fb5.lvs`, `klayout/pcells/fb5_pcells.py` |
| OSU 0.5 um standard cells (39 cells): GDS, Verilog, SPICE | **OSU 0.5 um standard cell library** (public, distributed with qflow/osu05) | `digital/gds/osu05_stdcells.gds2`, `digital/verilog/osu05_stdcells.v`, `digital/spice/fb5_osu_cells.sp` |
| LEF / tech LEF (layers, vias, sites, 40 MACROs) | qflow `tech/osu050/osu050_stdcells.lef` (Abstract Generator 5.5.10, 2004) | `digital/lef/fb5_tech.lef`, `digital/lef/fb5_stdcell.lef`; PDK GDS is byte-identical to qflow osu050 (md5 `ccac812b...`), so the abstraction is an exact match |
| routing/parasitic R/C rules | qflow `tech/osu050/osu050.par` (GrayWolf) and the `extract` section of `SCN3ME_SUBM.30.tech` | `digital/lef/fb5_lef.map`, `validation/parasitics/SCN3ME_SUBM.30.tech` |
| magic tech file (extraction) | qflow `tech/osu050/SCN3ME_SUBM.30.tech`, public MOSIS SCMOS | `validation/parasitics/SCN3ME_SUBM.30.tech` (vendored verbatim) |
| liberty at tt 3.3 / ff 3.6 / ss 3.0 V | re-characterized with an **external, non-bundled script** (`run_recharz_fb5.sh`) using FB5 CMOS cards | `digital/lib/*.lib`, `*.lib.report` |

## 5. R/C (interconnect parasitics) - 5HP measured + derived + PROXY

See **`validation/parasitics/RC_SOURCES.md`** and **`validation/parasitics/wet_tables/`**
for the full retrieval, the WAT table, the magic-unit calibration and the list of
parameters with no public 5HP measurement (fringe/contact are PROXY, not measured).

| claim | source | in repo |
|---|---|---|
| M1/M2/M3 sheet R = 0.08/0.05/0.04 ohm/sq; M4 0.01 | **20 MOSIS IBM SIGE05 WET lot reports** (measured), via design manual §1 | `validation/parasitics/fb5_5hp_rc.py`, `SCN3ME_SUBM.30.5hp.tech` |
| n+ diffusion 72 ohm/sq; BEOL parasitic C 0.03 fF/um2; p+/p poly/TaN R and C | **Dunn et al., IBM J. Res. & Dev. 47(2/3) 2003, Table 4** (process characterization) | same |
| MIM 0.7, MOSCAP 1.5 fF/um2 (5HP/AM/DM) | **Dunn et al. 2003, Table 6** | `passives/fb5_passives.lib` (lot medians), `ESTIMATES.md` |
| last metal 2 um Al = 14 mOhm/sq | **Dunn et al. 2003, Table 7** | `RC_SOURCES.md` |
| 1.2 um SiO2 ILD; M1 0.63 um / LM 2.07 um thick | **IBM 5HP BEOL** (Dunn 2003 §BEOL; Auburn Univ. serial-communication thesis) | `RC_SOURCES.md` |
| AMI C5 baseline R/C (0.09/0.09/0.05 ohm/sq etc.) | qflow `osu050.par` / `SCN3ME_SUBM.30.tech`; corroborated by the public **MOSIS WET report for AMIS/ON-SEMI SCN05 run V11L** and Iowa State EE330 AMI 0.5um sheet-R table | `validation/parasitics/SCN3ME_SUBM.30.tech` |
| fringe/perimeter C, contact/via R | **no public 5HP measurement**; PROXY scaling of AMI C5 measured values (NOT a 5HP measurement) | `wet_tables/fb5_wet.tsv`, `RC_SOURCES.md` §8 |
| HBT Cje/Cjc/Cjs | **no public 5HP measurement**; model assumption | `ESTIMATES.md` |
| MOSIS WAT table structure (PROCESS + CAPACITANCE PARAMETERS rows) | public WAT reports for **other** processes: AMIS/ON-SEMI SCN05 run V11L, WPI 1.2/1.6 um handouts, 0.35 um CMOS-class MOSIS lot N88Y | `wet_tables/fb5_wet.tsv`, `wet_tables/README.md` |
| First-hand WAT CAPACITANCE/CONTACT/fringe table, 105 AMI C5 lots (lot T89Y typical) | sibling PDK `/grid/fp5-pdk`: `tech/wire_rc.txt`, `passives/fp5_passives.lib`, `passives/passives_stats.txt`; build-time source `FP5_MOSIS_PARAMS` (the `wayback_params` MOSIS archive, `ami-c5*__*.txt`) | `wet_tables/ami_c5_wat_reference.txt` | AMI C5, **not** 5HP; recorded as table template + baseline validation. IBM SIGE05 equivalents are the `ibm-sige*` siblings in the same archive |
| complete per-lot 5HP contact/fringe/area capacitance tables | 20 IBM SIGE05 MOSIS WET reports: **not bundled, not publicly indexed** (full filesystem scan + 5 web-search rounds) | `RC_SOURCES.md` §6/§8 (next step) |

## 6. Not used

IBM's proprietary 5HP design kit, real 5HP layout rules / NPN geometry, measured
5HP S-parameters, noise parameters, thermal data, mismatch data, density/ESD/
reliability rules, and any copyrighted thesis PDF (gitignored; cited only).
