import networkx as nx
import pandas as pd
import numpy as np
import torch
import torch.nn as nn
import torch.nn.functional as F
from torch_cluster import random_walk
from torch_geometric.data import Data
from torch_geometric.data import InMemoryDataset

import torch_geometric.transforms as T
from torch_geometric.nn import SAGEConv
from torch_geometric.loader import NeighborSampler as RawNeighborSampler

def load_node_csv(path, index_col, **kwargs):
    df = pd.read_csv(path, names = ['source', 'target', 'weight'], \
                     index_col = index_col, header=None, sep='\t', **kwargs)
    mapping = {index: i for i, index in enumerate(df.index.unique())}
    
    x = np.identity(len(df.index.unique()))
    x = torch.from_numpy(x).float()
    return x, mapping

def load_edge_csv(path, x_mapping, **kwargs):
    df = pd.read_csv(path, names = ['source', 'target', 'weight'], \
        header=None, sep='\t', **kwargs)
    src = [x_mapping[index] for index in df['source']]
    dst = [x_mapping[index] for index in df['target']]
    edge_index = torch.tensor([src, dst])
    
    edge_attr = torch.tensor(df['weight'], dtype=torch.float)
    return edge_index, edge_attr
def load_edge_csv_noweight(path, x_mapping, **kwargs):
    df = pd.read_csv(path, names = ['source', 'target'], \
        header=None, sep='\t', **kwargs)
    src = [x_mapping[index] for index in df['source']]
    dst = [x_mapping[index] for index in df['target']]
    edge_index = torch.tensor([src, dst])
    
    return edge_index



node_x, node_mapping = load_node_csv("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Multi_Species_Chromatin_State_Annotation/Data/Orthology_Subgraphs_10k/SubGraph_5000bp.txt", index_col='source')
data = Data()
data.x = node_x
print(data)
edge_index = load_edge_csv_noweight("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Multi_Species_Chromatin_State_Annotation/Data/Orthology_Subgraphs_10k/SubGraph_5000bp.txt", x_mapping = node_mapping)
print(edge_index)
data.edge_index = edge_index
print(data)

class NeighborSampler(RawNeighborSampler):
    def sample(self, batch):
        batch = torch.tensor(batch)
        row, col, _ = self.adj_t.coo()

        # For each node in `batch`, we sample a direct neighbor (as positive
        # example) and a random node (as negative example):
        pos_batch = random_walk(row, col, batch, walk_length=1,
                                coalesced=False)[:, 1]
        pos_batch = pos_batch.flatten()

        neg_batch = torch.randint(0, self.adj_t.size(1), (batch.numel(), ),
                                  dtype=torch.long)

        batch = torch.cat([batch, pos_batch, neg_batch], dim=0)
        return super(NeighborSampler, self).sample(batch)


train_loader = NeighborSampler(data.edge_index, sizes=[10, 10], batch_size=256,
                               shuffle=True, num_nodes=len(data.x))

class SAGE(nn.Module):
    def __init__(self, in_channels, hidden_channels, num_layers):
        super(SAGE, self).__init__()
        self.num_layers = num_layers
        self.convs = nn.ModuleList()

        for i in range(num_layers):
            in_channels = in_channels if i == 0 else hidden_channels
            self.convs.append(SAGEConv(in_channels, hidden_channels))

    def forward(self, x, adjs):
        for i, (edge_index, _, size) in enumerate(adjs):
            x_target = x[:size[1]]  # Target nodes are always placed first.
            x = self.convs[i]((x, x_target), edge_index)
            if i != self.num_layers - 1:
                x = x.relu()
                x = F.dropout(x, p=0.5, training=self.training)
        return x

    def full_forward(self, x, edge_index):
        for i, conv in enumerate(self.convs):
            x = conv(x, edge_index)
            if i != self.num_layers - 1:
                x = x.relu()
                x = F.dropout(x, p=0.5, training=self.training)
        return x
    
device = torch.device('cuda' if torch.cuda.is_available() else 'cpu')
#device = torch.device('cpu')
model = SAGE(len(data.x), hidden_channels=256, num_layers=2)
x, edge_index = data.x.to(device), data.edge_index.to(device)

optimizer = torch.optim.Adam(model.parameters(), lr=0.0005)

def train():
    model.train()

    total_loss = 0
    for batch_size, n_id, adjs in train_loader:
        # `adjs` holds a list of `(edge_index, e_id, size)` tuples.
        adjs = [adj.to(device) for adj in adjs]
        optimizer.zero_grad()

        out = model(data.x[n_id], adjs)
        out, pos_out, neg_out = out.split(out.size(0) // 3, dim=0)

        pos_loss = F.logsigmoid((out * pos_out).sum(-1)).mean()
        neg_loss = F.logsigmoid(-(out * neg_out).sum(-1)).mean()
        loss = -pos_loss - neg_loss
        loss.backward()
        optimizer.step()

        total_loss += float(loss) * out.size(0)

    return total_loss / data.num_nodes

for epoch in range(1, 101):
    loss = train()
    print(loss)

with torch.no_grad():
    model.eval()
    out = model.full_forward(x, edge_index).cpu()

ids = list(node_mapping.values())
with open("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Multi_Species_Chromatin_State_Annotation/Results/embeddings/Orthology_Subgraph/graphsage_64d/orthology_graph.emb", "w") as f:
    for each_id, row in zip(ids, out):
        line = "%d " %each_id + " ".join(format(x, "0.6f") for x in row) + "\n"
        f.write(line)