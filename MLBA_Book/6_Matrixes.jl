#Creating matrices from the entries.
#Matrices are represented in Julia as 2- dimensional arrays.
#These are constructed by giving the elements in each row, separated by space,
#with the rows separated by semicolons.
#For example, the 3 × 4 matrix
A = [0.0  1.0 -2.3  0.1;
    1.3  4.0 -0.1  0.0;
    4.1 -1.0  0.0 1.7]
#(Here, Matrix{Float64} above the array tells us that the array is 2-dimensional,
#and its entries are 64-bit floating-point numbers.
#we put the different rows of the matrix on different lines,
#which makes the code more readable, but there is no need to do this
A = [0 1 -2.3 0.1; 1.3 4 -0.1 0; 4.1 -1 0 1.7]
#The Julia function size(A) gives the size, as a tuple.
#It can also be called as size(A,1) or size(A,2) to get only the number of rows or columns.
m, n = size(A)
m
n
size(A,1)
size(A,2)
tall(X) = size(X,1)>size(X,2);
tall(A)
#n the function definition, the number of rows
#and the number of columns are combined using the relational operator <,
#which gives a Boolean.
#Indexing entries. We get the i, j entry of a matrix A using A[i,j].
#We can also assign a new value to an entry.
A[2,3]  # Get 2,3 entry of A
A[1,3] = 7.5;  # Set 1,3 entry of A to 7.5
A
#Single index indexing. Julia allows you to access an entry of a matrix using only one index.
#To use this, you need to know that matrices in Julia are stored in column-major order.
Z = [ -1 0 2; -1 2 -3];
Z[5]
#With single index indexing, Z[5] is the fifth element in this sequence.
#This is very much not standard mathematical notation, and we would never use this in VMLS.
#But it can be handy in some cases when you are using Julia.
#Equality of matrices. A == B determines whether the matrices A and B are equal.
#The expression A .== B creates a matrix whose entries are Boolean,
#depending on whether the corresponding entries of A and B are the same.
#The expression sum(A .== B) gives the number of entries of A and B that are equal.
B = copy(A);
B[2,2] = 0;
A == B
A .== B
sum(A .== B)
#Row and column vectors. !!!!! In Julia, as in VMLS, n-vectors are the same as n × 1 matrices.
a=[-2.1-30] #A3-rowvectoror1x3matrix
b = [ -2.1; -3; 0 ]  # A 3-vector or 3x1 matrix
#You can see that b has type Vector{Float64}.
#(The Vector type is an alias for an Array of dimension one, and Matrix is an alias
#for an Array of dimension two.) However, the command size(b) gives (3,),
#whereas you might think it would or should be (3,1).
#Slicing and submatrices. Using colon notation you can extract a submatrix.
A = [ -1 0 1 0 ; 2 -3 0 1 ; 0 4 -2 1]
A[1:2,3:4]
A[:,3]  # Third column of A
A[2,:]  # Second row of A, returned as column vector!
#In mathematical (VMLS) notation, we say that A[2,:]
#returns the transpose of the second row of A.
#As with vectors, Julia’s slicing and selection is not limited to contiguous ranges of indexes.
m = size(X,1)
X[m:-1:1,:]  # Matrix X with row order reversed
#3Julia’s single indexing for matrices can be used with index ranges or sets.
#For example if X is an m × n matrix, X[:] is a vector of size mn that consists of
#the columns of X stacked on top of each other.
#The Julia function reshape(X,(k,l)) gives a new k × l matrix,
#with the entries taken in the column-major order from X.
#(We must have mn = kl, i.e., the original and reshaped matrix must have the
#same number of entries.) Neither of these is standard mathematical notation,
#but they can be useful in Julia.
B = [ 1 -3 ; 2 0 ; 1 -2]
B[:]
reshape(B,(2,3))
reshape(B,(3,3))
#Block matrices. Block matrices are constructed in Julia = standard mathematical notation in VMLS.
#You use ; to stack matrices, and a space to do (horizontal) concatenation.
#We apply this to the example on page 109 of VMLS.
B=[0 2 3]; #1x3matrix
C=[-1]; #1x1matrix
D = [ 2 2 1 ; 1 3 5]; # 2x3 matrix
E=[4;4]; #2x1matrix
# construct 3x4 block matrix
A = [B C ;D E]
#Column and row interpretation of a matrix.
#An m × n matrix A can be inter- preted as a collection of n m-vectors (its columns)
#or a collection of m row vectors (its rows).
#An array (or a tuple) of column vectors can be converted into a matrix using
#the horizontal concatenation function hcat.
a = [ [1., 2.], [4., 5.], [7., 8.] ] # array of 2-vectors
A = hcat(a...)
a = [ [1. 2.], [4. 5.], [7. 8.] ] # array of 1x2 matrices
A = vcat(a...)
#The ... operator in hcat(a...) splits the array a into its elements, i.e., hcat(a...)
#is the same as hcat(a[1], a[2], a[3]), which concatenates a[1], a[2], a[3] horizontally.
#Similarly, vcat concatenates an array of arrays vertically. This is useful when constructing a matrix from its row vectors.
a = [ [1. 2.], [4. 5.], [7. 8.] ] # array of 1x2 matrices
A = vcat(a...)

