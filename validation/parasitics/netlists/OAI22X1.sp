* NGSPICE file created from OAI22X1.ext - technology: scmos

.subckt OAI22X1 gnd vdd D C A B Y
M1000 gnd.t0 A.t0 a_2_6# gnd.t1 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=9p ps=15u
M1001 a_2_6# C.t0 Y gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=7.8u
M1002 Y D.t0 a_2_6# gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1003 Y B.t1 a_9_54# vdd pfet w=12u l=0.6u
+  ad=21.6p pd=15.6u as=5.4p ps=12.9u
M1004 a_28_54# D.t1 Y vdd pfet w=12u l=0.6u
+  ad=5.4p pd=12.9u as=21.6p ps=15.6u
M1005 a_9_54# A.t1 vdd vdd pfet w=12u l=0.6u
+  ad=5.4p pd=12.9u as=18p ps=27u
M1006 a_2_6# B.t0 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1007 vdd C.t1 a_28_54# vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=5.4p ps=12.9u
R0 C.n0 C.t1 401.401
R1 C.n0 C.t0 267.601
R2 C C.n0 15.8805
R3 D.n0 D.t1 347.137
R4 D.n0 D.t0 265.37
R5 D D.n0 15.8805
R6 B.n0 B.t1 356.8
R7 B.n0 B.t0 256.45
R8 B B.n0 38.1805
R9 A.n0 A.t1 462.726
R10 A.n0 A.t0 178.4
R11 A A.n0 15.8725
R12 gnd.t1 gnd.t0 0.041598
R13 gnd gnd.t0 0.0005
C0 Y D 0.02808f
C1 a_2_6# A 0.02808f
C2 D vdd 0.14256f
C3 C vdd 0.19008f
C4 A vdd 0.15048f
C5 a_2_6# Y 0.0567f
C6 a_2_6# B 0.02808f
C7 Y vdd 0.04662f
C8 a_2_6# D 0.02808f
C9 B vdd 0.17424f
C10 a_2_6# C 0.02808f
C11 Y gnd 4.4344f
C12 C gnd 1.05149f
C13 D gnd 1.05995f
C14 B gnd 1.10942f
C15 A gnd 1.13434f
C16 vdd gnd 16.4124f
C17 a_2_6# gnd 3.96798f
C18 A.t1 gnd 0.06534f
C19 A.t0 gnd 0.03015f
C20 A.n0 gnd 0.05613f
C21 B.t1 gnd 0.06453f
C22 B.t0 gnd 0.03929f
C23 B.n0 gnd 0.06396f
C24 D.t1 gnd 0.06476f
C25 D.t0 gnd 0.04211f
C26 D.n0 gnd 0.06474f
C27 C.t1 gnd 0.07411f
C28 C.t0 gnd 0.04526f
C29 C.n0 gnd 0.06978f
.ends

