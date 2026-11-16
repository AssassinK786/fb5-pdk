# FB5 first paper circuit: 12-GHz SiGe Gilbert mixer (Glenn et al., IEEE BCTM 1995) - research PDK
Paper: J. Glenn, M. Case, D. Harame, B. Meyerson, R. Poisson, "12-GHz Gilbert mixers using a manufacturable Si/SiGe
epitaxial-base bipolar technology", IEEE BCTM 1995, pp. 186-189 (user archive, VLSI/0.11-0.9um/0.5µm/). IBM UHV/CVD SiGe
HBT, HBT-2 profile: fT 47 GHz, fmax 60 GHz, BVceo 3.0 V -> FB5 `fb5npn_hp` (46.7 / 63.9 GHz extracted, BVceo 3.3 V).
All FB5 numbers below were regenerated 2026-11-14 after the fMAX/RB fix (see ../../README.md); see results_ar4_rl207.txt.

**Circuit (paper Fig. 1):** emitter-follower RF and LO buffers, Gilbert core with R1 across the RF-pair emitters (JLG16 R1 = 13 ohm,
JLG18 R1 = 0), resistor loads, emitter-follower IF outputs, all ports terminated 50 ohm on chip, NPN current sources, 5 V.
**Bench (paper):** single-ended RF (-25 dBm) and LO (0 dBm), single-ended IF out at 100 MHz into 50 ohm, unused ports 50 ohm.
Gain = power into the 50 ohm IF load / available RF power. Table 3 does not say whether compression and IP3 are input- or
output-referred. They are treated as **output-referred** because the JLG16 - JLG18 spacing only matches that way:
paper comp 1.9 dB / IP3 2.9 dB; FB5 output-referred OP1dB 1.1 / OIP3 2.2 dB; FB5 input-referred IP1dB 5.8 / IIP3 7.1 dB.

