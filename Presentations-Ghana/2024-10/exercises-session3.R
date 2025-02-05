# Exercise for session 3: Descriptive statistics

# Exercise 1a: install packages and load them
#install.packages("modelsummary")
#install.packages("huxtable")
#install.packages("ggplot2")
#install.packages("rstudioapi")
#install.packages("openxlsx")
#install.packages("dplyr") 
library(modelsummary)
library(huxtable)
library(ggplot2)
library(rstudioapi)
library(openxlsx)
library(dplyr)

# Exercise 1b: download data and read it
department_staff <- read.csv("data/department_staff_final.csv")


# Exercise 2: filtering revised
# using the pipe
# We then did the filter again, but now using the pipe
department_female <- filter(department_staff,
                      sex == "Female") %>%
                      arrange(years_of_service)
  

# Exercise 3: quick summary statistics
# remember that this dataset is quite simple, but this becomes more relevant for 
# a dataset with a lot of information, as it allows you to gather information 
# fairly quickly. 

datasummary_skim(department_staff)

# Exercise 4: customized
datasummary(
  years_of_service ~ N + Mean + Min + Max,
  department_staff
)

# Exercise 5: export table in excel
stats_table <- datasummary_skim(department_staff, 
                                output = "huxtable")

quick_xlsx(stats_table, file = "quick_stats.xlsx")

# Exercise 6: custom output
# for this one we only did set theme blue (and bright) but 
# I leave the rest here for reference
stats_table_custom <- stats_table %>%
  set_header_rows(1, TRUE) %>%
  set_header_cols(1, TRUE)  %>%
  set_align(1, everywhere, "center") %>%
  theme_blue()
quick_xlsx(
  stats_table_custom,
  file = "stats-custom.xlsx"
)

