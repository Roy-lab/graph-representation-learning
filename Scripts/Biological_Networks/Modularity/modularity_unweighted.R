#!/usr/bin/Rscript
#usage: ./script.R [.nw] [.gene-clst.txt]
args <- commandArgs(T)

netfile <- args[1]
clstfile <- args[2]
library('igraph')

net <- read.table(netfile, header=F, sep='\t')
colnames(net) <- c("V1","V2","weight")
netg <- graph.data.frame(net,directed=F)

clust <- read.table(clstfile,header=F,sep='\t')
names <- clust[,1]
clst <- as.data.frame(clust[,-1])
row.names(clst) <- names

V(netg)$comm <- clst[V(netg)$name,1]

modularity(netg,V(netg)$comm+1)

q(save="no")


