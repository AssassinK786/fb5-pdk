* NGSPICE file created from NOR3X1.ext - technology: scmos

.subckt NOR3X1 vdd gnd B C A Y
M1000 Y C.t0 gnd.t0 gnd.t0 nfet w=3u l=0.6u
+  ad=4.5p pd=9u as=2.7p ps=4.8u
M1001 a_2_64# A.t1 vdd vdd pfet w=9u l=0.6u
+  ad=8.1p pd=10.8u as=8.1p ps=10.8u
M1002 Y C.t2 a_25_64# vdd pfet w=9u l=0.6u
+  ad=8.1p pd=10.8u as=13.5p ps=21u
M1003 vdd A.t2 a_2_64# vdd pfet w=9u l=0.6u
+  ad=8.1p pd=10.8u as=13.5p ps=21u
M1004 a_25_64# B.t2 a_2_64# vdd pfet w=9u l=0.6u
+  ad=8.1p pd=10.8u as=8.1p ps=10.8u
M1005 a_25_64# C.t1 Y vdd pfet w=9u l=0.6u
+  ad=13.5p pd=21u as=8.1p ps=10.8u
M1006 gnd.t0 B.t0 Y gnd.t0 nfet w=3u l=0.6u
+  ad=2.7p pd=4.8u as=2.7p ps=4.8u
M1007 a_2_64# B.t1 a_25_64# vdd pfet w=9u l=0.6u
+  ad=13.32p pd=21u as=8.1p ps=10.8u
M1008 Y A.t0 gnd.t0 gnd.t0 nfet w=3u l=0.6u
+  ad=2.7p pd=4.8u as=4.5p ps=9u
R0 C.n1 C.t0 367.95
R1 C.n1 C.n0 278.75
R2 C.n0 C.t1 267.601
R3 C.n0 C.t2 178.4
R4 C C.n1 15.8805
R5 B.n1 B.n0 289.901
R6 B.n0 B.t1 267.601
R7 B.n1 B.t0 256.45
R8 B.n0 B.t2 178.4
R9 B B.n1 15.8805
R10 A.n1 A.n0 390.25
R11 A.n0 A.t2 267.601
R12 A.n0 A.t1 178.4
R13 A.n1 A.t0 144.951
R14 A A.n1 15.9005
R15 gnd gnd.t0 0.0429895
C0 a_25_64# vdd 0.26159f
C1 vdd A 0.45936f
C2 a_25_64# C 0.01872f
C3 a_2_64# B 0.05616f
C4 vdd a_2_64# 0.17094f
C5 Y B 0.02808f
C6 vdd B 0.4752f
C7 vdd Y 0.12691f
C8 Y C 0.16848f
C9 vdd C 0.64944f
C10 a_25_64# a_2_64# 0.0567f
C11 a_2_64# A 0.02808f
C12 a_25_64# B 0.04212f
C13 Y gnd 5.72639f
C14 C gnd 1.21916f
C15 B gnd 1.20058f
C16 A gnd 1.24627f
C17 vdd gnd 19.4179f
C18 a_25_64# gnd 5.27872f
C19 a_2_64# gnd 5.40244f
C20 A.t1 gnd 0.07862f
C21 A.t2 gnd 0.09225f
C22 A.n0 gnd 0.1233f
C23 A.t0 gnd 0.04282f
C24 A.n1 gnd 0.09402f
C25 B.t2 gnd 0.09766f
C26 B.t1 gnd 0.11458f
C27 B.n0 gnd 0.13549f
C28 B.t0 gnd 0.07252f
C29 B.n1 gnd 0.11897f
C30 C.t2 gnd 0.12676f
C31 C.t1 gnd 0.14874f
C32 C.n0 gnd 0.18004f
C33 C.t0 gnd 0.11939f
C34 C.n1 gnd 0.18079f
.ends

