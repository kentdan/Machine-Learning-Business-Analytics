#Geometric transformations
#Let’s create a rotation matrix, and use it to rotate a set of points π/3 radians (60◦).
Rot(theta) = [cos(theta) -sin(theta); sin(theta) cos(theta)];
 R = Rot(pi/3)
 # Create a list of 2-D points
points = [ [1,0], [1.5,0], [2,0], [1,0.25], [1.5, 0.25], [1,.5] ];
# Now rotate them.
rpoints = [ R*p for p in points ];
# Show the two sets of points.
using Plots
scatter([c[1] for c in points], [c[2] for c in points])
scatter!([c[1] for c in rpoints], [c[2] for c in rpoints])
plot!(lims = (-0.1, 2.1), size = (500,500), legend = false)
#Selectors
#Reverser matrix. The reverser matrix can be created from an identity matrix by reversing the order of its rows.
#The Julia command reverse can be used for this purpose.
#(reverse(A,dims=1) reverses the order of the rows of a matrix;
#flipdim(A,dims=2) reverses the order of the columns.)
#Multiplying a vector with a reverser matrix is the same as reversing the order of its entries directly.
using LinearAlgebra
using SparseArrays
eye(n) = 1.0*Matrix(I,n,n)
reverser(n) = reverse(eye(n),dims=1)
A = reverser(5)
x = [1., 2., 3., 4., 5.];
A*x  # Reverse x by multiplying with reverser matrix.
reverse(x)  # Reverse x directly.
#Permutation matrix.
#Let’s create a permutation matrix and use it to permute the entries of a vector.
A = [0 0 1; 1 0 0; 0 1 0]
x = [0.2, -1.7, 2.4]
A*x  # Permutes entries of x to [x[3],x[1],x[2]]
x[[3,1,2]]  # Same thing using permuted indices

#Incidence matrix
#Incidence matrix of a graph.
#We create the incidence matrix of the network shown in Figure 7.3 in VMLS.
A = [ -1 -1 0 1 0; 1 0 -1 0 0 ; 0 0 1 -1 -1 ; 0 1 0 0 1]
xcirc = [1, -1, 1, 0, 1] #A circulation
A*xcirc
s = [1,0,-1,0];  # A source vector
x = [0.6, 0.3, 0.6, -0.1, -0.3];  # A flow vector
A*x + s   # Total incoming flow at each node

#Dirichlet energy. On page 135 of VMLS we compute the Dirichlet energy of two potential vectors
#associated with the graph of Figure 7.2 in VMLS.
A = [ -1 -1 0 1 0 ; 1 0 -1 0 0 ; 0 0 1 -1 -1; 0 1 0 0 1 ]
vsmooth = [ 1, 2, 2, 1 ]
norm(A'*vsmooth)^2  # Dirichlet energy of vsmooth
vrough = [ 1, -1, 2, -1 ]
norm(A'*vrough)^2  # Dirichlet energy of vrough

#Convolution
#The Julia package DSP includes a convolution function conv. After adding this package,
#the command conv(a,b) can be used to compute the convolution of the vectors a and b.
#p(x)=(1+x)(2−x+x2)(1+x−2x2)=2+3x−3x2 −x3 +x4 −2x5.
using Pkg
Pkg.add("DSP")
using DSP
a = [1,1];  # coefficients of 1+x
b = [2,-1,1];  # coefficients of 2-x+x^2
c = [1,1,-2];  # coefficients of 1+x-2x^2
d = conv(conv(a,b),c)  # coefficients of product

function toeplitz(b,n)
       m = length(b)
       T = zeros(n+m-1,n)
       for i=1:m
           T[i : n+m : end] .= b[i]
       end
   return T
end
b = [-1,2,3]; a = [-2,3,-1,1];
Tb = toeplitz(b, length(a))
Tb*a, conv(b,a)
m = 2000; n = 2000;
b = randn(n); a=randn(m);
@time ctoep = toeplitz(b,n)*a;
@time cconv = conv(a,b);
norm(ctoep - cconv)
