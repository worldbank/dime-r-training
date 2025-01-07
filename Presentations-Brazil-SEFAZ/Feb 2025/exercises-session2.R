# Data
small_business_2019     <- read.csv("data/small_business_2019.csv")
small_business_2019_age <- read.csv("data/small_business_2019_age.csv")

# Exercise 3
library(dplyr)

# Exercise 5
temp1 <- filter(small_business_2019, region == "Tbilisi")
temp2 <- arrange(temp1, -income)
df_tbilisi_50 <- filter(temp2, row_number() <= 50)

# Exercise 6
temp1 <- select(small_business_2019, modified_id, income)
temp2 <- inner_join(temp1, small_business_2019_age, by = "modified_id")
temp3 <- filter(temp2, age > 5)
total_income <- colSums(select(temp3, income))
