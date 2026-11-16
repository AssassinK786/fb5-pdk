* NGSPICE file created from INVX4.ext - technology: scmos

.subckt INVX4 vdd gnd Y A
M1000 Y A.t1 gnd gnd nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=9p ps=15u
M1001 vdd A.t2 Y vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=10.8p ps=13.8u
M1002 Y A.t3 vdd vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=18p ps=27u
M1003 gnd A.t0 Y gnd nfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=7.8u
R0 A.n0 A.t2 323.351
R1 A.n0 A.t3 234.15
R2 A.n2 A.n0 223
R3 A.n1 A.t0 211.851
R4 A.n1 A.t1 144.951
R5 A A.n2 32.6055
R6 A.n2 A.n1 22.3005
C0 vdd A 0.30096f
C1 Y A 0.07488f
C2 Y vdd 0.04144f
C3 Y gnd 4.00128f
C4 A gnd 1.30155f
C5 vdd gnd 12.3514f
C6 A.t3 gnd 0.06077f
C7 A.t2 gnd 0.06877f
C8 A.n0 gnd 0.06867f
C9 A.t0 gnd 0.04089f
C10 A.t1 gnd 0.03459f
C11 A.n1 gnd 0.03297f
C12 A.n2 gnd 0.03259f
.ends

