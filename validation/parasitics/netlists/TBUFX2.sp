* NGSPICE file created from TBUFX2.ext - technology: scmos

.subckt TBUFX2 vdd gnd A EN Y
M1000 a_9_6.t0 EN.t2 gnd gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=15u as=9p ps=15u
M1001 a_18_6# EN.t0 Y gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1002 a_18_6# A.t0 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=7.8u
M1003 Y EN.t1 a_18_6# gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=9p ps=15u
M1004 gnd.t0 A.t1 a_18_6# gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1005 a_9_6.t1 EN.t3 vdd vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=18p ps=27u
M1006 vdd A.t3 a_18_54# vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1007 Y a_9_6.t3 a_18_54# vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=18p ps=27u
M1008 a_18_54# A.t2 vdd vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=10.8p ps=13.8u
M1009 a_18_54# a_9_6.t2 Y vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
R0 A.n0 A.t3 323.351
R1 A.n0 A.t2 234.15
R2 A.n1 A.t1 211.851
R3 A.n2 A.n0 167.25
R4 A.n1 A.t0 122.65
R5 A.n2 A.n1 55.7505
R6 A A.n2 15.9005
R7 EN EN.t3 305.781
R8 EN.n0 EN.t0 211.851
R9 EN.n1 EN.n0 178.4
R10 EN.n1 EN.t2 122.65
R11 EN.n0 EN.t1 122.65
R12 EN EN.n1 32.8722
R13 gnd gnd.t0 0.0443027
R14 a_9_6.n0 a_9_6.t2 323.351
R15 a_9_6.n0 a_9_6.t3 234.15
R16 a_9_6.n1 a_9_6.n0 216.5
R17 a_9_6.t1 a_9_6.n1 26.008
R18 a_9_6.n1 a_9_6.t0 24.2633
C0 a_18_54# vdd 0.0756f
C1 a_18_54# Y 0.0567f
C2 a_18_6# Y 0.0567f
C3 EN vdd 0.22176f
C4 EN Y 0.02808f
C5 A a_18_54# 0.07488f
C6 A a_18_6# 0.11232f
C7 Y vdd 0.03108f
C8 a_18_6# EN 0.05616f
C9 A vdd 0.30096f
C10 Y gnd 3.54744f
C11 A gnd 1.25037f
C12 EN gnd 2.16539f
C13 vdd gnd 18.9843f
C14 a_18_6# gnd 4.09352f
C15 a_18_54# gnd 6.14476f
C16 a_9_6.t0 gnd 0.05097f
C17 a_9_6.t3 gnd 0.04652f
C18 a_9_6.t2 gnd 0.05264f
C19 a_9_6.n0 gnd 0.0521f
C20 a_9_6.n1 gnd 0.30283f
C21 a_9_6.t1 gnd 0.11613f
C22 EN.t3 gnd 0.05938f
C23 EN.t2 gnd 0.02866f
C24 EN.t1 gnd 0.02866f
C25 EN.t0 gnd 0.0359f
C26 EN.n0 gnd 0.03861f
C27 EN.n1 gnd 0.03786f
C28 A.t2 gnd 0.08094f
C29 A.t3 gnd 0.09159f
C30 A.n0 gnd 0.08549f
C31 A.t0 gnd 0.04359f
C32 A.t1 gnd 0.0546f
C33 A.n1 gnd 0.04827f
C34 A.n2 gnd 0.03899f
.ends

