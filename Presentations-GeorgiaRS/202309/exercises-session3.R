# Data
small_business_2019_all <- read.csv("data/small_business_2019_all.csv")
View(small_business_2019_all)

# Exercise 1
#install.packages("modelsummary")
#install.packages("huxtable")

# Exercise 2
df_tbilisi_50 <- filter(small_business_2019,
                        region == "Tbilisi") %>%
  arrange(-income) %>%
  filter(row_number() <= 50)

# Exercise 3
library(modelsummary)
datasummary_skim(small_business_2019_all)

# Exercise 4
datasummary(
  age + income + vat_liability ~ N + Mean + SD + Min + Max,
  small_business_2019_all
)

# Exercise 5
library(huxtable)
stats_table <- datasummary_skim(small_business_2019_all, output = "huxtable")
quick_xlsx(stats_table, file = "quick_stats.xlsx")

# Exercise 6
stats_table_custom <- stats_table %>%
  set_header_rows(1, TRUE) %>%
  set_header_cols(1, TRUE)  %>%
  set_number_format(everywhere, 2:ncol(.), "%9.0f") %>%
  set_align(1, everywhere, "center") %>%
  theme_basic()
quick_xlsx(
  stats_table_custom,
  file = "stats-custom.xlsx"
)