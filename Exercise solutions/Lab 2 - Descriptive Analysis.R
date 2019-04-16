# ------------------------------------------------------------------------------ #
#                                                                                #
#                                     DIME                                       #
#                          Descriptive Staticstics in R                          #
#                             Exercise Solutions                                 #
#                                                                                #
# ------------------------------------------------------------------------------ #


# Set up -----------------------------------------------------------------------
  
# Install stargazer
install.packages("stargazer",
                   dependencies = TRUE)
install.packages("xlsx",
                 dependencies = TRUE)

# Load stargazer
library(stargazer)
library(tidyr)
library(xlsx)

# set work directory
projectFolder <- file.path("C:/Users/WB546716/Documents/GitHub/dime-r-training")
dataWorkFolder    <- file.path(projectFolder,"DataWork")
Data              <- file.path(dataWorkFolder,"DataSets")
finalData         <- file.path(Data,"Final")
rawOutput         <- file.path(dataWorkFolder,"Output","Raw")

# load the data set
whr <- read.csv(file.path(finalData,"whr_panel.csv"),
                  header = T)
# view data set before any descriptive analysis
View(whr)

# EXERCISE 1: Summary statistics ------------------------------------------------
  
summary(whr)
  
# EXERCISE 2: Frequencies tables ------------------------------------------------
  
# Year of data collection
table(whr$year)
  
# Number of countries per region per year
table(whr$region, whr$year)

# BONUS EXERCISE ----------------------------------------------------------------

# restrict the observations to only 2017
whr17 <- whr[whr$year == 2017,]

# table with a boolean vector
table(whr17$region,
      whr17$happy_rank > mean(whr17$happy_rank)) # whose happy rank is above average

# EXERCISE 3: Stargazer ---------------------------------------------------------
  
# A descriptive table with stargazer
stargazer(whr,
          digits = 1,
          type = "text")
  
# EXERCISE 4  : create vectors --------------------------------------------------
  
# Vector with covariates to be kept
covariates <- c("happy_score",
                "gdp_pc",
                "freedom",
                "trust_gov_corr")
# subset whr
whr_simp <- whr[, covariates]

# EXERCISE 5: EXPORT TABLES TO LATEX --------------------------------------------

# Set labels
cov_labels <- c("Happy score", "GDP per capita",
                  "Freedom", "Trust in government and corruption")

# Save table to latex
stargazer(whr_simp,
          covariate.labels = cov_labels, # formatting the table
          summary.stat = c("n", "mean", "sd", "min", "max"), # choose which stats to display
          digits = 2,
          out = file.path(rawOutput,"desc_table.tex"))
  
  
# EXERCISE 6: Aggregate ---------------------------------------------------------
  
# Aggregate happy score by region and year 
happy_table <- aggregate(happy_score ~ year + region,
                         data = whr,
                         FUN = mean)
View(happy_table)
  
# EXERCISE 7: Reshape -----------------------------------------------------------

# reshape into wide on year
happy_table <- spread(happy_table,
                      key = year,
                      value = happy_score)
View(happy_table)

# EXERCISE 8: Export the table to latex -----------------------------------------
  
stargazer(happy_table,
          summary = F,
          out = file.path(rawOutput, "happy_table.tex"), # exporting
          title = "Happy table", # formatting the table 
          digits = 1,
          rownames = F)

# EXERCISE 9: replicate the table ------------------------------------------------------------

#### Construct a duplicated df
x1 <- whr
x1$stat <- "mean"

x2 <- whr
x2$stat <- "N"

x12 <- rbind(x1,x2)

#### Collapse
happy_table2 <-
  aggregate(happy_score ~ stat +  region + year,
            data = x12,
            FUN = mean)

happy_table2 <- 
  rename(happy_table2, c("happy_score" = "value"))

#### Freq df

freqdf <- 
  as.data.frame(table(whr$region, whr$year))

#### replace values
happy_table2$value[happy_table2$stat == "N"] <- freqdf$Freq

happy_table2 <- 
  select(happy_table2, region, year, stat, value)

#### Reshape
ht_wd <- 
  spread(happy_table2, 
         key = year, 
         value = value)

#### Cosmetics

ht_wd$region[as.integer(row.names(ht_wd)) %% 2 == 0] <- "" # delete the duplicates of region names

#### Exporting the table to latex
stargazer(ht_wd, 
          summary = F,
          rownames = F) 

# EXERCISE 10: Save data frame in xlsx format -----------------------------------------

write.xlsx(happy_table,
           file = file.path(rawOutput,"happy_table.xlsx"))


  
# BONUS: Export a regression table ---------------------------------------------------

# load the data set
View(iris)

# Run a Regression
reg1 <- lm(Sepal.Length ~ Sepal.Width,
           data = iris)

# Export a regression table
depvar_label <- "Sepal Length"
covar_labels <- "Sepal Width"

stargazer(reg1,
          title = "Regression table",
          dep.var.labels=depvar_label,
          covariate.labels=covar_labels,
          digits = 2,
          out = file.path(rawOutput, "iris_regression.tex"), # exporting the table to latex
          header = F)

### multiple regression results in one table

# reg with two independent variables
reg2 <- lm(Sepal.Length ~ Sepal.Width + Petal.Length,
           data = iris)
# reg with two indep vars and species FE
reg3 <- lm(Sepal.Length ~ Sepal.Width + Petal.Length + factor(Species),
           data = iris)

depvar_label <- "Sepal Length"
covar_labels <- c("Sepal Width",
                  "Petal Length")

# formatting the table
stargazer(reg1,
          reg2,
          reg3,
          font.size = "tiny",
          title = "Regression table",
          keep = c("Spatial.Width", "Petal.Length"),
          dep.var.labels = depvar_label,
          covariate.labels = covar_labels,
          add.lines = list(c("Species FE", "No", "No", "Yes")),
          omit.stat = c("ser"),
          digits = 2,
          header = F)
  
#=============================== The end ======================================#