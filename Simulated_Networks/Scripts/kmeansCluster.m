function cids = kmeansCluster(param, folder)

filename = {'network_1_features.emb', 'network_2_features.emb', 'network_3_features.emb', 'network_4_features.emb', 'network_5_features.emb', ...
        'network_6_features.emb', 'network_7_features.emb', 'network_8_features.emb', 'network_9_features.emb', 'network_10_features.emb'};

cells = {'network_1', 'network_2', 'network_3', 'network_4', 'network_5', ...
        'network_6', 'network_7', 'network_8', 'network_9', 'network_10'};


for i = [10,25,50,100]
    mat = importdata(sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Results/embeddings/%s/%s/k_%d/network_features.emb', folder, param, i));
    disp(size(mat));
%     cell = cells{i};
%     disp(filename{i});
%     disp(cells{i});
    disp(i);
    cell = i;
    
    for k = 10:10:100

        mat = sortrows(mat, 1);
        %gene_names=readtable('/mnt/dv/wid/projects3/Roy-enhancer-promoter/RMEC/Graph_Diffusion/Results/snpgenemappings/Autismspectrumdisorderorschizophrenia/cd14_primary_cells/idx_top1percent_top5.txt','ReadVariableNames',0,'Delimiter','\t');
        cidx = kmeans(mat(:,2:end),k,'replicates',100);
        %[i,ix]=sort(cidx);
        %gene names sorted by index 
        %orig_index=d(ix,1);
        %gene_names_sort=gene_names.Var2(orig_index+1);

        cidx = cidx';
        tmat = [];
        llen = [];
        for m=min(cidx):max(cidx)
            tmat = [tmat;,mat(cidx==m,2:end)];
            llen = [llen;size(tmat,1)];
        end

        %% 
        f=figure;
        c=[ones(101,1),(1:-0.01:0)',(1:-0.01:0)'];
        imagesc(tmat,[-0.5,0.5]);
        [x,y] = size(tmat);
        box off
        for i=1:length(llen)
            line([0,k+1],[llen,llen],'LineWidth',1,'Color','g');
        end
        h=colorbar;
        colormap(c);
        %ylim([ymin ymax])
        set(gcf,'PaperPosition',[ 0 0 12 6], 'PaperPositionMode','manual', 'PaperSize',[12 6]);
        saveas(f, sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Results/node_feature_kmeans/%s/%s/k_%d/%d_cluster_kmeans.pdf', folder, param, cell, k));

        cids = cidx;
        result = table(cids);
        writetable(result, sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/Simulated_Networks/Results/node_feature_kmeans/%s/%s/k_%d/%d_cluster_kmeans.txt', folder, param, cell, k),'delimiter',',','writerownames',false,'writevariablenames',false)
    end
end