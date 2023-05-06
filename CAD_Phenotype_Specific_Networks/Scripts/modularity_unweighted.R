#!/usr/bin/Rscript
#usage: ./script.R [.nw] [.gene-clst.txt]
args <- commandArgs(T)

cells <- c("breast_variant_human_mammary_epithelial_cells_vhmec", "cd14_primary_cells", "cd19", "cd34_primary_cells", "cd3_primary_cells", "cd4_primary_cells",
    "cd56_primary_cells", "cd8_primary_cells", "fetal_adrenal_gland", "fetal_brain", "fetal_heart", "fetal_intestine_large",
    "fetal_intestine_small", "fetal_kidney", "fetal_lung", "fetal_muscle", "fetal_muscle_arm",
    "fetal_muscle_back", "fetal_muscle_leg", "fetal_muscle_lower_limb", "fetal_muscle_trunk", "fetal_ovary",
    "fetal_renal_cortex", "fetal_renal_pelvis", "fetal_skin", "fetal_spinal_cord", "fetal_stomach",
    "fetal_testes", "fetal_thymus", "fibroblast", "fibroblasts_fetal_skin_abdomen", "fibroblasts_fetal_skin_back",
    "fibroblasts_fetal_skin_biceps_left", "fibroblasts_fetal_skin_biceps_right", "fibroblasts_fetal_skin_quadriceps_left", "fibroblasts_fetal_skin_quadriceps_right",
    "fibroblasts_fetal_skin_scalp",
    "fibroblasts_fetal_skin_upper_back", "gastric_mucosa", "heart", "h1_bmp4_derived_mesendoderm_cultured_cells", "h1_bmp4_derived_trophoblast_cultured_cells", "h1_cells",
    "h1_derived_mesenchymal_stem_cells", "h1_derived_neuronal_progenitor_cultured_cells", "h9_cells", "imr90_fetal_lung_fibroblasts_cell_line", "keratinocyte",
    "melanocyte", "ovary", "pancreas", "placenta", "psoas_muscle",
    "small_bowel_mucosa", "testes")
x <- c(10,20,30,40,50,60,70,80,90,100)

for (cell in cells){
  cat("\n")
  print(cell)
  for (k in x) {
    netfile <- sprintf("Data//edgelist//edgelist_names//%s_no_weight.txt", cell)
    clstfile <- sprintf("Results//node_feature_kmeans//%s//%s//%d_cluster_kmeans_names.txt", args[1], cell, k)
    library('igraph')
    
    net <- read.table(netfile, header=F, sep='\t')
    colnames(net) <- c("V1","V2")
    netg <- graph.data.frame(net,directed=F)
    
    clust <- read.table(clstfile,header=F,sep='\t')
    names <- clust[,1]
    clst <- as.data.frame(clust[,-1])
    row.names(clst) <- names
    
    V(netg)$comm <- clst[V(netg)$name,1]
    
    cat(sprintf("%f\n", modularity(netg,V(netg)$comm+1)))
  }
}

q(save="no")

