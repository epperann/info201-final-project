#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(ggplot2)
source("borderinfo.R")

data <- read.csv("data/world-happiness-report-2021.csv")

# Define server logic required to draw a map
shinyServer(function(input, output) {

    
    output$message <- renderText({ 
        description <- "The data we are analyzing is the world happiness report from 2021. 
            The data set uses factors such as GDP, social support, life expectancy, freedom, and corruption to 
            determine the happiness of a country’s citizens. Also, they use their own ladder score. 
            This variable is meant to be representative of how easy it is for one to improve one’s own life. 
            A country with a high ladder score makes it easier for citizens to advance themselves, 
            and lower scoring countries do the opposite."
        })
    
    output$dataPlot <- renderPlot({
        ggplot(map_data("world"), aes(long, lat, group = group)) + 
            geom_polygon(col = "black", size = .1, fill = "white") +
            coord_quickmap()
    

    })
    output$borderPlot <- renderPlot({
        bordering_plot(input$country_border, input$factor_border)})
})
