# %% codecell
#packages
using Plots
using Random
using Statistics
using LinearAlgebra
using Distances
# %% codecell
#Q1
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
# %% codecell
Random.seed!(80)
X = vcat( [ [0, -0.2] + 0.1*randn(2) for i = 1:30 ],
		[ [0.5, 0.5] + 0.1*randn(2) for i = 1:30 ],
		[ [0.5, -0.5] + 0.1*randn(2) for i = 1:20 ],
		[ [0, 0.4] + 0.06* randn(2) for i = 1:20])
scatter([x[1] for x in X], [x[2] for x in X])
plot!(legend = false, grid = false, size = (500,500),
       xlims = (-0.25,0.75), ylims = (-0.7,0.7))
# %% codecell
#The three arrays are concatenated using vcat to get an array of 300 points.
#Next, we apply our kmeans function and make a figure with the three clusters
using LinearAlgebra
assignment, reps = kmeans(X, 4)
k = 4
N = length(X)
grps  = [[X[i] for i=1:N if assignment[i] == j] for j=1:k]
#chelsea longitude(X) = 0 , Latitude(Y) =0.2
c1 = [ [0, 0.2]]
chelx = [x[1] for x in c1];
chely = [x[2] for x in c1];
# %% codecell
scatter([c[1] for c in grps[1]], [c[2] for c in grps[1]], markercolor = :green,label ="cust_clus_1")
scatter!([c[1] for c in grps[2]], [c[2] for c in grps[2]], markercolor = :blue,label ="cust_clus_2")
scatter!([c[1] for c in grps[3]], [c[2] for c in grps[3]], markercolor = :orange,label ="cust_clus_3")
scatter!([c[1] for c in grps[4]], [c[2] for c in grps[4]], markercolor = :Purple,label ="cust_clus_4")
scatter!(chelx ,chely, markercolor = :Red,markershape = :star4,label ="Chelsea")
plot!(legend = false, grid = true, size = (500,500),
       xlims = (-0.25,0.75), ylims = (-0.75,0.75))
# %% codecell
#q2
x = X
reps = [[0, 0.2] ] #chelsea location
assignment = [1 for x in X] #how many of l2-norm each point to chelsea
# %% codecell
#l1
Jclustl1(x,reps,assignment) =
   [cityblock(x[i],reps[assignment[i]]) for i=1:length(x)]
# %% codecell
#l2
Jclustl2(x,reps,assignment) =
   [euclidean(x[i],reps[assignment[i]]) for i=1:length(x)]
# %% codecell
#distance l1 l2
dist_chel_l2 = Jclustl2(x,reps,assignment)
dist_chel_l1 = Jclustl1(x,reps,assignment)
# %% codecell
#q2a distance all
mean(dist_chel_l2)
mean(dist_chel_l1)
# %% codecell
#q2b smallest distances
smallest_distance_l2 = findmin(dist_chel_l2)
smallest_distance_l1 = findmin(dist_chel_l1)
smallest_distance_l1_argmin = argmin(dist_chel_l1)
smallest_distance_l2_argmin = argmin(dist_chel_l2)
#findmin(A,index)
#check small distance
smallest_distance_l2_check = euclidean([0, 0.2],X[83])
smallest_distance_l1_check = cityblock([0, 0.2],X[94])
smallest_distance_l1_argmin == smallest_distance_l2_argmin
# %% codecell
#q2c is largest distances l1 == largest distance l2?
farthest_distance_l2 = findmax(dist_chel_l2)
farthest_distance_l1 = findmax(dist_chel_l1)
farthest_distance_l1_argmax = argmax(dist_chel_l1)
farthest_distance_l2_argmax = argmax(dist_chel_l2)
#Largest distances
farthest_distance_l2_77 = euclidean([0, 0.2],X[farthest_distance_l1_argmax])
farthest_distance_l1_77 = cityblock([0, 0.2],X[farthest_distance_l2_argmax])
# %% codecell
# q2d Are the 5 closest customers to Chelsea's restaurant calculated using 1-norm and
# 2-norm the same?
function small_value(x,r)
	#x = dist_chel
	for i=1:r
		b = findmin(x)
		a = deleteat!(x,argmin(x))

		println(b)
	end
end
l1_5_smallest = small_value(dist_chel_l1,5)
l2_5_smallest = small_value(dist_chel_l2,5)
#q3
Random.seed!(8)
y = randn(100)
Random.seed!(8)
quality = y * 0.5 + rand(100) * 0.1
Random.seed!(10)
nutrition = y * 0.1 + rand(100) * 0.2
price = quality * 1 + nutrition * 0.1 + rand(100) * 2

