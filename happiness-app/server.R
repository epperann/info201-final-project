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
library(dplyr)
library(stringr)


data <- read.csv("data/world-happiness-report-2021.csv")

map_outline <- map_data("world")
map_outline[map_outline=="Republic of Congo"] <- "Congo (Brazzaville)"
map_outline[map_outline=="Hong Kong"] <- "Hong Kong S.A.R. of China"
map_outline[map_outline=="Northern Cyprus"] <- "North Cyprus"
map_outline[map_outline=="Macedonia"] <- "North Macedonia"
map_outline[map_outline=="Palestine"] <- "Palestinian Territories"
map_outline[map_outline=="USA"] <- "United States"
map_outline[map_outline=="UK"] <- "United Kingdom"

data <- data %>% 
    arrange(desc(Logged.GDP.per.capita))%>%
    mutate(Logged.GDP.per.capita.rank = row_number())
data <- data %>% 
    arrange(desc(Healthy.life.expectancy))%>%
    mutate(Healthy.life.expectancy.rank = row_number())
data <- data %>% 
    arrange(desc(Social.support))%>%
    mutate(Social.support.rank = row_number())
data <- data %>% 
    arrange(desc(Ladder.score))%>%
    mutate(Ladder.score.rank = row_number())
data <- data %>% 
    arrange(desc(Freedom.to.make.life.choices))%>%
    mutate(Freedom.to.make.life.choices.rank = row_number())

names(data) <- str_replace_all(names(data), c(" " = "."))
data <- rename(data, region = Country.name)
map_rank <- full_join(map_outline, data, by = "region")

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
        
    output$dataTable <- renderTable({
        tableRank <- data %>%
            select(region, input$mapType)%>%
            filter(get(input$mapType) <= 10)%>%
            arrange(get(input$mapType))
        
    })
    
    output$mapButton <- renderUI({
        radioButtons("mapType",
                 "Rank Countries By: ",
                 c("Happiness Score" = "Ladder.score.rank",
                   "GDP per Capita" = "Logged.GDP.per.capita.rank",
                   "Life Expectancy" = "Healthy.life.expectancy.rank",
                   "Social Support" = "Social.support.rank",
                   "Freedom to make Choices" = "Freedom.to.make.life.choices.rank"
                ))
        })

    output$dataPlot <- renderPlot({
        ggplot(map_rank, aes(long, lat, group = group, fill = get(input$mapType))) + #fill based on rank in each factor
            geom_polygon(col = "black", size = .1) +
            scale_fill_gradient(low = "black", high = "white", guide = guide_colorbar(title.position = "top"), na.value = "red") +
            coord_quickmap() +
            labs(title = "World Map, Ranked by Input",
            x = "Longitude",
            y = "Latitude")
    })
})


