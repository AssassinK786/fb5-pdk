* NGSPICE file created from AOI21X1.ext - technology: scmos

.subckt AOI21X1 gnd vdd A B Y C
M1000 a_2_54# B.t1 vdd vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1001 a_12_6.t0 A.t0 gnd.t1 gnd.t0 nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=9p ps=15u
M1002 gnd.t0 C.t0 Y gnd.t0 nfet w=3u l=0.6u
+  ad=4.5p pd=9u as=4.95p ps=7.8u
M1003 vdd A.t1 a_2_54# vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=18p ps=27u
M1004 Y C.t1 a_2_54# vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=10.8p ps=13.8u
M1005 Y B.t0 a_12_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=4.95p pd=7.8u as=2.7p ps=6.9u
R0 C.n0 C.t1 576.083
R1 C.n0 C.t0 96.6338
R2 C C.n0 15.8805
R3 B.n0 B.t1 367.95
R4 B.n0 B.t0 234.15
R5 B B.n0 38.1805
R6 A.n0 A.t0 384.675
R7 A.n0 A.t1 289.901
R8 A A.n0 15.8725
R9 gnd.t1 gnd.t0 0.0540991
R10 gnd gnd.t0 0.0005
C0 Y C 0.02808f
C1 Y vdd 0.04662f
C2 C vdd 0.12672f
C3 a_2_54# A 0.02808f
C4 A vdd 0.14256f
C5 a_2_54# B 0.02808f
C6 B vdd 0.12672f
C7 a_2_54# vdd 0.0567f
C8 Y gnd 4.48341f
C9 C gnd 1.26414f
C10 B gnd 1.10198f
C11 A gnd 1.18795f
C12 vdd gnd 12.4612f
C13 a_2_54# gnd 4.00028f
C14 A.t1 gnd 0.04903f
C15 A.t0 gnd 0.04269f
C16 A.n0 gnd 0.0538f
C17 B.t1 gnd 0.05051f
C18 B.t0 gnd 0.02952f
C19 B.n0 gnd 0.04768f
C20 C.t1 gnd 0.06388f
C21 C.t0 gnd 0.0154f
C22 C.n0 gnd 0.05423f
.ends

