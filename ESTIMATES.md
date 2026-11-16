# FB5 estimates and assumptions

Everything here is an **assumption, fit or borrowed value**, not a measurement of
IBM 5HP silicon. Source-backed numbers are in SOURCES.md. This file is the
"known unknowns" register for the PDK.

## 1. HBT Gummel-Poon cards (`models/fb5_hbt.lib`)

The GP card is a **behavioural fit to four published numbers** (fT, fMAX, BVceo,
beta). It is not a scalable physical model.

| parameter | status |
|---|---|
| RB (hp) = 124 ohm | **measured**, Bacon et al. 2002 Table 1 (Rb@100uA) |
| RB (hb) = 96 ohm, RBM 19 | **ESTIMATE** - no published Rb for the high-breakdown NPN |
| TF, XTF, VTF, ITF | fitted so peak fT = 47 / 28 GHz; no measured transit-time data |
| IS, BF, NF, VAF, IKF, ISE, NE, BR, VAR, IKR | typical SiGe values assumed; VAF 60/90 V (published VA is 65 V for hp) |
| RE = 6, RC = 35 / 120 ohm | assumed; not extracted from measurements |
| CJE 9f, CJC 5f / 3.5f, CJS 8f, VJE/VJC/VJS, MJE/MJC/MJS, XCJC 0.5 | assumed from emitter area / typical SiGe values; **no measured C-V or S-parameters** |
| EG 1.11, XTI 3, XTB 1.5, TR 50p | defaults; no temperature characterisation |
| BVceo 3.3 / 5.5 V | **not modelled by Gummel-Poon**; only enforced by usage (keep VCE below) |
| fMAX (hp 63.9 / hb 47.7 GHz) | **extracted** from Y-parameters (Mason U=1), see `validation/val_fmax.txt`; strongly bias-dependent (VCE 1->3 V moves hp fMAX 57->70 GHz) |
| peak fT at ~1.0 mA (hp) / 0.54 mA (hb) | published IBM 5HP minimum-area device peaks at **0.6 mA**; IKF was NOT refitted because the Gilbert circuit is biased at ~1 mA per unit emitter |
| geometry scaling | `area` factor scales current only; no geometry-dependent RB/CJC/fT |
| statistical corners / Monte Carlo / temperature corners | **none** for the HBT |

## 2. VBIC cards (`models/fb5_hbt_vbic.lib`)

| parameter | status |
|---|---|
| RTH 3000 / 3500 K/W, CTH 1 nF | **ESTIMATE** - no thermal measurement |
| ISP 1e-19, WSP 1.0, NFP 1.0 (substrate PNP) | **ESTIMATE** |
| AVC1 = 2.0 | **ESTIMATE**; AVC2 tuned so open-base BVceo = 3.3 / 5.5 V |
| RBX/RBI = 0.3/0.7 of RB, RCX/RCI = 0.3/0.7 of RC | **ESTIMATE** split ratios |
| TF retuned 2.45 / 3.78 ps | fitted so VBIC peak fT matches GP (47 / 28 GHz) |
| GP RB current crowding (IRB/RBM) | has no VBIC equivalent; dropped in the mapping |

## 3. HBT mismatch (`models/fb5_hbt_mm.lib`)

sigma(dIc/Ic) = 4 %.um / sqrt(AE) is **borrowed from National BiCMOS8 SiGe
(0.4 um emitter)**, not measured on IBM 5HP. Pratapgarhwala MS thesis, Georgia
Tech 2005. Implemented as an IS/area shift. Keep AE >= 2 um^2.

## 4. CMOS (`models/fb5.lib`)

- Single BSIM3v3.1 card per device, **no binning** (valid only near the fitted
  W/L), **no geometry scaling validation**, no temperature corners, no
  statistical/Monte Carlo models, no measured mismatch.
- Corners are **synthetic**: TOX/VTH0/U0 retuned to hit typical +-3 sigma of
  20 lot reports. They are not measured corner wafers.
- `t4ab_raw.lib` is one lot's card, used as the typical.
- Vt definition in `build_corners.py`: constant-current threshold at Vds 0.1 V,
  Id = 1e-7*(W/L); Idss at Vgs=Vds=3.3 V. Reproduces the original fit log.

## 5. Passives (`passives/fb5_passives.lib`, `passives/inductor/`)

| item | status |
|---|---|
| resistor / capacitor temperature coefficients | **ESTIMATE** - not in the lot reports |
| MIM 20 % and NMOS varactor 27 % raw spread | reduced to **10 % (ESTIMATE)** (mixed test structures) |
| NMOS varactor ~2.5:1 tuning range | **ESTIMATE** |
| cpoly C ~ 0.845 fF/um^2 | MOSIS lot-report median; process label in the source is unverified |
| inductor substrate values | **ESTIMATE**; treat model Q as a lower bound |
| kR 4.85 / kC 0.34 (Ronkainen fit) | fit to a 9-section subckt with almost no substrate path; constrains series loss, not FB5 substrate defaults |

