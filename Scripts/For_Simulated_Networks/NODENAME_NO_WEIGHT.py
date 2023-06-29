cells = [10,25,50,100]
folder = "node2vec_64d"

for cell in cells:
    print(cell)
    result = ""
    
    with open('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_' + str(cell) + '//network_no_weight_Nodenames.txt') as f:
        lines = f.readlines()
    
    for line in lines:
        result += "node_" + line
          
    f2 = open('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_' + str(cell) + '//network_no_weight_Nodenames.txt', 'w')
    f2.write(result)
    f2.close()