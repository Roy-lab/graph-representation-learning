function Get_Edgelist_Names()
    cells = {'breast_variant_human_mammary_epithelial_cells_vhmec', 'cd14_primary_cells', 'cd19', 'cd34_primary_cells', 'cd3_primary_cells', 'cd4_primary_cells', ...
    'cd56_primary_cells', 'cd8_primary_cells', 'fetal_adrenal_gland', 'fetal_brain', 'fetal_heart', 'fetal_intestine_large', ...
    'fetal_intestine_small', 'fetal_kidney', 'fetal_lung', 'fetal_muscle', 'fetal_muscle_arm', ...
    'fetal_muscle_back', 'fetal_muscle_leg', 'fetal_muscle_lower_limb', 'fetal_muscle_trunk', 'fetal_ovary', ...
    'fetal_renal_cortex', 'fetal_renal_pelvis', 'fetal_skin', 'fetal_spinal_cord', 'fetal_stomach', ...
    'fetal_testes', 'fetal_thymus', 'fibroblast', 'fibroblasts_fetal_skin_abdomen', 'fibroblasts_fetal_skin_back', ...
    'fibroblasts_fetal_skin_biceps_left', 'fibroblasts_fetal_skin_biceps_right', 'fibroblasts_fetal_skin_quadriceps_left', 'fibroblasts_fetal_skin_quadriceps_right', ...
    'fibroblasts_fetal_skin_scalp', ...
    'fibroblasts_fetal_skin_upper_back', 'gastric_mucosa', 'heart', 'h1_bmp4_derived_mesendoderm_cultured_cells', 'h1_bmp4_derived_trophoblast_cultured_cells', 'h1_cells', ...
    'h1_derived_mesenchymal_stem_cells', 'h1_derived_neuronal_progenitor_cultured_cells', 'h9_cells', 'imr90_fetal_lung_fibroblasts_cell_line', 'keratinocyte', ...
    'melanocyte', 'ovary', 'pancreas', 'placenta', 'psoas_muscle', ...
    'small_bowel_mucosa', 'testes'};

    for i = 1:length(cells)
        cell = cells{i};
        fprintf('%s\n', cell);
        
        edgelist=importdata(sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Cad/Data/edgelist/%s.txt',cell));
        edgelist = arrayfun(@num2str,edgelist,'un',0);
        nodeNames=readtable(sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Cad/Data/adj_matrix/%s_nodeNames.txt',cell));
        
        for j = 1:size(edgelist, 1)
            for k = 1:2
                edgelist(j, k) = nodeNames{str2double(edgelist(j,k)), 2};
            end
        end
        
        writecell(edgelist, sprintf('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Networks_Cad/Data/edgelist/edgelist_names/%s.txt',cell), 'Delimiter', '\t');
    end
end