# Load necessary Library ----
library("readxl")
library("dplyr")
library("tidyr")
library("tidyverse")
library("knitr")
library("ggplot2")
theme_set(theme_bw())
library("shiny")
library("shinydashboard")
library("kableExtra")
library("reshape")

# Disable Scientific Notation ----
options(scipen = 100)

# Suppressing Warning when Reading Excel File
options(warn=-1)

cells <- c("breast_variant_human_mammary_epithelial_cells_vhmec", "cd14_primary_cells", "cd19", "cd34_primary_cells", "cd3_primary_cells", 
           "cd4_primary_cells", "cd56_primary_cells", "cd8_primary_cells", "fetal_adrenal_gland", "fetal_heart", "fetal_intestine_large", 
           "fetal_intestine_small", "fetal_kidney", "fetal_lung", "fetal_muscle", "fetal_muscle_arm", "fetal_muscle_back", 
           "fetal_muscle_leg", "fetal_muscle_lower_limb", "fetal_muscle_trunk", "fetal_ovary", "fetal_renal_cortex", 
           "fetal_renal_pelvis", "fetal_skin", "fetal_spinal_cord", "fetal_stomach", "fetal_testes", "fetal_thymus", "fibroblast", 
           "fibroblasts_fetal_skin_abdomen", "fibroblasts_fetal_skin_back", "fibroblasts_fetal_skin_biceps_left", "fibroblasts_fetal_skin_biceps_right", 
           "fibroblasts_fetal_skin_quadriceps_left", "fibroblasts_fetal_skin_quadriceps_right", "fibroblasts_fetal_skin_scalp", 
           "fibroblasts_fetal_skin_upper_back", "gastric_mucosa", "h1_bmp4_derived_mesendoderm_cultured_cells", "h1_bmp4_derived_trophoblast_cultured_cells", 
           "h1_cells", "h1_derived_mesenchymal_stem_cells", "h1_derived_neuronal_progenitor_cultured_cells", "h9_cells", 
           "imr90_fetal_lung_fibroblasts_cell_line", "keratinocyte", "melanocyte", "ovary", "pancreas", "placenta", 
           "psoas_muscle", "small_bowel_mucosa", "testes")

# Load search filter ----
eval_type <- "modularity"
cell <- "breast_variant_human_mammary_epithelial_cells_vhmec"

# Load file ----
load_file <- function (filename){
  my_data <<- read_excel(paste(filename, "_index.xlsx", sep=""), col_names = FALSE)
}

# Initialization ----
init <- function(){
  for (rownum in 1:55){
    assign(as.character(my_data[(rownum - 1)*12+1,2]), as.integer(unlist(my_data[((rownum-1)*12+1 + 1):((rownum - 1)*12+1 + 10), 2])))
    for (i in 3:ncol(my_data)){
      assign(as.character(my_data[(rownum - 1)*12+1,i]), as.numeric(unlist(my_data[((rownum-1)*12+1 + 1):((rownum - 1)*12+1 + 10), i])))
    }
    
    df <- data.frame(cluster_num, spectral_clustering, node2vec_64d_p1_q1, node2vec_64d_p1_q0.5, node2vec_64d_p1_q2,
                     node2vec_128d_p1_q1, node2vec_128d_p1_q0.5, node2vec_128d_p1_q2, node2vec_256d_p1_q1, node2vec_256d_p1_q0.5,
                     node2vec_256d_p1_q2, DeepWalk_64d, DeepWalk_128d, DeepWalk_256d, Ohmnet_15_64d,
                     Ohmnet_15_128d, Ohmnet_15_256d, Ohmnet_55_64d,
                     Ohmnet_55_128d, Ohmnet_55_256d, Muscari)
    
    assign(as.character(my_data[(rownum - 1)*12+1,1]), df, envir = .GlobalEnv)
  }
}

#Bar Plot ----
bar_plotting <- function(){
  dfm <- melt(get(cell)[,c('cluster_num','node2vec_128d_p1_q1','node2vec_128d_p1_q0.5','node2vec_128d_p1_q2')],id.vars = 1)
  ggplot(dfm, aes(x=cluster_num, y = value)) + 
    geom_bar(aes(fill = variable),stat = "identity",position = "dodge") +
    labs(y= "Modularity Value", x= "# of Clusters") +
    scale_x_continuous(breaks=seq(0, 100, 10)) +
    ggtitle(cell)
}


