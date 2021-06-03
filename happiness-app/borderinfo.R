## This file determines data to be used in border comparisons
## for the happiness report

library(dplyr)
library(ggplot2)

borders_data <-read.csv("data/geosourcedata-countries-borders.csv")
happiness_data <- read.csv("data/world-happiness-report-2021.csv")
colnames(happiness_data)[1] <- "Country.name"

## Manipulating borders country names to match the names listed in the 
## happiness report.
borders_data[borders_data=="Bolivia (Plurinational State Of)"] <- "Bolivia"
borders_data[borders_data=="Congo"] <- "Congo (Brazzaville)"
borders_data[borders_data=="Cote d’Ivoire"] <- "Ivory Coast"
borders_data[borders_data=="Czechia"] <- "Czech Republic"
borders_data[borders_data=="Gambia (the)"] <- "Gambia"
borders_data[borders_data=="Hong Kong"] <- "Hong Kong S.A.R. of China"
borders_data[borders_data=="Iran (Islamic Republic of)"] <- "Iran"
borders_data[borders_data=="Lao People's Democratic Republic"] <- "Laos"
borders_data[borders_data=="Korea (the Republic of)"] <- "South Korea"
borders_data[borders_data=="Moldova (the Republic of)"] <- "Moldova"
borders_data[borders_data=="Cyprus"] <- "North Cyprus"
borders_data[borders_data=="Palestine, State of"] <- "Palestinian Territories"
borders_data[borders_data=="Russian Federation"] <- "Russia"
borders_data[borders_data==
               "Taiwan (Province of China)"] <- "Taiwan Province of China"
borders_data[borders_data=="Tanzania (the United Republic of)"] <- "Tanzania"
borders_data[borders_data==
               "United Kingdom of Great Britain and Northern Ireland"
             ] <- "United Kingdom"
borders_data[borders_data=="United States of America"] <- "United States"
borders_data[borders_data=="Venezuela (Bolivarian Republic of)"] <- "Venezuela"
borders_data[borders_data=="Viet Nam"] <- "Vietnam"

## Creates a list of bordering countries given the input country.
## Kosovo and Swaziland are not listed in the border data,
## so they must be manually added
bordering_choices <- function(input){
  if(input=="Kosovo") {
    borders <- c("Montenegro", "Serbia", "Albania", "North Macedonia")
  } else if(input=="Swaziland"){
    borders <- c("South Africa", "Mozambique")
  } else {
    borders <- filter(borders_data, country_name==!!input) %>%
      filter(country_border_name %in% happiness_data[,"Country.name"]) %>%
      pull("country_border_name")
  }
  return(borders)
}

## Returns a plot comparing the given country and its neighbors
## based on the given happiness index factor
bordering_plot <- function(country, factor){
  sym_factor <- rlang::sym(factor)
  countries <- bordering_choices(country)
  sort(countries)
  countries <- c(country, countries)
  temp <- filter(happiness_data, Country.name %in% countries)
  p <- ggplot(temp, aes(x=Country.name, y=!!sym_factor, fill=Country.name)) +
    geom_bar(stat="identity") + 
    theme(axis.text.x = element_text(angle = 90), legend.position = "none") +
    labs(title = paste0("Comparing the ", factor, " of ", country, " and its
    surrounding countries"), x= "Country Name", y = b_get_factor_y(factor))
  return(p)
}

## Formats the y axis label properly
b_get_factor_y <- function(factor) {
  res <- switch(factor,
                "Ladder.score" = "Happiness Index (Ability to Progress)",
                "Logged.GDP.per.capita" = "GDP Per Capita",
                "Social.support" = "Social Support",
                "Healthy.life.expectancy" = "Average Life Expectancy (yrs)",
                "Freedom.to.make.life.choices" = "Freedom of Choice", 
                "Generosity" = "Generosity Score",
                "Perceptions.of.corruption" = "Instance of Perceived Corruption")
                
  return(res)       
}

## Returns the region in which the intial country is locatedS
b_get_region <- function(country) {
  temp <- filter(happiness_data, Country.name==!!country) %>%
    pull(Regional.indicator)
  return(temp)
}

