# FB5 WAT / WET tables

\`fb5_wet.tsv\` is the **MOSIS WAT (Wafer Acceptance / Electrical Test)** parameter
table in machine-readable form. It is the single source of truth for
\`fb5_5hp_rc.py\`, which converts it into magic \`extract\` rules.

## Table layout

The WAT report format (public examples: MOSIS AMIS/ON-SEMI **SCN05 run V11L**,
WPI \`16umparameters.pdf\` / \`12umParameters.pdf\`, and the verbatim 0.35 um CMOS-class MOSIS N88Y
report) has two blocks:

- **PROCESS PARAMETERS**: Sheet Resistance (ohm/sq), Contact Resistance (ohm),
  Gate Oxide Thickness (angstrom)
- **CAPACITANCE PARAMETERS**: Area (substrate / N+active / P+active / poly /
  poly2 / metal1 / metal2), Fringe (substrate / poly / metal1 / metal2),
  Overlap (N+active / P+active) — area in aF/um^2, fringe/overlap in aF/um.

\`fb5_wet.tsv\` keeps that row naming in \`wat_row\` / \`pair\`, and adds
\`ami_c5\`, \`ibm_5hp\`, \`status\`, \`source\`, \`note\`.

## Status values

| status | meaning |
|---|---|
| \`MEASURED\` | public IBM 5HP measurement or IBM process characterization |
| \`DERIVED\` | computed from published IBM 5HP geometry (1.2 um SiO2 ILD), validated against an IBM measurement |
| \`PROXY\` | **NOT a measurement** - first-order scaling of an AMI C5 measured value by a 5HP ratio |
| \`MISSING\` | no public 5HP measurement exists; the generator currently applies a PROXY or keeps AMI |
| \`INFO\` | informational, not used to generate a rule |

## First-hand WAT reference (AMI C5, NOT 5HP)

\`ami_c5_wat_reference.txt\` is a **verbatim, first-hand WAT CAPACITANCE /
CONTACT table** from the sibling PDK \`/grid/fp5-pdk\` (FB5 was derived from it):
\`tech/wire_rc.txt\` (MOSIS lot T89Y, median of 105 C5 lots),
\`passives/fp5_passives.lib\` (contact R), \`passives/passives_stats.txt\`
(105-lot medians/sigma over the WAT PROCESS / CAPACITANCE rows). It gives real
WAT numbers for sheet R, area cap, fringe cap, inter-layer cap, overlap and
contact R — the exact layout the 5HP table needs.

It also reveals **where the WAT reports live**: \`fp5-pdk/passives/extract_passives.py\`
reads \`FP5_MOSIS_PARAMS\` (default \`home-dir mosis_cards/wayback_params\`, pattern
\`ami-c5*__*.txt\`, 105 runs). FB5's \`build_corners.py\` points at the same archive
(\`home-dir mosis_cards/_index_reports.tsv\`). **The IBM SIGE05 WET reports would be
the \`ibm-sige*\` siblings in that same archive**, which is not on this machine.

Note the definitional difference documented in that file: WAT \`Fringe\` is
single-sided, while magic's \`perimc\` folds both edges/sidewalls and is ~1.4x
larger. \`fb5_wet.tsv\`'s \`ami_c5\` column is in **magic-rule units** so the
generator can scale it; the raw WAT numbers are kept in the reference file.

## The gap

**The 20 IBM SIGE05 WET reports are not bundled here and are not publicly
indexed.** A full-filesystem scan of this machine (including \`/grid/fp5-pdk\`,
\`/grid/siliconcraft\`, \`/grid/ETRI050\`) and five rounds of web search found
only WAT reports for other processes (AMI C5 SCN05 V11L / T89Y 105-lot medians,
0.35 um CMOS-class MOSIS lot N88Y, 1.2/1.6um CMOS). Therefore \`fringe_*\` and \`contact_*\` rows
have \`ibm_5hp = -\` and \`status = MISSING\`.

\`fb5_5hp_rc.py\` fills them with explicitly-labelled PROXY values so the
flow is complete, but these are **not 5HP measurements** and must not be
quoted as such. The proxy rules are:

- fringe/perimeter C: AMI value x (5HP area C / AMI area C) for the same
  conductor pair (transfers the measured 5HP dielectric geometry onto the
  AMI-measured fringe shape factor)
- via/contact R: AMI value x (5HP sheet R / AMI sheet R) for the corresponding
  layer; diffusion/poly contacts are kept at AMI because no 5HP counterpart
  sheet R is published (first-order proxy only)

## How to supply the real data

1. Fetch the \`ibm-sige*__*.txt\` WAT extracts from the \`wayback_params\`
   archive (path above), compute lot medians the same way
   \`fp5-pdk/passives/extract_passives.py\` does, and put the
   \`CAPACITANCE PARAMETERS\` / \`PROCESS PARAMETERS\` values into \`ibm_5hp\` for
   the \`fringe_*\` and \`contact_*\` rows, set \`status = MEASURED\`, update \`source\`.
2. \`make check-parasitics\` regenerates \`SCN3ME_SUBM.30.5hp.tech\` and all
   reports. Rows with \`status = MEASURED\` bypass the proxy entirely.

No code change is needed - the fit is table-driven.
