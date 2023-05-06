cells = ['breast_variant_human_mammary_epithelial_cells_vhmec', 'cd14_primary_cells', 'cd19', 'cd34_primary_cells', 'cd3_primary_cells', \
    'cd4_primary_cells', 'cd56_primary_cells', 'cd8_primary_cells', 'fetal_adrenal_gland', 'fetal_brain', 'fetal_heart', 'fetal_intestine_large', \
    'fetal_intestine_small', 'fetal_kidney', 'fetal_lung', 'fetal_muscle', 'fetal_muscle_arm', 'fetal_muscle_back', \
    'fetal_muscle_leg', 'fetal_muscle_lower_limb', 'fetal_muscle_trunk', 'fetal_ovary', 'fetal_renal_cortex', \
    'fetal_renal_pelvis', 'fetal_skin', 'fetal_spinal_cord', 'fetal_stomach', 'fetal_testes', 'fetal_thymus', 'fibroblast', \
    'fibroblasts_fetal_skin_abdomen', 'fibroblasts_fetal_skin_back', 'fibroblasts_fetal_skin_biceps_left', 'fibroblasts_fetal_skin_biceps_right', \
    'fibroblasts_fetal_skin_quadriceps_left', 'fibroblasts_fetal_skin_quadriceps_right', 'fibroblasts_fetal_skin_scalp', \
    'fibroblasts_fetal_skin_upper_back', 'gastric_mucosa', 'heart', 'h1_bmp4_derived_mesendoderm_cultured_cells', 'h1_bmp4_derived_trophoblast_cultured_cells', \
    'h1_cells', 'h1_derived_mesenchymal_stem_cells', 'h1_derived_neuronal_progenitor_cultured_cells', 'h9_cells', \
    'imr90_fetal_lung_fibroblasts_cell_line', 'keratinocyte', 'melanocyte', 'ovary', 'pancreas', 'placenta', \
    'psoas_muscle', 'small_bowel_mucosa', 'testes']
 
for cell in cells:
    print(cell)
    nodelist = []
    result = ""
    result_node = ""
    with open('/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Network_Org/Data/edgelist/edgelist_names/' + cell + '.txt') as f:
        lines = f.readlines()
        
    for line in lines:
        if not line == "\n":
          first_node = line.split('\t')[0]
          second_node = line.split('\t')[1].split('\n')[0]
          
          if (first_node not in nodelist):
              nodelist.append(first_node)
          if (second_node not in nodelist):
              nodelist.append(second_node)
              
    nodelist.sort()
    
    for line in lines:
        if not line == "\n":
          first_node = line.split('\t')[0]
          second_node = line.split('\t')[1].split('\n')[0]
              
          result += str(nodelist.index(first_node) + 1) + "\t" + str(nodelist.index(second_node) + 1) + "\n"
          
    f1 = open("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Network_Org/Data/edgelist/" + cell + ".txt", "w")

    f1.write(result)

    f1.close()
    
    for i in range(len(nodelist)):
        result_node += str(i+1) + "\t" + nodelist[i] + "\n"
        
    f2 = open("/mnt/dv/wid/projects3/Roy-enhancer-promoter/Zhiwei_Work/RoadMap_Network_Org/Data/adj_matrix/" + cell + "_nodeNames.txt", "w")

    f2.write(result_node)

    f2.close()