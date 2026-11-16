* NGSPICE file created from FB5_INV_CHAIN.ext - technology: scmos

.subckt INVX1 A vdd gnd Y
M1000 Y A vdd vdd pfet w=6u l=0.6u
+  ad=9p pd=15u as=9p ps=15u
M1001 Y A gnd gnd nfet w=3u l=0.6u
+  ad=4.5p pd=9u as=4.5p ps=9u
C0 A vdd 0.44352f
C1 Y vdd 0.26936f
C2 Y gnd 4.1256f
C3 A gnd 1.23328f
C4 vdd gnd 9.02321f
.ends

.subckt FB5_INV_CHAIN in out vdd gnd
XINVX1_0 INVX1_1/Y vdd gnd out INVX1
XINVX1_1 INVX1_2/Y vdd gnd INVX1_1/Y INVX1
XINVX1_2 in vdd gnd INVX1_2/Y INVX1
C0 in gnd 0.6192f
C1 INVX1_2/Y gnd 1.79576f
C2 out gnd 0.58832f
C3 INVX1_1/Y gnd 1.79591f
C4 vdd gnd 0.07292f
.ends

