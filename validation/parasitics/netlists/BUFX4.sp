* NGSPICE file created from BUFX4.ext - technology: scmos

.subckt BUFX4 vdd gnd A Y
M1000 gnd.t1 A.t0 a_2_6.t1 gnd.t0 nfet w=4.5u l=0.6u
+  ad=5.13p pd=7.8u as=6.75p ps=12u
M1001 vdd A.t1 a_2_6.t0 vdd pfet w=9u l=0.6u
+  ad=10.35p pd=13.8u as=13.5p ps=21u
M1002 Y a_2_6.t5 vdd vdd pfet w=12u l=0.6u
+  ad=10.8p pd=13.8u as=10.35p ps=13.8u
M1003 gnd.t1 a_2_6.t2 Y gnd.t1 nfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=7.8u
M1004 vdd a_2_6.t4 Y vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=10.8p ps=13.8u
M1005 Y a_2_6.t3 gnd.t1 gnd.t1 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=5.13p ps=7.8u
R0 A.n0 A.t1 408.834
R1 A.n0 A.t0 297.334
R2 A A.n0 15.8725
R3 gnd.t0 gnd.t1 0.041598
R4 gnd gnd.t1 0.0005
R5 a_2_6.n0 a_2_6.t4 323.351
R6 a_2_6.n0 a_2_6.t5 234.15
R7 a_2_6.n1 a_2_6.t2 211.851
R8 a_2_6.n2 a_2_6.n1 133.8
R9 a_2_6.n1 a_2_6.t3 122.65
R10 a_2_6.n2 a_2_6.n0 89.2005
R11 a_2_6.t0 a_2_6.n3 34.7358
R12 a_2_6.n3 a_2_6.t1 32.2495
R13 a_2_6.n3 a_2_6.n2 15.8005
C0 Y vdd 0.03108f
C1 A vdd 0.28512f
C2 Y gnd 4.1764f
C3 A gnd 1.22595f
C4 vdd gnd 14.2345f
C5 a_2_6.t1 gnd 0.03433f
C6 a_2_6.t5 gnd 0.04197f
C7 a_2_6.t4 gnd 0.04749f
C8 a_2_6.n0 gnd 0.03992f
C9 a_2_6.t3 gnd 0.0226f
C10 a_2_6.t2 gnd 0.02831f
C11 a_2_6.n1 gnd 0.02932f
C12 a_2_6.n2 gnd 0.02026f
C13 a_2_6.n3 gnd 0.28262f
C14 a_2_6.t0 gnd 0.07949f
C15 A.t1 gnd 0.10233f
C16 A.t0 gnd 0.06479f
C17 A.n0 gnd 0.12221f
.ends

