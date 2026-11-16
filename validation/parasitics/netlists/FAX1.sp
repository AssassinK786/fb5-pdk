* NGSPICE file created from FAX1.ext - technology: scmos

.subckt FAX1 gnd vdd A B C YC YS
M1000 a_46_54# A.t5 vdd vdd pfet w=12u l=0.6u
+  ad=10.62p pd=13.8u as=10.8p ps=13.8u
M1001 gnd.t3 A.t3 a_2_6# gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=9p ps=15u
M1002 gnd.t0 A.t0 a_84_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=4.95p pd=7.8u as=2.7p ps=6.9u
M1003 a_33_6.t0 B.t2 a_25_6.t3 gnd.t0 nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=5.4p ps=7.8u
M1004 a_79_6.t0 C.t0 a_70_6.t2 gnd.t0 nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=6.3p ps=8.1u
M1005 a_46_6# A.t1 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1006 YS a_70_6.t5 vdd vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=11.7p ps=16.2u
M1007 a_46_6# C.t1 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1008 a_79_46# C.t3 a_70_6.t3 vdd pfet w=14.4u l=0.6u
+  ad=6.48p pd=15.3u as=14.22p ps=16.5u
M1009 YC a_25_6.t6 vdd vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=9p ps=15u
M1010 a_2_54# B.t7 vdd vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1011 a_25_6.t1 C.t2 a_2_6# gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1012 gnd.t0 A.t2 a_33_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=2.7p ps=6.9u
M1013 a_70_6.t0 a_25_6.t7 a_46_54# vdd pfet w=10.8u l=0.6u
+  ad=14.22p pd=16.5u as=9.72p ps=12.6u
M1014 a_84_6.t0 B.t0 a_79_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=2.7p ps=6.9u
M1015 vdd B.t5 a_46_54# vdd pfet w=10.8u l=0.6u
+  ad=9.72p pd=12.6u as=10.62p ps=13.8u
M1016 vdd A.t4 a_84_46# vdd pfet w=14.4u l=0.6u
+  ad=11.7p pd=16.2u as=6.48p ps=15.3u
M1017 vdd A.t7 a_2_54# vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=18p ps=27u
M1018 YS a_70_6.t4 gnd.t0 gnd.t0 nfet w=3u l=0.6u
+  ad=4.5p pd=9u as=4.95p ps=7.8u
M1019 a_25_6.t0 C.t5 a_2_54# vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1020 gnd.t0 B.t1 a_46_6# gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1021 vdd A.t6 a_33_54# vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=5.4p ps=12.9u
M1022 a_84_46# B.t4 a_79_46# vdd pfet w=14.4u l=0.6u
+  ad=6.48p pd=15.3u as=6.48p ps=15.3u
M1023 a_70_6.t1 a_25_6.t5 a_46_6# gnd.t0 nfet w=6u l=0.6u
+  ad=6.3p pd=8.1u as=5.4p ps=7.8u
M1024 a_46_54# C.t4 vdd vdd pfet w=10.8u l=0.6u
+  ad=9.72p pd=12.6u as=9.72p ps=12.6u
M1025 YC a_25_6.t4 gnd.t0 gnd.t0 nfet w=3u l=0.6u
+  ad=4.5p pd=9u as=4.5p ps=9u
M1026 a_2_6# B.t3 gnd.t3 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1027 a_33_54# B.t6 a_25_6.t2 vdd pfet w=12u l=0.6u
+  ad=5.4p pd=12.9u as=10.8p ps=13.8u
R0 C.n1 C.t4 367.95
R1 C.n0 C.t3 317.776
R2 C.n2 C.t2 312.2
R3 C.n2 C.t5 312.2
R4 C.n1 C.t1 301.05
R5 C.n0 C.t0 289.901
R6 C C.n2 16.6218
R7 C C.n0 16.2272
R8 C C.n1 15.8005
R9 B.n1 B.t5 446
R10 B.n2 B.t6 401.401
R11 B.n3 B.t7 401.401
R12 B.n0 B.t4 367.95
R13 B.n1 B.t1 228.576
R14 B.n2 B.t2 223
R15 B.n3 B.t3 223
R16 B.n0 B.t0 211.851
R17 B B.n0 16.6538
R18 B B.n2 16.6272
R19 B B.n3 15.8005
R20 B B.n1 15.8005
R21 A.n4 A.t7 468.3
R22 A.n0 A.t4 367.95
R23 A.n1 A.t5 312.2
R24 A.n1 A.t6 245.3
R25 A.n3 A.n1 223
R26 A.n0 A.t0 211.851
R27 A.n2 A.t1 167.25
R28 A.n4 A.t3 156.101
R29 A.n2 A.t2 128.655
R30 A A.n0 17.2672
R31 A A.n4 16.6005
R32 A A.n3 15.8005
R33 A.n3 A.n2 11.1505
R34 gnd.t3 gnd.t0 0.0480657
R35 gnd gnd.t0 0.0005
R36 a_70_6.n1 a_70_6.t5 512.9
R37 a_70_6.n1 a_70_6.t4 278.75
R38 a_70_6.n5 a_70_6.n4 174.748
R39 a_70_6.n3 a_70_6.n2 18.5318
R40 a_70_6.n2 a_70_6.n0 17.9298
R41 a_70_6.n2 a_70_6.n1 16.7108
R42 a_70_6.n0 a_70_6.t1 14.4005
R43 a_70_6.n3 a_70_6.t0 11.4116
R44 a_70_6.n0 a_70_6.t2 10.8005
R45 a_70_6.n4 a_70_6.t3 5.04378
R46 a_70_6.n4 a_70_6.n3 3.00436
R47 a_25_6.n2 a_25_6.t4 477.221
R48 a_25_6.n3 a_25_6.t5 356.8
R49 a_25_6.n2 a_25_6.t6 309.971
R50 a_25_6.n3 a_25_6.t7 289.901
R51 a_25_6.t2 a_25_6.n0 20.9654
R52 a_25_6.n0 a_25_6.n1 18.2112
R53 a_25_6.n0 a_25_6.n2 16.9942
R54 a_25_6.n0 a_25_6.n3 16.89
R55 a_25_6.n1 a_25_6.t1 10.8005
R56 a_25_6.n1 a_25_6.t3 10.8005
R57 a_25_6.t0 a_25_6.t2 7.703
C0 a_2_6# B 0.02808f
C1 a_2_6# A 0.02808f
C2 vdd YC 0.20202f
C3 vdd YS 0.09583f
C4 vdd C 0.72789f
C5 a_2_54# B 0.02808f
C6 a_46_54# vdd 0.0567f
C7 a_2_54# A 0.02808f
C8 vdd B 0.69696f
C9 vdd A 0.6336f
C10 a_46_6# C 0.02808f
C11 a_46_54# C 0.02808f
C12 B C 0.1404f
C13 A C 0.1404f
C14 B a_46_6# 0.02808f
C15 a_46_54# B 0.02808f
C16 A B 0.1404f
C17 a_2_54# vdd 0.0567f
C18 YC gnd 4.13556f
C19 YS gnd 4.83445f
C20 C gnd 4.40081f
C21 B gnd 6.00553f
C22 A gnd 6.56679f
C23 vdd gnd 40.6827f
C24 a_46_6# gnd 2.3249f
C25 a_2_6# gnd 2.40738f
C26 a_46_54# gnd 3.83532f
C27 a_2_54# gnd 4.00028f
C28 a_25_6.n0 gnd 0.74312f
C29 a_25_6.t3 gnd 0.03356f
C30 a_25_6.t1 gnd 0.03356f
C31 a_25_6.n1 gnd 0.07393f
C32 a_25_6.t6 gnd 0.05808f
C33 a_25_6.t4 gnd 0.06363f
C34 a_25_6.n2 gnd 0.10333f
C35 a_25_6.t7 gnd 0.07499f
C36 a_25_6.t5 gnd 0.06555f
C37 a_25_6.n3 gnd 0.08442f
C38 a_25_6.t2 gnd 0.20735f
C39 a_25_6.t0 gnd 0.06712f
C40 a_70_6.t3 gnd -0.06126f
C41 a_70_6.t2 gnd 0.02827f
C42 a_70_6.t1 gnd 0.0377f
C43 a_70_6.n0 gnd 0.07016f
C44 a_70_6.t5 gnd 0.06882f
C45 a_70_6.t4 gnd 0.03868f
C46 a_70_6.n1 gnd 0.08367f
C47 a_70_6.n2 gnd 0.48031f
C48 a_70_6.t0 gnd 0.06786f
C49 a_70_6.n3 gnd 0.19489f
C50 a_70_6.n4 gnd 0.03801f
C51 a_70_6.n5 gnd 0.06598f
C52 A.t4 gnd 0.08817f
C53 A.t0 gnd 0.04564f
C54 A.n0 gnd 0.08023f
C55 A.t5 gnd 0.07449f
C56 A.t6 gnd 0.0679f
C57 A.n1 gnd 0.07558f
C58 A.t1 gnd 0.04062f
C59 A.t2 gnd 0.03649f
C60 A.n2 gnd 0.03693f
C61 A.n3 gnd 0.03067f
C62 A.t7 gnd 0.08843f
C63 A.t3 gnd 0.03926f
C64 A.n4 gnd 0.06957f
C65 B.t4 gnd 0.09807f
C66 B.t0 gnd 0.04974f
C67 B.n0 gnd 0.07696f
C68 B.t5 gnd 0.09407f
C69 B.t1 gnd 0.05172f
C70 B.n1 gnd 0.08932f
C71 B.t6 gnd 0.0923f
C72 B.t2 gnd 0.05088f
C73 B.n2 gnd 0.0781f
C74 B.t7 gnd 0.0923f
C75 B.t3 gnd 0.05088f
C76 B.n3 gnd 0.0781f
C77 C.t3 gnd 0.12111f
C78 C.t0 gnd 0.07826f
C79 C.n0 gnd 0.10789f
C80 C.t4 gnd 0.11186f
C81 C.t1 gnd 0.07986f
C82 C.n1 gnd 0.11416f
C83 C.t5 gnd 0.10812f
C84 C.t2 gnd 0.07813f
C85 C.n2 gnd 0.10164f
.ends

