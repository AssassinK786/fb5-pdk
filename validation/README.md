# FB5 validation (updated 2026-11-14) - val_fb5.py -> val_fb5.txt, val_fmax.py -> val_fmax.txt

## 1. Figures of merit (all measured on the shipped cards)
| check | FB5 (measured) | IBM 5HP published | verdict |
|---|---|---|---|
| HBT hp beta | 97-107 | ~100 | OK |
| HBT hp peak fT | 46.7 GHz @ Ic 1.0 mA | 47-50 GHz | OK (-0.7 %) |
| HBT hp fMAX (Mason U=1) | 63.9 GHz | 65 GHz | OK (-1.7 %) |
| HBT hb peak fT / fMAX | 28.2 / 47.7 GHz | 28-29 GHz / (no published fmax) | fT OK, fmax ~5 % below the 50 GHz assumption |
| HBT hp_v VBIC fT / fMAX | 47.1 / 60.4 GHz | 47 / 65 GHz | fT OK, fmax -7 % |
| HBT hb_v VBIC fT / fMAX | 28.1 / 51.9 GHz | 28 GHz | OK |
| CMOS gate (L 0.5, 3.3 V) | inv FO1 70 ps, NAND2 FO2 130 ps | 90 ps | brackets it |
| ECL ring, 280 mV swing | 18.7 ps (0.3 mA) ... 10.4 ps (1.5 mA) | 16 ps | right range; ~1.5x fast at high current |
Not modelled by GP: BVceo, self-heating, substrate PNP, avalanche - VBIC adds these. All HBT values are strongly
bias-dependent: see the VCE sweep in val_fmax.txt (hp fMAX 57 GHz at VCE 1 V -> 70 GHz at 3 V).
Known remaining gap: the FB5 unit device reaches peak fT at ~1 mA, IBM 5HP's minimum-area device at 0.6 mA (current
density / IKF not refitted, because the Gilbert circuit is biased at ~1 mA per unit emitter).

## 2. How fT / fMAX are measured (validation/val_fmax.py)
* fT: frequency where the common-emitter short-circuit current gain |h21| = 1.
* fMAX: frequency where Mason's unilateral gain U = 1, from two-port Y parameters,
  U = |y21-y12|^2 / (4*(Re y11*Re y22 - Re y12*Re y21)). Two AC runs at the same DC bias give the Y matrix
  (run A: v_base=1, collector AC short; run B: base AC short, v_collector=1).
* Self-check: U(Y) must equal U(Z=invY) (Mason's U is a two-port invariant); measured agreement < 3e-15.
* Run: `cd validation && python3 val_fmax.py --sensitivity > val_fmax.txt`. Repo-relative paths, no external scripts.
* Root cause of the pre-2026-11-14 error: models/fit_hbt.py used `cbc=1.3*CJC` to derive RB from a *target* fMAX
  and then printed that target as the result. The old card had RB=77 ohm (IBM measures 124 ohm) and really gave
  fMAX 74.4 GHz. The `--sensitivity` table in val_fmax.txt shows the one-parameter-at-a-time debugging.

## 3. Sources for the HBT targets
* J. S. Dunn et al., "Foundation of rf CMOS and SiGe BiCMOS technologies", IBM J. Res. & Dev. 47(2/3),
  March/May 2003, Table 2 (p. 105): 5HP peak fT 50 GHz, peak fmax 65 GHz, Ic@peak fT 0.6 mA (min area),
  BVCEO 3.3 V, BVCBO 10.5 V; High-BV npn peak fT 29 GHz, BVCEO 5.5 V. 5HPE is a DIFFERENT 45/50 GHz variant.
  Also Table 1: "Ring oscillators ECL differential, typically 5HP-16 ps".
  https://hsisl.korea.ac.kr/wp-content/uploads/2018/03/IBMjrd2003.pdf
* P. Bacon et al. (IBM), "Low Phase Noise SiGe Voltage-controlled Oscillators for Wireless Applications",
  Microwave Journal, Feb 2002, Tables 1-2: 5HP/5AM (0.5 um) AE 0.5 x 2.5 um, beta 100, VA 65 V, BVCEO 3.35 V,
  BVCBO 10.5 V, Rb@100uA 124 ohm, fT 47 GHz, fmax 65 GHz, NFmin 0.8 dB; standard NPN fT 47 GHz / BVCEO 3.35 V,
  high-breakdown NPN fT 28 GHz / BVCEO 5.5 V.
  https://www.microwavejournal.com/articles/3389-low-phase-noise-sige-voltage-controlled-oscillators-for-wireless-applications
* D. L. Harame et al., "Current status and future trends of SiGe BiCMOS technology", IEEE TED 48(11), 2001
  (background/trends). Glenn et al., IEEE BCTM 1995 (HBT-2 profile, fT 47 GHz) for the mixer paper below.

# 2026-11-05: first paper circuit - gilbert_glenn95/
Glenn et al., BCTM 1995, 12-GHz SiGe Gilbert mixers (IBM HBT-2, fT 47 GHz, fmax 60 GHz).
Regenerated 2026-11-14 with the corrected RB=124 ohm card (RL re-tuned to 207 ohm for JLG18 10.4 dB):
FB5 matches gain (JLG16 5.6 vs 5.4 dB, JLG18 10.3 vs 10.4 dB). NF is 1.7-2.8 dB high (18.2/16.8 vs ~16.5/14 dB,
estimate). OIP3/OP1dB are 2-4 dB low. Bandwidth is 18.6/13.1 GHz vs the paper's 12.0/6.5 GHz (was 21.3/16.1 GHz
with the old card, so the fMAX fix also improved bandwidth agreement). See gilbert_glenn95/README.md.
