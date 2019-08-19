library(dplyr)
library(feather)
library(ggrepel)
library(igraph)
library(networkD3)
library(readr)
library(shiny)
library(stringi)
library(threejs)
library(visNetwork)

config_panel <- tabPanel("Configuration",

  radioButtons('measure_radio', 'measure', inline=TRUE, choices = c('log-dpf','t-score','dpf', 'pmi','n-pmi','pmi-sig','pmis')),
  selectInput('decade', 'Decade starting (ECCO only):', choices = c('1700'=10,'1710'=20,'1720'=30,'1730'=40,'1740'=50,'1750'=60,'1760'=70,'1770'=80,'1780'=90,'1790'=100),selected=100),
  radioButtons('distance', 'Window distance', choices = c('10','100','ratios'), inline=TRUE, selected=100),
  selectInput('dataset', 'Dataset', choices=c('ecco','all3cities','reddit-libertarian','reddit-socialism')),
  tags$hr(),
  sliderInput("conc", label = 'Concreteness threshold', min = 0, max = 5, value = 4.5, step = 0.1),
  sliderInput("label_size", label = '2D node label size', min = 0, max = 8, value = 3, step = 0.1),
  checkboxInput('use_dict', "filter concrete words?", value=FALSE),
  checkboxInput('show_labels', "show labels?", value=TRUE),
  checkboxInput("nightime",'dark backgrounds',value=FALSE),
  checkboxInput("full_rotate",'enable full rotation',value=FALSE)
)

diff_panel <-  tabPanel("Diff view",
                       sidebarLayout(
                           sidebarPanel(
                               radioButtons('measure_radio', 'measure',choices = c('log-dpf','pmi','n-pmi','pmi-sig','pmis','t-score')),
                               textInput('diff1', 'word1', value = "democracy"),
                               textInput('diff2', 'word2', value = "anarchy")
                           ),
                           mainPanel(
                               dataTableOutput('diffTable')
                           )
                       ))

table_panel <- tabPanel("Main table",
                        dataTableOutput("main_table"))

centrality_panel <- tabPanel("Centrality",
                        dataTableOutput("centralities"))
                        
sp_panel <-  tabPanel("Shortest Path",
                      scatterplotThreeOutput('sp_vis', width = '100%', height = '70vh')
)

declines_panel <-  tabPanel("Decline Plots",
                      plotOutput('declines', width = '100%', height = '70vh')
)
   

cent_declines_panel <-  tabPanel("Centrality Decline",
                            plotOutput('cent_declines', width = '100%', height = '70vh')
)

network_panel <-  tabPanel("Network 3D",
                        scatterplotThreeOutput('networkVis', width = '100%', height = '70vh')#,
)

network_panel_2d <-  tabPanel("Network 2D",
                              visNetworkOutput('networkVis2D', height = "70vh")
)

cliques_panel <-  tabPanel("Cliques 3D",
                           scatterplotThreeOutput('cliques', width = '100%', height = '70vh')#,
)
cliques_panel2D <-  tabPanel("Cliques 2D",
                             visNetworkOutput('cliques2D', width = '100%', height = '70vh')#,
)

cliques_table <-  tabPanel("Cliques Table",
                           dataTableOutput("cliquetab")
)

communities_panel <- tabPanel("Communities",
                        plotOutput("dendr"))


shinyUI(fillPage(
  sidebarLayout(
    sidebarPanel(
      textInput('term', 'Search term(s):', value = "democracy"),
      
      sliderInput("thresh", label = 'Score threshold ', min = 0, max = 4, value = 2.6, step = 0.1),
      sliderInput("rank", label = 'Rank threshold ', min = 0, max = 50, value = 20, step = 1),
      conditionalPanel(condition = "input.tabs == 'Network 3D'", 
      textInput('highlight', 'Highlight node:', value = "") ),
      
      conditionalPanel(condition = "input.tabs == 'Network 2D' || input.tabs == 'Network 3D' || input.tabs == 'Cliques 3D' || input.tabs == 'Cliques 2D'  ",
      sliderInput("prune_slide", label = "prune nodes of degree < ", min=1, max=50, value=2,step=1),
      sliderInput("network_steps", label = 'Steps from search nodes (radius of ego network)', min = 0, max = 4, value = 1, step = 1),
      selectInput("community_method", label="Community Detection Method",c('fast_greedy','leading_eigen','walktrap')),
      selectInput("2d_layout", label="2D layout",c('layout_nicely','layout_in_circle','layout_with_dh','layout_with_gem', 'layout_with_kk','layout_with_graphopt', 'layout_with_fr', 'layout_with_mds' )),
      sliderInput("clique_min", label = "Min Clique Size", min=1, max=8, value=3,step=1),
      sliderInput("cent_cutoff", label = "Centrality sample size", min=4, max=8, value=4,step=1)
      ),
      htmlOutput("data_summary"),
      htmlOutput("options_status"),
      htmlOutput("loaded_file"),
      htmlOutput("user_feedback"),
      width=2, height="100%"
      ),
    mainPanel(
    tabsetPanel(
       id = "tabs",
       config_panel,
       network_panel,
       network_panel_2d,
       diff_panel,
       sp_panel,
       centrality_panel,
       cent_declines_panel,
       cliques_panel,
       cliques_panel2D,
       cliques_table,
       communities_panel,
       declines_panel,
       table_panel
    ),width=10,height="100%"
    )
  )
))