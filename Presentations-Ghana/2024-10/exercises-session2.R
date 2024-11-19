
# Exercise 3
# load libraries 

library(dplyr)
library(tidyr)
library(openxlsx)

# Exercise 4 
#load data

# Data
department_staff_list    <- openxlsx::read.xlsx("data/department_staff_list.xlsx")
department_staff_age <- openxlsx::read.xlsx("data/department_staff_age.xlsx")

# Exercise 5
department_female <- filter(department_staff_list, sex == "Female") %>% 
  filter(years_of_service>0)
department_female <- arrange(department_female, years_of_service)
df_tbilisi_50 <- filter(temp2, row_number() <= 50)

# Exercise 6
temp1 <- select(small_business_2019, modified_id, income)
temp2 <- inner_join(temp1, small_business_2019_age, by = "modified_id")
temp3 <- filter(temp2, age > 5)
total_income <- colSums(select(temp3, income))
