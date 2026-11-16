* FB5 Gilbert mixer, Glenn et al. BCTM 1995 Fig. 1, R1=0 ohm, RL=207.0, AR=4.0
.include ../../../models/fb5_hbt.lib
.include ../../../models/fb5_hbt_vbic.lib
.lib ../../../passives/fb5_passives.lib devices
.lib ../../../passives/fb5_passives.lib res_typ
VCC vcc 0 5
* bias: reference diode (hb) 1 mA/unit, current sources = hb devices with 200 ohm/area emitter degeneration
XRREF vcc ref rp w=10 l=126.37
QREF ref ref eref 0 fb5npn_hb area=1
RER eref 0 200
VRFB vrfb 0 3.0
VLOB vlob 0 4.6
VSRF srf 0 dc 0 sin(0 0.035566 1e+09) ac 1
RSRF srf prfp 50
CRFP prfp rfp 10n
RTRFP rfp vrfb 50
RSRFN 0 prfn 50
CRFN prfn rfn 10n
RTRFN rfn vrfb 50
VSLO slo 0 dc 0 sin(0 0.63246 9e+08)
RSLO slo plop 50
CLOP plop lop 10n
RTLOP lop lob_p 50
RSLON 0 plon 50
CLON plon lon 10n
RTLON lon lob_n 50
VLOP lob_p vlob 0.0
VLON lob_n vlob -0.0
QEFR1 vcc rfp brp 0 dt_QEFR1 fb5npn_hp_v area=4
QCSR1 brp ref eCSR1 0 fb5npn_hb area=4
RCSR1 eCSR1 0 50
QEFR2 vcc rfn brn 0 dt_QEFR2 fb5npn_hp_v area=4
QCSR2 brn ref eCSR2 0 fb5npn_hb area=4
RCSR2 eCSR2 0 50
QR1 c1 brp er1 0 dt_QR1 fb5npn_hp_v area=4.0
QR2 c2 brn er2 0 dt_QR2 fb5npn_hp_v area=4.0
QCS1 er1 ref eCS1 0 fb5npn_hb area=4.0
RCS1 eCS1 0 50
QCS2 er2 ref eCS2 0 fb5npn_hb area=4.0
RCS2 eCS2 0 50
R1 er1 er2 0.001
QEFL1 vcc lop blp 0 dt_QEFL1 fb5npn_hp_v area=4
QCSL1 blp ref eCSL1 0 fb5npn_hb area=4
RCSL1 eCSL1 0 50
QEFL2 vcc lon bln 0 dt_QEFL2 fb5npn_hp_v area=4
QCSL2 bln ref eCSL2 0 fb5npn_hb area=4
RCSL2 eCSL2 0 50
Q1 op blp c1 0 dt_Q1 fb5npn_hp_v area=2.0
Q2 on bln c1 0 dt_Q2 fb5npn_hp_v area=2.0
Q3 op bln c2 0 dt_Q3 fb5npn_hp_v area=2.0
Q4 on blp c2 0 dt_Q4 fb5npn_hp_v area=2.0
RLP vcc op 207.0
RLN vcc on 207.0
QEFI1 vcc op eip 0 dt_QEFI1 fb5npn_hp_v area=6
QCSI1 eip ref eCSI1 0 fb5npn_hb area=6
RCSI1 eCSI1 0 33.33
QEFI2 vcc on ein 0 dt_QEFI2 fb5npn_hp_v area=6
QCSI2 ein ref eCSI2 0 fb5npn_hb area=6
RCSI2 eCSI2 0 33.33
RTIFP eip ifp 50
CIFP ifp ifo 10n
RLOAD ifo 0 50
RTIFN ein ifn 50
CIFN ifn ifno 10n
RLOADN ifno 0 50
.options savecurrents
.options reltol=0.0001 abstol=1e-12 vntol=1e-7 method=trap
.tran 4e-12 2.3e-08 0 4e-12
.control
run
wrdata g_r0_1.00_fb5npn_hp_v.dat v(ifo)
.endc
.end