**What is tuned and what is predicted.** The paper gives no resistor values or device sizes. Two numbers were fitted:
RF-pair current 4 mA per side (quad 2 mA per device, so every HBT sits near FB5's ~1 mA/unit peak-fT current) from the JLG16/JLG18 gain
ratio (paper 5.0 dB), and RL = 207 ohm to JLG18's 10.4 dB. Everything else below is a prediction. A first a-priori design
(8 mA/side, RL 108 ohm) is kept as `results_ar8_rl108.txt`: it gives JLG16 only 2.8 dB, which showed that the paper's RF pair has
more emitter impedance (lower current / larger RE) than an 8 mA FB5 pair.
Bias: 5 V, 38.2 mA (191 mW; paper about 250 mW). Highest VCE on an hp device is 2.87 V (RF follower), below BVceo. Current sources use
`fb5npn_hb` (BVceo 5.5 V). Port bias/coupling use ideal sources and 10 nF (bench bias tees). Resistors are ideal except the
bias reference (FB5 `rp`).

| metric (HBT-2 wafer) | paper JLG16 | FB5 JLG16 | paper JLG18 | FB5 JLG18 |
|---|---|---|---|---|
| conversion gain, low f | 5.4 dB | 5.6 dB | 10.4 dB | 10.3 dB (tuned) |
| -3 dB RF bandwidth (IF 100 MHz) | 12.0 GHz | 18.6 GHz | 6.5 GHz | 13.1 GHz |
| GBW | 22.4 GHz | 35.4 GHz | 21.5 GHz | 42.7 GHz |
| OP1dB at 1.5 / 5 / 10 GHz | -0.1 / -0.10 / -0.10 dBm | -4.2 / -3.6 / -3.7 dBm | -2.0 / -1.98 / -1.98 dBm | -5.3 / -4.6 / -4.0 dBm |
| OIP3 at 1.5 / 5 / 10 GHz | 10.8 / 9.5 / 8.4 dBm | 6.9 / 7.7 / 7.7 dBm | 7.9 / 7.9 / - dBm | 4.5 / 5.5 / 6.7 dBm |
| IIP3 = OIP3 - gain, 1.5 / 5 / 10 GHz | ~5.4 (1.5 GHz) | 1.3 / 2.1 / 2.1 dBm | ~-2.5 (1.5 GHz) | -5.8 / -4.8 / -3.6 dBm |
| OIP3 - OP1dB | 8.5-10.9 dB | 11.1-11.4 dB | 9.9 dB | 9.8-10.7 dB |
| SSB NF, low f | ~16.5 dB | 18.2 dB (estimate) | ~14 dB | 16.8 dB (estimate) |
| VBIC `fb5npn_hp_v` gain 1/5/10 GHz | - | 5.8 / 6.1 / 5.8 dB | - | 10.6 / 10.6 / 9.4 dB |

IM3 slopes 2.8-3.1 between -25 and -19 dBm per tone (two tones 100 + 120 MHz IF, 20 MHz apart as in the paper), so
IP3 is not set by the simulator's numerical floor. OIP3 above is the value at -25 dBm per tone.
The paper also shows NF rising to 17 (JLG18) and 19-19.5 dB (JLG16) at 10 GHz, LO-RF isolation and return loss. These were not simulated.

## Discussion
- **Gain and JLG16/JLG18 step:** reproduced after the two fits; the RB/fMAX fix moved gain by <0.15 dB. GP and VBIC agree
  within 0.3 dB (VBIC avalanche and self-heating do not matter at VCE <= 2.9 V and these currents).
- **Linearity:** FB5 is 2-4 dB lower in both OP1dB and OIP3, but the OIP3-OP1dB spacing (~10 dB) and the flat-with-frequency behaviour
  match the paper. The offset is in output swing. The real IF follower and loads probably had more headroom (larger RL·I and larger
  follower current). The paper used ~60 mW more power than this design, which supports that. The IF termination is also an
  assumption. "Terminated internally with 50 ohm" was modelled as a series back-termination. A shunt 50 ohm would make the
  follower drive 25 ohm, give ~4.6 dB more gain for the same RL (RL would re-tune to ~120 ohm) and change the output
  headroom. That choice is unpublished and could account for part of the linearity offset.
- **Bandwidth is 1.5x (JLG16) to 2.0x (JLG18) the paper's** (before the fMAX fix it was 1.8x / 2.5x: raising RB from 77 to
  124 ohm reduced the excessive gain-bandwidth product). The paper's own SPICE also left out interconnect and pads, and it tracked the
  measurement within 22 %. So the gap is mainly the transistors, not the layout. FB5 HBTs here are 2-4 unit emitters
  (2.5-5 um^2). The paper used 0.5 x 5 um devices with unpublished multiplicity at peak-fT current, and the 1995 HBT-2 profile is
  slower in Cbc/Ccs than the 5HP-class card FB5 was fitted to. Adding 100-300 fF of wiring capacitance to the load and quad-emitter
  nodes only brings JLG18 to 12.0 GHz with 300 fF (`cpar_sensitivity.txt`). Pad, probe and transmission-line effects would lower it further,
  but they do not explain a 2x gap. The JLG18 < JLG16 bandwidth ordering is reproduced. A plausible cause is the larger effective input capacitance of the
  undegenerated RF pair.
- **NF** is a labelled estimate. ngspice has no periodic-noise analysis, so `.noise` is run with the LO quad held
  hard-switched (0.4 V DC). Square-wave switching keeps the total output noise and scales the signal by 2/pi, so
  F_SSB ~ F_static * pi^2/4 (+3.9 dB). Noise during LO zero crossings is ignored, so the estimate is a lower bound.
  It now lands 1.7-2.8 dB above the measured values (the 2026-11-14 card raised NF by ~0.7-1 dB).
- **Not modelled:** pads, probes, interconnect, substrate coupling, poly-resistor parasitics (paper 400 ohm/sq poly, FB5 RP 214 ohm/sq),
  and the paper's exact device geometry.

## Files
`gilbert.py` (netlist generator + analyses; env GM_AR, GM_RL, GM_CPAR), `run.sh` (everything, ~6 min on 12 cores),
`results_ar4_rl207.txt` (table source), `results_ar8_rl108.txt` (a-priori design), `cpar_sensitivity.txt`, `op.txt`,
`netlists/` (representative generated decks: gain, two-tone, static noise, VBIC; run from `netlists/` so the `../../../`
include paths resolve to the PDK root).
