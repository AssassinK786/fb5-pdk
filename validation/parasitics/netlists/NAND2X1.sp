* NGSPICE file created from NAND2X1.ext - technology: scmos

.subckt NAND2X1 vdd Y gnd A B
M1000 Y A.t1 vdd vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=9p ps=15u
M1001 a_9_6# A.t0 gnd gnd nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=9p ps=15u
M1002 vdd B.t1 Y vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=7.8u
M1003 Y B.t0 a_9_6# gnd nfet w=6u l=0.6u
+  ad=9p pd=15u as=2.7p ps=6.9u
R0 B.n0 B.t0 468.3
R1 B.n0 B.t1 256.45
R2 B B.n0 38.1805
R3 A.n0 A.t1 568.65
R4 A.n0 A.t0 144.951
R5 A A.n0 38.1805
C0 Y B 0.05616f
C1 vdd A 0.44352f
C2 B vdd 0.64336f
C3 Y a_9_6# 0.0189f
C4 Y vdd 0.26936f
C5 Y gnd 4.21266f
C6 B gnd 1.04197f
C7 A gnd 1.15252f
C8 vdd gnd 11.302f
C9 A.t1 gnd 0.14095f
C10 A.t0 gnd 0.06953f
C11 A.n0 gnd 0.1554f
C12 B.t1 gnd 0.13586f
C13 B.t0 gnd 0.1989f
C14 B.n0 gnd 0.24535f
.ends

