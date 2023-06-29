cells = [10,25,50,100]

for cell in cells:
    print(cell)
    lines = []
    result = ""
    
    with open('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Data//t1_2_t2_1/k_'+str(cell)+"//network_no_weight.dat") as f:
        lines = f.readlines()
        
    for line in lines:
        result += "node_" + line.split("\t")[0] + "\t"
        result += "node_" + line.split("\t")[1] #+ "\t" 
        #result += line.split("\t")[2]
        result += "\n"
        
    f2 = open('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Data//t1_2_t2_1/k_'+str(cell)+"//edgelist_no_weight.txt", 'w')
    f2.write(result)
    f2.close()