# FB5 LEF / tech LEF

## Files

| file | purpose |
|---|---|
| `fb5_tech.lef` | **Tech LEF**: LEF 5.4 layer/via/viarule/site/spacing definitions for the SCMOS SUBM stack. For flows that read tech and cell LEF separately (qflow: `techleffile=fb5_tech.lef`, `leffile=fb5_stdcell.lef`). |
| `fb5_stdcell.lef` | **Cell LEF**: 40 MACROs (39 liberty cells + FILL), self-contained (repeats the technology section) so it also works with qflow/graywolf/qrouter and KLayout as a single file. |
| `fb5_lef.map` | LEF logical layer -> GDS layer/datatype reference table. |
| `check_lef.py` | Validation: KLayout reads both LEFs, cross-checks MACRO names against liberty/Verilog/SPICE/GDS and LEF layer references against the tech LEF. Run via `klayout -b -r check_lef.py`. |

## Provenance

Derived from `/usr/local/share/qflow/tech/osu050/osu050_stdcells.lef`
(Abstract Generator 5.5.10, 2004), the abstract view of the OSU 0.5 um standard
cells. `digital/gds/osu05_stdcells.gds2` is **byte-identical** to qflow's
`osu05_stdcells.gds2` (md5 `ccac812b479cd53693323f6d1dafc9f5`), so the LEF
abstraction matches the shipped layout exactly; it is not a guess.
To re-derive: the qflow LEF is a single file; `fb5_tech.lef` is its header
(`VERSION` .. the `SITE core` block) plus `END LIBRARY`, and `fb5_stdcell.lef`
is the same header followed by everything from `MACRO FILL` to `END LIBRARY`.
No geometry was changed - only the provenance comment header was added.

Rules are public MOSIS SCMOS rev 7.2 SUBM (lambda 0.30 um), i.e. generic rules,
**not** IBM 5HP proprietary rules. Units: DATABASE MICRONS 1000 (1 unit = 1 nm).
MANUFACTURINGGRID 0.15. SITE `core` = 2.4 x 30.0 um.

## Known limitations

* The 7 `PAD*` MACROs (PADFC/PADGND/PADINC/PADOUT/PADNC/PADVDD/PADINOUT) are
  abstract-only: they have no geometry in the GDS. This is inherited from qflow;
  `iit_stdcells` is a GDS container cell, not a real macro.
* `digital/spice/fb5_osu_cells.sp` has 36 subckts (4 PAD cells lack SPICE);
  subckt pin order is arbitrary and differs from cell to cell - always bind by
  name, never positionally, when mixing views.
* The tech LEF's resistance/capacitance numbers were re-derived from IBM 5HP
  measured data (see `../../validation/parasitics/RC_SOURCES.md`): metal1 0.08 ohm/sq,
  0.029 fF/um^2; metal2 0.05, 0.014; metal3 0.04, 0.0096. The original qflow
  `osu050.par` values (0.09/0.09/0.05 ohm/sq) were AMI C5 rules, not 5HP.
  Interconnect fringe capacitance and contact/via resistance still have no public
  5HP measurement and retain the AMI C5 estimates.
* No antenna / density / spacing-to-diffusion rules, no LEF for the HBT or
  passives, no tech LEF for MIM / poly2 / pbase layers.
