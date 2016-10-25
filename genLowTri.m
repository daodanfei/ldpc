function LowTri = genLowTri(n)
A = eye(n);
B = eye(n-1);
C = zeros(1,n-1);
D = zeros(n-1,1);
E = 0;
LowTri = A+[C E;B D];