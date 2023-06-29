cell='heart'

for k = 10:10:100
    adjmat=importdata(sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks/Data/Roadmap_Networks/adj_matrix/%s.txt',cell));

    matorder=readtable(sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks/Data/Roadmap_Networks/adj_matrix/%s_nodeNames.txt',cell),'ReadVariableNames',false,'Delimiter','\t');
    adjmat = squareform(pdist(adjmat));
    cids=importdata(sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks/Results/node_feature_kmeans/node2vec_256d/%s/%d_cluster_kmeans_names.txt',cell,k));

    reOrdered_cids=[];
    for i=1:length(cids.data)
    currentGene=matorder.Var2(i);
    %currentGene=regexprep(currentGene,':','');
    idx=strmatch(currentGene,cids.textdata,'exact');
    if isempty(idx)==0;
    reOrdered_cids=[reOrdered_cids;cids.data(idx)];
    end
    end

    SI=getSil(adjmat,reOrdered_cids+1);
    fprintf('%f\n', SI);
end