# Shiny App ----
## UI ----

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      radioButtons(inputId = "radio1", label = "Evaluation Matrix",
                   c("Modularity" = "modularity",
                     "Silhouette" = "silhouette"),
                   inline = TRUE),
      selectInput(inputId = 'dropdown',
                  label = 'Choose the cell to display:',
                  choices = cells), 
      radioButtons(inputId = "radio", label = "Plot Type",
                            c("Bar Plot" = "bar",
                              "Line Plot" = "line"),
                            inline = TRUE),
      selectInput(inputId = 'dropdown1',
                  label = 'Choose the cell to display:',
                  choice = c(
                    'node2vec_64d_p1_q1 node2vec_64d_p1_q0.5 node2vec_64d_p1_q2',
                    'node2vec_128d_p1_q1 node2vec_128d_p1_q0.5 node2vec_128d_p1_q2',
                    'node2vec_256d_p1_q1 node2vec_256d_p1_q0.5 node2vec_256d_p1_q2',
                    'DeepWalk_64d DeepWalk_128d DeepWalk_256d',
                    'spectral_clustering node2vec_64d_p1_q1 DeepWalk_64d Ohmnet_55_64d Muscari',
                    'spectral_clustering node2vec_128d_p1_q1 DeepWalk_128d Ohmnet_55_128d Muscari',
                    'spectral_clustering node2vec_256d_p1_q1 DeepWalk_256d Ohmnet_55_256d Muscari',
                    'Ohmnet_55_64d Ohmnet_55_128d Ohmnet_55_256d'
                  ))
    ),
    mainPanel(
      plotOutput("plot1")
    )
  )
  
)

