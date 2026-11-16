* NGSPICE file created from AND2X2.ext - technology: scmos

.subckt AND2X2 vdd gnd A B Y
M1000 a_2_6.t2 A.t1 vdd vdd pfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=9p ps=15u
M1001 a_9_6.t0 A.t0 a_2_6.t1 gnd.t2 nfet w=6u l=0.6u
+  ad=2.7p pd=6.9u as=9p ps=15u
M1002 Y a_2_6.t3 gnd.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=9p pd=15u as=5.4p ps=7.8u
M1003 Y a_2_6.t4 vdd vdd pfet w=12u l=0.6u
+  ad=18p pd=27u as=9.72p ps=13.8u
M1004 vdd B.t1 a_2_6.t0 vdd pfet w=6u l=0.6u
+  ad=9.72p pd=13.8u as=5.4p ps=7.8u
M1005 gnd.t0 B.t0 a_9_6.t0 gnd.t0 nfet w=6u l=0.6u
+  ad=5.4p pd=7.8u as=2.7p ps=6.9u
R0 B.n0 B.t1 524.051
R1 B.n0 B.t0 223
R2 B B.n0 15.9792
R3 A.n0 A.t1 488.37
R4 A.n0 A.t0 243.071
R5 A A.n0 15.8805
R6 gnd.t2 gnd.t0 0.00165675
R7 gnd gnd.t0 0.0005
R8 a_2_6.n0 a_2_6.t4 479.45
R9 a_2_6.n0 a_2_6.t3 156.101
R10 a_2_6.t2 a_2_6.n1 36.7438
R11 a_2_6.n1 a_2_6.t1 24.2646
R12 a_2_6.n1 a_2_6.n0 15.8005
R13 a_2_6.t0 a_2_6.t2 15.4055
C0 vdd B 0.44352f
C1 vdd Y 0.04662f
C2 vdd A 0.4752f
C3 Y gnd 4.22043f
C4 B gnd 1.37718f
C5 A gnd 1.10344f
C6 vdd gnd 13.9748f
C7 a_2_6.t1 gnd 0.04369f
C8 a_2_6.t3 gnd 0.02339f
C9 a_2_6.t4 gnd 0.05332f
C10 a_2_6.n0 gnd 0.04205f
C11 a_2_6.n1 gnd 0.24662f
C12 a_2_6.t2 gnd 0.05865f
C13 a_2_6.t0 gnd 0.01837f
C14 A.t1 gnd 0.15656f
C15 A.t0 gnd 0.10522f
C16 A.n0 gnd 0.18962f
C17 B.t0 gnd 0.09192f
C18 B.t1 gnd 0.148f
C19 B.n0 gnd 0.16455f
.ends

