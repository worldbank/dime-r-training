#------------------------------------------------------------------------------ #
#                                                                               #
#                                    DIME                                       #
#                              Data Processing                                  #
#                         master script w/ solutions                            #
#                                                                               #
#------------------------------------------------------------------------------ #

### Setup -----------------------------------------------------------------------

# 1) setup work directory
projectFolder <- file.path("C:/Users/WB546716/Documents/GitHub/dime-r-training")
dataWorkFolder    <- file.path(projectFolder,"DataWork")
Data              <- file.path(dataWorkFolder,"DataSets")
finalData         <- file.path(Data,"Final")
rawData           <- file.path(Data,"Raw")

# 2) download the data
for (year in 2015:2017) {
  download.file(paste0("https://www.kaggle.com/unsdsn/world-happiness/downloads/", year ,".csv/2"),
                destfile = file.path(Data,paste0("Raw/WHR", year, ".csv")),
                method = "curl")
}
#### the website requires registration to download the data set, so you probably have to log in and download the files manually

dateDownloaded <- date()

# 3) load packages
library(ggplot2)
library(tibble)
library(tidyr)
library(readr)
library(purrr)
library(tidyverse)
library(dplyr)

### Exercise 1: Loading a Data Set from CSV ----------------------------------------
whr15 <- read.csv(file.path(rawData,"2015.csv"),
                  header = T,
                  stringsAsFactors = F)
whr16 <- read.csv(file.path(rawData,"2016.csv"),
                  header = T,
                  stringsAsFactors = F)
whr17 <- read.csv(file.path(rawData,"2017.csv"),
                  header = T,
                  stringsAsFactors = F)

### Exploring a Data Set -----------------------------------------------------------

### Exercise 2: exploring the data -------------------------------------------------
View(whr15)
class(whr15)
dim(whr15)
str(whr15)
head(whr15)
summary(whr15)

str(whr15)
str(whr16)
str(whr17)

### ID Variables -------------------------------------------------------------------
dim(whr15) # checking for obs and #of variables
dim(whr16)
dim(whr17)

n_distinct(whr15$Country, na.rm = TRUE)
n_distinct(whr16$Country, na.rm = TRUE)
n_distinct(whr17$Country, na.rm = TRUE)

### Exercise 3: identify the ID ----------------------------------------------------
n_distinct(whr15$Region, na.rm = TRUE)
n_distinct(whr15$Country, na.rm = TRUE)

n_distinct(whr16$Country, na.rm = TRUE) == nrow(whr16)
n_distinct(whr17$Country, na.rm = TRUE) == nrow(whr17)

### Exercise 4: compare vectors ----------------------------------------------------
setdiff(whr15$Country, whr16$Country)
setdiff(whr16$Country, whr15$Country)
setdiff(whr16$Country, whr17$Country)
setdiff(whr17$Country, whr16$Country)

### Exercise 5: replacing values ---------------------------------------------------

whr15$Country[whr15$Country == "Somaliland region"]         <- "Somaliland Region" 
whr17$Country[whr17$Country == "Hong Kong S.A.R., China"]   <- "Hong Kong" 
whr17$Country[whr17$Country == "Taiwan Province of China"]  <- "Taiwan" 
# checking for names
names(whr15)
names(whr16)

### Exercise 6: creating variables -------------------------------------------------
whr15$year <- 2015
whr16$year <- 2016
whr17$year <- 2017

### Appending and merging data sets ------------------------------------------------

### Exercise 7: append data sets ---------------------------------------------------
whr_panel <- rbind(whr15, whr16, whr17) # this one doesnt run, but we can fix it in the following steps
whr_panel <- bind_rows(whr15, whr16, whr17) # this one will run, it did exactly the same job as rbind did.

# checking for variables again
setdiff(names(whr15), names(whr16))
setdiff(names(whr16), names(whr15))
setdiff(names(whr17), names(whr16))
setdiff(names(whr16), names(whr17))

### Exercise 8: subset the data ----------------------------------------------------
regions <- select(whr16, Country, Region)
str(regions)
keepVars <-   c("Country",
                "Region",
                "year",
                "Happiness.Rank",
                "Happiness.Score",
                "Economy..GDP.per.Capita.", 
                "Family",
                "Health..Life.Expectancy.",
                "Freedom",
                "Trust..Government.Corruption.",
                "Generosity",
                "Dystopia.Residual")
whr15 <- whr15[, keepVars]
whr16 <- select(whr16, keepVars)
whr17 <- select(whr17, keepVars)

### Exercise 9: Merge -------------------------------------------------------------
whr17 <- left_join(whr17, regions) # this doesnt run, so we have to fix the dataset first

# fixing data sets
str(whr17)
any(is.na(whr17$Region)) # checking for missing
sum(is.na(whr17$Region)) # checking for #of missing
whr17$Country[is.na(whr17$Region)] # shows where the missing is
whr17$Region[whr17$Country %in% c("Mozambique", "Lesotho", "Central African Republic")] <- "Sub-Saharan Africa"
any(is.na(whr17$Region))

# rename some variables
whr17 <- rename(whr17,
                Lower.Confidence.Interval = Whisker.low,
                Upper.Confidence.Interval = Whisker.high)

names(whr15)
newnames <-  c("country",
            "region",
            "year",
            "happy_rank",
            "happy_score",
            "gdp_pc",
            "family",
            "health",
            "freedom",
            "trust_gov_corr",
            "generosity",
            "dystopia_res")
names(whr15) <- newnames

# Ordering variables
whr17 <- select(whr17, keepVars)
names(whr16) <- newnames
names(whr17) <- newnames

## Append the data
whr_panel <- rbind(whr15, whr16, whr17) # the rbind works now!In the same way "bind_rows" does.

### Saving a data set -----------------------------------------------------------

### Exercise 10: save the data set as csv ---------------------------------------
write.csv(whr_panel,
          file.path(finalData, "whr_panel.csv"),
          row.names = FALSE)

### Adding Variables ------------------------------------------------------------

### Exercise 11: Create a variable based on a formula ---------------------------
whr_panel <- 
  mutate(whr_panel,
         happy_high = happy_score > median(happy_score)) # set happy score above median

whr_panel <- 
  mutate(whr_panel,
         happy_high = happy_score > median(happy_score),
         happy_low = happy_score < median(happy_score), # set happy score below median
         dystopia_res = NULL)

### Exercise 12: turn a variable into a factor ----------------------------------
whr_panel <-
  mutate(whr_panel,
         region_cat = factor(region))

class(whr_panel$region_cat)

levels(whr_panel$region_cat)


