using Pkg
Pkg.add("https://github.com/VMLS-book/VMLS.jl")
x = [ -1.1, 0.0, 3.6, -7.2 ]
length(x)
y = [ -1.1; 0.0; 3.6; -7.2 ]
length(y)
#The Vector{Float64} displayed by Julia above each array tells us that the array is one-dimensional
#its entries are floating point numbers that use 64 bits.
a = [ 1 2 ]
b = ( 1, 2 )
# b is a tuple or list consisting of two scalars.

#Indexing
x = [ -1.1, 0.0, 3.6, -7.2 ];
x[3]
x[3] = 4.0;
x
x = [ -1.1, 0.0, 3.6, -7.2 ];
y = x;
x[3] = 4.0;
 y
  # The assignment to y[1] also changed x[1]
 x = [ -1.1, 0.0, 3.6, -7.2 ];
 y = copy(x);
 x[3] = 4.0;
 y
  y[1] = 2.0;
  x
#Vector equality.
#Equality of vectors is checked using the relational operator ==.
#For two vectors (arrays) a and b__
 x = [ -1.1, 0.0, 3.6, -7.2 ];
 y = copy(x);
 y[3] = 4.0
 y == x
 z = x
 z[3] = 4.0
 z == x
 #Scalars versus 1-vectors. In the mathematical notation used in VMLS we con- sider a
 #1-vector to be the same as a number. But in Julia, 1-vectors are not the same as scalars (numbers).
 #Julia distinguishes between the 1-vector (array) [ 1.3 ] and the number 1.3.
  x = [ 1.3 ]
  y = 1.3
  x == y
  x[1] == y
#Block or stacked vectors. To construct a block vector in Julia, you can use vcat
#(vertical concatenate) or the semicolon (;) operator.
x=[1,-2]; y=[1,1,0];
z = [ x; y ] #concanate using semicolon
#Some common mistakes. There are a few Julia operations that look similar
#but do not construct a block or stacked vector.
#For example, z = (x,y) creates a list or tuple of the two vectors;
#z = [x,y] creates an array of the two vectors. Both of these are valid Julia expression,
#but neither of them is the stacked vector [x;y].

#Subvectors and slicing.
#As in the mathematical notation used in VMLS, the Julia expression r:s denotes the
#index range r, r + 1, . . . , s. (It is assumed here that r and s are positive integers with
#r the smaller of the two.) In VMLS, we use xr:s to denote the slice of the vector x
#from index r to s. In Julia you can extract a subvector or slice of a vector using an index
# range as the argument. You can also use index ranges to assign a slice of a vector.
x = [ 9, 4, 3, 0, 5 ];
y = x[2:4]
x[4:5] = [ -2, -3 ];  # Re-assign the 4 and 5 entries of x
x
#Julia indexing into arrays.
#Vector of first differences. Let’s use slicing to create the (n − 1)-vector d defined
#by di = xi+1 −xi, for i = 1,...,n−1, where x is an n-vector.
#The vector d is called the vector of (first) differences of x.
x = [ 1, 0, 0, -2, 2 ];
d = x[2:end] - x[1:end-1]
#Lists of vectors. An ordered list of n-vectors might be denoted in VMLS
#as a1,...,ak or a(1),...,a(k), or just as a,b,c.
#If we give the elements of the list, separated by commas,and surrounded by square brackets,
# we form a one-dimensional array of vectors. If instead we use parentheses as delimiters,
#we obtain a tuple or list.
x = [ 1.0, 0 ];   y = [ 1.0, -1.0 ];   z = [ 0, 1.0];
list = [ x, y, z ]
list[2]  # Second element of list
list = ( x, y, z )
list[3]  # Third element of list
#Zero vectors. In Julia a zero vector of dimension n is created using zeros(n).
zeros(3)
#Unit vectors. There is no built-in Julia function for creating ei,
#the ith unit vector of length n. The following code creates ei, with i = 2 and n = 4.
i = 2; n = 4;
ei = zeros(n);   # Create a zero vector
ei[i] = 1;   # Set ith entry to 1
ei
# create ei using concatenation, using a Julia inline function.
 unit_vector(i,n) = [zeros(i-1); 1 ; zeros(n-i)]
unit_vector(2,4)
#Ones vector. In Julia the ones vector of dimension n,
#denoted 1n or just 1 in VMLS, is created using ones(n).
ones(2)
#Random vectors. We do not use or refer to random vectors in VMLS,
#which does not assume a background in probability.
rand(2)
rand(2)
randn(2)
#Plotting.
using Plots  # Only need to do this once per session
temps = [71, 71, 68, 69, 68, 69, 68, 74, 77, 82, 85, 86,
 88, 86, 85, 86, 84, 79, 77, 75, 73, 71, 70, 70, 69, 69, 69,
 69, 67, 68, 68, 73, 76, 77, 82, 84, 84, 81, 80, 78, 79, 78,
 73, 72, 70, 70, 68, 67];
plot(temps, marker = :circle, legend = false, grid = false)
savefig("temperature.pdf")
