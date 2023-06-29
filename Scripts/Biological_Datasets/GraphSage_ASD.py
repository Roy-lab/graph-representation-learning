#!/usr/bin/env python
# coding: utf-8

# In[1]:


import networkx as nx
import pandas as pd
import numpy as np
import os
import random

import stellargraph as sg
from stellargraph.data import EdgeSplitter
from stellargraph.mapper import GraphSAGELinkGenerator
from stellargraph.layer import GraphSAGE, link_classification
from stellargraph.data import UniformRandomWalk
from stellargraph.data import UnsupervisedSampler
from sklearn.model_selection import train_test_split

from tensorflow import keras
from sklearn import preprocessing, feature_extraction, model_selection
from sklearn.linear_model import LogisticRegressionCV, LogisticRegression
from sklearn.metrics import accuracy_score

from stellargraph import globalvar

from stellargraph import datasets
from IPython.display import display, HTML

from sklearn.decomposition import PCA
from sklearn.manifold import TSNE
from stellargraph.mapper import GraphSAGENodeGenerator
import pandas as pd
import numpy as np
import matplotlib.pyplot as plt




# In[ ]:


for mux in [0.5]:
    for k in [100]:
        for s in [1]:
            data = pd.read_csv("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Org/Data/edgelist/cd19.edgelist", delimiter = "\t", header = None)
            data.columns = ['source', 'target']
            #print(data)

            nodeid = pd.read_csv("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Org/Data/adj_matrix/cd19_nodeNames.txt", delimiter = "\t", header = None)
            nodeid.columns = ['org_ID', "name"]
            nodeid.insert(0, "ID", range(len(nodeid)))
            #print(nodeid)

            G = sg.StellarGraph(edges=data)

            i = np.identity(G.number_of_nodes(), dtype = float)
            df = pd.DataFrame(i, index = nodeid["ID"])
            G = sg.StellarGraph(edges=data, nodes = df)
            print(G.info())

            nodes = list(G.nodes())
            number_of_walks = 1
            length = 5

            unsupervised_samples = UnsupervisedSampler(
                G, nodes=nodes, length=length, number_of_walks=number_of_walks
            )

            batch_size = 20
            epochs = 20
            num_samples = [10, 5]

            generator = GraphSAGELinkGenerator(G, batch_size, num_samples)
            train_gen = generator.flow(unsupervised_samples)

            layer_sizes = [64, 64]
            graphsage = GraphSAGE(
                layer_sizes=layer_sizes, generator=generator, bias=True, dropout=0.0, normalize="l2"
            )

            # Build the model and expose input and output sockets of graphsage, for node pair inputs:
            x_inp, x_out = graphsage.in_out_tensors()

            prediction = link_classification(
                output_dim=1, output_act="sigmoid", edge_embedding_method="ip"
            )(x_out)

            model = keras.Model(inputs=x_inp, outputs=prediction)

            model.compile(
                optimizer=keras.optimizers.Adam(learning_rate=1e-3),
                loss=keras.losses.binary_crossentropy,
                metrics=[keras.metrics.binary_accuracy],
            )

            history = model.fit(
                train_gen,
                epochs=epochs,
                verbose=1,
                use_multiprocessing=False,
                workers=4,
                shuffle=True,
            )

            x_inp_src = x_inp[0::2]
            x_out_src = x_out[0]
            embedding_model = keras.Model(inputs=x_inp_src, outputs=x_out_src)

            node_gen = GraphSAGENodeGenerator(G, batch_size, num_samples).flow(nodeid["ID"])

            node_embeddings = embedding_model.predict(node_gen, workers=4, verbose=1)

            ids = list(range(0,G.number_of_nodes()))
            with open("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Org/Results/embeddings/graphsage_64d_stellargraph/cd19_features.emb", "w") as f:
                for each_id, row in zip(ids, node_embeddings):
                    line = "%d " %each_id + " ".join(format(x, "0.6f") for x in row) + "\n"
                    f.write(line)




