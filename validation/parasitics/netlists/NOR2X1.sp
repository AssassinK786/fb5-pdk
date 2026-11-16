* NGSPICE file created from NOR2X1.ext - technology: scmos

.subckt NOR2X1 vdd B gnd Y A
M1000 Y A.t0 gnd gnd nfet w=3u l=0.6u
+  ad=2.7p pd=4.8u as=4.5p ps=9u
M1001 Y B.t1 a_9_54# vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=5.4p ps=12.9u
M1002 a_9_54# A.t1 vdd vdd pfet w=12u l=0.6u
+  ad=5.4p pd=12.9u as=18p ps=27u
M1003 gnd B.t0 Y gnd nfet w=3u l=0.6u
+  ad=4.5p pd=9u as=2.7p ps=4.8u
R0 B.n0 B.t0 401.401
R1 B.n0 B.t1 267.601
R2 B B.n0 38.1805
R3 A.n0 A.t1 568.65
R4 A.n0 A.t0 89.2005
R5 A A.n0 38.1805
C0 Y a_9_54# 0.0252f
C1 Y B 0.06552f
C2 B vdd 0.29304f
C3 Y vdd 0.03108f
C4 vdd A 0.12672f
C5 Y gnd 4.34176f
C6 B gnd 1.17569f
C7 A gnd 1.25546f
C8 vdd gnd 11.1783f
C9 A.t1 gnd 0.05101f
C10 A.t0 gnd 0.01181f
C11 A.n0 gnd 0.04171f
C12 B.t1 gnd 0.10112f
C13 B.t0 gnd 0.07408f
C14 B.n0 gnd 0.12214f
.ends

