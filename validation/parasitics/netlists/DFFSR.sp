* NGSPICE file created from DFFSR.ext - technology: scmos

.subckt DFFSR gnd vdd D S R Q CLK
M1000 a_23_27.t2 a_47_71.t7 a_2_6# vdd pfet w=3u l=0.6u
+  ad=2.7p pd=4.8u as=4.5p ps=9u
M1001 a_2_6# R.t3 vdd vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=9p ps=15u
M1002 a_47_71.t1 CLK.t1 vdd vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=7.8u
M1003 a_47_71.t0 CLK.t0 gnd.t0 gnd.t0 nfet w=3u l=0.6u
+  ad=4.5p pd=9u as=2.7p ps=4.8u
M1004 a_113_6# S.t0 a_146_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=10.8p pd=15.6u as=3.6p ps=7.2u
M1005 a_10_61.t0 a_23_27.t5 vdd vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1006 a_113_6# a_47_4.t4 a_105_6.t1 vdd pfet w=3u l=0.6u
+  ad=4.5p pd=9u as=2.7p ps=4.8u
M1007 vdd a_122_6.t5 Q vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=9p ps=15u
M1008 vdd S.t2 a_113_6# vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=7.8u
M1009 a_26_6# a_23_27.t4 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=3.6p pd=7.2u as=7.2p ps=8.4u
M1010 a_23_27.t0 a_47_4.t3 a_2_6# gnd.t0 nfet w=3u l=0.6u
+  ad=2.7p pd=4.8u as=4.5p ps=9u
M1011 a_57_6# a_47_4.t5 a_23_27.t1 vdd pfet w=3u l=0.6u
+  ad=4.95p pd=7.8u as=2.7p ps=4.8u
M1012 gnd.t0 a_10_61.t5 a_10_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=7.2p pd=8.4u as=3.6p ps=7.2u
M1013 a_105_6.t0 a_47_4.t2 a_10_61.t1 gnd.t0 nfet w=3u l=0.6u
+  ad=2.7p pd=4.8u as=4.5p ps=9u
M1014 vdd S.t3 a_10_61.t4 vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=7.8u
M1015 gnd.t0 D.t0 a_57_6# gnd.t0 nfet w=3u l=0.6u
+  ad=4.5p pd=9u as=2.7p ps=4.8u
M1016 a_122_6.t1 a_105_6.t5 vdd vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=9p ps=15u
M1017 a_10_61.t3 S.t1 a_26_6# gnd.t0 nfet w=6u l=0.6u
+  ad=10.8p pd=15.6u as=3.6p ps=7.2u
M1018 gnd.t0 a_47_71.t3 a_47_4.t1 gnd.t0 nfet w=3u l=0.6u
+  ad=2.7p pd=4.8u as=4.5p ps=9u
M1019 vdd R.t2 a_122_6.t2 vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1020 a_130_6# a_105_6.t4 a_122_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=3.6p pd=7.2u as=10.8p ps=15.6u
M1021 a_10_6.t0 R.t1 a_2_6# gnd.t3 nfet w=6u l=0.6u
+  ad=3.6p pd=7.2u as=10.8p ps=15.6u
M1022 vdd a_47_71.t6 a_47_4.t0 vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=9p ps=15u
M1023 a_57_6# a_47_71.t4 a_23_27.t3 gnd.t0 nfet w=3u l=0.6u
+  ad=2.7p pd=4.8u as=2.7p ps=4.8u
M1024 vdd D.t1 a_57_6# vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=4.95p ps=7.8u
M1025 vdd a_10_61.t6 a_2_6# vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1026 a_105_6.t2 a_47_71.t5 a_10_61.t2 vdd pfet w=3u l=0.6u
+  ad=2.7p pd=4.8u as=4.5p ps=9u
M1027 a_146_6.t0 a_122_6.t4 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=3.6p pd=7.2u as=7.2p ps=8.4u
M1028 gnd.t0 a_122_6.t3 Q gnd.t0 nfet w=3u l=0.6u
+  ad=4.5p pd=9u as=4.5p ps=9u
M1029 a_113_6# a_122_6.t6 vdd vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1030 a_113_6# a_47_71.t2 a_105_6.t3 gnd.t0 nfet w=3u l=0.6u
+  ad=4.5p pd=9u as=2.7p ps=4.8u
M1031 gnd.t0 R.t0 a_130_6# gnd.t0 nfet w=6u l=0.6u
+  ad=7.2p pd=8.4u as=3.6p ps=7.2u
R0 CLK.n0 CLK.t1 657.851
R1 CLK.n0 CLK.t0 144.951
R2 CLK CLK.n0 15.8805
R3 D.n0 D.t1 747.051
R4 D.n0 D.t0 200.701
R5 D D.n0 38.1805
R6 S.n0 S.t0 468.3
R7 S.n1 S.t1 390.25
R8 S.n0 S.t2 345.651
R9 S.n1 S.t3 330.784
R10 S S.n0 18.8138
R11 S S.n1 15.8005
R12 R.n0 R.t2 446
R13 R.n1 R.t3 412.55
R14 R.n1 R.t1 334.5
R15 R.n0 R.t0 304.767
R16 R R.n0 51.5492
R17 R R.n1 49.8825
R18 gnd.t3 gnd.t0 0.00927289
R19 gnd gnd.t0 0.0005
R20 a_122_6.n0 a_122_6.t5 468.3
R21 a_122_6.n0 a_122_6.t3 301.05
R22 a_122_6.n3 a_122_6.n2 283.954
R23 a_122_6.n3 a_122_6.t4 280.238
R24 a_122_6.n2 a_122_6.t6 196.983
R25 a_122_6.n4 a_122_6.n0 105.3
R26 a_122_6.n2 a_122_6.n1 51.5705
R27 a_122_6.t0 a_122_6.n4 27.7699
R28 a_122_6.n4 a_122_6.n3 15.8005
R29 a_122_6.n1 a_122_6.t1 15.4055
R30 a_122_6.n1 a_122_6.t2 15.4055
R31 a_105_6.n1 a_105_6.t4 810.234
R32 a_105_6.n1 a_105_6.t5 152.383
R33 a_105_6.n2 a_105_6.n0 71.225
R34 a_105_6.n0 a_105_6.t1 30.8105
R35 a_105_6.n0 a_105_6.t2 30.8105
R36 a_105_6.t3 a_105_6.n2 26.8455
R37 a_105_6.t0 a_105_6.t3 21.6005
R38 a_105_6.n2 a_105_6.n1 16.5625
R39 a_47_4.n2 a_47_4.t3 669
R40 a_47_4.n1 a_47_4.t4 444.423
R41 a_47_4.n2 a_47_4.t5 256.45
R42 a_47_4.n0 a_47_4.n1 156.05
R43 a_47_4.n1 a_47_4.t2 133.8
R44 a_47_4.n0 a_47_4.n2 66.5775
R45 a_47_4.t0 a_47_4.n0 51.405
R46 a_47_4.n0 a_47_4.t1 48.3955
R47 a_47_71.n1 a_47_71.t2 695.018
R48 a_47_71.n2 a_47_71.t7 551.38
R49 a_47_71.n4 a_47_71.t6 472.017
R50 a_47_71.n1 a_47_71.t5 245.3
R51 a_47_71.n2 a_47_71.t4 160.75
R52 a_47_71.n4 a_47_71.n3 141.233
R53 a_47_71.n3 a_47_71.t3 133.8
R54 a_47_71.n0 a_47_71.n1 71.6905
R55 a_47_71.t1 a_47_71.n0 50.8955
R56 a_47_71.n0 a_47_71.t0 48.083
R57 a_47_71.n0 a_47_71.n4 17.2845
R58 a_47_71.n3 a_47_71.n2 16.2605
R59 a_23_27.n1 a_23_27.t4 494.317
R60 a_23_27.n1 a_23_27.t5 234.15
R61 a_23_27.n2 a_23_27.n0 71.35
R62 a_23_27.n0 a_23_27.t1 30.8105
R63 a_23_27.n0 a_23_27.t2 30.8105
R64 a_23_27.t3 a_23_27.n2 26.7205
R65 a_23_27.t0 a_23_27.t3 21.6005
R66 a_23_27.n2 a_23_27.n1 16.8758
R67 a_10_61.n2 a_10_61.n1 321.12
R68 a_10_61.n2 a_10_61.t6 211.851
R69 a_10_61.n1 a_10_61.t5 153.87
R70 a_10_61.n0 a_10_61.t2 102.16
R71 a_10_61.n0 a_10_61.t1 48.3205
R72 a_10_61.n1 a_10_61.t3 43.6032
R73 a_10_61.n3 a_10_61.n2 38.4738
R74 a_10_61.t4 a_10_61.n3 35.5105
R75 a_10_61.t0 a_10_61.t4 15.4055
R76 a_10_61.n3 a_10_61.n0 2.39583
C0 vdd a_113_6# 0.20479f
C1 D R 0.02808f
C2 R a_57_6# 0.03108f
C3 S a_113_6# 0.08724f
C4 R a_113_6# 0.05916f
C5 S vdd 0.28512f
C6 vdd a_2_6# 0.18931f
C7 CLK vdd 0.17424f
C8 R vdd 0.33264f
C9 S a_2_6# 0.06852f
C10 S CLK 0.02808f
C11 S R 0.0936f
C12 Q vdd 0.06216f
C13 R a_2_6# 0.44292f
C14 CLK R 0.02808f
C15 D vdd 0.28512f
C16 vdd a_57_6# 0.05184f
C17 S D 0.02808f
C18 S a_57_6# 0.03108f
C19 Q gnd 4.39456f
C20 CLK gnd 1.53347f
C21 D gnd 1.7909f
C22 S gnd 9.07755f
C23 R gnd 8.66029f
C24 vdd gnd 41.1424f
C25 a_113_6# gnd 10.5572f
C26 a_57_6# gnd 3.99862f
C27 a_2_6# gnd 10.2961f
C28 a_10_61.t2 gnd 0.03687f
C29 a_10_61.t1 gnd 0.03361f
C30 a_10_61.n0 gnd 0.47189f
C31 a_10_61.t6 gnd 0.0396f
C32 a_10_61.t5 gnd 0.03504f
C33 a_10_61.t3 gnd 0.15029f
C34 a_10_61.n1 gnd 0.18852f
C35 a_10_61.n2 gnd 0.06475f
C36 a_10_61.n3 gnd 0.3218f
C37 a_10_61.t4 gnd 0.08333f
C38 a_10_61.t0 gnd 0.02763f
C39 a_23_27.t1 gnd 0.01275f
C40 a_23_27.t2 gnd 0.01275f
C41 a_23_27.n0 gnd 0.02622f
C42 a_23_27.t5 gnd 0.03838f
C43 a_23_27.t4 gnd 0.06025f
C44 a_23_27.n1 gnd 0.07065f
C45 a_23_27.n2 gnd 0.41169f
C46 a_23_27.t3 gnd 0.04155f
C47 a_23_27.t0 gnd 0.01275f
C48 a_47_71.n0 gnd 0.66552f
C49 a_47_71.t5 gnd 0.04854f
C50 a_47_71.t2 gnd 0.10412f
C51 a_47_71.n1 gnd 0.15098f
C52 a_47_71.t0 gnd 0.04447f
C53 a_47_71.t6 gnd 0.08595f
C54 a_47_71.t3 gnd 0.03481f
C55 a_47_71.t7 gnd 0.08339f
C56 a_47_71.t4 gnd 0.03743f
C57 a_47_71.n2 gnd 0.30649f
C58 a_47_71.n3 gnd 0.06086f
C59 a_47_71.n4 gnd 0.08802f
C60 a_47_71.t1 gnd 0.09915f
C61 a_47_4.n0 gnd 0.85731f
C62 a_47_4.t1 gnd 0.051f
C63 a_47_4.t2 gnd 0.0377f
C64 a_47_4.t4 gnd 0.13297f
C65 a_47_4.n1 gnd 0.33165f
C66 a_47_4.t3 gnd 0.11058f
C67 a_47_4.t5 gnd 0.05409f
C68 a_47_4.n2 gnd 0.17288f
C69 a_47_4.t0 gnd 0.11644f
C70 a_105_6.t1 gnd 0.02112f
C71 a_105_6.t2 gnd 0.02112f
C72 a_105_6.n0 gnd 0.0431f
C73 a_105_6.t5 gnd 0.05341f
C74 a_105_6.t4 gnd 0.145f
C75 a_105_6.n1 gnd 0.16352f
C76 a_105_6.n2 gnd 0.64695f
C77 a_105_6.t3 gnd 0.07041f
C78 a_105_6.t0 gnd 0.02112f
C79 a_122_6.t5 gnd 0.04172f
C80 a_122_6.t3 gnd 0.02592f
C81 a_122_6.n0 gnd 0.07031f
C82 a_122_6.t6 gnd 0.02647f
C83 a_122_6.t2 gnd 0.01896f
C84 a_122_6.t1 gnd 0.01896f
C85 a_122_6.n1 gnd 0.06952f
C86 a_122_6.n2 gnd 0.11169f
C87 a_122_6.t4 gnd 0.03277f
C88 a_122_6.n3 gnd 0.04654f
C89 a_122_6.n4 gnd 0.20426f
C90 a_122_6.t0 gnd 0.05097f
C91 R.t2 gnd 0.1245f
C92 R.t0 gnd 0.10076f
C93 R.n0 gnd 0.19415f
C94 R.t3 gnd 0.11722f
C95 R.t1 gnd 0.10363f
C96 R.n1 gnd 0.17177f
C97 S.t2 gnd 0.0804f
C98 S.t0 gnd 0.1001f
C99 S.n0 gnd 0.17702f
C100 S.t3 gnd 0.08158f
C101 S.t1 gnd 0.08963f
C102 S.n1 gnd 0.13526f
C103 D.t1 gnd 0.19107f
C104 D.t0 gnd 0.06384f
C105 D.n0 gnd 0.21329f
C106 CLK.t1 gnd 0.12943f
C107 CLK.t0 gnd 0.03988f
C108 CLK.n0 gnd 0.12665f
.ends

