#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
countries <- read.csv("data/world-happiness-report-2021.csv") %>%
    pull(1)
sort(countries)

# Define UI for application that draws a histogram
shinyUI(fluidPage(
    tabsetPanel(
        tabPanel("About", fluid = TRUE,
            # Application title
            titlePanel("World Happiness Report"),

            # Sidebar with a slider input for number of bins

            # Show a plot of the generated distribution
            mainPanel(
            plotOutput("dataPlot"),
            textOutput("message")
            )
        ),
        tabPanel("World Map", fluid = TRUE),
        tabPanel("Border Comparison", fluid = TRUE,
            titlePanel("Comparing the Happiness of Bordering Countries"),
            sidebarLayout(
                sidebarPanel(
                    selectInput("country_border", "Select a country:",
                                 choices = countries),
                    radioButtons("factor_border", "Select a happiness factor:",
                                 choices = c("Overall Happiness Index"=
                                     "Ladder.score",
                                 "GDP Per Capita"="Logged.GDP.per.capita",
                                 "Social Support"="Social.support",
                                 "Life Expectancy"="Healthy.life.expectancy",
                                 "Freedom to Make Life Choices"=
                                     "Freedom.to.make.life.choices",
                                 "Generosity"="Generosity",
                                 "Perceptions of Corruption"=
                                     "Perceptions.of.corruption"))
                ),
                mainPanel(
                    plotOutput("borderPlot")
                )
            )
        )
    )
))
