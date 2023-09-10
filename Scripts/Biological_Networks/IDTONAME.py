import pandas as pd

for i in  ['10','20','30','40','50','60','70','80','90','100']:
    lines = [] 
    label = None
    result = ""

    with open('Data/Roadmap_Networks//adj_matrix//breast_variant_human_mammary_epithelial_cells_vhmec_nodeNames.txt') as f:
        lines = f.readlines()

    with open('Results//node_feature_kmeans//graphsage_64d//breast_variant_human_mammary_epithelial_cells_vhmec//' + str(i) + '_cluster_kmeans.txt') as f2:
        label = f2.readline()

    label = label.split(',')

    counter = 0
    for name in lines:
        tabp = name.find("\t")
        newp = name.find("\n")

        newname = name[tabp + 1:newp]

        result += newname + "\t" + label[counter] + "\n"

        counter += 1

    f3 = open("Results//node_feature_kmeans//graphsage_64d//breast_variant_human_mammary_epithelial_cells_vhmec//" + str(i) + "_cluster_kmeans_names.txt", "w")

    f3.write(result)

    f3.close()









