data <- read.csv("data/world-happiness-report-2021.csv")

map_outline <- map_data("world")
map_outline[map_outline=="Republic of Congo"] <- "Congo (Brazzaville)"
map_outline[map_outline=="Hong Kong"] <- "Hong Kong S.A.R. of China"
map_outline[map_outline=="Northern Cyprus"] <- "North Cyprus"
map_outline[map_outline=="Macedonia"] <- "North Macedonia"
map_outline[map_outline=="Palestine"] <- "Palestinian Territories"
map_outline[map_outline=="USA"] <- "United States"
map_outline[map_outline=="UK"] <- "United Kingdom"

add_rank <- function(data, rankee){
    name <- paste0(rankee, ".rank")
  data <- data %>% 
    arrange(desc(get(rankee))) %>%
    mutate(name = row_number())
}


add_rank(data, "Logged.GDP.per.capita")
add_rank
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


