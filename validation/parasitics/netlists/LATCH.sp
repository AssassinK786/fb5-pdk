* NGSPICE file created from LATCH.ext - technology: scmos

.subckt LATCH D Q gnd vdd CLK
M1000 gnd.t1 CLK.t0 a_2_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=8.1u as=9p ps=15u
M1001 a_23_6.t2 CLK a_18_6.t0 gnd.t0 nfet w=3u l=0.6u
+  ad=4.5p pd=6u as=1.35p ps=3.9u
M1002 a_23_6.t0 a_2_6.t3 a_18_74.t0 vdd pfet w=6u l=0.6u
+  ad=8.1p pd=9u as=2.7p ps=6.9u
M1003 Q a_23_6.t4 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=8.1u
M1004 a_35_6.t0 a_2_6.t2 a_23_6.t1 gnd.t0 nfet w=3u l=0.6u
+  ad=1.35p pd=3.9u as=4.5p ps=6u
M1005 a_18_6.t0 D.t0 gnd.t1 gnd.t0 nfet w=3u l=0.6u
+  ad=1.35p pd=3.9u as=5.4p ps=8.1u
M1006 vdd CLK.t2 a_2_6.t1 vdd pfet w=12u l=0.6u
+  ad=10.8p pd=14.1u as=18p ps=27u
M1007 vdd Q.t1 a_35_84.t0 vdd pfet w=3u l=0.6u
+  ad=9.9p pd=14.1u as=1.35p ps=3.9u
M1008 a_18_74.t0 D.t1 vdd vdd pfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=10.8p ps=14.1u
M1009 Q a_23_6.t5 vdd vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=9.9p ps=14.1u
M1010 gnd.t0 Q.t0 a_35_6.t0 gnd.t0 nfet w=3u l=0.6u
+  ad=5.4p pd=8.1u as=1.35p ps=3.9u
M1011 a_35_84.t0 CLK.t1 a_23_6.t3 vdd pfet w=3u l=0.6u
+  ad=1.35p pd=3.9u as=8.1p ps=9u
R0 Q.n0 Q.t1 527.768
R1 Q.n0 Q.t0 312.2
R2 Q Q.n0 16.0605
R3 D.n0 D.t0 420.728
R4 D.n0 D.t1 376.87
R5 D D.n0 15.9805
R6 CLK CLK.t1 562.331
R7 CLK.n0 CLK.t2 423.7
R8 CLK.n0 CLK.t0 200.701
R9 CLK CLK.n0 16.1338
R10 gnd.t1 gnd.t0 0.0425392
R11 gnd gnd.t0 0.0005
R12 a_23_6.n1 a_23_6.t4 353.084
R13 a_23_6.n1 a_23_6.t5 263.884
R14 a_23_6.n3 a_23_6.t3 51.3505
R15 a_23_6.n3 a_23_6.n2 36.1333
R16 a_23_6.n0 a_23_6.t1 36.0005
R17 a_23_6.n0 a_23_6.t2 36.0005
R18 a_23_6.t0 a_23_6.n3 30.8105
R19 a_23_6.n2 a_23_6.n0 26.5755
R20 a_23_6.n2 a_23_6.n1 16.5625
R21 a_2_6.n0 a_2_6.t3 457.151
R22 a_2_6.n0 a_2_6.t2 446
R23 a_2_6.t1 a_2_6.t0 26.315
R24 a_2_6.t0 a_2_6.n0 16.7025
C0 CLK vdd 0.76032f
C1 vdd Q 0.67992f
C2 CLK D 0.03744f
C3 D vdd 0.58473f
C4 Q gnd 5.82383f
C5 D gnd 1.52726f
C6 CLK gnd 3.57827f
C7 vdd gnd 20.6735f
C8 a_2_6.t3 gnd 0.04514f
C9 a_2_6.t2 gnd 0.03848f
C10 a_2_6.n0 gnd 0.0683f
C11 a_2_6.t0 gnd 0.41344f
C12 a_2_6.t1 gnd 0.11443f
C13 a_23_6.t3 gnd 0.01563f
C14 a_23_6.t1 gnd 0.01563f
C15 a_23_6.t2 gnd 0.01563f
C16 a_23_6.n0 gnd 0.03348f
C17 a_23_6.t5 gnd 0.0424f
C18 a_23_6.t4 gnd 0.03487f
C19 a_23_6.n1 gnd 0.04964f
C20 a_23_6.n2 gnd 0.32375f
C21 a_23_6.n3 gnd 0.05641f
C22 a_23_6.t0 gnd 0.04272f
C23 CLK.t1 gnd 0.12439f
C24 CLK.t2 gnd 0.15123f
C25 CLK.t0 gnd 0.07769f
C26 CLK.n0 gnd 0.12499f
C27 D.t1 gnd 0.15827f
C28 D.t0 gnd 0.14468f
C29 D.n0 gnd 0.23099f
C30 Q.t1 gnd 0.05247f
C31 Q.t0 gnd 0.03539f
C32 Q.n0 gnd 0.07566f
.ends

