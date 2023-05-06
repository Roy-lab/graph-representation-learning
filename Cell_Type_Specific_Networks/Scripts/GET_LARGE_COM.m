function GET_LARGE_COM()

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
        
    %folders = {'node2vec_64d', 'node2vec_64d_p1_q2', 'node2vec_64d_p1_q0.5', 'node2vec_64d_p2_q1', 'node2vec_64d_p0.5_q1', 'node2vec_128d', 'node2vec_128d_p1_q2', 'node2vec_128d_p1_q0.5', 'node2vec_128d_p2_q1', 'node2vec_128d_p0.5_q1', 'node2vec_256d', 'node2vec_256d_p1_q2', 'node2vec_256d_p1_q0.5', 'node2vec_256d_p2_q1', 'node2vec_256d_p0.5_q1'};
     folders = {'DeepWalk_64d', 'DeepWalk_128d', 'DeepWalk_256d'};
        
    for i = 1:length(cells)
        cell = cells{i};
        disp(cell);
        edgelist = readmatrix(sprintf('/mnt//dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Org/Data//edgelist/%s.txt', cell));
        edgelist = unique(edgelist, 'rows');
        G = graph(edgelist(:,1), edgelist(:,2));
        bins = conncomp(G);
        mode_bins = mode(bins);
        index = bins == mode_bins;
        
%        adj_matrix = readmatrix(sprintf('/mnt//dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Org/Data//adj_matrix/%s.txt', cell));
%        disp(size(adj_matrix));
%        adj_matrix = adj_matrix(index, index);
%        disp(size(adj_matrix));
%        dlmwrite(sprintf('/mnt//dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Org/Data//adj_matrix/%s.txt', cell),adj_matrix, 'delimiter','\t');
%        
%        nodename = readtable(sprintf('/mnt//dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Org/Data//adj_matrix/%s_nodeNames.txt', cell));
%        disp(size(nodename));
%        nodename = nodename(index,:);
%        disp(size(nodename));
%        writetable(nodename, sprintf('/mnt//dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Org/Data//adj_matrix/%s_nodeNames.txt', cell), 'Delimiter','\t', 'WriteVariableNames',0);
        for j = 1:length(folders)
            folder = folders{j};
            embeddings = readmatrix(sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Org/Results/embeddings/%s/%s_features.txt', folder, cell));
            disp(size(embeddings));
            embeddings = sortrows(embeddings, 1);
            embeddings = embeddings(index, :);
            disp(size(embeddings));
            dlmwrite(sprintf('/mnt//dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Org/Results/embeddings/%s/%s_features.txt', folder, cell),embeddings, 'delimiter',' ');
        end
    end

end