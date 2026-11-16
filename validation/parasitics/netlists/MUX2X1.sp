* NGSPICE file created from MUX2X1.ext - technology: scmos

.subckt MUX2X1 S vdd gnd Y A B
M1000 gnd.t0 A.t0 a_30_10# gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=15u as=2.7p ps=6.9u
M1001 a_17_50# B.t1 vdd vdd pfet w=12u l=0.6u
+  ad=5.4p pd=12.9u as=9.36p ps=13.8u
M1002 Y S.t2 a_17_50# vdd pfet w=12u l=0.6u
+  ad=11.16p pd=15u as=5.4p ps=12.9u
M1003 a_30_54# a_2_10.t3 Y vdd pfet w=12u l=0.6u
+  ad=5.4p pd=12.9u as=11.16p ps=15u
M1004 a_17_10.t0 B.t0 gnd.t1 gnd.t0 nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=4.77p ps=7.8u
M1005 vdd S.t3 a_2_10.t1 vdd pfet w=6u l=0.6u
+  ad=9.36p pd=13.8u as=9p ps=15u
M1006 a_30_10# S.t0 Y gnd.t0 nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=5.4p ps=7.8u
M1007 gnd.t1 S.t1 a_2_10.t0 gnd.t0 nfet w=3u l=0.6u
+  ad=4.77p pd=7.8u as=4.5p ps=9u
M1008 vdd A.t1 a_30_54# vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=5.4p ps=12.9u
M1009 Y a_2_10.t2 a_17_10.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=2.7p ps=6.9u
R0 A.n0 A.t0 304.767
R1 A.n0 A.t1 260.168
R2 A A.n0 15.8805
R3 B.n0 B.t1 323.351
R4 B.n0 B.t0 245.3
R5 B B.n0 15.8805
R6 S.t3 S.t2 590.951
R7 S.t1 S.t0 512.9
R8 S.n0 S.t3 434.851
R9 S.n0 S.t1 289.901
R10 S S.n0 15.8805
R11 gnd.t1 gnd.t0 0.0427975
R12 gnd gnd.t0 0.0005
R13 a_2_10.n0 a_2_10.t3 434.851
R14 a_2_10.n0 a_2_10.t2 172.826
R15 a_2_10.t1 a_2_10.n1 52.0342
R16 a_2_10.n1 a_2_10.t0 48.1353
R17 a_2_10.n1 a_2_10.n0 15.8005
C0 vdd A 0.19008f
C1 Y A 0.03744f
C2 vdd S 0.86112f
C3 vdd B 0.18978f
C4 Y vdd 0.0259f
C5 Y S 0.06552f
C6 Y a_30_10# 0.01575f
C7 Y a_30_54# 0.01575f
C8 Y gnd 4.4081f
C9 A gnd 0.89709f
C10 B gnd 0.92096f
C11 S gnd 1.74079f
C12 vdd gnd 17.8392f
C13 a_2_10.t3 gnd 0.10543f
C14 a_2_10.t2 gnd 0.05069f
C15 a_2_10.n0 gnd 0.09438f
C16 a_2_10.t0 gnd 0.04527f
C17 a_2_10.n1 gnd 0.5318f
C18 a_2_10.t1 gnd 0.10486f
C19 S.t2 gnd 0.24394f
C20 S.t3 gnd 0.24035f
C21 S.t0 gnd 0.17755f
C22 S.t1 gnd 0.1909f
C23 S.n0 gnd 0.1962f
C24 B.t1 gnd 0.09446f
C25 B.t0 gnd 0.06098f
C26 B.n0 gnd 0.08719f
C27 A.t1 gnd 0.07001f
C28 A.t0 gnd 0.05518f
C29 A.n0 gnd 0.06932f
.ends

