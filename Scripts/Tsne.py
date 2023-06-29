from sklearn.manifold import TSNE
from numpy import reshape
import seaborn as sns
import pandas as pd
import matplotlib.pyplot as plt

embedding = pd.read_csv("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Org/Results/embeddings/vgae_64d/heart_features.emb",sep=' ',header=None)
with open("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Org/Results/node_feature_kmeans/vgae_64d/heart/50_cluster_kmeans.txt", "r") as f:
	cluster = f.readline()
	cluster = cluster[:-1]
cluster = cluster.split(',')

embedding.sort_values(by=[0], inplace=True)
embedding = embedding.iloc[:,1:]
array = embedding.to_numpy()

tsne = TSNE(n_components=2, verbose=1, random_state=123)
z = tsne.fit_transform(array)

df = pd.DataFrame()
if len(cluster) > len(z[:,0]):
	df["y"] = cluster[:len(z[:,0])]
else:
	df["y"] = cluster
df["comp-1"] = z[:,0]
df["comp-2"] = z[:,1]

y = [int(i) for i in df.y.tolist()]
count_vec = []
for i in range(1, 51):
	count_vec.append(y.count(i))
order = [i for _,i in sorted(zip(count_vec, range(1,51)), reverse=True)]

swap = {}
for i in range(1, len(order)+1):
	swap[order[i-1]] = i
new_y = [swap[i] for i in y]

sns.scatterplot(x="comp-1", y="comp-2", hue=new_y, hue_order = range(1,11),
	palette=sns.color_palette("husl", n_colors = 10),
	data=df, linewidth=0, s = 2).set(title=\"VGAE\")
lgd = plt.legend(bbox_to_anchor=(1.02, 1), loc='upper left', borderaxespad=0)
plt.savefig('heart_10_cluster.pdf',bbox_extra_artists=(lgd,), bbox_inches='tight')
plt.show()