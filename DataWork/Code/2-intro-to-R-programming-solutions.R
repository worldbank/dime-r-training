## R for Stata Users
## March 2023
## Exercise solutions 
## Session: Introduction to R programming

## Exercise 1 ====
# (no coding needed for exercise)

## Exercise 2 ====
# (no coding needed for exercise)

## Exercise 3 ====
library(here)
whr <- read.csv(here("DataWork", "DataSets", "Final", "whr_panel.csv"))
# note that this will only work if exercise 2
# was executed correctly

## Exercise 4 ====
#install.packages("dplyr") # uncomment installation if needed
#install.packages("purrr") # uncomment installation if needed
library(dply)
library(purrr)

## Exercise 5 ====
# Create dataframe
df <- data.frame(replicate(50000, sample(1:100, 400, replace=TRUE)))
# Create empty vector
col_means_loop <- c()
# Loop and append means to vector (will take a few seconds)
for (column in df){
  col_means_loop <- append(col_means_loop, mean(column))
}

## Exercise 6 ====
col_means_map <- map(df, mean)
# this will only work if you defined df in exercise 5

## Exercise 7 ====
zscore <- function(x) {
  mean <- mean(x, na.rm = TRUE)
  sd   <- sd(x, na.rm = TRUE)
  z    <- (x - mean)/sd
  return(z)
}

## Exercise 8 ====
z_scores <- whr %>%
  select(health_life_expectancy, freedom) %>%
  map(zscore)
whr$hle_st <- z_scores[[1]]
whr$freedom_st <- z_scores[[2]]
# this will only run if you created the function
# zscores() in exercise 7
