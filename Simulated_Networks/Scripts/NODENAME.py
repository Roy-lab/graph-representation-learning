cells = [10,25,50,100]
folder = "node2vec_64d"

for cell in cells:
    print(cell)
    result = ""
    
    for j in range(1000):
      result += "node_" + str(j+1) + "\n"
          
    f2 = open('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks//Data//t1_2_t2_1//k_' + str(cell) + '//network_Nodenames.txt', 'w')
    f2.write(result)
    f2.close()