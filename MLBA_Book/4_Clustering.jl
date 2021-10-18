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
