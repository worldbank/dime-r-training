## R for Data Analysis
## Exercise solutions
## Session: Descriptive analysis

## Install the libraries you don't have, activate each line ====
#install.packages("modelsummary") # to export easy descriptive tables
#install.packages("fixest")       # easy fixed effects regressions
#install.packages("huxtable")     # easy regression tables
#install.packages("openxlsx")     # export tables to Excel format
#install.packages("estimatr")     # backend calculations for balance tables

## Loading libraries ====
library(here)
library(tidyverse)
library(modelsummary)
library(fixest)
library(janitor)
library(huxtable)
library(openxlsx)

## Load data ====
census <-
  read_rds(
    here(
      "DataWork",
      "DataSets", 
      "Final", 
      "census.rds"
    )
  )

## Exercise 1 ====
summary(census)

## Exercise 2 ====
summary(census$pop)

## Exercise 3 ====
# One-way tabulation
census %>% 
  tabyl(region)
# Two-way tabulation
census %>%
  tabyl(state, region)

## Exercise 4 ====
datasummary_skim(census)

## Exercise 5 ====
datasummary(
  pop + death + marriage + divorce ~ N + Mean + SD + Median + Min + Max,
  data = census
)

## Exercise 6 ====
reg1 <-
  lm(
    divorce ~ pop + popurban + marriage,
    census
  )

## Exercise 7 ====
reg2 <-
  feols(
    divorce ~ pop + popurban + marriage | region,
    census,
    vcov = cluster ~ state # this defines clustered std errors by state
  )
summary(reg2)

## Exercise 8 ====
# Wrapping huxreg into a single object
huxreg_result <- huxreg(reg1, reg2)
# Exporting to Excel table
quick_xlsx(
  huxreg_result,
  file = here(
    "DataWork",
    "Output",
    "Raw",
    "regression-table.xlsx"
  )
)
# Exporting to Latex
quick_latex(
  huxreg_result,
  file = here(
    "DataWork",
    "Output",
    "Raw",
    "regression-table.tex"
  )
)
