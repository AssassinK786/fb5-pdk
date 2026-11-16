* spiral_n1p5_w10_s2_d100_octagon: FB5 spiral (Mohan L + pi model), L=0.319 nH Rdc=0.282 ohm
.subckt spiral_n1p5_w10_s2_d100_octagon p1 p2 sub
Ls p1 x 3.1881e-10
Rs x p2 0.6888
Cs p1 p2 1.7265e-15
Cox1 p1 n1 8.2859e-15
Rsub1 n1 sub 4.7901e+03
Csub1 n1 sub 2.0876e-17
Cox2 p2 n2 8.2859e-15
Rsub2 n2 sub 4.7901e+03
Csub2 n2 sub 2.0876e-17
.ends
