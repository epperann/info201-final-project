#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#

library(shiny)
library(ggplot2)
library(kableExtra)
library(dplyr)

source("borderinfo.R")
source("weightinfo.R")

data <- read.csv("data/world-happiness-report-2021.csv")

Name <- c("Botswana", "United States", "Bulgaria", "Italy", "Costa Rica")
Happiness <- c("3.467", "6.951", "5.266", "6.483", "7.069")
GDP <- c("9.782", "11.023", "10.016", "10.623", "9.880")
gdpHappy <- data_frame(Name, Happiness, GDP)


# Define server logic required to draw a map
shinyServer(function(input, output) {

    ## About Page Description
    output$message <- renderText({ 
        description <- "The data we are analyzing is the World Happiness Report
        from 2021. The data is pulled from the Gallup World Poll, Lloyd's Register 
        Foundation and the Institute of Global Health Innovation. The data set 
        was taken from Kaggle. The data set uses factors such as GDP, social support, 
        life expectancy, freedom, and corruption to determine the happiness of a 
        country’s citizens. In addition, each country use their own ladder 
        score. This variable is meant to be representative of how easy it is for 
        one to improve one’s own life and therefore, happiness index. A 
        country with a high ladder score makes it easier for citizens to advance 
        themselves, and lower scoring countries do the opposite. This project 
        aims to look at how these different factors come together in various 
        ways to reflect the happiness on a global scale. In doing so, we hope to 
        emphasize the aspects of a nation's environment that contribute the most 
        to general happiness in order to promote change."
        })
    
    ## About Page Plot
    output$dataPlot <- renderPlot({
        ggplot(map_data("world"), aes(long, lat, group = group)) + 
            geom_polygon(col = "black", size = .1, fill = "white") +
            coord_quickmap()
    })
    
    ## Border Tab Plot
    output$borderPlot <- renderPlot({
        bordering_plot(input$country_border, input$factor_border)})
    
    ## Border Tab region data
    output$region <- renderText({b_get_region(input$country_border)})
    

    output$concTbl <- function(){
        gdpHappy %>% 
            kbl() %>% 
            kable_styling()
    }
    
    ## Factor Tab Table
    output$factor_table <- render_gt(build_factor_table(input$bracket, 
                                                        input$factor_t))
    
})
