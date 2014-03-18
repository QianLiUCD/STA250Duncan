# setwd("/Users/Qian/Documents/STA_250Duncan/HW4/shinyapp")

library("shiny")
library("ggplot2")
data = read.csv("winequality-white.csv",sep=";",header = T)
data[which(data$quality==9),]$quality=8
data[which(data$quality==3),]$quality=4

shinyServer(function(input, output) {

  output$main_plot <- renderPlot({  
    df = as.data.frame(data[which(data$quality==input$quality),
                            input$dist])
    colnames(df)="Hist"
    print(
      ggplot(df, aes(x=Hist)) +
      geom_histogram(aes(y=..density..),  
                     binwidth = diff(range(data[,input$dist]))/30,
                     colour="black", fill="white") + 
      geom_density(alpha=.2, fill="#FF6666") + 
        geom_vline(aes(xintercept=mean(Hist, na.rm=T)),  
                   color="red", linetype="dashed", size=1)+
        xlim (range(data[,input$dist])[1],range(data[,input$dist])[2])
        )
  })
  output$summary <- renderPrint({
    summary(data[which(data$quality==input$quality),input$dist])
  })
  output$table <- renderTable({
    Part = data[which(data$quality==input$quality),input$dist]
    Sample = sample(1:length(Part),50)
    data.frame(Part[Sample])
  })
}
)
  