## Server ----
server <- function(input, output){
  observeEvent(input$radio1, {
    if (input$radio1 == "modularity"){
      load_file("modularity")
      init()
      eval_type <- input$radio1
      
      observeEvent(input$radio, {
        if (input$radio == "bar"){
          observeEvent(input$dropdown, {
            cell <- input$dropdown
            observeEvent(input$dropdown1, {
              if (input$dropdown1 == 'spectral_clustering node2vec_64d_p1_q1 DeepWalk_64d Ohmnet_55_64d Muscari' |
                  input$dropdown1 == 'spectral_clustering node2vec_128d_p1_q1 DeepWalk_128d Ohmnet_55_128d Muscari' |
                  input$dropdown1 =='spectral_clustering node2vec_256d_p1_q1 DeepWalk_256d Ohmnet_55_256d Muscari'){
                output$plot1 <- renderPlot({
                  dfm <- melt(get(cell)[,append(strsplit(input$dropdown1, split = " ")[[1]], "cluster_num", 0)],id.vars = 1)
                  ggplot(dfm, aes(x=cluster_num, y = value)) + 
                    geom_bar(aes(fill = variable),stat = "identity",position = "dodge") +
                    labs(y= "Modularity Value", x= "# of Clusters") +
                    scale_fill_manual(values = c("firebrick1", "gold", "chartreuse2", "blue3", "mediumorchid1")) +
                    scale_x_continuous(breaks=seq(0, 100, 10)) +
                    theme(legend.text = element_text(size=15)) +
                    ggtitle(cell)
                })
              } else {
                output$plot1 <- renderPlot({
                  dfm <- melt(get(cell)[,append(strsplit(input$dropdown1, split = " ")[[1]], "cluster_num", 0)],id.vars = 1)
                  ggplot(dfm, aes(x=cluster_num, y = value)) + 
                    geom_bar(aes(fill = variable),stat = "identity",position = "dodge") +
                    labs(y= "Modularity Value", x= "# of Clusters") +
                    scale_x_continuous(breaks=seq(0, 100, 10)) +
                    theme(legend.text = element_text(size=15)) +
                    scale_fill_manual(values = c("firebrick1", "gold", "blue3", "mediumorchid1")) +
                    ggtitle(cell)
                })
              }
            })
          })
        } else {
          observeEvent(input$dropdown, {
            cell <- input$dropdown
            observeEvent(input$dropdown1, {
              if (input$dropdown1 == 'spectral_clustering node2vec_64d_p1_q1 DeepWalk_64d Ohmnet_55_64d Muscari' |
                  input$dropdown1 == 'spectral_clustering node2vec_128d_p1_q1 DeepWalk_128d Ohmnet_55_128d Muscari' |
                  input$dropdown1 =='spectral_clustering node2vec_256d_p1_q1 DeepWalk_256d Ohmnet_55_256d Muscari'){
                output$plot1 <- renderPlot({
                  dfm_1 <- melt(get(cell)[,append(strsplit(input$dropdown1, split = " ")[[1]], "cluster_num", 0)],id.vars = 1)
                  ggplot(dfm_1, aes(x=cluster_num, y = value)) + 
                    geom_line(aes(color = variable, linetype = variable), lwd=1) +
                    scale_color_manual(values = c("firebrick1", "gold", "chartreuse2", "blue3", "mediumorchid1")) +
                    scale_linetype_manual(values=c("solid", "solid", "solid", "solid", "solid")) +
                    labs(y= "Modularity Value", x= "# of Clusters") +
                    scale_x_continuous(breaks=seq(0, 100, 10)) +
                    theme(legend.text = element_text(size=15)) +
                    geom_point(size = 3) +
                    geom_point(aes(x=7, y=get(cell)[["Muscari"]][1]), colour="purple", size = 3) +
                    ggtitle(cell)
                })
              } else {
                output$plot1 <- renderPlot({
                  dfm_1 <- melt(get(cell)[,append(strsplit(input$dropdown1, split = " ")[[1]], "cluster_num", 0)],id.vars = 1)
                  ggplot(dfm_1, aes(x=cluster_num, y = value)) + 
                    geom_line(aes(color = variable, linetype = variable), lwd=1) +
                    scale_color_manual(values = c("firebrick1", "gold", "blue3")) +
                    scale_linetype_manual(values=c("solid", "solid", "solid")) +
                    labs(y= "Modularity Value", x= "# of Clusters") +
                    scale_x_continuous(breaks=seq(0, 100, 10)) +
                    theme(legend.text = element_text(size=15)) +
                    geom_point(size = 3) +
                    ggtitle(cell)
                })
              }
            })
          })
        }
      })
    } else {
      load_file("silhouette")
      init()
      eval_type <- input$radio1
      
      observeEvent(input$radio, {
        if (input$radio == "bar"){
          observeEvent(input$dropdown, {
            cell <- input$dropdown
            observeEvent(input$dropdown1, {
              if (input$dropdown1 == 'spectral_clustering node2vec_64d_p1_q1 DeepWalk_64d Ohmnet_55_64d' |
                  input$dropdown1 == 'spectral_clustering node2vec_128d_p1_q1 DeepWalk_128d Ohmnet_55_128d' |
                  input$dropdown1 =='spectral_clustering node2vec_256d_p1_q1 DeepWalk_256d Ohmnet_55_256d'){
                output$plot1 <- renderPlot({
                  dfm <- melt(get(cell)[,append(strsplit(input$dropdown1, split = " ")[[1]], "cluster_num", 0)],id.vars = 1)
                  ggplot(dfm, aes(x=cluster_num, y = value)) + 
                    geom_bar(aes(fill = variable),stat = "identity",position = "dodge") +
                    labs(y= "Silhouette Value", x= "# of Clusters") +
                    scale_x_continuous(breaks=seq(0, 100, 10)) +
                    theme(legend.text = element_text(size=15)) +
                    scale_fill_manual(values = c("firebrick1", "gold", "chartreuse2", "blue", "mediumorchid1")) +
                    ggtitle(cell)
                })
              } else {
                output$plot1 <- renderPlot({
                  dfm <- melt(get(cell)[,append(strsplit(input$dropdown1, split = " ")[[1]], "cluster_num", 0)],id.vars = 1)
                  ggplot(dfm, aes(x=cluster_num, y = value)) + 
                    geom_bar(aes(fill = variable),stat = "identity",position = "dodge") +
                    labs(y= "Silhouette Value", x= "# of Clusters") +
                    scale_x_continuous(breaks=seq(0, 100, 10)) +
                    theme(legend.text = element_text(size=15)) +
                    scale_fill_manual(values = c("firebrick1", "gold", "blue3", "mediumorchid1")) +
                    ggtitle(cell)
                })
              }
            })
          })
        } else {
          observeEvent(input$dropdown, {
            cell <- input$dropdown
            observeEvent(input$dropdown1, {
              if (input$dropdown1 == 'spectral_clustering node2vec_64d_p1_q1 DeepWalk_64d Ohmnet_55_64d' |
                  input$dropdown1 == 'spectral_clustering node2vec_128d_p1_q1 DeepWalk_128d Ohmnet_55_128d' |
                  input$dropdown1 =='spectral_clustering node2vec_256d_p1_q1 DeepWalk_256d Ohmnet_55_256d'){
                output$plot1 <- renderPlot({
                  dfm_1 <- melt(get(cell)[,append(strsplit(input$dropdown1, split = " ")[[1]], "cluster_num", 0)],id.vars = 1)
                  ggplot(dfm_1, aes(x=cluster_num, y = value)) + 
                    geom_line(aes(color = variable, linetype = variable), lwd=1) +
                    scale_color_manual(values = c("firebrick1", "gold", "chartreuse2", "blue", "mediumorchid1")) +
                    scale_linetype_manual(values=c("solid", "solid", "solid", "solid", "solid")) +
                    labs(y= "Silhouette Value", x= "# of Clusters") +
                    scale_x_continuous(breaks=seq(0, 100, 10)) +
                    theme(legend.text = element_text(size=15)) +
                    geom_point(size = 3) +
                    geom_point(aes(x=7, y=get(cell)[["Muscari"]][1]), colour="purple", size = 3) +
                    ggtitle(cell)
                })
              } else {
                output$plot1 <- renderPlot({
                  dfm_1 <- melt(get(cell)[,append(strsplit(input$dropdown1, split = " ")[[1]], "cluster_num", 0)],id.vars = 1)
                  ggplot(dfm_1, aes(x=cluster_num, y = value)) + 
                    geom_line(aes(color = variable, linetype = variable), lwd=1) +
                    scale_color_manual(values = c("firebrick1", "gold", "blue3", "mediumorchid1")) +
                    scale_linetype_manual(values=c("solid", "solid", "solid", "solid")) +
                    labs(y= "Silhouette Value", x= "# of Clusters") +
                    scale_x_continuous(breaks=seq(0, 100, 10)) +
                    theme(legend.text = element_text(size=15)) +
                    geom_point(size = 3) +
                    ggtitle(cell)
                })
              }
              
            })
            
          })
        }
      })
    }
  })
  
}
shinyApp(ui = ui, server = server)
