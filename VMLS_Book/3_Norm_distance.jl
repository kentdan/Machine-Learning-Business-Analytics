#Norm. The norm ∥x∥ is written in Julia as norm(x). (It can be evaluated several other ways too.)
#The norm function is contained in the Julia package LinearAlgebra,
#so you must install and then add this package to use it; see page ix.
using LinearAlgebra
using Statistics
x = [ 2, -1, 2 ];
norm(x)
sqrt(x'*x)
sqrt(sum(x.^2))
#Triangle inequality. Let’s check the triangle inequality,
#∥x + y∥ ≤ ∥x∥ + ∥y∥, for some specific values of x and y.
x = randn(10); y = randn(10);
lhs = norm(x+y)
rhs = norm(x) + norm(y)
#RMS value. The RMS value of a vector x is rms(x) = ∥x∥/√n.
#In Julia, this is expressed as norm(x)/sqrt(length(x)).
#(The VMLS package contains this function, so you can use it once you’ve installed this package.)
rms(x) = norm(x) / sqrt(length(x));
t = 0:0.01:1;  # List of times
x = cos.(8*t) - 2*sin.(11*t);
mean(x)
rms(x)
using Plots
plot(t, x)
plot!(t, mean(x)*ones(length(x)))
plot!(t, (mean(x)+rms(x))*ones(length(x)), color = :green)
plot!(t, (mean(x)-rms(x))*ones(length(x)), color = :green)
plot!(legend = false)
#Chebyshev inequality. The Chebyshev inequality states that the number of entries of an
#n-vector x that have absolute value at least a is no more than ∥x∥2/a2 = nrms(x)2/a2.
#If this number is, say, 12.15, we can conclude that no more that 12 entries have absolute value
#at least a, since the number of entries is an integer.
#So the Chebyshev bound can be improved to be floor(∥x∥2/a）
#where floor(u) is the integer part of a positive number.
#Let’s define a function with the Chebyshev bound, including the floor function improvement,
#and apply the bound to the signal found above, for a specific value of a.
# Define Chebyshev bound function
cheb_bound(x,a) = floor(norm(x)^2/a);
a = 1.5;
cheb_bound(x,a)
# Number of entries of x with |x_i| >= a
sum(abs.(x) .>= a)
#Distance. The distance between two vectors is dist(x, y) = ∥x − y∥.
#This is written in Julia as norm(x-y). Let’s find the distance between the pairs of the
#three vectors u, v, and w from page 49 of VMLS.
u = [1.8, 2.0, -3.7, 4.7];
v = [0.6, 2.1, 1.9, -1.4];
w = [2.0, 1.9, -4.0, 4.6];
norm(u-v), norm(u-w), norm(v-w)

#Nearest neighbor. We define a function that calculates the nearest neighbor of a
#vector in a list of vectors, and try it on the points in Figure 3.3 of VMLS.
nearest_neighbor(x,z) = z[ argmin([norm(x-y) for y in z]) ];
z = ( [2,1], [7,2], [5.5,4], [4,8], [1,5], [9,6] );
nearest_neighbor([5,6], z)
nearest_neighbor([3,3], z)
#the expression [norm(x-y) for y in z] uses a convenient con- struction in Julia.
#Here z is a list of vectors, and the expression expands to an array with elements norm(x-z[1]),
#norm(x-z[2]), .... The function argmin applied to this
#array returns the index of the smallest element.

#De-meaning a vector. We refer to the vector x − avg(x)1 as the de-meaned version of x.
de_mean(x) = x .- mean(x);  # Define de-mean function
x = [1, -2.2, 3];
mean(x)
x_tilde = de_mean(x)
mean(x_tilde)

#Standard deviation
#Standard deviation. We can define a function that corresponds to the
#VMLS definition of the standard deviation of a vector, std(x) = ∥x − avg(x)1∥/√n,
# where n is the length of the vector.
x = rand(100);
# VMLS definition of std
stdev(x) = norm(x .- mean(x)) / sqrt(length(x));
stdev(x)
#Return and risk. We evaluate the mean return and risk (measured by standard deviation)
#of the four time series Figure 3.4 of VMLS.
#This function is in the VMLS package, so you can use it once you’ve installed this package.
#(Julia’s Statistics package has a similar function, std(x),
#which computes the value ∥x − avg(x)1∥/√n − 1, where n is the length of x.)
a = ones(10);
mean(a), stdev(a)
b = [ 5, 1, -2, 3, 6, 3, -1, 3, 4, 1 ];
mean(b), stdev(b)
c = [ 5, 7, -2, 2, -3, 1, -1, 2, 7, 8 ];
mean(c), stdev(c)

# Standardizing a vector. If a vector x isn’t constant
#(i.e., at least two of its entries are different), we can standardize it,
#by subtracting its mean and dividing by its standard deviation.
#The resulting standardized vector has mean value zero and RMS value one.
#Its entries are called z-scores. We’ll define a standardize function,
#and then check it with a random vector.
function standardize(x)
       x_tilde = x .- mean(x)   # De-meaned vector
       return x_tilde/rms(x_tilde)
       end
x = rand(100);
mean(x), rms(x)
z = standardize(x);
mean(z), rms(z)

#Angle
#Angle. Let’s define a function that computes the angle between two vectors.
#We will call it ang because Julia already includes a function angle
#(for the phase angle of a complex number).
 # Define angle function, which returns radians
 ang(x,y) = acos(x'*y/(norm(x)*norm(y)));
 a = [1,2,-1];  b=[2,0,-3];
 ang(a,b)
 ang(a,b)*(360/(2*pi))  # Get angle in degrees
#Correlation coefficient. The correlation coefficient between two vectors a and b
#(with nonzero standard deviation) is defined as ρ= a ̃T ̃b / ∥a ̃∥∥ ̃b∥
#where a ̃ and  ̃b are the de-meaned versions of a and b, respectively.
#There is no built-in function for correlation, so we can define one.
# We use function to calculate the correlation coefficients of the
#three pairs of vectors in Figure 3.8 in VMLS.
function correl_coef(a,b)
                a_tilde = a .- mean(a)
                b_tilde = b .- mean(b)
                return (a_tilde'*b_tilde)/(norm(a_tilde)*norm(b_tilde))
                end
 a = [4.4, 9.4, 15.4, 12.4, 10.4, 1.4, -4.6, -5.6, -0.6, 7.4];
 b = [6.2, 11.2, 14.2, 14.2, 8.2, 2.2, -3.8, -4.8, -1.8, 4.2];
 correl_coef(a,b)
a = [4.1, 10.1, 15.1, 13.1, 7.1, 2.1, -2.9, -5.9, 0.1, 7.1];
b = [5.5, -0.5, -4.5, -3.5, 1.5, 7.5, 13.5, 14.5, 11.5, 4.5];
correl_coef(a,b)
a = [-5.0, 0.0, 5.0, 8.0, 13.0, 11.0, 1.0, 6.0, 4.0, 7.0];
b = [5.8, 0.8, 7.8, 9.8, 0.8, 11.8, 10.8, 5.8, -0.2, -3.2];
correl_coef(a,b)

#Complexity
x = randn(10^6); y = randn(10^6);
@time correl_coef(x,y);
@time correl_coef(x,y);
x = randn(10^7); y = randn(10^7);
@time correl_coef(x,y)
@time correl_coef(x,y)
