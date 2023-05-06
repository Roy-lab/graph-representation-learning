# Graph Representation Learning
Comparison of various node embedding algorithms on node classification downstream task

## Overview
We benchmarked three different node embedding algorithms and spectral clustering methods on (diffused/undiffused) RoadMap project 55 cell lines and on synthetic benchmark graphs. The following are data pipelines for pre-processing and post-processing. Diffused networks are based on the Hi-C genomic analysis technique to learn the score for each protein and transfer them to edge weights. 

## Pre-processing graph data
Below, we describe the usage of each script to the generate corresponding adjacency matrix, edge list, node IDs/names, etc.

- `Adj_Matrix_Noweight.py` \
    This file takes a filtered non-weighted graph in edgelist format and transforms it into an adjacency matrix format. The Output file can be used by the spectral clustering algorithm. 
- `Edgelist_Names.py`,`Edgelist_Names_No_Weight.py` \
    These files match the numerical node IDs to literal IDs in edgelist format. Output files can be used in Silhouette and Modularity Index Scripts when the algorithms need to match the node cluster labels to corresponding node IDs. 
- `Get_Avg_Node_Degree.py` \
    This file takes an edgelist format graph as input and computes the average and standard deviation of node degree in the graph. The result can be an indicator to the hyperparameters when constructing synthetic benchmark graphs. 
- `Get_Edgelist.py`, `Get_EdgeList_No_Weight.py` \
    These files take an adjacency matrix as input, extracting edges and/or edge weights and store the graph in edgelist format. 
- `Get_Large_Conn.m` \
    This MATLAB script takes a graph in edgelist format and computes the largest connected component in the graph. If there is only one connected component, then the output is identical to the input. This script is used mainly on the filtered unweighted graph, where some graph segments might become isolated during filtering. 

## Postprocessing cluster labels
After we retrieve the node cluster labels through applying K-Means clustering on node embeddings, we need to match the labels with the correct nodes

- `IDTONAME.py` \
    This file is used by labels learned from spectral clustering and node2vec algorithms. They both use weighted undirected graphs.
- `IDTONAME_DEEP.py` \
    This file is used by labels learned from the DeepWalk algorithm. It utilizes the filtered unweighted undirected graphs.
- `IDTONAME_OHMNET.py` \
    This file is used by labels learned from the Ohmnet algorithm. Since we need to align nodes with same literal IDs across mutliple graphs, we iterate through all nodes in all networks and assign each unique node a novel numerial ID. After we get the cluster labels, we have to match those with correct node literal IDs.

# Running different node embedding algorithms
Below, we describe usage scripts on RoadMap project cell lines which can be found in [here](RoadMap_Networks/Data/RoadMap_Networks)

