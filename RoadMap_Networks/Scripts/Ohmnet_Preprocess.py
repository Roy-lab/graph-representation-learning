import pandas as pd
import numpy as np

trial_name = "third_trial"

lines = []
filenames = []
filepaths = []
contents = []
index = []
nodename = []
result = ""

with open('C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Data\RoadMap_Networks\\ohmnet_structure\\' + trial_name + '\\tissue.list') as f:
    lines = f.readlines()

for line in lines:
    filepaths.append(line.split("\n")[0])
    filenames.append(line.split("\n")[0].split("/")[-1])

for filepath in filepaths:
    with open(filepath) as f:
        contents.append(f.readlines())

idx = 0

for content in contents:
    for edge in content:
        if (edge != "\n"):
            node1 = edge.split("\t")[0]
            node2 = edge.split("\t")[1]

            if not (node1 in nodename):
                index.append(idx)
                nodename.append(node1)
                idx += 1
            if not (node2 in nodename):
                index.append(idx)
                nodename.append(node2)
                idx += 1

            result += str(index[nodename.index(node1)]) + "\t" + str(index[nodename.index(node2)]) + "\t" + edge.split("\t")[2]

    f1 = open("C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Data\Roadmap_Networks\ohmnet_structure\\" + trial_name + "\\edgelist\\" + filenames[contents.index(content)], "w")

    f1.write(result)

    f1.close()

    result = ""
    print(idx)

print(nodename[0], index[0])

result = ""
for i in range(len(nodename)):
    result += str(index[i]) + "\t" + str(nodename[i]) + "\n"

f1 = open("C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Data\Roadmap_Networks\ohmnet_structure\\" + trial_name + "\\nodenames.txt", "w")

f1.write(result)

f1.close()
