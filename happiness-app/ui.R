#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    tabsetPanel(
        tabPanel("About", fluid = TRUE,
            # Application title
            titlePanel("World Happiness Report"),

            # Sidebar with a slider input for number of bins

            # Show a plot of the generated distribution
            mainPanel(
            textOutput("message")
            )
        ),
        tabPanel("World Map", fluid = TRUE,
            sidebarLayout(
                sidebarPanel(
                   uiOutput("mapButton")
                 
                ),
            
            mainPanel(
            plotOutput("dataPlot"),
            
            tableOutput("dataTable")
           ) ) ),
        
        tabPanel("Border Comparison", fluid = TRUE)
    )
))

