import pandas as pd

cells = "cd14_primary_cells"

lines = []
Names = []
result = ""
nodenames = []
result_nodenames = ""

with open('C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Data\RoadMap_Networks\edgelist\\' + cells + '_no_weight.edgelist') as f:
    lines = f.readlines()

with open('C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Data\Roadmap_Networks\\adj_matrix\\' + cells + '_nodeNames.txt') as f2:
    Names = f2.readlines()

for line in lines:
    first_ID = line.split(" ")[0]
    second_ID = line.split(" ")[1].split("\n")[0]

    first_Name = Names[int(first_ID)].split("\t")[1].split("\n")[0]
    second_Name = Names[int(second_ID)].split("\t")[1].split("\n")[0]

    result += first_Name + "\t" + second_Name + "\n"

    if int(first_ID) not in nodenames:
        nodenames.append(int(first_ID))
        result_nodenames += Names[int(first_ID)]

f1 = open("C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Data\RoadMap_Networks\edgelist\edgelist_names\\" + cells + "_no_weight.txt", "w")

f1.write(result)

f1.close()

f2 = open("C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Data\RoadMap_Networks\\adj_matrix_no_weight\\" + cells + "_no_weight_nodeNames.txt", "w")

f2.write(result_nodenames)

f2.close()