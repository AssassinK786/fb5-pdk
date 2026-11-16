* NGSPICE file created from TBUFX1.ext - technology: scmos

.subckt TBUFX1 vdd gnd EN A Y
M1000 a_9_6.t1 EN.t2 vdd vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=9p ps=15u
M1001 a_9_6.t0 EN.t1 gnd gnd nfet w=3u l=0.6u
+  ad=4.5p pd=9u as=4.5p ps=9u
M1002 a_26_6.t0 EN.t0 Y gnd nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=9p ps=15u
M1003 vdd A.t1 a_26_54# vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=5.4p ps=12.9u
M1004 a_26_54# a_9_6.t2 Y vdd pfet w=12u l=0.6u
+  ad=5.4p pd=12.9u as=18p ps=27u
M1005 gnd A.t0 a_26_6.t0 gnd nfet w=6u l=0.6u
+  ad=9p pd=15u as=2.7p ps=6.9u
R0 A.n0 A.t1 421.471
R1 A.n0 A.t0 198.47
R2 A A.n0 15.8805
R3 EN.n1 EN.n0 390.25
R4 EN.n0 EN.t0 312.2
R5 EN.n1 EN.t2 200.701
R6 EN.n0 EN.t1 178.4
R7 EN EN.n1 15.8805
R8 a_9_6.n0 a_9_6.t2 551
R9 a_9_6.t1 a_9_6.n0 51.8222
R10 a_9_6.n0 a_9_6.t0 47.8127
C0 EN Y 0.02808f
C1 EN vdd 0.54832f
C2 vdd A 0.12672f
C3 vdd Y 0.04662f
C4 Y gnd 4.07838f
C5 A gnd 1.02926f
C6 EN gnd 1.41371f
C7 vdd gnd 14.1871f
C8 a_9_6.t0 gnd 0.02298f
C9 a_9_6.t2 gnd 0.06186f
C10 a_9_6.n0 gnd 0.26947f
C11 a_9_6.t1 gnd 0.0539f
C12 EN.t2 gnd 0.08385f
C13 EN.t1 gnd 0.05965f
C14 EN.t0 gnd 0.10581f
C15 EN.n0 gnd 0.16279f
C16 EN.n1 gnd 0.12891f
C17 A.t1 gnd 0.04551f
C18 A.t0 gnd 0.02334f
C19 A.n0 gnd 0.04013f
.ends