## 6. Layout (`klayout/`)

- Rules are generic **MOSIS SCMOS SUBM**, not IBM 5HP rules. Drawn NPN emitter
  2.4 x 2.4 um vs IBM 0.5 x 2.5 um; 3-4 metal layers vs IBM 5.
- **LEF / tech LEF are now provided** (digital/lef/) but are derived from qflow's generic
  OSU050 abstraction: 7 PAD* MACROs have no GDS geometry, no antenna/density/ESD rules,
  no LEF for HBT/passives/MIM/poly2. A full DEF/LEF P&R flow is not bundled.
  R/C in the tech LEF now uses IBM 5HP measured values (see RC_SOURCES.md): sheet R
  0.08/0.05/0.04 ohm/sq, area C 0.029/0.014/0.0096 fF/um^2.
- **Parasitic extraction is now provided** (validation/parasitics/). Metal sheet R and
  area/interlevel C were re-derived from IBM 5HP measured/derived data (20 MOSIS SIGE05 WET
  lots + IBM J. Res. & Dev. 47(2/3) 2003 Tables 4/6/7 + 1.2 um SiO2 BEOL); see
  `validation/parasitics/RC_SOURCES.md`. A MOSIS WAT-format table (`wet_tables/fb5_wet.tsv`)
  is now the single source of truth for `fb5_5hp_rc.py`.
- **Interconnect fringe/perimeter capacitance and contact/via resistance are PROXY, not
  measured**: no public 5HP WAT measurement exists (21 of 38 WAT rows are MISSING). They are
  first-order scalings of AMI C5 measured values by 5HP area-cap / sheet-R ratios — see
  `wet_tables/README.md` and RC_SOURCES.md section 8. **Do not quote them as 5HP measured.**
  HBT Cje/Cjc/Cjs also remain ESTIMATEs. magic `extresist` emits no wire R for top-level
  routing (only C), so the routed-chain post-layout result is a lower bound.
- The **20 IBM SIGE05 MOSIS WET reports themselves** (which contain the complete measured
  contact/fringe/area capacitance tables) are **not bundled and not publicly indexed** —
  confirmed by a full filesystem scan plus 5 web-search rounds. A **first-hand WAT
  CAPACITANCE/CONTACT/fringe table for AMI C5** (105 lots, lot T89Y) was found in the
  sibling `/grid/fp5-pdk` and transcribed to `wet_tables/ami_c5_wat_reference.txt`; it
  also reveals the exact build-time archive (`FP5_MOSIS_PARAMS`, `ami-c5*__*.txt`) where
  the `ibm-sige*` WET reports live. `fb5_wet.tsv` has the WAT layout with 5HP cells blank;
  filling them and setting status=MEASURED is the highest-value next step
  (RC_SOURCES.md sections 6/8).
- `fb5_passives.lib` MIM 1.27 fF/um^2 (lot median) differs from IBM Table 6's published
  0.7 fF/um^2 for 5HP/AM/DM; likely a different/stacked MIM option. Kept (lot-specific),
  but flagged for verification. MOSCAP/decap 1.51 matches IBM's 1.5.
- Still missing: antenna, density, latch-up spacing, pad, ESD, reliability rules, IO cells,
  golden-GDS DRC/LVS regression, and HBT/passives extraction decks.
- Drawn minimum gate length 0.6 um (2 lambda) despite the "0.5 um" class name.

## 7. Digital (`digital/`)

- The re-characterization script `run_recharz_fb5.sh` and a full DEF/LEF P&R flow
  are **NOT bundled**; the liberty reports (`*.lib.report`) list sim/lib ratios
  0.795-1.009. Liberty headers (nom_voltage, operating conditions) were fixed to
  the corner supply; `default_max_transition 2.0` added. tech LEF + cell LEF are bundled.
- TBUFX1/X2 are scaled copies, not re-characterized from layout extraction.

## 8. Circuit-level validation

- Gilbert mixer (`validation/gilbert_glenn95/`): **two fitted values** (RF-pair
  current 4 mA/side, RL 207 ohm). Everything else is a prediction. Port
  back-termination (series 50 ohm), LO hard-switched static NF estimate
  (F_SSB ~ F_static*pi^2/4), and device sizes are assumptions. Pads, probes,
  interconnect, substrate coupling and poly-resistor parasitics are not modelled.
- ECL ring: no layout wiring (same as all MOSIS ring benches).
- fT/fMAX numbers are only valid at the stated bias (VCE 1.8 V, 27 C).

## 9. Naming

"IBM 5HP / 5AM class" is a **behavioural target**, not a claim of identity or
fabricability. The kit is not a foundry deliverable and cannot be taped out.
