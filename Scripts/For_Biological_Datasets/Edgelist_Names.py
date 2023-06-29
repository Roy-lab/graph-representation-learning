import pandas as pd

cells = "cd14_primary_cells"

lines = []
Names = []
result = ""

with open('C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Data\RoadMap_Networks\edgelist\\' + cells + '.edgelist') as f:
    lines = f.readlines()

with open('C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Data\Roadmap_Networks\\adj_matrix\\' + cells + '_nodeNames.txt') as f2:
    Names = f2.readlines()

for line in lines:
    first_ID = line.split(" ")[0]
    second_ID = line.split(" ")[1]

    first_Name = Names[int(first_ID)].split("\t")[1].split("\n")[0]
    second_Name = Names[int(second_ID)].split("\t")[1].split("\n")[0]

    result += first_Name + "\t" + second_Name + "\t" + line.split(" ")[2]

f1 = open("C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Data\RoadMap_Networks\edgelist\edgelist_names\\" + cells + ".txt", "w")

f1.write(result)

f1.close()