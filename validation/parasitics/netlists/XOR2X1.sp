* NGSPICE file created from XOR2X1.ext - technology: scmos

.subckt XOR2X1 Y vdd B A gnd
M1000 gnd.t2 A.t1 a_2_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=6.3p pd=8.1u as=9p ps=15u
M1001 Y a_2_6.t2 a_18_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=9u as=2.7p ps=6.9u
M1002 a_13_43.t0 B.t0 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=15u as=6.3p ps=8.1u
M1003 a_18_54# a_13_43.t3 vdd vdd pfet w=12u l=0.6u
+  ad=5.4p pd=12.9u as=12.6p ps=14.1u
M1004 a_35_6.t0 A.t0 Y gnd.t0 nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=9p ps=9u
M1005 a_18_6.t0 a_13_43.t2 gnd.t2 gnd.t0 nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=6.3p ps=8.1u
M1006 vdd A.t3 a_2_6.t1 vdd pfet w=12u l=0.6u
+  ad=12.6p pd=14.1u as=18p ps=27u
M1007 vdd B.t3 a_35_54# vdd pfet w=12u l=0.6u
+  ad=12.6p pd=14.1u as=5.4p ps=12.9u
M1008 Y A.t2 a_18_54# vdd pfet w=12u l=0.6u
+  ad=18p pd=15u as=5.4p ps=12.9u
M1009 a_35_54# a_2_6.t3 Y vdd pfet w=12u l=0.6u
+  ad=5.4p pd=12.9u as=18p ps=15u
M1010 a_13_43.t1 B.t2 vdd vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=12.6p ps=14.1u
M1011 gnd.t0 B.t1 a_35_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=6.3p pd=8.1u as=2.7p ps=6.9u
R0 B.n0 B.t3 334.5
R1 B.n0 B.t2 234.15
R2 B.n1 B.t1 223
R3 B.n2 B.n0 167.25
R4 B.n1 B.t0 122.65
R5 B.n2 B.n1 55.7505
R6 B B.n2 15.8805
R7 A.n1 A.t3 423.7
R8 A.n0 A.t2 401.401
R9 A.n0 A.t0 306.625
R10 A.n1 A.t1 200.701
R11 A A.n0 16.1272
R12 A A.n1 15.8005
R13 gnd.t2 gnd.t0 0.0364614
R14 gnd gnd.t0 0.0005
R15 a_2_6.t0 a_2_6.t3 473.772
R16 a_2_6.t0 a_2_6.t2 150.102
R17 a_2_6.t1 a_2_6.t0 26.8408
R18 a_13_43.n0 a_13_43.t2 312.2
R19 a_13_43.n0 a_13_43.t3 304.767
R20 a_13_43.t1 a_13_43.t0 26.585
R21 a_13_43.t0 a_13_43.n0 16.8608
C0 vdd Y 0.04662f
C1 vdd A 0.25344f
C2 Y A 0.12168f
C3 vdd B 0.3168f
C4 Y gnd 4.41846f
C5 B gnd 1.20552f
C6 A gnd 2.41647f
C7 vdd gnd 20.1374f
C8 a_13_43.t3 gnd 0.03504f
C9 a_13_43.t2 gnd 0.02642f
C10 a_13_43.n0 gnd 0.03666f
C11 a_13_43.t0 gnd 0.33092f
C12 a_13_43.t1 gnd 0.08144f
C13 a_2_6.t0 gnd 0.2962f
C14 a_2_6.t3 gnd 0.03373f
C15 a_2_6.t2 gnd 0.01521f
C16 a_2_6.t1 gnd 0.06463f
C17 A.t2 gnd 0.08989f
C18 A.t0 gnd 0.06098f
C19 A.n0 gnd 0.09002f
C20 A.t3 gnd 0.09213f
C21 A.t1 gnd 0.04733f
C22 A.n1 gnd 0.07605f
C23 B.t2 gnd 0.0725f
C24 B.t3 gnd 0.08321f
C25 B.n0 gnd 0.07763f
C26 B.t0 gnd 0.03904f
C27 B.t1 gnd 0.05008f
C28 B.n1 gnd 0.04428f
C29 B.n2 gnd 0.03489f
.ends

