## This page calculates the data for a world map that ranks
## all of the countries

library(shiny)
library(ggplot2)
library(dplyr)
library(stringr)
library(maps)


data <- read.csv("data/world-happiness-report-2021.csv")
colnames(data)[1] <- "Country.name"
 
## Adjusts the data so country names are in sync
map_outline <- map_data("world")
map_outline[map_outline=="Republic of Congo"] <- "Congo (Brazzaville)"
map_outline[map_outline=="Hong Kong"] <- "Hong Kong S.A.R. of China"
map_outline[map_outline=="Northern Cyprus"] <- "North Cyprus"
map_outline[map_outline=="Macedonia"] <- "North Macedonia"
map_outline[map_outline=="Palestine"] <- "Palestinian Territories"
map_outline[map_outline=="USA"] <- "United States"
map_outline[map_outline=="UK"] <- "United Kingdom"

## Adds a column that ranks countries based on each factor
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
data <- data %>% 
  arrange(desc(Generosity))%>%
  mutate(Generosity.rank = row_number())
data <- data %>% 
  arrange(desc(Perceptions.of.corruption))%>%
  mutate(Perceptions.of.corruption.rank = row_number())

## Joins the map data with the happiness report data
names(data) <- str_replace_all(names(data), c(" " = "."))
data <- rename(data, region = Country.name)
map_rank <- full_join(map_outline, data, by = "region")

    ##Creates a table with the top ten of a given factor
  rankingTable <- function(factor){
    tableRank <- data %>%
      select(region, factor)%>%
      filter(get(factor) <= 10)%>%
      arrange(get(factor))
    tableRank<- rename(tableRank, Country = region)
  }
  
  
  ## Creates a plot that fills dependent on each countries rank fora  given factor
  rankingPlot <- function(factor){
    newFactor <- str_replace_all(toString(factor), c("." = " "))
    ggplot(map_rank, aes(long, lat, group = group, fill = get(factor))) + #fill based on rank in each factor
      geom_polygon(col = "black", size = .1) +
      scale_fill_gradient(low = "black", high = "white", guide = guide_colorbar(title.position = "top"), na.value = "red") +
      coord_quickmap() +
      labs(title = "World Map, Ranked by Gallup Poll Factors",
           x = "Longitude",
           y = "Latitude",
           fill = "Ranking")
  }
  


