* spiral_n5p5_w8_s2_d300_octagon: FB5 spiral (Mohan L + pi model), L=11.991 nH Rdc=3.798 ohm
.subckt spiral_n5p5_w8_s2_d300_octagon p1 p2 sub
Ls p1 x 1.1991e-08
Rs x p2 9.2833
Cs p1 p2 4.0516e-15
Cox1 p1 n1 7.1469e-14
Rsub1 n1 sub 5.5535e+02
Csub1 n1 sub 1.8007e-16
Cox2 p2 n2 7.1469e-14
Rsub2 n2 sub 5.5535e+02
Csub2 n2 sub 1.8007e-16
.ends
