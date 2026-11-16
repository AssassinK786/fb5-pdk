* NGSPICE file created from OR2X2.ext - technology: scmos

.subckt OR2X2 Y B vdd gnd A
M1000 a_2_54.t0 A.t0 gnd gnd nfet w=3u l=0.6u
+  ad=2.7p pd=4.8u as=4.5p ps=9u
M1001 Y a_2_54.t2 gnd gnd nfet w=6u l=0.6u
+  ad=9p pd=15u as=4.77p ps=7.8u
M1002 vdd B.t1 a_9_54# vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=5.4p ps=12.9u
M1003 a_9_54# A.t1 a_2_54.t1 vdd pfet w=12u l=0.6u
+  ad=5.4p pd=12.9u as=18p ps=27u
M1004 Y a_2_54.t3 vdd vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=10.8p ps=13.8u
M1005 gnd B.t0 a_2_54.t0 gnd nfet w=3u l=0.6u
+  ad=4.77p pd=7.8u as=2.7p ps=4.8u
R0 B.n0 B.t1 379.101
R1 B.n0 B.t0 312.2
R2 B B.n0 15.8725
R3 A.t0 A.t1 568.65
R4 A A.t0 15.8805
R5 a_2_54.n0 a_2_54.t2 332.271
R6 a_2_54.n0 a_2_54.t3 274.291
R7 a_2_54.t1 a_2_54.t0 26.1947
R8 a_2_54.t0 a_2_54.n0 15.8005
C0 Y vdd 0.06993f
C1 A vdd 0.14256f
C2 vdd B 0.12672f
C3 Y gnd 4.18158f
C4 B gnd 1.27549f
C5 A gnd 1.24052f
C6 vdd gnd 11.9083f
C7 a_2_54.t3 gnd 0.03433f
C8 a_2_54.t2 gnd 0.02676f
C9 a_2_54.n0 gnd 0.04117f
C10 a_2_54.t0 gnd 0.24366f
C11 a_2_54.t1 gnd 0.0815f
C12 A.t1 gnd 0.07013f
C13 A.t0 gnd 0.07743f
C14 B.t0 gnd 0.03351f
C15 B.t1 gnd 0.06209f
C16 B.n0 gnd 0.05871f
.ends

