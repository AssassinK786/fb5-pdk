* NGSPICE file created from INVX2.ext - technology: scmos

.subckt INVX2 vdd gnd Y A
M1000 Y A.t0 gnd gnd nfet w=6u l=0.6u
+  ad=9p pd=15u as=9p ps=15u
M1001 Y A.t1 vdd vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=18p ps=27u
R0 A.n0 A.t1 457.151
R1 A.n0 A.t0 144.951
R2 A A.n0 38.1805
C0 Y vdd 0.06216f
C1 vdd A 0.12672f
C2 Y gnd 4.022f
C3 A gnd 1.09706f
C4 vdd gnd 9.84801f
C5 A.t1 gnd 0.04564f
C6 A.t0 gnd 0.01987f
C7 A.n0 gnd 0.03903f
.ends

