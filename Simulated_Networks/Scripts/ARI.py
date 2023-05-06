import numpy as np
import sys
from sklearn.metrics.cluster import adjusted_rand_score

cells = [10,25,50,100]
x = [10,20,30,40,50,60,70,80,90,100]
nums = [1,2,3,4,5]
mux = 0.5
folder = sys.argv[1]

for num in nums:
	for cell in cells:
		print()
		print("{} {}".format(str(cell), str(num)))
		true_cluster_file = np.loadtxt("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Data\
/t1_2_t2_1_muw_{}/k_{}/community_{}_no_weight.dat".format(str(mux), str(cell), str(num)), dtype="int")
		true_cluster = true_cluster_file[:,1]

		for k in x:
			actual_cluster_file = np.loadtxt("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Results/node_feature_\
kmeans/{}/t1_2_t2_1_muw_{}/k_{}/network_{}_{}_cluster_kmeans.txt".format(folder, str(mux), str(cell), str(num), str(k)), dtype="int", delimiter=',')
			#actual_cluster_file = np.loadtxt("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Results//spect_kmeans\
#/t1_2_t2_1_muw_{}/k_{}/network_{}_{}_cluster_spect_kmeans.txt".format(str(mux), str(cell), str(num), str(k)), dtype="int", delimiter=',')

			#print(true_cluster)
			#print(actual_cluster_file)
			print(format(adjusted_rand_score(true_cluster, actual_cluster_file), ".6f"))
			
