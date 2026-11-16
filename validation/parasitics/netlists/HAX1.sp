* NGSPICE file created from HAX1.ext - technology: scmos

.subckt HAX1 vdd gnd YC A B YS
M1000 vdd A.t3 a_2_74.t2 vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=9p ps=15u
M1001 a_41_74.t0 a_2_74.t5 vdd vdd pfet w=6u l=0.6u
+  ad=9.9p pd=13.8u as=5.4p ps=7.8u
M1002 a_9_6.t0 A.t1 gnd.t3 gnd.t3 nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=9p ps=15u
M1003 a_41_74.t1 B.t0 a_38_6# gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1004 vdd A.t2 a_49_54# vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=5.4p ps=12.9u
M1005 vdd a_2_74.t6 YC vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=9p ps=15u
M1006 a_38_6# a_2_74.t3 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=4.86p ps=7.8u
M1007 YS a_41_74.t3 vdd vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=9p ps=15u
M1008 a_38_6# A.t0 a_41_74.t1 gnd.t0 nfet w=6u l=0.6u
+  ad=8.64p pd=15u as=5.4p ps=7.8u
M1009 YS a_41_74.t2 gnd.t0 gnd.t0 nfet w=3u l=0.6u
+  ad=4.5p pd=9u as=4.5p ps=9u
M1010 a_2_74.t0 B.t3 vdd vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=7.8u
M1011 a_2_74.t1 B.t1 a_9_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=15u as=2.7p ps=6.9u
M1012 a_49_54# B.t2 a_41_74.t0 vdd pfet w=12u l=0.6u
+  ad=5.4p pd=12.9u as=9.9p ps=13.8u
M1013 gnd.t0 a_2_74.t4 YC gnd.t0 nfet w=3u l=0.6u
+  ad=4.86p pd=7.8u as=4.5p ps=9u
R0 B.n1 B.t3 499.521
R1 B.n0 B.t2 367.95
R2 B.n0 B.t0 267.601
R3 B.n1 B.t1 243.071
R4 B B.n0 16.5738
R5 B B.n1 15.8005
R6 A.n1 A.t3 587.977
R7 A.n0 A.t2 423.7
R8 A.n0 A.t0 200.701
R9 A.n1 A.t1 153.87
R10 A A.n0 17.0138
R11 A A.n1 15.8005
R12 gnd.t3 gnd.t0 0.00422461
R13 gnd gnd.t0 0.0005
R14 a_41_74.n0 a_41_74.t3 631.833
R15 a_41_74.n0 a_41_74.t2 219.284
R16 a_41_74.t0 a_41_74.t1 18.9322
R17 a_41_74.t1 a_41_74.n0 15.8605
R18 a_2_74.n1 a_2_74.n0 468.3
R19 a_2_74.n0 a_2_74.t5 211.851
R20 a_2_74.n1 a_2_74.t3 178.4
R21 a_2_74.n2 a_2_74.t4 141.233
R22 a_2_74.n0 a_2_74.t6 122.65
R23 a_2_74.n4 a_2_74.t2 51.2555
R24 a_2_74.t0 a_2_74.n4 50.9155
R25 a_2_74.n2 a_2_74.n1 40.8838
R26 a_2_74.n3 a_2_74.t1 23.8233
R27 a_2_74.n3 a_2_74.n2 15.9005
R28 a_2_74.n4 a_2_74.n3 1.8445
C0 YC A 0.02331f
C1 vdd YS 0.25123f
C2 YC vdd 0.26936f
C3 a_38_6# B 0.02808f
C4 B A 0.0702f
C5 a_38_6# A 0.02808f
C6 B vdd 0.61776f
C7 A vdd 0.58608f
C8 YC B 0.02331f
C9 YS gnd 4.57645f
C10 YC gnd 4.38452f
C11 B gnd 3.57104f
C12 A gnd 4.16593f
C13 vdd gnd 26.0542f
C14 a_38_6# gnd 2.2682f
C15 a_2_74.t2 gnd 0.08036f
C16 a_2_74.t6 gnd 0.03515f
C17 a_2_74.t5 gnd 0.04404f
C18 a_2_74.n0 gnd 0.07549f
C19 a_2_74.t3 gnd 0.0408f
C20 a_2_74.n1 gnd 0.06466f
C21 a_2_74.t4 gnd 0.02707f
C22 a_2_74.n2 gnd 0.03833f
C23 a_2_74.t1 gnd 0.06909f
C24 a_2_74.n3 gnd 0.21978f
C25 a_2_74.n4 gnd 0.35769f
C26 a_2_74.t0 gnd 0.07951f
C27 a_41_74.t3 gnd 0.07131f
C28 a_41_74.t2 gnd 0.03074f
C29 a_41_74.n0 gnd 0.08525f
C30 a_41_74.t1 gnd 0.41291f
C31 a_41_74.t0 gnd 0.19821f
C32 A.t2 gnd 0.12193f
C33 A.t0 gnd 0.06264f
C34 A.n0 gnd 0.10972f
C35 A.t3 gnd 0.11779f
C36 A.t1 gnd 0.05651f
C37 A.n1 gnd 0.11536f
C38 B.t2 gnd 0.12494f
C39 B.t0 gnd 0.07685f
C40 B.n0 gnd 0.11891f
C41 B.t3 gnd 0.10999f
C42 B.t1 gnd 0.07611f
C43 B.n1 gnd 0.13648f
.ends

