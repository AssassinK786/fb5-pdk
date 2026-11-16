* NGSPICE file created from INVX8.ext - technology: scmos

.subckt INVX8 vdd gnd A Y
M1000 Y A.t3 gnd gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=9p ps=15u
M1001 gnd.t0 A.t0 Y gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=7.8u
M1002 vdd A.t6 Y vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1003 Y A.t1 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1004 Y A.t7 vdd vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=18p ps=27u
M1005 Y A.t5 vdd vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.8p ps=13.8u
M1006 gnd.t0 A.t2 Y gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.4p ps=7.8u
M1007 vdd A.t4 Y vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=10.8p ps=13.8u
R0 A.n0 A.t4 323.351
R1 A.n1 A.t6 234.15
R2 A.n0 A.t5 234.15
R3 A.n2 A.t7 234.15
R4 A.n6 A.n2 223
R5 A.n3 A.t0 223
R6 A.n5 A.t3 144.951
R7 A.n3 A.t1 133.8
R8 A.n4 A.t2 133.8
R9 A.n2 A.n1 89.2005
R10 A.n1 A.n0 89.2005
R11 A.n4 A.n3 89.2005
R12 A.n5 A.n4 78.0505
R13 A A.n6 32.6055
R14 A.n6 A.n5 22.3005
R15 gnd gnd.t0 0.0429895
C0 vdd Y 0.17612f
C1 A Y 0.20592f
C2 vdd A 0.64944f
C3 Y gnd 8.22928f
C4 A gnd 1.69073f
C5 vdd gnd 18.1857f
C6 A.t7 gnd 0.07575f
C7 A.t6 gnd 0.07575f
C8 A.t5 gnd 0.07575f
C9 A.t4 gnd 0.08571f
C10 A.n0 gnd 0.06928f
C11 A.n1 gnd 0.04312f
C12 A.n2 gnd 0.05943f
C13 A.t2 gnd 0.04195f
C14 A.t1 gnd 0.04195f
C15 A.t0 gnd 0.05221f
C16 A.n3 gnd 0.04801f
C17 A.n4 gnd 0.03146f
C18 A.t3 gnd 0.04312f
C19 A.n5 gnd 0.02564f
C20 A.n6 gnd 0.04062f
.ends

