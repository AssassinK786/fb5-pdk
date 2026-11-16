* NGSPICE file created from CLKBUF2.ext - technology: scmos

.subckt CLKBUF2 vdd gnd A Y
M1000 a_9_6.t2 A.t1 gnd gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=9p ps=15u
M1001 Y a_73_6.t5 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1002 gnd.t0 a_9_6.t4 a_25_6.t2 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1003 a_57_6.t0 a_41_6.t7 vdd vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1004 gnd.t0 a_25_6.t4 a_41_6.t2 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1005 vdd a_57_6.t6 a_73_6.t0 vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1006 gnd.t0 a_41_6.t4 a_57_6.t2 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1007 vdd a_41_6.t6 a_57_6.t3 vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1008 vdd A.t2 a_9_6.t1 vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1009 gnd.t0 a_57_6.t4 a_73_6.t3 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1010 a_25_6.t3 a_9_6.t5 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1011 Y a_73_6.t7 vdd vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1012 a_41_6.t1 a_25_6.t5 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1013 a_9_6.t0 A.t3 vdd vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=18p ps=27u
M1014 a_41_6.t0 a_25_6.t7 vdd vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1015 a_73_6.t1 a_57_6.t7 vdd vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1016 gnd.t0 a_73_6.t4 Y gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=7.8u
M1017 a_25_6.t0 a_9_6.t7 vdd vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1018 a_57_6.t1 a_41_6.t5 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1019 vdd a_73_6.t6 Y vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=10.8p ps=13.8u
M1020 vdd a_25_6.t6 a_41_6.t3 vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1021 gnd.t0 A.t0 a_9_6.t3 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1022 a_73_6.t2 a_57_6.t5 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1023 vdd a_9_6.t6 a_25_6.t1 vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
R0 A.n0 A.t2 379.101
R1 A.n1 A.t3 379.101
R2 A.n0 A.t0 223
R3 A.n1 A.t1 223
R4 A.n2 A.n0 39.0255
R5 A A.n2 15.9205
R6 A.n2 A.n1 5.5755
R7 gnd gnd.t0 0.0469293
R8 a_73_6.n2 a_73_6.t7 379.101
R9 a_73_6.n1 a_73_6.t6 379.101
R10 a_73_6.n2 a_73_6.t5 223
R11 a_73_6.n1 a_73_6.t4 223
R12 a_73_6.n3 a_73_6.n1 33.4505
R13 a_73_6.t1 a_73_6.n4 18.3255
R14 a_73_6.n4 a_73_6.n3 15.9805
R15 a_73_6.n4 a_73_6.n0 13.2433
R16 a_73_6.n3 a_73_6.n2 11.1505
R17 a_73_6.n0 a_73_6.t2 10.8005
R18 a_73_6.n0 a_73_6.t3 10.8005
R19 a_73_6.t0 a_73_6.t1 7.703
R20 a_57_6.n2 a_57_6.t7 379.101
R21 a_57_6.n1 a_57_6.t6 379.101
R22 a_57_6.n2 a_57_6.t5 223
R23 a_57_6.n1 a_57_6.t4 223
R24 a_57_6.n3 a_57_6.n1 39.0255
R25 a_57_6.t3 a_57_6.n4 18.3855
R26 a_57_6.n4 a_57_6.n3 15.9005
R27 a_57_6.n4 a_57_6.n0 13.3032
R28 a_57_6.n0 a_57_6.t1 10.8005
R29 a_57_6.n0 a_57_6.t2 10.8005
R30 a_57_6.t0 a_57_6.t3 7.703
R31 a_57_6.n3 a_57_6.n2 5.5755
R32 a_41_6.n2 a_41_6.t7 379.101
R33 a_41_6.n1 a_41_6.t6 379.101
R34 a_41_6.n2 a_41_6.t5 223
R35 a_41_6.n1 a_41_6.t4 223
R36 a_41_6.n3 a_41_6.n2 22.3005
R37 a_41_6.n3 a_41_6.n1 22.3005
R38 a_41_6.t3 a_41_6.n4 18.3655
R39 a_41_6.n4 a_41_6.n3 15.9805
R40 a_41_6.n4 a_41_6.n0 13.2833
R41 a_41_6.n0 a_41_6.t1 10.8005
R42 a_41_6.n0 a_41_6.t2 10.8005
R43 a_41_6.t0 a_41_6.t3 7.703
R44 a_25_6.n2 a_25_6.t7 379.101
R45 a_25_6.n1 a_25_6.t6 379.101
R46 a_25_6.n2 a_25_6.t5 223
R47 a_25_6.n1 a_25_6.t4 223
R48 a_25_6.n3 a_25_6.n1 27.8755
R49 a_25_6.t1 a_25_6.n4 18.3655
R50 a_25_6.n3 a_25_6.n2 16.7255
R51 a_25_6.n4 a_25_6.n3 15.9605
R52 a_25_6.n4 a_25_6.n0 13.2833
R53 a_25_6.n0 a_25_6.t3 10.8005
R54 a_25_6.n0 a_25_6.t2 10.8005
R55 a_25_6.t0 a_25_6.t1 7.703
R56 a_9_6.n2 a_9_6.t7 379.101
R57 a_9_6.n1 a_9_6.t6 379.101
R58 a_9_6.n2 a_9_6.t5 223
R59 a_9_6.n1 a_9_6.t4 223
R60 a_9_6.n3 a_9_6.n1 33.4505
R61 a_9_6.t0 a_9_6.n4 18.3255
R62 a_9_6.n4 a_9_6.n3 15.9805
R63 a_9_6.n4 a_9_6.n0 13.2433
R64 a_9_6.n3 a_9_6.n2 11.1505
R65 a_9_6.n0 a_9_6.t2 10.8005
R66 a_9_6.n0 a_9_6.t3 10.8005
R67 a_9_6.t1 a_9_6.t0 7.703
C0 Y vdd 0.10878f
C1 A vdd 0.25344f
C2 Y gnd 4.75954f
C3 A gnd 1.74306f
C4 vdd gnd 41.123f
C5 a_9_6.t3 gnd 0.01576f
C6 a_9_6.t2 gnd 0.01576f
C7 a_9_6.n0 gnd 0.03295f
C8 a_9_6.t6 gnd 0.04096f
C9 a_9_6.t4 gnd 0.02311f
C10 a_9_6.n1 gnd 0.03676f
C11 a_9_6.t7 gnd 0.04096f
C12 a_9_6.t5 gnd 0.02311f
C13 a_9_6.n2 gnd 0.03256f
C14 a_9_6.n3 gnd 0.00856f
C15 a_9_6.n4 gnd 0.22009f
C16 a_9_6.t0 gnd 0.09763f
C17 a_9_6.t1 gnd 0.03151f
C18 a_25_6.t2 gnd 0.01269f
C19 a_25_6.t3 gnd 0.01269f
C20 a_25_6.n0 gnd 0.02671f
C21 a_25_6.t6 gnd 0.03299f
C22 a_25_6.t4 gnd 0.01861f
C23 a_25_6.n1 gnd 0.02876f
C24 a_25_6.t7 gnd 0.03299f
C25 a_25_6.t5 gnd 0.01861f
C26 a_25_6.n2 gnd 0.02707f
C27 a_25_6.n3 gnd 0.00687f
C28 a_25_6.n4 gnd 0.18199f
C29 a_25_6.t1 gnd 0.07884f
C30 a_25_6.t0 gnd 0.02538f
C31 a_41_6.t2 gnd 0.01261f
C32 a_41_6.t1 gnd 0.01261f
C33 a_41_6.n0 gnd 0.02653f
C34 a_41_6.t6 gnd 0.03277f
C35 a_41_6.t4 gnd 0.01849f
C36 a_41_6.n1 gnd 0.02773f
C37 a_41_6.t7 gnd 0.03277f
C38 a_41_6.t5 gnd 0.01849f
C39 a_41_6.n2 gnd 0.02941f
C40 a_41_6.n3 gnd 0.00685f
C41 a_41_6.n4 gnd 0.18243f
C42 a_41_6.t3 gnd 0.07832f
C43 a_41_6.t0 gnd 0.02521f
C44 a_57_6.t2 gnd 0.01624f
C45 a_57_6.t1 gnd 0.01624f
C46 a_57_6.n0 gnd 0.03429f
C47 a_57_6.t6 gnd 0.04222f
C48 a_57_6.t4 gnd 0.02382f
C49 a_57_6.n1 gnd 0.03897f
C50 a_57_6.t7 gnd 0.04222f
C51 a_57_6.t5 gnd 0.02382f
C52 a_57_6.n2 gnd 0.03248f
C53 a_57_6.n3 gnd 0.00872f
C54 a_57_6.n4 gnd 0.23052f
C55 a_57_6.t3 gnd 0.10102f
C56 a_57_6.t0 gnd 0.03248f
C57 a_73_6.t3 gnd 0.01576f
C58 a_73_6.t2 gnd 0.01576f
C59 a_73_6.n0 gnd 0.03295f
C60 a_73_6.t6 gnd 0.04096f
C61 a_73_6.t4 gnd 0.02311f
C62 a_73_6.n1 gnd 0.03676f
C63 a_73_6.t7 gnd 0.04096f
C64 a_73_6.t5 gnd 0.02311f
C65 a_73_6.n2 gnd 0.03256f
C66 a_73_6.n3 gnd 0.00856f
C67 a_73_6.n4 gnd 0.22009f
C68 a_73_6.t1 gnd 0.09763f
C69 a_73_6.t0 gnd 0.03151f
C70 A.t2 gnd 0.08143f
C71 A.t0 gnd 0.04594f
C72 A.n0 gnd 0.07517f
C73 A.t3 gnd 0.08143f
C74 A.t1 gnd 0.04594f
C75 A.n1 gnd 0.06264f
C76 A.n2 gnd 0.01687f
.ends

