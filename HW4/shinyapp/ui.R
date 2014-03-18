library(shiny)
#setwd("/Users/Qian/Downloads/")
#data = read.csv("winequality-white.csv",sep=";",header = T)

shinyUI(pageWithSidebar(
  headerPanel("The histograms of white wine data"),
  sidebarPanel(
    selectInput(inputId = "quality",
              label = "The quality of the wine:",
              choices = c(4:8),
              selected = 5),
    
    radioButtons("dist", "Variable:",
                 list("PH Value" = "pH",
                      "Free Sulfur Dioxide" = "free.sulfur.dioxide",
                      "Residual Sugar"="residual.sugar", 
                       "Chlorides"="chlorides"),
                 selected = "PH Value")
    ),
  mainPanel(
    tabsetPanel(
      tabPanel("Plot", plotOutput(outputId = "main_plot")), 
      tabPanel("Summary", verbatimTextOutput("summary")), 
      tabPanel("Table", tableOutput("table"))
    )
  )
  )
)