#zero and identities matrices
#Zero matrices. A zero matrix of size m × n is created using zeros(m,n).
zeros(2,2)
#The LinearAlgebra package also contains functions for creating a
#special identity matrix object I, which has some nice features.
#You can use 1.0*Matrix(I,n,n) to create an n × n identity matrix.
#(Multiplying by 1.0 converts the matrix into one with numerical entries;
# otherwise it has Boolean entries.)
#This expression is pretty unwieldy, so we can define a function eye(n)
using LinearAlgebra
eye(n) = 1.0*Matrix(I,n,n)
eye(4)
#Julia’s identity matrix I has some useful properties.
#For example, when it can deduce its dimensions, you don’t have to specify it
 A = [ 1 -1 2; 0 3 -1]
 [A I]
 [A ; I]
 B = [ 1 2 ; 3 4 ]
 B + I

#Ones matrix. In VMLS we do not have notation for a matrix with all entries one.
#In Julia, such a matrix is given by ones(m,n).
#Diagonal matrices. In standard mathematical notation, diag(1, 2, 3)
#is a diagonal 3 × 3 matrix with diagonal entries 1, 2, 3.
#In Julia such a matrix is created using the function diagm,
#provided in the LinearAlgebra package. To construct the diagonal matrix with diagonal
#entries in the vector s, you use diagm(0 => s). This is fairly unwieldy,
#so the VMLS package defines a function diagonal(s).
#(Note that you have to pass the diagonal entries as a vector.)
 diagonal(x) = diagm(0 => x)
diagonal([1,2,3])
#A closely related Julia function diag(X) does the opposite: It takes the diagonal entries of the
#(possibly not square) matrix X and puts them into a vector.
H = [0 1 -2 1; 2 -1 3 0]
diag(H)
#Random matrices. A random m×n matrix with entries between 0 and 1 is created using rand(m,n).
#For entries that have a normal distribution, randn(m,n).
rand(2,3)
randn(3,2)
#Sparse matrices. Functions for creating and manipulating sparse matrices are contained in the SparseArrays package,
#The sparse function creates a sparse matrix from three arrays that specify the row indexes,
#column indexes, and values of the nonzero elements.
using Pkg
Pkg.add("SparseArrays")
using SparseArrays
rowind = [ 1, 2, 2, 1, 3, 4 ];  # row indexes of nonzeros
colind = [ 1, 1, 2, 3, 3, 4 ];  # column indexes
values = [-1.11, 0.15, -0.10, 1.17, -0.30, 0.13 ]; # values
A = sparse(rowind, colind, values, 4, 5)
nnz(A)
#Sparse matrices can be converted to regular non-sparse matrices using the Array function.
#Applying sparse to a full matrix gives the equivalent sparse matrix.
A = sparse([1, 3, 2, 1], [1, 1, 2, 3],
   		[1.0, 2.0, 3.0, 4.0], 3, 3)
B = Array(A)
B[1,3] = 0.0;
sparse(B)
#A useful function for creating a random sparse matrix is sprand(m,n,d)
#(with entries between 0 and 1) and sprandn(m,n,d)
# The following code creates a random 10000 × 10000 sparse matrix, with a density 10−7.
# This means that we’d expect there to be around 10 nonzero entries.
#(So this is a very sparse matrix!)
A = sprand(10000,10000,10^-7)
