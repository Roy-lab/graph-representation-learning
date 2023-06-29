import pandas as pd
import numpy as np

filename = ['breast_variant_human_mammary_epithelial_cells_vhmec.txt', 'cd19.txt', 'cd34_primary_cells.txt', 'cd3_primary_cells.txt', 'cd4_primary_cells.txt', \
    'cd56_primary_cells.txt', 'cd8_primary_cells.txt', 'fetal_adrenal_gland.txt', 'fetal_heart.txt', 'fetal_intestine_large.txt', \
    'fetal_intestine_small.txt', 'fetal_kidney.txt', 'fetal_lung.txt', 'fetal_muscle.txt', 'fetal_muscle_arm.txt', \
    'fetal_muscle_back.txt', 'fetal_muscle_leg.txt', 'fetal_muscle_lower_limb.txt', 'fetal_muscle_trunk.txt', 'fetal_ovary.txt', \
    'fetal_renal_cortex.txt', 'fetal_renal_pelvis.txt', 'fetal_skin.txt', 'fetal_spinal_cord.txt', 'fetal_stomach.txt', \
    'fetal_testes.txt', 'fetal_thymus.txt', 'fibroblast.txt', 'fibroblasts_fetal_skin_abdomen.txt', 'fibroblasts_fetal_skin_back.txt', \
    'fibroblasts_fetal_skin_biceps_left.txt', 'fibroblasts_fetal_skin_biceps_right.txt', 'fibroblasts_fetal_skin_quadriceps_left.txt', 'fibroblasts_fetal_skin_quadriceps_right.txt', \
    'fibroblasts_fetal_skin_scalp.txt', \
    'fibroblasts_fetal_skin_upper_back.txt', 'gastric_mucosa.txt', 'h1_bmp4_derived_mesendoderm_cultured_cells.txt', 'h1_bmp4_derived_trophoblast_cultured_cells.txt', 'h1_cells.txt', \
    'h1_derived_mesenchymal_stem_cells.txt', 'h1_derived_neuronal_progenitor_cultured_cells.txt', 'h9_cells.txt', 'imr90_fetal_lung_fibroblasts_cell_line.txt', 'keratinocyte.txt', \
    'melanocyte.txt', 'ovary.txt', 'pancreas.txt', 'placenta.txt', 'psoas_muscle.txt', \
    'small_bowel_mucosa.txt', 'testes.txt']

for file in filename:

    data = pd.read_csv('Data//Roadmap_Networks//adj_matrix//' + file, sep=" ", header = None)

    np.fill_diagonal(data.values, np.nan)

    deletelist = []
    edge_list = data.stack().reset_index().rename(columns= {'level_0' :'From', 'level_1':'To', 0:'Weight'})
    edge_list = edge_list[edge_list["Weight"]!=0]
    print(file[:-4])
    print(len(edge_list))

    mean_weight = edge_list["Weight"].mean()

    edge_list = edge_list[edge_list["Weight"] >= mean_weight]

    no_weight = edge_list.iloc[:,:2]

    print(len(no_weight))

    no_weight.to_csv("Data//Roadmap_Networks//edgelist//" + file[:-4] + "_no_weight.edgelist", index = False, header = False, float_format='%f', sep=' ')

    