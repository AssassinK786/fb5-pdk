#!/bin/bash
# FB5 Gilbert mixer vs Glenn et al. BCTM 1995. Calibrated design (AR 4 mA/side, RL 207) + a-priori peak-fT design (AR 8, RL 108).
cd "$(dirname "$0")"; export OMP_WAIT_POLICY=passive
python3 gilbert.py op > op.txt
GM_AR=4 GM_RL=207 python3 gilbert.py all > all_ar4.log 2>&1
GM_AR=8 GM_RL=108 python3 gilbert.py all > all_ar8.log 2>&1
cat results_ar*.txt
# sensitivity: extra wiring capacitance (not part of the comparison)
for c in 100e-15 300e-15; do for r in 0 13; do GM_CPAR=$c python3 gilbert.py bw $r; done; done > cpar_sensitivity.txt; rm -rf runs_ar*_cp*
