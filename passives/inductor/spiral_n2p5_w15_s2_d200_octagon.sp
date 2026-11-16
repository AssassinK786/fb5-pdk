* spiral_n2p5_w15_s2_d200_octagon: FB5 spiral (Mohan L + pi model), L=1.482 nH Rdc=0.595 ohm
.subckt spiral_n2p5_w15_s2_d200_octagon p1 p2 sub
Ls p1 x 1.4824e-09
Rs x p2 1.4533
Cs p1 p2 6.4745e-15
Cox1 p1 n1 3.9333e-14
Rsub1 n1 sub 1.0091e+03
Csub1 n1 sub 9.9101e-17
Cox2 p2 n2 3.9333e-14
Rsub2 n2 sub 1.0091e+03
Csub2 n2 sub 9.9101e-17
.ends
