# Graph Representation Learning
Comparison of various node embedding algorithms on node classification downstream task

## Overview
We benchmarked 3 different node embedding algorithms and spectral clustering methods on (diffused/undiffused) RoadMap project 55 cell lines and on systhetic benchmark grpahs. The following are data pipelines for pre-propressing and post-propressing. Diffused networks are based on the Hi-C genomic analysis technique to learn score for each protein and transfer them to edge weights. 

## Preprosessing graph data
Below, we describe the usage of each script to generate corresponding adjacency matrix, edge list, node IDs / names, etc.

- `Adj_Matrix_Noweight.py` \
    This file takes a filtered non-weighted graph in edgelist format and transform to adjacency matrix format. Output file can be used by spectral clustering algorithm. 
- `Edgelist_Names.py`,`Edgelist_Names_No_Weight.py` \
    These files match the node numerical IDs to literal IDs in edgelist format. Output file can be used in Silhouette and Modularity Index Scripts when the algorithms need to match the node cluster labels to corresponding node IDs. 
- `Get_Avg_Node_Degree.py` \
    This file takes an edgelist format graph as input and compute the average and standard deviation of node degree in the graph. The result can be an indicator to the hyperparameters when constructing systhetic benchmark graphs. 
- `Get_Edgelist.py`, `Get_EdgeList_No_Weight.py` \
    These files take an adjacency matrix as input, extracting edges and/or edge weights and store the graph in edgelist format. 
- `Get_Large_Conn.m` \
    This MATLAB script takes an graph in edgelist format and computes the largest connected commponent in the graph. If there is only one connected component, then the output is identical to the input. This script is used mainly on filtered unweighted graph where some graph segements might become isolated during filtering. 

## Postprosessing cluster labels
After we retrieve the node cluster labels through applying K-Means clustering on node embeddings, we need to match the labels with correct nodes

- `IDTONAME.py` \
    This file is used by labels learned from spectral clustering and node2vec algorithms. They both use the weighted undirected graphs.
- `IDTONAME_DEEP.py` \
    This file is used by labels learned from DeepWalk algorithm. It utilize the filtered unweighted undirected graphs.
- `IDTONAME_OHMNET.py` \
    This file is used by labels learned from Ohmnet algorithm. Since we need to align nodes with same literal IDs across mutliple graphs, we iterate through all nodes in all networks and assign each unique node a novel numerial ID. After we got the cluster labels, we have to match those with correct node literal IDs.
    
## Ohmnet specific scripts 
- `Ohmnet_Extract.py` \
    This python script reads all the weighted graphs in edgelist format, extracts unique nodes across all network layers and assigns a new numerical ID to each node. The corresponeding edgelist and node ID list are store in the same folder. 

# Running different node embedding algorthms
Below, we describe usage scripts on RoadMap project cell lines which can be found in [here](RoadMap_Networks/Data/RoadMap_Networks)

* [Spectral Clustering](#Spectral_Clustering)
* [node2vec](#node2vec)
* [DeepWalk](#deepwalk)
* [Ohmnet](#ohmnet)

### Spectral Clustering

### node2vec
    


