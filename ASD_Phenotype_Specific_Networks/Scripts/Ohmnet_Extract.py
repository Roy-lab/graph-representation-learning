import pandas as pd

lines = []
cd14_list = []
fetal_brain_list = []
heart_list = []
cd14_result = ""
fetal_brain_result = ""
heart_result = ""

with open('C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Results\embeddings\ohmnet\leaf_vectors.emb') as f:
    lines = f.readlines()

for line in lines[1:]:
    space_index = line.find(" ")
    name = line[:space_index]
    features = line[space_index:]
    node_id = name.split("__")[1]
    cell_type = name.split("__")[0]

    if "cd14_primary_cells" in cell_type:
        cd14_list.append(node_id + features)
    if "fetal_brain" in cell_type:
        fetal_brain_list.append(node_id + features)
    if "heart" in cell_type:
        heart_list.append(node_id + features)

for line1 in cd14_list:
    cd14_result += line1

for line2 in fetal_brain_list:
    fetal_brain_result += line2

for line3 in heart_list:
    heart_result += line3

f1 = open("C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Results\embeddings\ohmnet\cd14_primary_cells_features.emb", "w")

f1.write(cd14_result)

f1.close()

f2 = open("C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Results\embeddings\ohmnet\\fetal_brain_features.emb", "w")

f2.write(fetal_brain_result)

f2.close()

f3 = open("C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Results\embeddings\ohmnet\heart_features.emb", "w")

f3.write(heart_result)

f3.close()

