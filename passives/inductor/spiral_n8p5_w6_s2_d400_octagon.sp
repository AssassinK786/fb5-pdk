* spiral_n8p5_w6_s2_d400_octagon: FB5 spiral (Mohan L + pi model), L=40.100 nH Rdc=10.584 ohm
.subckt spiral_n8p5_w6_s2_d400_octagon p1 p2 sub
Ls p1 x 4.0100e-08
Rs x p2 25.8671
Cs p1 p2 3.5221e-15
Cox1 p1 n1 1.1202e-13
Rsub1 n1 sub 3.5432e+02
Csub1 n1 sub 2.8223e-16
Cox2 p2 n2 1.1202e-13
Rsub2 n2 sub 3.5432e+02
Csub2 n2 sub 2.8223e-16
.ends
