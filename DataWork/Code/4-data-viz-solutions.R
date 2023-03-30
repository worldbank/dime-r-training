# R for Stata Users Session 7 Data visualization

  ## 1. Setup ----

# install.packages("tidyverse")
# install.packages("here")
# install.packages("janitor")
# install.packages("ggplot2)

  library(tidyverse)
  library(here)
  library(janitor)
  library(ggplot2)
  
  ## 2. Data Import ----
  
  whr_panel <- read_csv(here("DataWork", "DataSets", "Final", "whr_panel.csv"))
  
  ## 3. Exploratory Analysis ----
  
# EXERCISE 1
  
  vars <- c("economy_gdp_per_capita", "happiness_score", "health_life_expectancy", "freedom")
  
  whr_plot <- whr_panel %>%
      select(all_of(vars))
  
  plot(whr_plot)  
  
# Use of ggplot2
  
  whr_panel %>%
      ggplot() +
      geom_point(mapping = aes(x = happiness_score, y = economy_gdp_per_capita))
  
  whr_panel %>%
      ggplot(aes(x = happiness_score, y = economy_gdp_per_capita)) +
      geom_point()
  
# EXERCISE 2
  
  whr_panel %>%
      ggplot() + 
      geom_point(aes(x = freedom, y = economy_gdp_per_capita))
  
# EXERCISE 3
  
  whr_panel %>%
      ggplot(
          aes(
              x = freedom, 
              y = economy_gdp_per_capita, 
              color = as.factor(year)
          )
      ) +
      geom_point()
  
# EXERCISE 4
  
  whr_panel %>%
      ggplot(
          aes(
              x = happiness_score, y = economy_gdp_per_capita, 
              color = region
          )
      ) + 
      geom_point() +
      facet_wrap(~ region)
  
# EXERCISE 5
  
  fig <- whr_panel %>%
      ggplot(
          aes(
              x = happiness_score, y = economy_gdp_per_capita, 
              color = region
          )
      ) + 
      geom_point() +
      facet_wrap(~ region)
  
  ggsave(
      fig,
      filename = here("DataWork","Output","Raw","fig.png"),
      dpi = 750, 
      scale = 0.8,
      height = 8, 
      width = 12
  )
