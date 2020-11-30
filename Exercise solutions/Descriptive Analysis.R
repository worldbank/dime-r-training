

# Setting the stage --------------------------------------------------------------------------------

# Set folder paths
projectFolder <- file.path("EDIT/THIS/FILE/PATH/dime-r-training")


dataWorkFolder    <- file.path(projectFolder,"DataWork")
Data              <- file.path(dataWorkFolder,"DataSets")
finalData         <- file.path(Data,"Final")
rawOutput         <- file.path(dataWorkFolder,"Output","Raw")

# Load packages
packages <- c("tidyverse", 
              "skimr", 
              "huxtable")
install.packages("pacman") # this package tests if a package is installed before loading, and installs it if it is not
pacman::p_load(packages, 
               character.only = TRUE)

# Load data
census <- 
  readRDS(file.path(finalData, "census.RDS"))



  summary(census)
  
  full_skim <-
    skim(census)
  
  summ_table <-
    census %>%
    skim(pop,
         popurban,
         medage,
         death,
         marriage,
         divorce)
  
  summ_table <-
    census %>%
    skim(pop,
         popurban,
         medage,
         death,
         marriage,
         divorce) %>%
    filter(skim_type == "numeric")
  
  my_stats <- 
    skim_with(numeric = sfl(N = ~ sum(!is.na(.)),
                            Mean = mean, 
                            Median = median, 
                            SD = sd, 
                            Min = min, 
                            Max = max),
              append = FALSE)
  
  census %>% 
    my_stats()
  
  oi <- 
    census %>% 
    my_stats() %>%
    select(-n_missing, -complete_rate) %>%
    yank("numeric")
  
  oi2 <- 
    census %>% 
    group_by(region) %>%
    my_stats() %>%
    select(-n_missing, -complete_rate) %>%
    yank("numeric")
  
  oi2 <- 
    census %>% 
    group_by(region) %>%
    summarise(`Number of States` = n_distinct(state),
              `Total Population` = sum(pop),
              `Average Population` = mean(pop),
              `SD of Population` = sd(pop))
  
 table(census$region)
 
 https://qiushi.rbind.io/post/introduction-to-skimr/
  
  
