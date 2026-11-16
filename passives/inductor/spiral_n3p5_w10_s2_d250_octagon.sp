* spiral_n3p5_w10_s2_d250_octagon: FB5 spiral (Mohan L + pi model), L=4.339 nH Rdc=1.644 ohm
.subckt spiral_n3p5_w10_s2_d250_octagon p1 p2 sub
Ls p1 x 4.3393e-09
Rs x p2 4.0181
Cs p1 p2 4.0286e-15
Cox1 p1 n1 4.8334e-14
Rsub1 n1 sub 8.2116e+02
Csub1 n1 sub 1.2178e-16
Cox2 p2 n2 4.8334e-14
Rsub2 n2 sub 8.2116e+02
Csub2 n2 sub 1.2178e-16
.ends
