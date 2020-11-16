

  library(tidyverse)
  library(skimr)
  
  census <- 
    readRDS("C:/Users/wb501238/Documents/GitHub/dime-r-training/DataWork/DataSets/Final/census.RDS")
  
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
  
  