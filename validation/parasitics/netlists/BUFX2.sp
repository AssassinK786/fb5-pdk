* NGSPICE file created from BUFX2.ext - technology: scmos

.subckt BUFX2 vdd gnd A Y
M1000 vdd A.t1 a_2_6.t0 vdd pfet w=6u l=0.6u
+  ad=9.9p pd=13.8u as=9p ps=15u
M1001 gnd.t1 A.t0 a_2_6.t1 gnd.t0 nfet w=3u l=0.6u
+  ad=4.95p pd=7.8u as=4.5p ps=9u
M1002 Y a_2_6.t3 vdd vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=9.9p ps=13.8u
M1003 Y a_2_6.t2 gnd.t1 gnd.t1 nfet w=6u l=0.6u
+  ad=9p pd=15u as=4.95p ps=7.8u
R0 A.n0 A.t1 472.017
R1 A.n0 A.t0 345.651
R2 A A.n0 27.0305
R3 gnd.t0 gnd.t1 0.041598
R4 gnd gnd.t1 0.0005
R5 a_2_6.n0 a_2_6.t2 354.57
R6 a_2_6.n0 a_2_6.t3 265.37
R7 a_2_6.t0 a_2_6.n1 51.4755
R8 a_2_6.n1 a_2_6.t1 48.186
R9 a_2_6.n1 a_2_6.n0 15.8005
C0 Y vdd 0.04662f
C1 vdd A 0.45936f
C2 Y gnd 4.05029f
C3 A gnd 1.29309f
C4 vdd gnd 9.53035f
C5 a_2_6.t1 gnd 0.02748f
C6 a_2_6.t3 gnd 0.05131f
C7 a_2_6.t2 gnd 0.04222f
C8 a_2_6.n0 gnd 0.05449f
C9 a_2_6.n1 gnd 0.31163f
C10 a_2_6.t0 gnd 0.06115f
C11 A.t0 gnd 0.10051f
C12 A.t1 gnd 0.15031f
C13 A.n0 gnd 0.19841f
.ends

