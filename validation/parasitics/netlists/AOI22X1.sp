* NGSPICE file created from AOI22X1.ext - technology: scmos

.subckt AOI22X1 gnd vdd C D Y A B
M1000 gnd.t0 C.t0 a_28_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=15u as=2.7p ps=6.9u
M1001 Y B.t0 a_11_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=9u as=2.7p ps=6.9u
M1002 a_11_6.t0 A.t0 gnd.t1 gnd.t0 nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=9p ps=15u
M1003 a_2_54# B.t1 vdd vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1004 a_28_6.t0 D.t0 Y gnd.t0 nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=9p ps=9u
M1005 vdd A.t1 a_2_54# vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=18p ps=27u
M1006 Y D.t1 a_2_54# vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1007 a_2_54# C.t1 Y vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=10.8p ps=13.8u
R0 C.n0 C.t0 354.57
R1 C.n0 C.t1 265.37
R2 C C.n0 15.8805
R3 D.n0 D.t1 360.517
R4 D.n0 D.t0 278.75
R5 D D.n0 23.3672
R6 B.n0 B.t1 367.95
R7 B.n0 B.t0 241.583
R8 B B.n0 15.8805
R9 A.n0 A.t0 373.526
R10 A.n0 A.t1 289.901
R11 A A.n0 15.8725
R12 gnd.t1 gnd.t0 0.0516224
R13 gnd gnd.t0 0.0005
C0 vdd Y 0.08547f
C1 D Y 0.02808f
C2 B vdd 0.14256f
C3 vdd D 0.12672f
C4 C a_2_54# 0.02808f
C5 vdd A 0.14256f
C6 a_2_54# Y 0.0567f
C7 B a_2_54# 0.02808f
C8 vdd a_2_54# 0.0567f
C9 a_2_54# D 0.02808f
C10 a_2_54# A 0.02808f
C11 C vdd 0.22968f
C12 Y gnd 4.26406f
C13 C gnd 0.99642f
C14 D gnd 1.23692f
C15 B gnd 1.06648f
C16 A gnd 1.17232f
C17 vdd gnd 14.3917f
C18 a_2_54# gnd 6.186f
C19 A.t1 gnd 0.04944f
C20 A.t0 gnd 0.04235f
C21 A.n0 gnd 0.05353f
C22 B.t1 gnd 0.05706f
C23 B.t0 gnd 0.03342f
C24 B.n0 gnd 0.05688f
C25 D.t0 gnd 0.03902f
C26 D.t1 gnd 0.05856f
C27 D.n0 gnd 0.0546f
C28 C.t1 gnd 0.07454f
C29 C.t0 gnd 0.06351f
C30 C.n0 gnd 0.08486f
.ends

