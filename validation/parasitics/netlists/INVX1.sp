* NGSPICE file created from INVX1.ext - technology: scmos

.subckt INVX1 A Y vdd gnd
M1000 Y A.t1 vdd vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=9p ps=15u
M1001 Y A.t0 gnd gnd nfet w=3u l=0.6u
+  ad=4.5p pd=9u as=4.5p ps=9u
R0 A.n0 A.t1 680.15
R1 A.n0 A.t0 89.2005
R2 A A.n0 38.1805
C0 A vdd 0.44352f
C1 Y vdd 0.26936f
C2 Y gnd 4.1256f
C3 A gnd 1.31092f
C4 vdd gnd 9.02321f
C5 A.t1 gnd 0.15974f
C6 A.t0 gnd 0.04135f
C7 A.n0 gnd 0.16479f
.ends

