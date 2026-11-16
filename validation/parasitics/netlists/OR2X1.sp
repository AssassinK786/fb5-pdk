* NGSPICE file created from OR2X1.ext - technology: scmos

.subckt OR2X1 Y B vdd gnd A
M1000 a_2_54.t0 A.t0 gnd gnd nfet w=3u l=0.6u
+  ad=2.7p pd=4.8u as=4.5p ps=9u
M1001 Y a_2_54.t3 vdd vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=9.9p ps=13.8u
M1002 Y a_2_54.t2 gnd gnd nfet w=3u l=0.6u
+  ad=4.5p pd=9u as=2.7p ps=4.8u
M1003 vdd B.t1 a_9_54# vdd pfet w=12u l=0.6u
+  ad=9.9p pd=13.8u as=5.4p ps=12.9u
M1004 a_9_54# A.t1 a_2_54.t1 vdd pfet w=12u l=0.6u
+  ad=5.4p pd=12.9u as=18p ps=27u
M1005 gnd B.t0 a_2_54.t0 gnd nfet w=3u l=0.6u
+  ad=2.7p pd=4.8u as=2.7p ps=4.8u
R0 B.n0 B.t1 479.45
R1 B.n0 B.t0 211.851
R2 B B.n0 15.9205
R3 A.n0 A.t1 568.65
R4 A.n0 A.t0 89.2005
R5 A A.n0 38.1805
R6 a_2_54.n0 a_2_54.t2 408.834
R7 a_2_54.n0 a_2_54.t3 386.534
R8 a_2_54.t1 a_2_54.t0 26.1947
R9 a_2_54.t0 a_2_54.n0 15.8205
C0 vdd A 0.12672f
C1 B vdd 0.12672f
C2 Y vdd 0.22015f
C3 Y gnd 4.25928f
C4 B gnd 1.41493f
C5 A gnd 1.26038f
C6 vdd gnd 13.1088f
C7 a_2_54.t3 gnd 0.05716f
C8 a_2_54.t2 gnd 0.04731f
C9 a_2_54.n0 gnd 0.08754f
C10 a_2_54.t0 gnd 0.46676f
C11 a_2_54.t1 gnd 0.15301f
C12 A.t1 gnd 0.06231f
C13 A.t0 gnd 0.01443f
C14 A.n0 gnd 0.05096f
C15 B.t1 gnd 0.06654f
C16 B.t0 gnd 0.02506f
C17 B.n0 gnd 0.05816f
.ends

