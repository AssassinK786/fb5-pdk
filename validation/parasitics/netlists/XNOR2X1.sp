* NGSPICE file created from XNOR2X1.ext - technology: scmos

.subckt XNOR2X1 A B gnd vdd Y
M1000 gnd.t2 A.t1 a_2_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=6.3p pd=8.1u as=9p ps=15u
M1001 Y A.t0 a_18_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=9u as=2.7p ps=6.9u
M1002 a_12_41.t0 B.t0 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=15u as=6.3p ps=8.1u
M1003 a_18_54# a_12_41.t3 vdd vdd pfet w=12u l=0.6u
+  ad=5.4p pd=12.9u as=12.6p ps=14.1u
M1004 a_35_6.t0 a_2_6.t2 Y gnd.t0 nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=9p ps=9u
M1005 a_18_6.t0 a_12_41.t2 gnd.t2 gnd.t0 nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=6.3p ps=8.1u
M1006 vdd A.t3 a_2_6.t1 vdd pfet w=12u l=0.6u
+  ad=12.6p pd=14.1u as=18p ps=27u
M1007 vdd B.t3 a_35_54# vdd pfet w=12u l=0.6u
+  ad=12.6p pd=14.1u as=5.4p ps=12.9u
M1008 Y a_2_6.t3 a_18_54# vdd pfet w=12u l=0.6u
+  ad=18p pd=15u as=5.4p ps=12.9u
M1009 a_35_54# A.t2 Y vdd pfet w=12u l=0.6u
+  ad=5.4p pd=12.9u as=18p ps=15u
M1010 a_12_41.t1 B.t2 vdd vdd pfet w=12u l=0.6u
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
R7 A A.t2 451.894
R8 A.n0 A.t3 416.267
R9 A.n0 A.t1 200.701
R10 A A.t0 153.423
R11 A A.n0 16.1605
R12 gnd.t2 gnd.t0 0.0364614
R13 gnd gnd.t0 0.0005
R14 a_2_6.n0 a_2_6.t2 395.825
R15 a_2_6.n0 a_2_6.t3 273.175
R16 a_2_6.t1 a_2_6.t0 25.828
R17 a_2_6.t0 a_2_6.n0 16.2405
R18 a_12_41.n0 a_12_41.t3 334.5
R19 a_12_41.n0 a_12_41.t2 289.901
R20 a_12_41.t1 a_12_41.t0 26.585
R21 a_12_41.t0 a_12_41.n0 16.8942
C0 vdd Y 0.03108f
C1 A Y 0.11691f
C2 vdd A 0.26928f
C3 B A 0.00936f
C4 vdd B 0.3168f
C5 Y gnd 4.63761f
C6 B gnd 1.20552f
C7 A gnd 4.30478f
C8 vdd gnd 20.1374f
C9 a_12_41.t3 gnd 0.03506f
C10 a_12_41.t2 gnd 0.02438f
C11 a_12_41.n0 gnd 0.03588f
C12 a_12_41.t0 gnd 0.31343f
C13 a_12_41.t1 gnd 0.07821f
C14 a_2_6.t2 gnd 0.03991f
C15 a_2_6.t3 gnd 0.04329f
C16 a_2_6.n0 gnd 0.0529f
C17 a_2_6.t0 gnd 0.37962f
C18 a_2_6.t1 gnd 0.10083f
C19 A.t0 gnd 0.03596f
C20 A.t2 gnd 0.07861f
C21 A.t3 gnd 0.07566f
C22 A.t1 gnd 0.03856f
C23 A.n0 gnd 0.06321f
C24 B.t2 gnd 0.0725f
C25 B.t3 gnd 0.08321f
C26 B.n0 gnd 0.07763f
C27 B.t0 gnd 0.03904f
C28 B.t1 gnd 0.05008f
C29 B.n1 gnd 0.04428f
C30 B.n2 gnd 0.03489f
.ends

