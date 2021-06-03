#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#

library(dplyr)
library(shiny)
library(gt)
library(maps)

countries <- read.csv("data/world-happiness-report-2021.csv") %>%
    pull(1)
countries <- sort(countries)


# Define UI for the application
shinyUI(fluidPage(
    tabsetPanel(
        tabPanel("About", fluid = TRUE,
            # Application title
            titlePanel("World Happiness Report"),
            
            # Overview Info and Map
            mainPanel(
            strong("Created by Annika Epperly, John Duffy, and Mahathi Allepally"),
            plotOutput("dataPlot"),
            h4("Overview:"),
            textOutput("message"),
            h4("More Info:"),
            a("2021 World Happiness Report", href="https://worldhappiness.report/ed/2021/"),
            p("\n"),
            a("Kaggle Dataset used for this app",
              href="https://www.kaggle.com/ajaypalsinghlo/world-happiness-report-2021"),
            p("\n")
            )
        ),
        
        ## Map of happiness distribution
        tabPanel("World Map", fluid = TRUE,
            titlePanel("Ranking the Happiness of Particpating Countries"),
            p("Select one of the six happiness report
              factors. The plot below will update with a map of the world that 
              is colored dependent on each country's rank for that factor
              Using this visualization, we can see how certain factors
              are important to the overall score and which factors have 
              a stronger correlation to a happier country. Countries that are red
              did not participate in the Gallup Poll."),
            sidebarLayout(
                sidebarPanel(
                    radioButtons("mapType",
                                 "Rank Countries By: ",
                                 c("Happiness Score" = "Ladder.score.rank",
                                   "GDP per Capita" = "Logged.GDP.per.capita.rank",
                                   "Life Expectancy" = "Healthy.life.expectancy.rank",
                                   "Social Support" = "Social.support.rank",
                                   "Freedom to make Choices" = "Freedom.to.make.life.choices.rank",
                                   "Generosity" = "Generosity.rank",
                                   "Perceptions of Corruption" = "Perceptions.of.corruption.rank"
                                 )),
                    tableOutput("rankTable")
                ),
                mainPanel(
                    plotOutput("rankPlot")
                    
                )
            )
                 
        ),
        tabPanel("Border Comparison", fluid = TRUE,
            titlePanel("Comparing the Happiness of Bordering Countries"),
            p("Select a country and then one of the seven happiness report
              factors. The plot below will update with a comparison of the
              selected country to its neighbors based on the selected factor.
              Using this visualization, we can make connections about how
              happiness changes by geographical region, as well as about
              how each of the seven factors tend to differ in similar areas."),
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
                                     "Perceptions.of.corruption")),
                    p(strong("The general region is:")),
                    textOutput("region")
                ),
                mainPanel(
                    plotOutput("borderPlot")
                )
            )
        ),
        
        ## Table showing rankings by factor
        tabPanel("Impact by Factor",
                 titlePanel("Examining the Impact of Each Factor on
                                the Total Happiness Score"),
                 p("Select a bracket, and then select one of the six happiness
                   factors to view the country ranking. This visualization 
                   will show us how much each factor impacts the overall 
                   happiness score by showing the rankings of each factor and
                   how much it contributes to the score compared to the overall
                   score and ranking. In the table below, the Contribution to 
                   Happiness Score represents the assessed number of points each
                   country gets added to the baseline Dystopia happiness score 
                   based on the results of each factor. All factors except
                   for perceptions of corruption are ranked from highest score
                   to lowest score. In the case of perceptions of corruption, 
                   a higher score translates to a lower happiness score."),
                 sidebarLayout(
                     sidebarPanel(
                         radioButtons("bracket", "Select a range:",
                                      choices = c("Top 10", "Bottom 10")),
                         radioButtons("factor_t", "Select a happiness factor:",
                                      choices = c("GDP Per Capita"="Logged.GDP.per.capita",
                                                  "Social Support"="Social.support",
                                                  "Life Expectancy"="Healthy.life.expectancy",
                                                  "Freedom to Make Life Choices"=
                                                      "Freedom.to.make.life.choices",
                                                  "Generosity"="Generosity",
                                                  "Perceptions of Corruption"=
                                                      "Perceptions.of.corruption"))
                     ),
                     mainPanel(
                         gt_output("factor_table")
                     )
                 )
        ),
        
        ## Data analysis
        tabPanel("Conclusion", fluid = TRUE,
                 titlePanel("Conclusions"),
                 mainPanel(
                     HTML(
                         paste(
                             p("A notable insight that we found relates to countries' GDP per capita and their overall happiness index. Across the world's countries, 
                          there is not a strong correlation between GDP and happiness, showing that other factors were much more important in the determination of happiness. 
                          Countries with a high GDP are often developed and industrial or small and rich and countries with a low GDP are usually developing nations 
                          that have a slow pace in terms of economic growth."),'<br/>',
                             p("Here is a table showing the GDP compared to the happiness index for a few selected countries:"),'<br/>'
                         )
                     ),
                     tableOutput("concTbl"),
                     
                     HTML(
                         paste(
                             p("There are broad implications for this insight for people. GDP in and of itself does not represent the other factors that we had examined, 
                          such as social support, freedom to make choices and generosity. In fact, countries that have a high GDP do not necessarily report a high
                          overall happiness index. Important components that contribute to the wellbeing of people include leisure time, healthcare, income equality
                          and a lowered perception of corruption. This shows that countries should strive to increase and improve social factors rather than 
                          the economic output per person, while also making sure that economic growth occurs more uniformly across the population than very few people."),'<br/>',
                             p("The quality of the data set was reasonably high and included uniform data for each country. The data set comes from an initiative
                          by the United Nations, which is generally a reliable source. There is no obvious source of bias in this set, but there is some ambiguity
                          as to how scores for elements such as social support and generosity were calculated. These scores are affected by the survey techniques
                          that were used to poll people and additionally there is no insight on which populations in these countries were able to be surveyed.
                          Certain population groups do not stand to be harmed by the data set, but rather ignored."),'<br/>',
                             p("Potential further advancements for this project include taking a closer look at the spurious relationships between happiness and the various 
                          factors in the data set by using statistics to assess the impact of each of the factors on the overall happiness index. There is 
                          also room to look at conflict and how that affects happiness for each country.")
                         )
                     )
                     
                 )
                 
        )

    )
))
