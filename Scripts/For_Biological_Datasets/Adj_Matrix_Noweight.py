import pandas as pd

cells = "fetal_brain"

lines = []
result = ""

index_list = []

with open('C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Data\RoadMap_Networks\edgelist\\' + cells + '_no_weight.edgelist') as f:
    lines = f.readlines()

adj_matrix = [[str(0) for _ in range(1490)] for i in range(1490)]

for line in lines:
    first_num = line.split(" ")[0]
    second_num = line.split(" ")[1].split("\n")[0]

    if int(first_num) not in index_list:
        index_list.append(int(first_num))
    if int(second_num) not in index_list:
        index_list.append(int(second_num))

    adj_matrix[int(first_num)][int(second_num)] = str(1)

count = 0
for i in range(1490):
    count = 0
    for k in range(1490):
        if k not in index_list:
            adj_matrix[i][k] = None
            count += 1

    for j in range(count):
        adj_matrix[i].remove(None)

count = 0
for m in range(1490):
    if m not in index_list:
        adj_matrix[m] = None
        count += 1

for n in range(count):
    adj_matrix.remove(None)

print(len(adj_matrix))

for line1 in adj_matrix:
    result += " ".join(line1) + "\n"

f1 = open("C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Data\RoadMap_Networks\\adj_matrix_no_weight\\" + cells + "_no_weight.txt", "w")

f1.write(result)

f1.close()


