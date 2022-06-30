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

cells <- c("network_k_10", "network_k_25", "network_k_50", "network_k_100")

# Load search filter ----
eval_type <- "modularity"
cell <- "network_k_10"

# Load file ----
load_file <- function (filename, mux){
  my_data <<- read_excel(sprintf("%s_t1_2_t2_1_muw_%s.xlsx", filename, mux), col_names = FALSE)
}

# Initialization ----
init <- function(){
  for (rownum in 1:4){
    assign(as.character(my_data[(rownum - 1)*12+1,2]), as.integer(unlist(my_data[((rownum-1)*12+1 + 1):((rownum - 1)*12+1 + 10), 2])))
    for (i in 3:ncol(my_data)){
      assign(as.character(my_data[(rownum - 1)*12+1,i]), as.numeric(unlist(my_data[((rownum-1)*12+1 + 1):((rownum - 1)*12+1 + 10), i])))
    }
    
    df <- data.frame(cluster_num, spectral_clustering, node2vec_64d, node2vec_64d_p1_q2, node2vec_64d_p1_q0.5, 
                     node2vec_64d_p2_q1, node2vec_64d_p0.5_q1,
                     node2vec_128d, node2vec_128d_p1_q0.5, node2vec_128d_p1_q2, 
                     node2vec_128d_p2_q1, node2vec_128d_p0.5_q1,
                     node2vec_256d, node2vec_256d_p1_q0.5, node2vec_256d_p1_q2,
                     node2vec_256d_p2_q1, node2vec_256d_p0.5_q1,
                     DeepWalk_64d, DeepWalk_128d, DeepWalk_256d)
    
    assign(as.character(my_data[(rownum - 1)*12+1,1]), df, envir = .GlobalEnv)
  }
}

#Bar Plot ----
bar_plotting <- function(){
  dfm <- melt(get(cell)[,c('cluster_num','node2vec_128d','node2vec_128d_p1_q0.5','node2vec_128d_p1_q2')],id.vars = 1)
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
      radioButtons(inputId = "radio2", label = "mixing parameter",
                   c("0.1" = "0.1",
                     "0.5" = "0.5"),
                   inline = TRUE),
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
                  label = 'Choose methods to compare:',
                  choice = c(
                    'node2vec_64d node2vec_64d_p1_q0.5 node2vec_64d_p1_q2 node2vec_64d_p2_q1 node2vec_64d_p0.5_q1',
                    'node2vec_128d node2vec_128d_p1_q0.5 node2vec_128d_p1_q2 node2vec_128d_p2_q1 node2vec_128d_p0.5_q1',
                    'node2vec_256d node2vec_256d_p1_q0.5 node2vec_256d_p1_q2 node2vec_256d_p2_q1 node2vec_256d_p0.5_q1',
                    'DeepWalk_64d DeepWalk_128d DeepWalk_256d',
                    'spectral_clustering node2vec_64d_p1_q0.5 DeepWalk_64d',
                    'spectral_clustering node2vec_128d_p1_q0.5 DeepWalk_128d',
                    'spectral_clustering node2vec_256d_p1_q0.5 DeepWalk_256d'
                  ))
    ),
    mainPanel(
      plotOutput("plot1"),
    )
  )
  
)

## Server ----
server <- function(input, output){
  observeEvent({input$radio1 
    input$radio2}, {
    if (input$radio1 == "modularity"){
        if (input$radio2 == "0.1"){
          load_file("modularity", "0.1")
        } else {
          load_file("modularity", "0.5")
        }
      init()
      eval_type <- input$radio1
      
      observeEvent(input$radio, {
        if (input$radio == "bar"){
          observeEvent(input$dropdown, {
            cell <- input$dropdown
            observeEvent(input$dropdown1, {
                output$plot1 <- renderPlot({
                  dfm <- melt(get(cell)[,append(strsplit(input$dropdown1, split = " ")[[1]], "cluster_num", 0)],id.vars = 1)
                  ggplot(dfm, aes(x=cluster_num, y = value)) + 
                    geom_bar(aes(fill = variable),stat = "identity",position = "dodge") +
                    scale_fill_manual(values = c("coral2", "chartreuse3", "mediumorchid3", "darkolivegreen3", "gray67")) +
                    labs(y= "Modularity Value", x= "# of Clusters") +
                    scale_x_continuous(breaks=seq(0, 100, 10)) +
                    theme(legend.text = element_text(size=15)) +
                    ggtitle(cell)
                })
            })
          })
        } else {
          observeEvent(input$dropdown, {
            cell <- input$dropdown
            observeEvent(input$dropdown1, {
                output$plot1 <- renderPlot({
                  dfm_1 <- melt(get(cell)[,append(strsplit(input$dropdown1, split = " ")[[1]], "cluster_num", 0)],id.vars = 1)
                  ggplot(dfm_1, aes(x=cluster_num, y = value)) + 
                    geom_line(aes(color = variable, linetype = variable), lwd=1) +
                    scale_color_manual(values = c("coral2", "chartreuse3", "mediumorchid3", "darkolivegreen3", "gray67")) +
                    scale_linetype_manual(values=c("solid", "solid", "solid", "solid", "solid")) +
                    labs(y= "Modularity Value", x= "# of Clusters") +
                    scale_x_continuous(breaks=seq(0, 100, 10)) +
                    theme(legend.text = element_text(size=15)) +
                    ggtitle(cell)
                })
            })
          })
        }
      })
    } else {
      if (input$radio2 == "0.1"){
        load_file("silhouette", "0.1")
      } else {
        load_file("silhouette", "0.5")
      }
      init()
      eval_type <- input$radio1
      
      observeEvent(input$radio, {
        if (input$radio == "bar"){
          observeEvent(input$dropdown, {
            cell <- input$dropdown
            observeEvent(input$dropdown1, {
                output$plot1 <- renderPlot({
                  dfm <- melt(get(cell)[,append(strsplit(input$dropdown1, split = " ")[[1]], "cluster_num", 0)],id.vars = 1)
                  ggplot(dfm, aes(x=cluster_num, y = value)) + 
                    geom_bar(aes(fill = variable),stat = "identity",position = "dodge") +
                    scale_fill_manual(values = c("coral2", "chartreuse3", "mediumorchid3", "darkolivegreen3", "gray67")) +
                    labs(y= "Silhouette Value", x= "# of Clusters") +
                    scale_x_continuous(breaks=seq(0, 100, 10)) +
                    theme(legend.text = element_text(size=15)) +
                    ggtitle(cell)
                })
            })
          })
        } else {
          observeEvent(input$dropdown, {
            cell <- input$dropdown
            observeEvent(input$dropdown1, {
                output$plot1 <- renderPlot({
                  dfm_1 <- melt(get(cell)[,append(strsplit(input$dropdown1, split = " ")[[1]], "cluster_num", 0)],id.vars = 1)
                  ggplot(dfm_1, aes(x=cluster_num, y = value)) + 
                    geom_line(aes(color = variable, linetype = variable), lwd=1.5) +
                    scale_color_manual(values = c("coral2", "chartreuse3", "mediumorchid3", "darkolivegreen3", "gray67")) +
                    scale_linetype_manual(values=c("solid", "solid", "solid", "solid", "solid")) +
                    labs(y= "Silhouette Value", x= "# of Clusters") +
                    scale_x_continuous(breaks=seq(0, 100, 10)) +
                    theme(legend.text = element_text(size=15)) +
                    ggtitle(cell)
                })
              
            })
            
          })
        }
      })
    }
  })
  
}
shinyApp(ui = ui, server = server)
