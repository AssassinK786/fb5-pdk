* NGSPICE file created from AND2X1.ext - technology: scmos

.subckt AND2X1 Y B vdd gnd A
M1000 a_2_6.t2 A.t1 vdd vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=9p ps=15u
M1001 a_9_6.t0 A.t0 a_2_6.t1 gnd.t2 nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=9p ps=15u
M1002 Y a_2_6.t4 vdd vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=7.8u
M1003 Y a_2_6.t3 gnd.t0 gnd.t0 nfet w=3u l=0.6u
+  ad=4.5p pd=9u as=4.95p ps=7.8u
M1004 vdd B.t1 a_2_6.t0 vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1005 gnd.t0 B.t0 a_9_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=4.95p pd=7.8u as=2.7p ps=6.9u
R0 B.n0 B.t0 390.25
R1 B.n0 B.t1 356.8
R2 B B.n0 15.9005
R3 A.n0 A.t1 479.45
R4 A.n0 A.t0 234.15
R5 A A.n0 38.1805
R6 gnd.t2 gnd.t0 0.00165675
R7 gnd gnd.t0 0.0005
R8 a_2_6.n0 a_2_6.t4 577.571
R9 a_2_6.n0 a_2_6.t3 227.46
R10 a_2_6.t2 a_2_6.t1 36.7038
R11 a_2_6.t1 a_2_6.n0 15.8205
R12 a_2_6.t0 a_2_6.t2 15.4055
C0 vdd A 0.44352f
C1 Y vdd 0.21238f
C2 B vdd 0.55868f
C3 Y gnd 4.28f
C4 B gnd 1.15771f
C5 A gnd 1.15743f
C6 vdd gnd 13.2325f
C7 a_2_6.t4 gnd 0.07455f
C8 a_2_6.t3 gnd 0.03372f
C9 a_2_6.n0 gnd 0.0814f
C10 a_2_6.t1 gnd 0.47104f
C11 a_2_6.t2 gnd 0.09398f
C12 a_2_6.t0 gnd 0.02948f
C13 A.t1 gnd 0.13389f
C14 A.t0 gnd 0.08992f
C15 A.n0 gnd 0.16524f
C16 B.t1 gnd 0.14252f
C17 B.t0 gnd 0.15375f
C18 B.n0 gnd 0.20715f
.ends

