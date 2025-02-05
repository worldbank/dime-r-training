# Exercise for session 3: Descriptive statistics

# Exercise 1a: install packages and load them
install.packages("modelsummary")
install.packages("huxtable")
install.packages("ggplot2")
install.packages("rstudioapi")
install.packages("openxlsx")
install.packages("dplyr") 

library(modelsummary)
library(huxtable)
library(ggplot2)
library(rstudioapi)
library(openxlsx)
library(dplyr)

# Exercise 1b: download data and read it
# here you have to change it to your own path or use the point and click approach
department_staff_final <- read.csv("data/department_staff_final.csv")

# We then did the filter again, but now using the pipe
department_female <- filter(department_staff_final, sex == "Female") %>%
  arrange(years_of_service) 

# 
datasummary_skim(department_staff_final, 
                 output = "C:/Users/wb614536/Downloads/quick_summary.docx")

datasummary_skim(department_staff_final, type = "categorical")

stats_table <- datasummary_skim(department_staff, 
                                output = "huxtable")

stats_table_custom <- stats_table %>%
  theme_blue()


quick_xlsx(
  stats_table_custom,
  file = "stats-custom.xlsx"
)


