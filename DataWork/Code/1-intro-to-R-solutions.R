## R for Stata Users
## March 2023
## Exercise solutions 
## Session: Introduction to R

## Exercise 1 ====
whr <- read.csv("/path/to/data/file")
# note that this was executed through point-and-click
# during the actual session

## Exercise 2 ====
# Subset data
subset(whr, year == 2016)
# Check first 6 observations or whr
head(whr)

## Exercise 3 ====
# Subset data and store result in a new df
whr2016 <- subset(whr, year == 2016)
# Display head of new df
head(whr2016)
# Display head of origninal df
head(whr)

## Exercise 4 ====
# Create vector of strings
str_vec <- c("R", "Python", "SAS", "Excel", "Stata")
# Create string "scalar"
str_scalar <- "can be an option to"
# Concatenation
paste(str_vec[1], str_scalar, str_vec[5])

## Exercise 5 ====
# Create boolean vector
inc_below_avg <- whr$economy_gdp_per_capita < mean(whr$economy_gdp_per_capita)
# See head of vector
head(inc_below_avg)

## Exercise 6 ====
# Create new column (vector) of zeros
whr$rank_low <- 0
# Subset obs with income below average
# and replace values of rank_low with 1 for those obs
whr$rank_low[inc_below_avg] <- 1