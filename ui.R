## The UI for the shiny app
## At least three tabs, About, Map, and a second Visualization
library(shiny)

ui <- fluidPage(
  h3("Visualizing the Word Happiness Report"),
  tabsetPanel(
    tabPanel("About", fluid = TRUE,
             p("Here we'll put information about the report,
               where we got the data, as well as information about
               the project.")),
    ## Used to view happiness by region
    tabPanel("World Map", fluid = TRUE,
             sidebarLayout(
               sidebarPanel(),
               mainPanel(
                 p("Put a map here to create a visualization of all
                   the countries in the report. Filter by overall score,
                   type of criteria, etc.")
               )
             ))
  )
  
)

shinyServer(ui)