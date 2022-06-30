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
Inputs: The adjacency matrix of cell line networks \
Outputs: The node cluster labels in a single line separated by comma \
Note: Cluster labels follow the order of nodes in adjacency matrix, thus it is suggested to sort the nodes by IDs

Example to execute the script: 
```shell
matlab -nodesktop -display
>> doSpect2_addMean;
```

### node2vec
*Inputs*: 

The edgelist format graphs with numerical node IDs. The graph can be either weighted or unweighted. 
```shell
node1_id_int node2_id_int <weight_float, optional>
```
*Outputs*: 

.emb file containing n + 1 lines where the first line has the format
```shell
number_of_nodes embedding_dimension
```
and the following lines contains node embeddings with the start of node IDs
```shell
node_ID <embeddings>
```
<br />
The Original source code can be found at [snap](https://github.com/snap-stanford/snap/tree/master/examples/node2vec) library.

Example commend lines to run node2vec
```shell
conda create py37 python==3.7
conda activate py37
cd <path to work space>
Scripts/snap/examples/node2vec/node2vec -i:Data/edgelist/"$cell".edgelist -o:Results/embeddings/node2vec_64d/"$cell"_features.emb -d:64 -p:1 -q:1
```
Command line arguments \
`-i`: the input path \
`-o`: the path where output files will be saved \
`-d`: embedding dimension (default == 128) \
`-p`: the return parameter (deafult == 1) \
`-q`: the in-out parameter (default == 1)

### DeepWalk
*Inputs*: 

The edgelist or adjacency matrix format graphs with numerical node IDs. The graph should be unweighted. 
```shell
node1_id_int node2_id_int
```
*Outputs*: 

.emb file containing n + 1 lines where the first line has the format
```shell
number_of_nodes embedding_dimension
```
and the following lines contains node embeddings with the start of node IDs
```shell
node_ID <embeddings>
```
<br />
The Original source code can be found at [deepwalk](https://github.com/phanein/deepwalk) library.

Example commend lines to create environment
```shell
conda create py37 python==3.7
conda activate py37
cd <path to work space>
cd deepwalk
pip install -r requirements.txt
python setup.py install
```

Example commend line to run DeepWalk
```shell
deepwalk --input Data/edgelist/"$cell".edgelist --output Results/embeddings/DeepWalk_64d/"$cell"_features.emb --representation-size 64 --format edgelist
```
Command line arguments \
`--input`: the input path \
`--output`: the path where output files will be saved \
`--representation-size`: embedding dimension (default == 64) \
`--format`: adjacency matrix or edgelist

### Ohmnet
*Inputs*: 

The `tissue.list` file contains absolute paths to all cell line networks in each line.
The `tissue.hierarchy` file includes the tree structure hiearchy structure with all network file names stored at leaf nodes. 
Here is an overview of the hierarchy tree 
![tree](\Data\Roadmap_Networks\tree.png)

*Outputs*: 

The output file `leaf_vectors.emb` contains embeddings for nodes at the level of leaves in the hierarchy (we care more about this because it contains embbedings for our biological networks. \
The output file `internal_vectors.emb` contains embeddings for nodes at higher levels in the hierarchy.
<br />
These files contain n + 1 lines where the first line has the format
```shell
number_of_nodes_in_layers embedding_dimension
```
and the following lines contains node embeddings with the start of node IDs
```shell
node_ID <embeddings>
```
<br />
The Original source code can be found at [ohmnet](https://github.com/mims-harvard/ohmnet) library.

Example commend lines to create environment
```shell
conda create py37 python==3.7
conda actvate py37
python ./Scripts/ohmnet/main.py --input "Data/ohmnet_structure/tissue.list" --outdir "Results/embeddings/Ohmnet_128d/" --hierarchy "Data/ohmnet_structure/tissue.hierarchy" --unweighted --dimension 128
```
Command line arguments \
`--input`: the input path to the list of networks \
`--outdir`: the folder where output files will be saved \
`--hierarchy`: the input path to the hierarchy of all networks
`--dimension`: embedding dimension (default == 128) \
`--weighted`: We have to special that networks are unweighted




