# Solutions for session 2 : data wrangling
# Exercise 2: Install needed packages (for this session only dplyr and tidyr)
# Note: the installation of packages only has to be done one time. 
install.packages("dplyr")
install.packages("readr") # to write csv

# Exercise 3: load libraries 
# Note: the loading of libraries has to be done in every script you will use the functions in. 
library(dplyr)

# Exercise 4: load data
# Data
# remember that the path I am using in the argument of the function is found in the file by
# right-clicking > properties > and the location of the file, you can copy and paste that
# and then, change backward slashes (\) for forward slashes (/)
department_staff_list <- read.csv("data/department_staff_list.csv")
department_staff_age <- read.csv("data/department_staff_age.csv")

# you can also to it using our point and click method. 

# Exercise 5: filter and sorting 

# step 1 filter
temp1 <- filter(department_staff_list, sex == "Female")

# step 2 sort (arrange)
department_female <- arrange(temp1, -years_of_service)
# order by years of service

# In this exercise you asked me about filtering by multiple variables so we did 

account_female <- filter(department_staff_list, department == "Controller & Accountant General" & sex == "Female")


# Exercise 6: join datasets
department_age <- left_join(department_staff_list, department_staff_age)

# Exercise 7: group by 
temp1 <- group_by(department_staff_list, department)
employees_by_department <- summarise(temp1, number = n())

# Exercise 8: save datasets (if we have time)

write.csv(employees_by_department,
          "data/employees_by_department.csv", row.names = FALSE)

write.csv(department_age,
          "data/department_staff_final.csv", row.names = FALSE)



