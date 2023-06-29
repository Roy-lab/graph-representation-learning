import sys

cells = [10,25,50,100]
folder = sys.argv[1]
print(folder)

for cell in cells:
    print(cell)
    for i in ['10', '20', '30', '40', '50', '60', '70', '80', '90', '100']:
        result = ""
        labels = []
        
        # with open('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Results//spect_kmeans//t1_2_t2_1//k_' + str(cell) + "//" + str(i) + '_cluster_spect_kmeans.txt') as f:
        with open('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Results//node_feature_kmeans//' + folder + "//t1_2_t2_1//k_" + str(cell) + "//" + str(i) + '_cluster_kmeans.txt') as f:
          labels = f.readline()
          
        labels = labels.split(",")
        
        with open('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Data//t1_2_t2_1/k_' + str(cell) + "//" + "network_no_weight_Nodenames.txt") as f1:
          nodenames = f1.readlines()
          
        
        
        for j in range(len(nodenames)):
          result += nodenames[j].split("\n")[0] + "\t" + labels[j] + "\n"
          
        # f2 = open('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Results//spect_kmeans//t1_2_t2_1//k_' + str(cell) + "//" + str(i) + '_cluster_spect_kmeans_names.txt', 'w')
        f2 = open('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Results//node_feature_kmeans//' + folder + "//t1_2_t2_1//k_" + str(cell) + "//" + str(i) + '_cluster_kmeans_names.txt', 'w')
        f2.write(result)
        f2.close()