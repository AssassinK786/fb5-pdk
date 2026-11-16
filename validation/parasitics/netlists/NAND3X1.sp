* NGSPICE file created from NAND3X1.ext - technology: scmos

.subckt NAND3X1 B vdd gnd A C Y
M1000 Y A.t1 vdd vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=9p ps=15u
M1001 a_9_6# A.t0 gnd.t1 gnd.t1 nfet w=9u l=0.6u
+  ad=4.05p pd=9.9u as=13.5p ps=21u
M1002 Y C.t1 vdd vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=7.8u
M1003 Y C.t0 a_14_6# gnd.t0 nfet w=9u l=0.6u
+  ad=13.5p pd=21u as=4.05p ps=9.9u
M1004 vdd B.t1 Y vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1005 a_14_6# B.t0 a_9_6# gnd.t0 nfet w=9u l=0.6u
+  ad=4.05p pd=9.9u as=4.05p ps=9.9u
R0 C.n0 C.t0 468.3
R1 C.n0 C.t1 234.15
R2 C C.n0 38.1805
R3 B.n0 B.t1 431.134
R4 B.n0 B.t0 252.733
R5 B B.n0 15.8805
R6 A.n0 A.t1 345.651
R7 A.n0 A.t0 312.2
R8 A A.n0 38.1805
R9 gnd.t1 gnd.t0 0.00165675
R10 gnd gnd.t0 0.0005
C0 C vdd 0.64336f
C1 Y B 0.05616f
C2 Y C 0.02808f
C3 Y vdd 0.29008f
C4 B vdd 0.49104f
C5 A vdd 0.64336f
C6 Y gnd 5.74073f
C7 C gnd 0.92353f
C8 B gnd 0.93747f
C9 A gnd 0.82926f
C10 vdd gnd 13.15f
C11 A.t1 gnd 0.14994f
C12 A.t0 gnd 0.16902f
C13 A.n0 gnd 0.21179f
C14 B.t1 gnd 0.15052f
C15 B.t0 gnd 0.13065f
C16 B.n0 gnd 0.19265f
C17 C.t1 gnd 0.12183f
C18 C.t0 gnd 0.21169f
C19 C.n0 gnd 0.22606f
.ends

