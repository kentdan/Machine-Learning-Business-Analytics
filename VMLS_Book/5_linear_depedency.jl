#Linear dependence
# Basis
# Cash flow replication. Let’s consider cash flows over 3 periods,
# given by 3-vectors. We know from VMLS page 93 that the vectors
#form a basis, where r is the (positive) per-period interest rate.
#The first vector e1 is a single payment of $1 in period (time) t = 1.
#The second vector l1 is loan of $1 in period t = 1, paid back in period t = 2 with interest r.
#The third vector l2 is loan of $1 in period t = 2, paid back in period t = 3 with interest r.
#Let’s use this basis to replicate the cash flow c = (1, 2, −3) as
#From the third component we have c3 = α3(−(1 + r)), so α3 = −c3/(1 + r).
#From the second component we have c2 =α2(−(1+r))+α3 =α2(−(1+r))−c3/(1+r),
#which is the net present value (NPV) of the cash flow c.
#from the second component we have
#c2 =α2(−(1+r))+α3 =α2(−(1+r))−c3/(1+r),
#so α2 = −c2/(1 + r) − c3/(1 + r)2. Finally from c1 = α1 + α2, we have
#α1 =c1 +c2/(1+r)+c3/(1+r)2,
#Let’s check this in Julia using an interest rate of 5% per period, and the specific
#cash flow c = (1, 2, −3).
using Statistics
using LinearAlgebra
r = 0.05;
e1 = [1,0,0]; l1 = [1,-(1+r),0]; l2 = [0,1,-(1+r)];
c = [1,2,-3];
# Coefficients of expansion
alpha3 = -c[3]/(1+r);
alpha2 = -c[2]/(1+r) -c[3]/(1+r)^2;
alpha1 = c[1] + c[2]/(1+r) + c[3]/(1+r)^2  # NPV of cash flow
alpha1*e1 + alpha2*l1 + alpha3*l2

#Orthonormal vectors
#form an orthonormal basis, and check the expansion of x = (1, 2, 3) in this basis,
#x = ( a T1 x ) a 1 + · · · + ( a Tn x ) a n .
a1 = [0,0,-1]; a2 = [1,1,0]/sqrt(2); a3 = [1,-1,0]/sqrt(2);
norm(a1), norm(a2), norm(a3)
a1'*a2, a1'*a3, a2'*a3
x = [1,2,3]
# Get coefficients of x in orthonormal basis
beta1 = a1'*x; beta2 = a2'*x; beta3 = a3'*x;
# Expansion of x in basis
xexp = beta1*a1 + beta2*a2 + beta3*a3
#Gram–Schmidt algorithm
#The following is a Julia implementation of Algorithm 5.1 in VMLS (Gram–Schmidt algorithm).
# It takes as input an array [ a[1], a[2], ..., a[k] ],
# containing the k vectors a1, . . . , ak. If the vectors are linearly independent,
# it returns an array [ q[1], ..., q[k] ] with the orthonormal set of vectors
#computed by Gram– Schmidt algorithm.
function gram_schmidt(a; tol = 1e-10)
	q=[]
	for i = 1:length(a)
		qtilde = a[i]
		for j = 1:i-1
			qtilde -= (q[j]'*a[i]) * q[j]
		end
	    if norm(qtilde) < tol
	       println("Vectors are linearly dependent.")
	       return q
		end
	    push!(q, qtilde/norm(qtilde))
	end;
	return q
end
#We apply the function to the example on page 100 of VMLS.
a = [ [-1, 1, -1, 1], [-1, 3, -1, 3], [1, 3, 5, 7] ]
q = gram_schmidt(a)
# test orthnormality
norm(q[1])
q[1]'*q[2]
q[1]'*q[3]
norm(q[2])
q[2]'*q[3]
norm(q[3])
# Example of early termination.
#If we replace a3 with a linear combination of a1 and a2 the set becomes linearly dependent.
b = [ a[1], a[2], 1.3*a[1] + 0.5*a[2] ]
q = gram_schmidt(b)
#Example of independence-dimension inequality.
#We know that any three 2- vectors must be dependent.
#Let’s use the Gram-Schmidt algorithm to verify this for three specific vectors.
three_two_vectors = [ [1,1], [1,2], [-1,1] ]
q = gram_schmidt(three_two_vectors)
