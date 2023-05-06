import numpy as np
import sys
from sklearn.metrics.cluster import adjusted_mutual_info_score
import xlsxwriter

cells = [10,25,50,100]
x = [10,20,30,40,50,60,70,80,90,100]
nums = [1,2,3,4,5]
mux = 0.1
column = -1

workbook = xlsxwriter.Workbook('hello.xlsx')
workbook.add_worksheet("Sheet1")
workbook.add_worksheet("Sheet2")
workbook.add_worksheet("Sheet3")
workbook.add_worksheet("Sheet4")
workbook.add_worksheet("Sheet5")

#folders = ['spectral_clustering','node2vec_64d','node2vec_64d_p1_q2','node2vec_64d_p1_q0.5','node2vec_64d_p2_q1','node2vec_64d_p0.5_q1','node2vec_128d','node2vec_128d_p1_q2','node2vec_128d_p1_q0.5','node2vec_128d_p2_q1','node2vec_128d_p0.5_q1','node2vec_256d','node2vec_256d_p1_q2','node2vec_256d_p1_q0.5','node2vec_256d_p2_q1','node2vec_256d_p0.5_q1','DeepWalk_64d','DeepWalk_128d','DeepWalk_256d','gae_64d','gae_128d','gae_256d','gvae_64d','gvae_128d','gvae_256d','graphsage_64d','graphsage_128d','graphsage_256d',"graphsage_64d_un","graphsage_128d_un","graphsage_256d_un", "graphsage_64d_100_epoch", "graphsage_128d_100_epoch", "graphsage_256d_100_epoch"]
folders =["graphsage_64d_100_epoch", "graphsage_128d_100_epoch", "graphsage_256d_100_epoch"]
for folder in folders:

	column += 1

	for num in nums:
		worksheet = workbook.get_worksheet_by_name('Sheet' + str(num))
		row = 0
		worksheet.write(row, column, folder)
		row += 1
		for cell in cells:
			if (cell == 10):
				print()
				print("{} {}".format(str(cell), str(num)))
			else:
				print()
				print("{} {}".format(str(cell), str(num)))
				worksheet.write(row, column, "")
				row +=1
				worksheet.write(row, column, folder)
				row+=1
			if (folder == 'DeepWalk_64d' or folder == 'DeepWalk_128d' or folder == 'DeepWalk_256d' or folder == "graphsage_64d_un" or folder == "graphsage_128d_un" or folder == "graphsage_256d_un" or folder == "graphsage_64d_100_epoch" or folder == "graphsage_128d_100_epoch" or folder == "graphsage_256d_100_epoch"):
				true_cluster_file = np.loadtxt("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Data\
/t1_2_t2_1_muw_{}/k_{}/community_{}_no_weight.dat".format(str(mux), str(cell), str(num)), dtype="int")
			else:
				true_cluster_file = np.loadtxt("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Data\
/t1_2_t2_1_muw_{}/k_{}/community_{}.dat".format(str(mux), str(cell), str(num)), dtype="int")
			true_cluster = true_cluster_file[:,1]

			for k in x:
				if (folder != "spectral_clustering"):
					actual_cluster_file = np.loadtxt("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Results/node_feature_\
kmeans/{}/t1_2_t2_1_muw_{}/k_{}/network_{}_{}_cluster_kmeans.txt".format(folder, str(mux), str(cell), str(num), str(k)), dtype="int", delimiter=',')
				else:
					actual_cluster_file = np.loadtxt("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Results//spect_kmeans\
/t1_2_t2_1_muw_{}/k_{}/network_{}_{}_cluster_spect_kmeans.txt".format(str(mux), str(cell), str(num), str(k)), dtype="int", delimiter=',')

				#print(true_cluster)
				#print(actual_cluster_file)
				print(format(adjusted_mutual_info_score(true_cluster, actual_cluster_file), ".6f"))
				worksheet.write(row, column, format(adjusted_mutual_info_score(true_cluster, actual_cluster_file), ".6f"))
				row += 1

workbook.close()
			
