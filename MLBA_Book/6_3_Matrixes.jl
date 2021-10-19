#Transpose. In VMLS we denote the transpose of an m × n matrix A as AT .
#In Julia, the transpose of A is given by A'.
H=[01 -21;2 -130]
H'
#Addition, subtraction, and scalar multiplication.
#In Julia, addition and subtraction of matrices,
#and scalar-matrix multiplication, both follow standard mathematical notation.
U = [ 0 4; 7 0; 3 1]
V = [ 1 2; 2 3; 0 4]
U+V
2.2*U
#(We can also multiply a matrix on the right by a scalar.)

#Elementwise operations.
#For example, if A and B are matrices of the same size,
#then C = A .* B creates a matrix of the same size
#with elements Cij = AijBij.
#Thus, if X is a matrix, then Y = exp.(X)
#creates a matrix of the same size, with elements Yij = exp(Xij ).
#Matrix norm. In VMLS we use ∥A∥ to denote the norm of an m × n matrix,
using LinearAlgebra
A = [2 3 -1; 0 -1 4]
norm(A)
norm(A[:])
#Triangle inequality. Let’s check that the triangle inequality ∥A+B∥ ≤ ∥A∥+∥B∥ holds,
# for two specific matrices.
A=[-10;22]; B=[31;-32];
 norm(A + B), norm(A) + norm(B)

#Matrix-vector multiplication
#In Julia, matrix-vector multiplication has the natural syntax y=A*x
A = [0 2 -1; -2 1 1]
x = [2, 1, -1]
A*x
#Difference matrix. An (n − 1) × n difference matrix (equation (6.5) of VMLS)
#can be constructed in several ways. A simple one is the following.
eye(n) = 1.0*Matrix(I,n,n)
difference_matrix(n) = [- eye(n-1) zeros(n-1)] + [zeros(n-1) eye(n-1)];
D = difference_matrix(4)
D*[-1,0,2,1]
#sparse matrix
using SparseArrays
difference_matrix(n) = [-I(n-1) spzeros(n-1)] +[spzeros(n-1) I(n-1)];
D = difference_matrix(4)
D*[-1,0,2,1]

#Running sum matrix. The running sum matrix (equation (6.6) in VMLS)
#is a lower triangular matrix, with elements on and below the diagonal equal to one.
function running_sum(n)  # n x n running sum matrix
	S = zeros(n,n)
	for i=1:n
	   for j=1:i
	   S[i,j] = 1
	 	end
	end
	   return S
end
running_sum(4)
running_sum(4)*[-1,1,2,0]

#Vandermonde matrix
# tj−1 for i = 1,...,m and j = 1,...,n. We define a function that i
#takes an m-vector with elements t1, . . . , tm and returns the corresponding m × n
#Vandermonde matrix.
function vandermonde(t,n)
       m = length(t)
       V = zeros(m,n)
       for i=1:m
	   	for j=1:n
           V[i,j] = t[i]^(j-1)
       	end
       end
   return V
end
vandermonde([-1,0,0.5,1],5)
#An alternative shorter definition uses Julia’s hcat function.
vandermonde1(t,n) = hcat( [t.^i for i = 0:n-1]... )
vandermonde1([-1,0,0.5,1],5)

#Complexity of matrix-vector multiplication.
# The complexity of multiplying an m × n matrix by an n-vector is 2mn flops.
#This grows linearly with both m and n. Let’s check this.
 A = rand(1000,10000);  x = rand(10000);
  @time y = A*x;
  @time y = A*x;
A = rand(5000,20000);  x = rand(20000);
  @time y = A*x;
  @time y = A*x;
  #In the second matrix-vector multiply, m increases by a factor of 5 and n
  #increases by a factor of 2, so the complexity predicts that the computation time
  #should be (approximately) increased by a factor of 10.
  #As we can see, it is increased by a factor around 7.4.
#The increase in efficiency obtained by sparse matrix computations is
#seen from matrix-vector multiplications with the difference matrix.
n = 10^4;
D = [-eye(n-1) zeros(n-1)] + [zeros(n-1) eye(n-1)];
x = randn(n);
@time y=D*x;
Ds = [-I(n-1) spzeros(n-1)] + [spzeros(n-1) I(n-1)];
@time y=Ds*x;
