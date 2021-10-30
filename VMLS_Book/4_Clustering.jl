#Clustering
#we can store the list of vectors in a Julia list or tuple of N vectors.
#If we call this list x, we can access the ith entry (which is a vector) using x[i].
#To specify the clusters or group membership, we can use a list of assignments called assignment,
#where assignment[i] is the number of the group that vector x[i] is assigned to.
#(This is an integer between 1 and k.)
#(In VMLS chapter 4, we describe the assignments using a vector c or the subsets Gj.)
# We can store the k cluster representatives as a Julia list called reps,
# with reps[j] the jth cluster representative.
#(In VMLS we describe the representatives as the vectors z1, . . . , zk.)

using Statistics
using Plots
using Random
Jclust(x,reps,assignment) =
   mean( [norm(x[i]-reps[assignment[i]])^2 for i=1:length(x)] )
x = [ [0,1], [1,0], [-1,1] ]
reps = [ [1,1], [0,0] ] #center of each cluster
assignment = [1,2,1] #which of the point it going to be assign
Jclust(x,reps,assignment)
group_number = [rand(1:3) for i = 1:5 ]
group1 = [i for i=1:5 if group_number[i] == 1];
println("index of group1 :", group1 )
group2 = [i for i=1:5 if group_number[i] == 2];
println("index of group1 :", group2 )
group3 = [i for i=1:5 if group_number[i] == 3];
println("index of group1 :", group3 )
#The k-means algorithm
#We write a simple Julia implementation of the k-means algorithm and
#apply it to a set of points in a plane, similar to the example in Figure 4.1 of VMLS.
#We first create a function kmeans that can be called as
#assignment, representatives = kmeans(x, k)
#where x is an array of N vectors and k is the number of groups.
#The first output argument is an array of N integers, containing the computed group assignments
#(integers from 1 to k). The second output argument is an array of k vectors, with the k group
#representatives. We also include two optional keyword arguments, with a limit on the number of
#iterations and a tolerance used in the stopping condition.
function kmeansfunction(x, k; maxiters = 100, tol = 1e-5)
	N = length(x) #number point of cluster
	n = length(x[1]) # the dimention
	distances = zeros(N)  # used to store the distance of each
	reps = [zeros(n) for j=1:k]  # used to store representatives.
	# 'assignment' is an array of N integers between 1 and k.
	assignment = [ rand(1:k) for i in 1:N ] # The initial assignment is chosen randomly.
	Jprevious = Inf  # used in stopping condition
	for iter = 1:maxiters
    	# Cluster j representative is average of points in cluster j.
		for j = 1:k
        group = [i for i=1:N if assignment[i] == j]
        reps[j] = sum(x[group]) / length(group);
    end;
    # For each x[i], find distance to the nearest representative
	# and its group index.
	for i=1:N
	(distances[i], assignment[i]) =
	findmin([norm(x[i] - reps[j]) for j = 1:k])
	end;
	# Compute clustering objective.
	J = norm(distances)^2 / N
	# Show progress and terminate if J stopped decreasing.
	println("Iteration ", iter, ": Jclust = ", J, ".")
	if iter>1&&abs(J-Jprevious)<tol*J
	return assignment, reps
	end
	Jprevious = J
	end
end

function kmeans(x, k; maxiters = 100, tol = 1e-5)
	N = length(x) #number point of cluster
	n = length(x[1]) # the dimention
	distances = zeros(N)  # used to store the distance of each
	reps = [zeros(n) for j=1:k]  # used to store representatives.
	# 'assignment' is an array of N integers between 1 and k.
	assignment = [ rand(1:k) for i in 1:N ] # The initial assignment is chosen randomly.
	Jprevious = Inf  # used in stopping condition
	for iter = 1:maxiters
    	# Cluster j representative is average of points in cluster j.
		for j = 1:k
        group = [i for i=1:N if assignment[i] == j]
        reps[j] = sum(x[group]) / length(group);
    end;
    # For each x[i], find distance to the nearest representative
	# and its group index.
	for i=1:N
	(distances[i], assignment[i]) =
	findmin([norm(x[i] - reps[j]) for j = 1:k])
	end;
	# Compute clustering objective.
	J = norm(distances)^2 / N
	# Show progress and terminate if J stopped decreasing.
	println("Iteration ", iter, ": Jclust = ", J, ".")
	if iter>1&&abs(J-Jprevious)<tol*J
	return assignment, reps
	end
	Jprevious = J
	end
end
#Initialization.
#The Julia function rand(1:k) picks a random number from the set 1:k, i.e.,
#the integers 1,...,k. On line 11 we create an array assignment of N elements,
#with each element chosen by calling rand(1:k).

#Updating group representatives.
#Lines 17–20 update the k group representa- tives. In line 18, we find the indexes of the points
# in cluster j and collect them in an array group.
# The expression x[group] on line 19 constructs an array from the subset of elements of
#x indexed by group. The function sum computes the sum of the elements of the array x[group].
#Updating group assignments.
#Dividing by the number of elements length(x[group]) gives the average of the vectors in the group.
#The result is jth the group representative.
#This vector is stored as the jth element in an array reps of length N.

#Clustering objective.
#On lines 24–27 we update the group assignments.
#The Julia function findmin computes both the minimum of a sequence of numbers and
#the position of the minimum in the sequence.

#Convergence. We terminate the algorithm when the improvement in the
#clustering objective becomes very small (lines 34–36).
#We apply the algorithm on a randomly generated set of N = 300 points,
#shown in Figure 4.1. These points were generated as follows.
X = vcat( [ 0.3*randn(2) for i = 1:100 ],
          [ [1,1] + 0.3*randn(2) for i = 1:100 ],
          [ [1,-1] + 0.3*randn(2) for i = 1:100 ] )
scatter([x[1] for x in X], [x[2] for x in X])
plot!(legend = false, grid = false, size = (500,500),
       xlims = (-1.5,2.5), ylims = (-2,2))
#The three arrays are concatenated using vcat to get an array of 300 points.
#Next, we apply our kmeans function and make a figure with the three clusters
using LinearAlgebra
assignment, reps = kmeans(X, 3)

k = 3
N = length(X)

grps  = [[X[i] for i=1:N if assignment[i] == j] for j=1:k]
scatter([c[1] for c in grps[1]], [c[2] for c in grps[1]])
scatter!([c[1] for c in grps[2]], [c[2] for c in grps[2]])
scatter!([c[1] for c in grps[3]], [c[2] for c in grps[3]])
plot!(legend = false, grid = false, size = (500,500),
       xlims = (-1.5,2.5), ylims = (-2,2))

#Image clustering
#Document topic discovery
#We apply the kmeans function to the document topic discovery example in Section 4.4.2 of VMLS.
# The word histograms, dictionary, and document titles are available via the VMLS function
#wikipedia_data. The resulting clustering depends on the (randomly chosen) initial partition
#selected by kmeans.
include("/Users/danielkent/Desktop/MLBA/MLBA_Book/src/wikipedia_data.jl")
articles, dictionary, titles = wikipedia_data();
N = length(articles);
k = 9;
assignment, reps = kmeans(articles, k);
d = [ norm(articles[i] - reps[assignment[i]]) for i = 1:N ];
for j = 1:k
           group = [ i for i=1:N if assignment[i] == j ]
           println()
           println("Cluster ", j, " (", length(group), " articles)")
           I = sortperm(reps[j], rev=true)
           println("Top words: \n    ", dictionary[I[1:5]]);
           println("Documents closest to representative: ")
           I = sortperm(d[group])
           for i= 1:5
println("", titles[group[I[i]]])
end
end
