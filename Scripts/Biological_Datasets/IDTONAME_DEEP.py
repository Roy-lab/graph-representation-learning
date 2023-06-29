import pandas as pd

cells = "fetal_brain"

for i in  ['10','20','30','40','50','60','70','80','90','100']:
    lines = []
    lines_ID = []
    lines_name = []
    label = None
    IDs = []
    ID_list = []
    result = ""

    with open('C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Data\Roadmap_Networks\\adj_matrix\\' + cells + '_nodeNames.txt') as f:
        lines = f.readlines()

    with open('C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Results\\node_feature_kmeans\\DeepWalk_64d\\' + cells + '\\' + str(i) + '_cluster_kmeans.txt') as f2:
        label = f2.readline()

    with open('C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Results\embeddings\DeepWalk_64d\\' + cells + '_features.emb') as f3:
        IDs = f3.readlines()

    for ID in IDs:
        ID_number = ID.split(" ")[0]
        ID_list.append(ID_number)
    
    ID_list = [int(x) for x in ID_list]
    ID_list.sort()
    print(ID_list)

    for name in lines:
        lines_ID.append(name.split("\t")[0])
        lines_name.append(name.split("\t")[1])

    label = label.split(',')

    for k in range(len(label)):
        newname = lines_name[int(ID_list[k])].split("\n")[0]
        result += newname + "\t" + label[k] + "\n"
    
    f4 = open("C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Results\\node_feature_kmeans\\DeepWalk_64d\\" + cells + "\\" + str(i) + "_cluster_kmeans_names.txt", "w")

    f4.write(result)

    f4.close()
    