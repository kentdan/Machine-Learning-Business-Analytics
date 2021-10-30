#Vector addition and subtraction.
#If x and y are vectors of the same size, x+y and x-y give their sum and difference, respectively.
[0,7,3]+[1,2,0] #Vectoraddition
[ 1, 9 ] - [ 1, 1]  # Vector subtraction
#Scalar-vector multiplication and division.
#If a is a number and x a vector, you can express the scalar-vector product either as a*x or x*a.
# x/a, or the less familar looking expression a\x.
 x = [ 0, 2, -1 ];
 2.2 * x   # Scalar-vector multiplication
 x * 2.2   # Scalar-vector multiplication
 x / 3   # Scalar-vector division
 3 \ x   # Scalar-vector division
 #Scalar-vector addition. In Julia you can add a scalar a and a vector x using
 #x .+ a
 [ 1.1, -3.7, 0.3 ] .- 1.4  # Vector-scalar subtraction
  0.7 .+ [1,-1]

  #Elementwise operations. Julia supports methods for carrying out an operation
  #on every element or coefficient of a vector. To do this we add a period or dot
  #before the operator.
p_initial = [ 22.15, 89.32, 56.77 ];
p_final = [ 23.05, 87.32, 57.13 ];
r = (p_final - p_initial) ./ p_initial
#Elementwise operations with a scalar.
#Elementwise operations work when one of the arguments is a scalar,
# in which case it is interpreted as the scalar times a ones vector of the appropriate dimension.
 w = [1,2,2]; z = [1,2,3];
  w == z
  w .== z
  #[abs.(x) .> 1] gives the subvector of x consisting of the entries larger than one in magnitude.
x = [1.1, .5, -1.5, -0.3]
x[abs.(x) .> 1]
#Dot notation works with assignment too,
#allowing you to assign multiple entries of a vector
# to a scalar value. For example:
x = rand(4)
x[1:2] = [-1,1];
x
x[2:3] .= 1.3;
x
#Linear combination.
#You can form a linear combination in Julia using scalar-vector multiplication and addition.
a=[1,2]; b=[3,4];
alpha = -0.5; beta = 1.5;
c = alpha*a + beta*b
function lincomb(coeff, vectors)
	  n = length(vectors[1])  # Length of vectors
	  a = zeros(n);
	  for i = 1:length(vectors)
		  a = a + coeff[i] * vectors[i];
	  end
	  return a
	  end
lincomb( ( -0.5, 1.5), ( [1, 2], [ 3, 4]) )

function lincomb1(coeff, vectors)
        return sum( coeff[i] * vectors[i] for i = 1:length(vectors) )
        end
#Checking properties
#let’s check the distributive property
# β(a + b) = βa + βb,
#which holds for any two n-vectors a and b, and any scalar β.
#We’ll do this for n = 3, and randomly generated a, b, and β.
#(This computation does not show that the property always holds;
#it only shows that it holds for the specific vectors chosen.
#But it’s good to be skeptical and check identities with random arguments.)
#We use the lincomb function we just defined.
a = rand(3)
b = rand(3);
beta = randn()  # Generates a random scalar
lhs = beta*(a+b)
rhs = beta*a + beta*b
#Although the two vectors lhs and rhs are displayed as the same,
#they might not be exactly the same, due to very small round-off errors
#in floating point computations.

#Inner product. The inner product of n-vectors x and y is denoted as xT y. In
#Julia, the inner product of x and y is denoted as x'*y.
x = [ -1, 2, 2 ];
y = [ 1, 0, -3 ];
x'*y
#Net present value. As an example, the following code snippet finds the net present value (NPV)
# of a cash flow vector c, with per-period interest rate r.
 c = [ 0.1, 0.1, 0.1, 1.1 ];  # Cash flow vector
 n = length(c);
 r = 0.05;   # 5% per-period interest rate
 d = (1+r) .^ -(0:n-1)
 NPV = c'*d
#Total school-age population.
#Suppose that the 100-vector x gives the age distribution of some population,
# with xi the number of people of age i − 1, for i = 1, . . . , 100.
#We can express this as sT x, where s is the vector with entries one for i = 6, . . . , 19
#and zero otherwise. In Julia, this is expressed as x6 +x7 +···+x18 +x19.
x = rand(100)
s = [ zeros(5); ones(14); zeros(81) ];
school_age_pop = s'*x
  sum(x[6:19])
#Complexity of vector computations
#Floating point operations.
#For any two numbers a and b, we have (a+b)(a−b) = a2 −b2.
#due to very small floating point round-off errors. But they should be very nearly the same.
a = rand(); b = rand();
lhs = (a+b) * (a-b)
rhs = a^2 - b^2
lhs - rhs
#Complexity. You can time a Julia command by adding @time before the command.
#The timer is not very accurate for very small times, say, measured in microseconds (10−6 seconds). Also,
#you should run the command more than once; it can be a lot faster on the second or subsequent runs.
a = randn(10^5); b = randn(10^5);
@time a'*b
@time a'*b
c = randn(10^6); d = randn(10^6);
@time c'*d
@time c'*d
#Sparse vectors. Functions for creating and manipulating sparse vectors are contained in the Julia
# package SparseArrays, so you need to install this package before you can use them; see page ix.
#create a sparse vector from lists of the indices and values using the sparsevec function.
#create a sparse vector of zeros (using spzeros(n)) and then assign values to the nonzero entries.
#A sparse vector can be created from a non-sparse vector using sparse(x),
# which returns a sparse version of x.
#nnz(x) gives the number of nonzero elements of a sparse vector.
#Sparse vectors are overloaded to work as you imagine;
using SparseArrays
a = sparsevec( [ 123456, 123457 ], [ 1.0, -1.0 ], 10^6 )
length(a)
nnz(a)
b = randn(10^6);  # An ordinary (non-sparse) vector
@time 2*a;  # Computed efficiently!
@time 2*b;
@time a'*b;  # Computed efficiently!
@time b'*b;
@time c = a + b;
