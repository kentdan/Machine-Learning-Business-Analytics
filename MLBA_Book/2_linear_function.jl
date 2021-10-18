#Functions in Julia. Julia provides several methods for defining functions.
#A simple function given by an expression such as f(x) = x1 + x2 − x24
#can be defined in a single line.
f(x) = x[1] + x[2] - x[4]^2
f([-1,0,1,2])
#Superposition. Suppose a is an n-vector. The function f(x) = aTx is linear,
#which means that for any n-vectors x and y, and any scalars α and β, the super-position equality
#f(αx + βy) = αf(x) + βf(y)
#Superposition says that evaluating f at a linear combination of two vectors is the same
#as forming the linear combination of f evaluated at the two vectors.
#Let’s define the inner product function f for a specific value of a,
#and then verify superposition in Julia for specific values of x, y, α, and β.
#(This check does not show that the function is linear.
#It simply checks that superposition holds for these specific values.)
a = [-2, 0, 1, -3];
f(x) = a'*x # Inner product function
x=[2,2,-1,1]; y=[0,1,-1,0];
alpha = 1.5; beta = -3.7;
lhs = f(alpha * x + beta * y)
rhs = alpha * f(x) + beta * f(y)
#For the function f(x) = aT x, we have f(e3) = a3. Let’s check that this holds in our example.
e3 = [0, 0, 1, 0];
f(e3)
# Let’s define the average function in Julia, and check its value for a specific vector.
# (Julia’s Statistics package contains the average function, which is called mean.)
avg(x) = (ones(length(x)) / length(x))'*x;
x = [1, -3, 2, -1];
avg(x)
using Statistics
mean(x)

#Taylor approximation
#Taylor approximation. The (first-order) Taylor approximation of a function f :
#Rn → R, at the point z, is the affine function of x given by
#f(x)=f(z)+∇f(z) (x−z).
# For x near z, f(x) is very close to f(x). Let’s try a numerical example (see page 36)
f(x) = x[1] + exp(x[2]-x[1]);   # A function
# And its gradient
grad_f(z) = [1-exp(z[2]-z[1]), exp(z[2]-z[1])];
z = [1, 2];
 # Taylor approximation at z
f_hat(x) = f(z) + grad_f(z)'*(x-z);
# Let's compare f and f_hat for some specific x's
f([1,2]),  f_hat([1,2])
f([0.96,1.98]),  f_hat([0.96,1.98])
f([1.10,2.11]),  f_hat([1.10,2.11])

# Regression model
#Regression model. The regression model is the affine function of x given by f (x) = xT β + v,
#where the n-vector β and the scalar v are the parameters in the model.
#The regression model is used to guess or approximate a real or ob- served value of the number y that is associated with x.
#Let’s define the regression model for house sale prices described on page 39 of VMLS,
# and compare its prediction to the true house sale price y for a few values of x.
# Parameters in regression model
beta = [148.73, -18.85]; v = 54.40;
y_hat(x) = x'*beta + v;
# Evaluate regression model prediction
x = [0.846, 1];  y = 115;
y_hat(x), y
x = [1.324,2];  y = 234.50;
y_hat(x), y
#We use the VMLS function house_sales_data to obtain the vectors price, area, beds (see appendix A).
export house_sales_data
include("/Users/danielkent/Desktop/MLBA/MLBA_Book/src/house_sales_data.jl")
D = house_sales_data();
price = D["price"]
area = D["area"]
beds = D["beds"]
v = 54.4017;
beta = [ 148.7251, -18.8534 ];
predicted = v .+ beta[1] * area + beta[2] * beds;
using Plots
scatter(price, predicted, lims = (0,800))
plot!([0, 800], [0, 800], linestyle = :dash)
# make axes equal and add labels
plot!(xlims = (0,800), ylims = (0,800), size = (500,500))
plot!(xlabel = "Actual price", ylabel = "Predicted price")
