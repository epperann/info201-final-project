library(dplyr)
library(ggplot2)
library(gt)

happiness_data <- read.csv("data/world-happiness-report-2021.csv")
colnames(happiness_data)[1] <- "Country.name"

## Builds a gt table with the top or bottom ten
## countries ranked by the given factor
build_factor_table <- function(option, factor){
  y <- -1
  if(factor=="Perceptions.of.corruption"){
    y <- 1
  }
  if(option=="Top 10") {
    x <- y*-10
  } else {
    x <- y*10
  }
  
  sym_factor <- rlang::sym(factor)
  explained <- w_get_explained(factor)
  new_data <- arrange(happiness_data, "Ladder.score") %>%
    mutate(Happiness.rank = 1:nrow(happiness_data)) %>%
    arrange(y*!!sym_factor) %>%
    top_n(x, !!sym_factor) %>%
    select(Country.name, !!sym_factor, !!explained, Ladder.score, Happiness.rank) %>%
    rename("Contribution to Happiness Score"=!!explained)
  tab <- gt(new_data) %>%
    tab_header(title= paste0("The ", option, " Countries Ranked by ", factor)) %>%
    cols_move_to_end(Ladder.score) %>%
    cols_label(Country.name = "Country",
               Ladder.score = "Happiness Score", Happiness.rank = 
                 "Happiness Rank")
  return(tab)
}

## Returns an edited name for formatting
w_get_name <- function(factor){
  res <- switch(factor,
  "Logged.GDP.per.capita" = "GDP Per Capita",
  "Social.support" = "Social Support",
  "Healthy.life.expectancy" = "Average Life Expectancy (yrs)",
  "Freedom.to.make.life.choices" = "Freedom of Choice", 
  "Generosity" = "Generosity Score",
  "Perceptions.of.corruption" = "Instance of Perceived Corruption")
  return(res)
}

## Returns an edited name for formatting
w_get_explained <- function(factor){
  res <- switch(factor,
                "Logged.GDP.per.capita" = "Explained.by..Log.GDP.per.capita",
                "Social.support" = "Explained.by..Social.support",
                "Healthy.life.expectancy" = "Explained.by..Healthy.life.expectancy",
                "Freedom.to.make.life.choices" = 
                  "Explained.by..Freedom.to.make.life.choices", 
                "Generosity" = "Explained.by..Generosity",
                "Perceptions.of.corruption" = 
                  "Explained.by..Perceptions.of.corruption")
  return(res)
}

