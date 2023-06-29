function runSil(folder)

cells = {10,25,50,100};

for j = 1:length(cells)
    cell = cells{j};
    fprintf('\n');
    fprintf('%d\n', cells{j});
    

    for k = 10:10:100
        adjmat=importdata(sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Data/t1_2_t2_1/k_%d/network.txt',cell));
        %adjmat=importdata(sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Data/t1_2_t2_1/k_%d/network_no_weight.txt',cell));

        %matorder=readtable(sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Data/t1_2_t2_1/k_%d/network_no_weight_Nodenames.txt',cell),'ReadVariableNames',false,'Delimiter','\t');
        matorder=readtable(sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Data/t1_2_t2_1/k_%d/network_Nodenames.txt',cell),'ReadVariableNames',false,'Delimiter','\t');
        adjmat = squareform(pdist(adjmat));
        cids=importdata(sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Results/node_feature_kmeans//%s//t1_2_t2_1//k_%d/%d_cluster_kmeans_names.txt',folder,cell,k));
        %cids=importdata(sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Results//spect_kmeans//t1_2_t2_1/k_%d//%d_cluster_spect_kmeans_names.txt',cell,k));
        
        reOrdered_cids=[];
        for i=1:length(cids.data)
        currentGene=matorder.Var1(i);
        %currentGene=regexprep(currentGene,':','');
        idx=strmatch(currentGene,cids.textdata,'exact');
        if isempty(idx)==0;
        reOrdered_cids=[reOrdered_cids;cids.data(idx)];
        end
        end

        SI=getSil(adjmat,reOrdered_cids+1);
        fprintf('%f\n', SI);
    end
end
