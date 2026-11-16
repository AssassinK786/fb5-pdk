* NGSPICE file created from OAI21X1.ext - technology: scmos

.subckt OAI21X1 gnd vdd A B Y C
M1000 gnd.t0 A.t0 a_2_6# gnd.t2 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=9p ps=15u
M1001 vdd C.t1 Y vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=9.9p ps=13.8u
M1002 Y C.t0 a_2_6# gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=7.8u
M1003 Y B.t1 a_9_54# vdd pfet w=12u l=0.6u
+  ad=9.9p pd=13.8u as=5.4p ps=12.9u
M1004 a_9_54# A.t1 vdd vdd pfet w=12u l=0.6u
+  ad=5.4p pd=12.9u as=18p ps=27u
M1005 a_2_6# B.t0 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
R0 C.n0 C.t0 535.201
R1 C.n0 C.t1 206.275
R2 C C.n0 16.0938
R3 B.n0 B.t1 356.8
R4 B.n0 B.t0 256.45
R5 B B.n0 38.1805
R6 A.n0 A.t1 462.726
R7 A.n0 A.t0 178.4
R8 A A.n0 15.8725
R9 gnd.t2 gnd.t0 0.041598
R10 gnd gnd.t0 0.0005
C0 C vdd 0.60331f
C1 Y C 0.03744f
C2 A a_2_6# 0.02808f
C3 B a_2_6# 0.02808f
C4 Y vdd 0.05439f
C5 A vdd 0.15048f
C6 B vdd 0.17424f
C7 Y gnd 4.54278f
C8 C gnd 1.43439f
C9 B gnd 1.10942f
C10 A gnd 1.13434f
C11 vdd gnd 12.8569f
C12 a_2_6# gnd 2.60706f
C13 A.t1 gnd 0.06534f
C14 A.t0 gnd 0.03015f
C15 A.n0 gnd 0.05613f
C16 B.t1 gnd 0.06453f
C17 B.t0 gnd 0.03929f
C18 B.n0 gnd 0.06396f
C19 C.t1 gnd 0.1073f
C20 C.t0 gnd 0.18107f
C21 C.n0 gnd 0.20542f
.ends

