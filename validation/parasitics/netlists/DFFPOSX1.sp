* NGSPICE file created from DFFPOSX1.ext - technology: scmos

.subckt DFFPOSX1 vdd D gnd Q CLK
M1000 a_76_6.t0 a_2_6.t2 a_66_6.t0 gnd.t0 nfet w=3u l=0.6u
+  ad=1.35p pd=3.9u as=3.6p ps=5.4u
M1001 gnd.t1 CLK.t1 a_2_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=4.95p pd=7.8u as=9p ps=15u
M1002 a_66_6.t1 CLK.t0 a_61_6.t0 gnd.t0 nfet w=3u l=0.6u
+  ad=3.6p pd=5.4u as=1.35p ps=3.9u
M1003 Q.t0 a_66_6.t4 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=15u as=4.95p ps=7.8u
M1004 a_22_6.t2 CLK.t3 a_17_74# vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=3.6p ps=7.2u
M1005 gnd.t0 a_34_4.t3 a_31_6.t0 gnd.t0 nfet w=3u l=0.6u
+  ad=3.15p pd=5.1u as=1.35p ps=3.9u
M1006 vdd a_34_4.t5 a_31_74.t0 vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=3.6p ps=7.2u
M1007 a_61_74.t0 a_34_4.t4 vdd vdd pfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=9p ps=15u
M1008 a_34_4.t1 a_22_6.t4 vdd vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=7.8u
M1009 a_22_6.t1 a_2_6.t3 a_17_6# gnd.t0 nfet w=3u l=0.6u
+  ad=3.15p pd=5.1u as=1.35p ps=3.9u
M1010 a_34_4.t0 a_22_6.t3 gnd.t0 gnd.t0 nfet w=3u l=0.6u
+  ad=4.5p pd=9u as=3.15p ps=5.1u
M1011 vdd Q.t2 a_76_84.t0 vdd pfet w=3u l=0.6u
+  ad=9.45p pd=13.8u as=1.35p ps=3.9u
M1012 gnd.t0 Q.t1 a_76_6.t0 gnd.t0 nfet w=3u l=0.6u
+  ad=4.95p pd=7.8u as=1.35p ps=3.9u
M1013 a_61_6.t0 a_34_4.t2 gnd.t0 gnd.t0 nfet w=3u l=0.6u
+  ad=1.35p pd=3.9u as=4.5p ps=9u
M1014 a_76_84.t0 CLK.t2 a_66_6.t2 vdd pfet w=3u l=0.6u
+  ad=1.35p pd=3.9u as=6.75p ps=8.4u
M1015 Q.t0 a_66_6.t5 vdd vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=9.45p ps=13.8u
M1016 vdd CLK.t4 a_2_6.t1 vdd pfet w=12u l=0.6u
+  ad=9.9p pd=13.8u as=18p ps=27u
M1017 a_31_6.t0 CLK a_22_6.t1 gnd.t0 nfet w=3u l=0.6u
+  ad=1.35p pd=3.9u as=3.15p ps=5.1u
M1018 a_66_6.t3 a_2_6.t4 a_61_74.t0 vdd pfet w=6u l=0.6u
+  ad=6.75p pd=8.4u as=2.7p ps=6.9u
M1019 a_17_74# D.t1 vdd vdd pfet w=6u l=0.6u
+  ad=3.6p pd=7.2u as=9.9p ps=13.8u
M1020 a_31_74.t0 a_2_6.t5 a_22_6.t0 vdd pfet w=6u l=0.6u
+  ad=3.6p pd=7.2u as=5.4p ps=7.8u
M1021 a_17_6# D.t0 gnd.t1 gnd.t0 nfet w=3u l=0.6u
+  ad=1.35p pd=3.9u as=4.95p ps=7.8u
R0 Q.n0 Q.t2 471.068
R1 Q.n0 Q.t1 209.341
R2 Q.n0 Q.t0 1.14751
R3 Q Q.t0 0.0005
R4 D.n0 D.t1 434.851
R5 D.n0 D.t0 356.8
R6 D D.n0 16.3338
R7 CLK CLK.t3 539.851
R8 CLK.n1 CLK.t4 423.7
R9 CLK.n0 CLK.t0 328
R10 CLK.n0 CLK.t2 295.483
R11 CLK.n1 CLK.t1 200.701
R12 CLK CLK.n1 15.8805
R13 CLK CLK.n0 1.1605
R14 gnd.t1 gnd.t0 0.046479
R15 gnd gnd.t0 0.0005
R16 a_66_6.n1 a_66_6.t5 323.351
R17 a_66_6.n1 a_66_6.t4 278.75
R18 a_66_6.t2 a_66_6.n2 46.4775
R19 a_66_6.n2 a_66_6.n1 44.4708
R20 a_66_6.n0 a_66_6.t0 28.8005
R21 a_66_6.n0 a_66_6.t1 28.8005
R22 a_66_6.n2 a_66_6.n0 26.4823
R23 a_66_6.t3 a_66_6.t2 15.4055
R24 a_22_6.n0 a_22_6.t3 524.051
R25 a_22_6.n0 a_22_6.t4 267.601
R26 a_22_6.t2 a_22_6.t1 36.1083
R27 a_22_6.t1 a_22_6.n0 16.8092
R28 a_22_6.t0 a_22_6.t2 15.4055
R29 a_34_4.n0 a_34_4.t2 724.75
R30 a_34_4.n2 a_34_4.n1 510.671
R31 a_34_4.n0 a_34_4.t4 234.15
R32 a_34_4.n2 a_34_4.t5 156.101
R33 a_34_4.n1 a_34_4.t3 98.1205
R34 a_34_4.n1 a_34_4.t0 63.4993
R35 a_34_4.t1 a_34_4.n3 50.9155
R36 a_34_4.n3 a_34_4.n2 16.0538
R37 a_34_4.n3 a_34_4.n0 15.8938
R38 a_2_6.n0 a_2_6.t2 624.4
R39 a_2_6.n1 a_2_6.t3 524.051
R40 a_2_6.n1 a_2_6.t5 345.651
R41 a_2_6.n0 a_2_6.t4 234.15
R42 a_2_6.t0 a_2_6.n0 94.7265
R43 a_2_6.t1 a_2_6.t0 25.748
R44 a_2_6.t0 a_2_6.n1 16.4325
C0 Q vdd 0.86043f
C1 D CLK 0.05616f
C2 D vdd 0.44352f
C3 CLK vdd 1.24776f
C4 Q gnd 6.19135f
C5 D gnd 2.14465f
C6 CLK gnd 7.29444f
C7 vdd gnd 32.1817f
C8 a_2_6.t0 gnd 1.15798f
C9 a_2_6.t4 gnd 0.0705f
C10 a_2_6.t2 gnd 0.11862f
C11 a_2_6.n0 gnd 0.14562f
C12 a_2_6.t5 gnd 0.08632f
C13 a_2_6.t3 gnd 0.0992f
C14 a_2_6.n1 gnd 0.14348f
C15 a_2_6.t1 gnd 0.25093f
C16 a_34_4.t4 gnd 0.08703f
C17 a_34_4.t2 gnd 0.15519f
C18 a_34_4.n0 gnd 0.1913f
C19 a_34_4.t5 gnd 0.072f
C20 a_34_4.t3 gnd 0.04368f
C21 a_34_4.t0 gnd 0.11656f
C22 a_34_4.n1 gnd 0.28854f
C23 a_34_4.n2 gnd 0.13565f
C24 a_34_4.n3 gnd 0.32092f
C25 a_34_4.t1 gnd 0.14917f
C26 a_22_6.t4 gnd 0.06743f
C27 a_22_6.t3 gnd 0.08556f
C28 a_22_6.n0 gnd 0.12127f
C29 a_22_6.t1 gnd 0.801f
C30 a_22_6.t2 gnd 0.12967f
C31 a_22_6.t0 gnd 0.04203f
C32 a_66_6.t0 gnd 0.00958f
C33 a_66_6.t1 gnd 0.00958f
C34 a_66_6.n0 gnd 0.02059f
C35 a_66_6.t5 gnd 0.03497f
C36 a_66_6.t4 gnd 0.02347f
C37 a_66_6.n1 gnd 0.03621f
C38 a_66_6.n2 gnd 0.25001f
C39 a_66_6.t2 gnd 0.05532f
C40 a_66_6.t3 gnd 0.01437f
C41 CLK.n0 gnd 0.57313f
C42 CLK.t2 gnd 0.08446f
C43 CLK.t0 gnd 0.09261f
C44 CLK.t3 gnd 0.14617f
C45 CLK.t4 gnd 0.1647f
C46 CLK.t1 gnd 0.08461f
C47 CLK.n1 gnd 0.13612f
C48 D.t1 gnd 0.14373f
C49 D.t0 gnd 0.10503f
C50 D.n0 gnd 0.19179f
C51 Q.t0 gnd 0.72995f
C52 Q.n0 gnd 0.12377f
C53 Q.t1 gnd 0.03509f
C54 Q.t2 gnd 0.05587f
.ends