# Plot the predicted price on the y-axis and the true price on the x-axis.
# Which data point is the farthest (in terms of 2-norm) to its prediction?
#price! = 𝛽quantity× 𝑞𝑢𝑎𝑙𝑖𝑡𝑦i + 𝛽𝑛𝑢𝑡𝑟𝑖𝑡𝑖𝑜𝑛i + 𝜐
#The parameters are 𝛽quantity'( = 0.5, 𝛽𝑛𝑢𝑡𝑟𝑖𝑡𝑖𝑜𝑛 = 7.1, and 𝜐 = 0.1. )
bq = 0.5
bn = 7.1
v = 0.1
pred_price = (bq * quality) + (bn * nutrition) .+ v
length(v)
length((bq * quality))
length((bn * nutrition))
scatter(price,pred_price,label ="price")

Jclustl2(x,reps) =
   [euclidean(x[i],reps[i]) for i=1:length(x)]
x= price
reps = pred_price
dist_price_l2 = Jclustl2(x,reps)
farthest_distance = findmax(dist_price_l2)
afkhjsl = argmax(dist_price_l2)
farthest_distance_l2_check = euclidean(price[afkhjsl],pred_price[afkhjsl])
#q4
#What is best location to open these three restaurants for Chelsea's franchisee,
#i.e., where are the three clustering centres?
function kmeans1(x, k; maxiters = 100, tol = 1e-5)
	N = length(x) #number point of cluster
	n = length(x[1]) # the dimention
	distances = zeros(N)  # used to store the distance of each
	reps1 = [zeros(n) for j=1:k]  # used to store representatives.
	# 'assignment1' is an array of N integers between 1 and k.
	assignment1 = [ rand(1:k) for i in 1:N ] # The initial assignment1 is chosen randomly.
	Jprevious = Inf  # used in stopping condition
	for iter = 1:maxiters
    	# Cluster j representative is average of points in cluster j.
		for j = 1:k
        group = [i for i=1:N if assignment1[i] == j]
        reps1[j] = sum(x[group]) / length(group);
    end;
    # For each x[i], find distance to the nearest representative
	# and its group index.
	for i=1:N
	(distances[i], assignment1[i]) =
	findmin([cityblock(x[i],reps1[j]) for j = 1:k]) #change to l1
	end;
	# Compute clustering objective.
	J = norm(distances)^2/ N
	# Show progress and terminate if J stopped decreasing.
	println("Iteration ", iter, ": Jclust = ", J, ".")
	if iter>1&&abs(J-Jprevious)<tol*J
	return assignment1, reps1
	end
	Jprevious = J
	end
end
# %% codecell
Random.seed!(80)
X = vcat( [ [0, -0.2] + 0.1*randn(2) for i = 1:30 ],
		[ [0.5, 0.5] + 0.1*randn(2) for i = 1:30 ],
		[ [0.5, -0.5] + 0.1*randn(2) for i = 1:20 ],
		[ [0, 0.4] + 0.06* randn(2) for i = 1:20])
assignment1, reps1 = kmeans1(X, 4)
k = 3
N = length(X)
grps1  = [[X[i] for i=1:N if assignment1[i] == j] for j=1:k]
center1x = [mean([c[1] for c in grps1[1]])]
center1y = [mean([c[2] for c in grps1[1]])]
center2x = [mean([c[1] for c in grps1[2]])]
center2y = [mean([c[2] for c in grps1[2]])]
center3x = [mean([c[1] for c in grps1[3]])]
center3y = [mean([c[2] for c in grps1[3]])]
center1 = [center1x,center1y]
center2 = [center2x,center2y]
center3 = [center3x,center3y]
scatter([c[1] for c in grps[1]], [c[2] for c in grps1[1]], markercolor = :green,label ="cust_clus_1")
scatter!([c[1] for c in grps[2]], [c[2] for c in grps1[2]], markercolor = :blue,label ="cust_clus_2")
scatter!([c[1] for c in grps[3]], [c[2] for c in grps1[3]], markercolor = :orange,label ="cust_clus_3")
scatter!(center1x,center1y, markercolor = :blue,markershape = :star4, label ="center1")
scatter!(center2x,center2y, markercolor = :yellow,markershape = :star4, label ="center2")
scatter!(center3x,center3y, markercolor = :Purple,markershape = :star4, label ="center3")

#q4
#Use 1-norm to measure distance in the 𝑘 -means algorithm.
#And plot the customers on the map. Are they the same as (b)

assignment1, reps1 = Clustering.kmeans(X, 3)
k = 3
N = length(X))
grpsL1  = [[X[i] for i=1:N if assignment[i] == j] for j=1:k]

#(Ida the mathematician) Write a function Gram_Schmidt that takes the input of an array containing vectors.
#The function returns the orthonormal set of vectors when the input array contains vectors
#that are all linearly independent;
#otherwise, return “Vectors are linearly dependent.”.
