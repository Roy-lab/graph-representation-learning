#!/usr/bin/Rscript
#usage: ./script.R [.nw] [.gene-clst.txt]
args <- commandArgs(T)
cells <- c(10,25,50,100)
x <- c(10,20,30,40,50,60,70,80,90,100)

for (cell in cells){
  cat(sprintf("\n"))
  print(cell)

  for (k in x) {
    netfile <- sprintf("Data//t1_2_t2_1/k_%d//edgelist_no_weight.txt", cell)
    clstfile <- sprintf("Results//node_feature_kmeans//%s//t1_2_t2_1//k_%d//%d_cluster_kmeans_names.txt", args[1], cell, k)
    
    library('igraph')
    
    net <- read.table(netfile, header=F, sep='\t')
    colnames(net) <- c("V1","V2")
    netg <- graph.data.frame(net,directed=F)
    
    clust <- read.table(clstfile,header=F,sep='\t')
    names <- clust[,1]
    clst <- as.data.frame(clust[,-1])
    row.names(clst) <- names
    
    V(netg)$comm <- clst[V(netg)$name,1]
    
    cat(sprintf("%f\n", modularity(netg,V(netg)$comm+1)))
  }
}

q(save="no")