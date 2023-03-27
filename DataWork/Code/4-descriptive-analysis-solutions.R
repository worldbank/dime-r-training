## R for Stata Users
## March 2023
## Exercise solutions
## Session: Descriptive analysis

## Loading libraries ====
library(here)
library(tidyverse)
library(modelsummary)
library(fixest)
library(janitor)
library(huxtable)
library(openxlsx)

## Exercise 1 ====
summary(census)

## Exercise 2-3 ====
summary(census$pop)

## Exercise 4 ====
# Variable region
census %>% 
  tabyl(region)
# Variables state and region
census %>%
  tabyl(state, region)

## Exercise 5 ====
datasummary_skim(census)

## Exercise 6 ====
datasummary(
  pop + death + marriage + divorce ~ N + Mean + SD + Median + Min + Max,
  data = census
)

## Exercise 7-8 ====
reg1 <-
  lm(
    divorce ~ pop + popurban + marriage,
    census
  )

## Exercise 9-10 ====
reg2 <-
  feols(
    divorce ~ pop + popurban + marriage | region,
    census,
    se = "iid"
  )
summary(reg2)

## Exercise 11 ====
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