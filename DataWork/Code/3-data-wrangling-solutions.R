# R for Stata Users — Session 3 — Data Wrangling

  ## 1. Setup ----

  # install.packages("tidyverse")
  # install.packages("here")
  # install.packages("janitor")

  library(tidyverse)
  library(here)
  library(janitor)
  
  ## 2. Data Import ----
  
# EXERCISE 1
  
  whr15 <- read_csv(here("DataWork", "DataSets", "Raw", "Un WHR", "WHR2015.csv"))
  whr16 <- read_csv(here("DataWork", "DataSets", "Raw", "Un WHR", "WHR2016.csv")) 
  whr17 <- read_csv(here("DataWork", "DataSets", "Raw", "Un WHR", "WHR2017.csv"))
  
  ## 3. Data Wrangling ----
  
    ### Clean Names
  
  whr15 %>% names() # Check variable names
  
  whr15 <- whr15 %>% janitor::clean_names() # Clean names, then check again:
  
  whr15 %>% names()
  
  whr16 <- whr16 %>% janitor::clean_names()
  
  whr17 <- whr17 %>% clean_names()
  
  whr17 <- whr17 %>% # Other option is to rename the variables manually, although is way more annoying:
      rename(
          country                     = Country,
          happiness_rank              = Happiness.Rank,
          happiness_score             = Happiness.Score,
          whisker_high                = Whisker.high,
          whisker_low                 = Whisker.low,
          economy_gdp_per_capita      = Economy..GDP.per.Capita.,
          family                      = Family,
          health_life_expectancy      = Health..Life.Expectancy.,
          freedom                     = Freedom,
          generosity                  = Generosity,
          trust_government_corruption = Trust..Government.Corruption.,
          dystopia_residual           = Dystopia.Residual
      )
  
    ### Observe Data
  
  whr17 %>% glimpse()
  
  dim(whr17)    
  
# EXERCISE 2
  
  n_distinct(whr15$country, na.rm = TRUE)  
  
  n_distinct(whr15$region, na.rm = TRUE)
  
    ### Data Wrangling Proper
  
# Check which regions are in whr15
  
  whr15 %>% janitor::tabyl(region)
  
# Filter by region
  
  whr15 %>% filter(region == "Western Europe")
  
# EXERCISE 3
  
  whr15 %>% filter(region == "Eastern Asia" | region == "North America")
  
  whr15 %>% filter(region %in% c("Eastern Asia", "North America")) # Alternative to above  
  
  whr15 %>%
      filter(
          is.na(region)
      )
  
# Filter to only keep non-missing values
  
  whr15 %>%
      filter(!is.na(region)) %>%
      head(5)
  
# Creating new variables
  
  whr15 %>%
      mutate(
          hpl_le = happiness_score * health_life_expectancy
      ) %>%
      select(happiness_score, health_life_expectancy, hpl_le) %>%
      head()
  
  whr15 %>%
      mutate(
          happiness_score_6 = happiness_score > 6
      ) %>%
      tabyl(happiness_score_6)
  
  whr15 %>%
      mutate(
          happiness_score_6 = as.numeric(happiness_score > 6 & !is.na(happiness_score))
      ) %>%
      tabyl(happiness_score_6)
  
  whr15 %>%
      mutate(
          happiness_score_6 = as.numeric(happiness_score > mean(happiness_score, na.rm = TRUE))
      ) %>%
      tabyl(happiness_score_6)
  
# Grouping
  
  whr15 %>%
      group_by(region) %>%
      mutate(
          mean_hap = mean(happiness_score, na.rm = TRUE)
      ) %>%
      select(country, region, happiness_score, mean_hap)
  
  vars <- c("happiness_score", "health_life_expectancy", "trust_government_corruption")
  
  whr15 %>%
      group_by(region) %>%
      summarize(
          across(
              all_of(vars), ~ mean(.x, na.rm = TRUE)
          )
      )
  
# EXERCISE 4
  
  whr15 <- whr15 %>%
      mutate(year = 2015)
  
  whr16 <- whr16 %>%
      mutate(year = 2016)
  
  whr17 <- whr17 %>%
      mutate(year = 2017)
  
# Appending Data Frames
  
# EXERCISE 5
  
  bind_rows(whr15, whr16, whr17)
  
# EXERCISE 6
  
  regions <- read_rds(here("DataWork", "DataSets", "Raw", "Un WHR", "regions.RDS"))
  
# Merge whr17 and regions
  
  whr17 %>% names() # Check variable names
  
  regions %>% names()
  
  whr17 <- whr17 %>%
      left_join(regions, by = "country") %>%
      select(country, region, everything())
  
# Check if any countries don't have region now
  
  whr17 %>%
      filter(is.na(region))
  
# EXERCISE 7
  
  vars_to_keep <- c(
      "country", "region", "year", "happiness_rank", "happiness_score",
      "economy_gdp_per_capita", "health_life_expectancy", "freedom"
  )
  
  whr15 <- whr15 %>% select(all_of(vars_to_keep))
  
  whr16 <- whr16 %>% select(all_of(vars_to_keep))
  
  whr17 <- whr17 %>% select(all_of(vars_to_keep))
  
  whr_panel <- rbind(whr15, whr16, whr17) %>%
      select(
          country, region, year, happiness_rank, happiness_score,
          economy_gdp_per_capita, health_life_expectancy, freedom
      )
  
  whr_panel %>% head()
  
  ## 4. Data Export ----
  
# EXERCISE 8
  
  write_csv(
      whr_panel, here("DataWork", "DataSets", "Final", "whr_panel_MA.csv")
  )
  
  write_rds(
      whr_panel, here("DataWork", "DataSets", "Final", "whr_panel_MA.RDS")
  )  
  