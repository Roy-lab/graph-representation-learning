
mean_list = []
cells = ['breast_variant_human_mammary_epithelial_cells_vhmec', 'cd19', 'cd34_primary_cells', 'cd3_primary_cells', 'cd4_primary_cells', \
         'cd56_primary_cells', 'cd8_primary_cells', 'fetal_adrenal_gland', 'fetal_heart', 'fetal_intestine_large',\
         'fetal_intestine_small', 'fetal_kidney', 'fetal_lung', 'fetal_muscle', 'fetal_muscle_arm',\
         'fetal_muscle_back', 'fetal_muscle_leg', 'fetal_muscle_lower_limb', 'fetal_muscle_trunk', 'fetal_ovary',\
         'fetal_renal_cortex', 'fetal_renal_pelvis', 'fetal_skin', 'fetal_spinal_cord', 'fetal_stomach',\
         'fetal_testes', 'fetal_thymus', 'fibroblast', 'fibroblasts_fetal_skin_abdomen', 'fibroblasts_fetal_skin_back',\
         'fibroblasts_fetal_skin_biceps_left', 'fibroblasts_fetal_skin_biceps_right', 'fibroblasts_fetal_skin_quadriceps_left', 'fibroblasts_fetal_skin_quadriceps_right',\
         'fibroblasts_fetal_skin_scalp',\
         'fibroblasts_fetal_skin_upper_back', 'gastric_mucosa', 'h1_bmp4_derived_mesendoderm_cultured_cells', 'h1_bmp4_derived_trophoblast_cultured_cells', 'h1_cells',\
         'h1_derived_mesenchymal_stem_cells', 'h1_derived_neuronal_progenitor_cultured_cells', 'h9_cells', 'imr90_fetal_lung_fibroblasts_cell_line', 'keratinocyte',\
         'melanocyte', 'ovary', 'pancreas', 'placenta', 'psoas_muscle',\
         'small_bowel_mucosa', 'testes', 'cd14_primary_cells', 'fetal_brain', 'heart']

for cell in cells:
    print(cell)
    node_occ = []
    with open('/mnt/dv/wid/projects3/Roy-enhancer-promoter/RMEC/Graph_Diffusion/Scripts/ArboretumHiC/Muscari_Version/muscari/regular_graphs/Autismspectrumdisorderorschizophrenia/subnetwork_' + cell + '.txt') as f:
        lines = f.readlines()
        
    for line in lines:
        node_occ.append(line.split("\t")[0])
        
    unique = sorted(set(node_occ))
    
    frequency = [node_occ.count(x) for x in unique]
    
    mean_list.append(sum(frequency) / len(frequency))

mean_val = sum(mean_list) / len(mean_list)
variance = sum([((x - mean_val) ** 2) for x in mean_list]) / len(mean_list)
res = variance ** 0.5

print()
print("mean: " + str(mean_val))
print("std: " + str(res))