cells = ['breast_variant_human_mammary_epithelial_cells_vhmec', 'cd19', 'cd34_primary_cells', 'cd3_primary_cells', 'cd4_primary_cells',
         'cd56_primary_cells', 'cd8_primary_cells', 'fetal_adrenal_gland', 'fetal_heart', 'fetal_intestine_large',
         'fetal_intestine_small', 'fetal_kidney', 'fetal_lung', 'fetal_muscle', 'fetal_muscle_arm',
         'fetal_muscle_back', 'fetal_muscle_leg', 'fetal_muscle_lower_limb', 'fetal_muscle_trunk', 'fetal_ovary',
         'fetal_renal_cortex', 'fetal_renal_pelvis', 'fetal_skin', 'fetal_spinal_cord', 'fetal_stomach',
         'fetal_testes', 'fetal_thymus', 'fibroblast', 'fibroblasts_fetal_skin_abdomen', 'fibroblasts_fetal_skin_back',
         'fibroblasts_fetal_skin_biceps_left', 'fibroblasts_fetal_skin_biceps_right', 'fibroblasts_fetal_skin_quadriceps_left', 'fibroblasts_fetal_skin_quadriceps_right',
         'fibroblasts_fetal_skin_scalp',
         'fibroblasts_fetal_skin_upper_back', 'gastric_mucosa', 'h1_bmp4_derived_mesendoderm_cultured_cells', 'h1_bmp4_derived_trophoblast_cultured_cells', 'h1_cells',
         'h1_derived_mesenchymal_stem_cells', 'h1_derived_neuronal_progenitor_cultured_cells', 'h9_cells', 'imr90_fetal_lung_fibroblasts_cell_line', 'keratinocyte',
         'melanocyte', 'ovary', 'pancreas', 'placenta', 'psoas_muscle',
         'small_bowel_mucosa', 'testes', 'cd14_primary_cells', 'fetal_brain', 'heart']

folder = "ohmnet_55_256d"
trial = "third_trial"

for cell in cells:
    print(cell)
    for i in ['10', '20', '30', '40', '50', '60', '70', '80', '90', '100']:
        lines = []
        embeddings = []
        IDs = []
        label = None
        result = ""

        with open('C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Data\Roadmap_Networks\\ohmnet_structure\\' + trial + "\\" + 'nodenames.txt') as f:
            lines = f.readlines()

        with open('C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Results\\node_feature_kmeans\\' + folder + '\\' + cell + '\\' + str(i) + '_cluster_kmeans.txt') as f2:
            label = f2.readline()

        with open('C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Results\\embeddings\\' + folder + "\\" + cell + "_features.emb") as f3:
            embeddings = f3.readlines()

        label = label.split(',')

        for embedding in embeddings:
            IDs.append(int(embedding.split(" ")[0]))

        IDs = sorted(IDs)

        for counter in range(len(IDs)):
            for name in lines:
                if (name.split("\t")[0] == str(IDs[counter])):
                    tabp = name.find("\t")
                    newp = name.find("\n")

                    newname = name[tabp + 1:newp]

                    result += newname + "\t" + label[counter] + "\n"

        print(counter)

        f3 = open('C:\Zhiwei_Song\Wisconsin\Roy_Lab\Zhiwei_Work\RoadMap_Networks\Results\\node_feature_kmeans\\' +
                  folder + '\\' + cell + '\\' + str(i) + "_cluster_kmeans_names.txt", "w")

        f3.write(result)

        f3.close()
