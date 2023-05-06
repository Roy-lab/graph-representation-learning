function cids = kmeansCluster(folder)

cells = {'breast_variant_human_mammary_epithelial_cells_vhmec', 'cd14_primary_cells', 'cd19', 'cd34_primary_cells', 'cd3_primary_cells', ...
    'cd4_primary_cells', 'cd56_primary_cells', 'cd8_primary_cells', 'fetal_adrenal_gland', 'fetal_brain', 'fetal_heart', 'fetal_intestine_large', ...
    'fetal_intestine_small', 'fetal_kidney', 'fetal_lung', 'fetal_muscle', 'fetal_muscle_arm', 'fetal_muscle_back', ...
    'fetal_muscle_leg', 'fetal_muscle_lower_limb', 'fetal_muscle_trunk', 'fetal_ovary', 'fetal_renal_cortex', ...
    'fetal_renal_pelvis', 'fetal_skin', 'fetal_spinal_cord', 'fetal_stomach', 'fetal_testes', 'fetal_thymus', 'fibroblast', ...
    'fibroblasts_fetal_skin_abdomen', 'fibroblasts_fetal_skin_back', 'fibroblasts_fetal_skin_biceps_left', 'fibroblasts_fetal_skin_biceps_right', ...
    'fibroblasts_fetal_skin_quadriceps_left', 'fibroblasts_fetal_skin_quadriceps_right', 'fibroblasts_fetal_skin_scalp', ...
    'fibroblasts_fetal_skin_upper_back', 'gastric_mucosa', 'heart', 'h1_bmp4_derived_mesendoderm_cultured_cells','h1_bmp4_derived_trophoblast_cultured_cells', ...
    'h1_cells', 'h1_derived_mesenchymal_stem_cells', 'h1_derived_neuronal_progenitor_cultured_cells', 'h9_cells', ...
    'imr90_fetal_lung_fibroblasts_cell_line', 'keratinocyte', 'melanocyte', 'ovary', 'pancreas', 'placenta', ...
    'psoas_muscle', 'small_bowel_mucosa', 'testes'};


for i = 1:length(cells)
    mat = importdata(sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Cad/Results/embeddings/%s/%s_features.emb',folder,cells{i}));
    disp(folder);
    disp(size(mat));
    cell = cells{i};
    disp(cells{i});
    
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
        saveas(f, sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Cad/Results/node_feature_kmeans/%s/%s/%d_cluster_kmeans.pdf', folder, cell, k));

        cids = cidx;
        result = table(cids);
        writetable(result, sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Cad/Results/node_feature_kmeans/%s/%s/%d_cluster_kmeans.txt', folder, cell, k),'delimiter',',','writerownames',false,'writevariablenames',false)
    end
end