* [Spectral Clustering](#Spectral_Clustering)
* [node2vec](#node2vec)
* [DeepWalk](#deepwalk)
* [GraphSAGE](#GraphSAGE)
* [VGAE](#VGAE)

### Spectral Clustering
*Inputs*: 

The adjacency matrix of cell line networks \
*Outputs*: 

The node cluster labels in a single line separated by a comma \
*Note*: Cluster labels follow the order of nodes in the adjacency matrix, thus it is suggested to sort the nodes by IDs

*Scripts*:

`doSpect2_addMean.m`: In this script, we read an adjacency matrix into matrix format in MATLAB and compute the graph Laplacian based on this formula \
<img width="195" alt="image" src="https://user-images.githubusercontent.com/61021277/176759050-d24623c3-2f36-4334-88ca-d22e788b1b5e.png"> \
After, we calculate the eigenvectors and eigenvalues of Graph Laplacian and sort them based on eigenvalues descending.
Since each column of eigenvector matrix stores a unique eigenvector, we take each row and assign to the corresponding node as its embedding. We then perform K-Means clustering for node classification. 


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
and the following lines contain node embeddings with the start of node IDs
```shell
node_ID <embeddings>
```
<br />
The original source code can be found at [snap](https://github.com/snap-stanford/snap/tree/master/examples/node2vec) library.

Example command lines to run node2vec
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
and the following lines contain node embeddings with the start of node IDs
```shell
node_ID <embeddings>
```
<br />
The original source code can be found at [deepwalk](https://github.com/phanein/deepwalk) library.

Example command lines to create the environment
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

### Graphsage
*Inputs*

The edgelist format graphs with numerical node IDs. The graph should be unweighted.
```shell
node1_id_int node2_id_int

*Outputs*: 

.emb file containing n lines of node embeddings with the start of node IDs
```shell
node_ID <embeddings>
```
<br />
The original source code can be found at [GraphSage](https://pytorch-geometric.readthedocs.io/en/latest/generated/torch_geometric.nn.models.GraphSAGE.html) library.

Example command line to create the environment
```shell
conda create pygeo python==3.7
conda install pytorch torchvision torchaudio pytorch-cuda=11.7 -c pytorch -c nvidia
conda install pyg -c pyg
conda activate pygeo
```

Example commend line to run Graphsage
```shell
cd <path to work space>
cd GraphSage_Scripts
conda activate pygeo
python Graphsage.py
```
Hyperparameters in the Graphsage Script \
`-batch_size (line 84)`: The batch size used to generate positive and negative samples \
`-hidden_channels (line 116)`: The number of preceptions in each hidden layer \
`-num_layers (line 116)`: number of hidden layer \
`-step_size lr (line 119)`: step size in gradient descent \
`-epoch (line 143)`: number of iterations in gradient descent step (default setting is 50)

Note: The Graphsage.py script is written for generating embeddings on 55 cell-type specific networks. You have modified the input path and output path in the Python script to retrieve the desired network datasets.

### VGAE
*Inputs*

The adjacency matrix format graphs. The graph should be unweighted. 

*Outputs*: 

.emb file containing n lines of node embeddings with the start of node IDs
```shell
node_ID <embeddings>
```
<br />
The original source code can be found at [VGAE](https://github.com/tkipf/gae) library.



# Synthetic Benchmark Graphs
We generate 40 networks stimulating real-world networks and apply various node embedding and node classification techniques to them. We follow the procedure described in [Benchmark graphs for testing community detection algorithms](https://arxiv.org/abs/0805.4770) with different choices of hyperparameters. 

## Code Link
[https://www.santofortunato.net/resources](https://www.santofortunato.net/resources) under LFR benchmark graphs
![image](https://user-images.githubusercontent.com/61021277/176755854-a63bedb5-1d4a-4219-8e15-f9cf6e8f5b58.png)
I used the package 2 to generate undirected weighted graphs

## Parameter description  
`t1` : exponents of the power distribution for node degrees\
`t2` : exponents of the power distribution for community sizes\
`N` : the number of nodes \
`K` : the average degree of the nodes \
`kmin` : the minimum degree of nodes\
`kmax` : the maximum degree of nodes\
`mux` : the mixing parameter indicating the fraction of each node where its outgoing edge is connected to the same community or a different community\
`smin` : the minimal community size\
`smax` : the maximal community size

## Experience choice:
- N is set to 1000 as the original RoadMap graphs have approximately 1000 nodes in all 55 cell lines

- t1 is set to 2 and t2 is set to 1. In the LFR paper, the common range for t1 is [2, 3] and for t2 is [1, 2]

- K is set to [10, 25, 50, 100]. From unnormalized RoadMap networks, the average node degree of 55 cell lines is about 25.84 with a standard deviation of 10.56

- Kmax is set to [15, 50, 75, 125] with respect to the average node degree

- mux is set to [0.1, 0.5]. For 0.1, the network is pretty sparse and the network communities are easy to be detected. However, for 0.5, each network community has an equal number of edges outgoing to a different community or within its own community. This is more similar to the full network used in the normalized Roadmap networks

- other parameters are default values

## File generated: 
1) network.dat contains the list of edges (nodes are labeled from 1 to the number of nodes; the edges are ordered and repeated twice, i.e. source-target and target-source), with the relative weight.

2) community.dat contains a list of the nodes and their membership (memberships are labeled by integer numbers >=1).

3) statistics.dat contains the degree distribution (in logarithmic bins), the community size distribution, the distribution of the mixing parameter for the topology and the weights, and the internal and external weight distribution.

## Example commend line to use the package:
```shell
./benchmark -N 1000 -k 25 -maxk 50 -muw 0.1 -t1 2 -t2 1
```

# Kmeans Clustering
After we get the node embeddings from each algorithm, we need to perform node classification based on the embeddings in the latent space. We choose to use K-Means clustering is the most common and popular one in the unsupervised learning field. 

## Scripts and usage
`kmeansCluster.m`: It takes the embedding file as input and sorts the embedding based on node IDs ascending. Then it performs K-Means clustering on the embedding space and output cluster labels

```shell
sed -i '1d' network_1_features.emb
matlab -nodesktop -nodisplay
>> kmeansCluster('node2vec_64d');
```
note: the `sed` command removes the first line of embedding files which contains basic information
```shell
number_of_nodes embedding_dimension
```

# Evaluation Metrics
we compare and evaluate the performance of the node embedding learning algorithm based on the modularity index and the silhouette index. Both metrics are widely used to measure the strength of graph node segmentation and their maximation refers to the identification of node clusters with strong interconnections among nodes in their clusters.

## Modularity Metric
`\Scripts\Modularity\modularity.R`: calculate the modularity score for weighted graphs
`\Scripts\Modularity\modularity_no_weight.R`: calculate the modularity score for unweighted graphs

*Usage*:
```shell
conda create -n r_env r-essentials r-base
conda activate r_env
Rscript Scripts/modularity.R node2vec_64d
```

### Silhouette Metric
`\Scripts\SilhouetteIndex\calcA.m`: Calculate the distance matrix for each node based on the average edge weights connected to it
`\Scripts\SilhouetteIndex\getSil.m`: Retrieve the Silhouette score for each node in the graph
`\Scripts\SilhouetteIndex\runSil.m`: Align the node cluster labels to unique nodes and calculate the silhouette score of the whole graph

*Usage*:
```shell
cd <path to adjacency matrix>
matlab -nodesktop -nodisplay
>> addpath('<path to Silhouette folder>');
>> runSil('node2vec_64d');
```

