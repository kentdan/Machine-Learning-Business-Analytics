# %% codecell
#customer latitude
using Plots
Random.seed!(8)
X = vcat( [ [0, -0.2] + 0.1*randn(2) for i = 1:30 ],
	[ [0.5, 0.5] + 0.1*randn(2) for i = 1:30 ],
	[ [0.5, -0.5] + 0.1*randn(2) for i = 1:20 ],
	[ [0, 0.4] + 0.06* randn(2) for i = 1:20])
scatter([x[1] for x in X], [x[2] for x in X])
function kmeans(x, k; maxiters = 100, tol = 1e-5)
N = length(x)
n = length(x[1])
distances = zeros(N)  # used to store the distance of each
                      # point to the nearest representative.
reps = [zeros(n) for j=1:k]  # used to store representatives.
# 'assignment' is an array of N integers between 1 and k.
# The initial assignment is chosen randomly.
assignment = [ rand(1:k) for i in 1:N ]
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
		(distances[i], assignment[i])
		findmin([norm(x[i] - reps[j]) for j = 1:k])
end;
# Compute clustering objective.
J = norm(distances)^2 / N
	# Show progress and terminate if J stopped decreasing.
	println("Iteration ", iter, ": Jclust = ", J, ".")
	ifiter>1&&abs(J-Jprevious)<tol*J
	return assignment, reps
	end
	Jprevious = J
end

end


reps = kmeans(X, 4)
plot!(legend = false, grid = false, size = (500,500),
       xlims = (-1.5,2.5), ylims = (-2,2))
#Chelsea's restaurant locates at
#(latitude, longitude) = (0.2, 0).
#Plot the location of these customers as well as
#Chelsea's restaurant, mark them with different color.
