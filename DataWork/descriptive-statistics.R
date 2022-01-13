# Load packages ################################################################

library(here)
library(tidyverse)
library(skimr)
library(lfe)
library(huxtable)
library(openxlsx)

# Load data
census <-
  read_rds(here("DataWork",
                "DataSets", 
                "Final", 
                "census.RDS"))

# Exploring the data ###########################################################

# See summary statistics for the whole data set:
summary(census)
summary(census, 0)

# See summary statistics for a single variable:
summary(census$region)
summary(census$death)

# Frequency table using table()
table(census$region)
table(census$state, census$region)

# Now with skimr
skim(census)

# Creating custom summary statistics tables ####################################

summary_stats <-
  skim_with(numeric = sfl(Mean = mean, # Variable name = statistic
                          Median = median,
                          SD = sd,
                          Min = min,
                          Max = max),
            append = FALSE) # Remove all default statistics

summary_stats_table <-
  census %>%
  summary_stats() %>%
  yank("numeric") %>%
  select(- complete_rate) %>%
  rename(`Missings` = n_missing)

# Exporting tables #############################################################

quick_xlsx(table,
           file = here("DataWork",
                       "Output",
                       "Raw",
                       "summary-statistics.xlsx"))

## Add variable names --------------------------------------------
# Extract variable labels from data frame
# Extract variable labels from data frame
census_dictionary <-
  data.frame("Variable" = attributes(census)$var.labels,
             "name" = names(census))

summary_stats_table <-
  summary_stats_table %>%
  rename(name = skim_variable) %>% # Rename var with var names so we can merge the datasets
  left_join(census_dictionary) %>% # Merge to variable labels
  select(-name) %>% # Keep only variable labels instead of names
  as_hux # Convert it into a huxtable object

summary_stats_table <-
  summary_stats_table %>%
  relocate(Variable) %>%  # Make variable labels the first column
  set_header_rows(1, TRUE) %>% # Use stats name as table header
  set_header_cols("Variable", TRUE)  %>%  # Use variable name as row header
  set_number_format(everywhere, 2:ncol(.), "%9.0f") %>% # Don't round large numbers
  theme_basic() # Set a theme for quick formatting

quick_xlsx(summary_stats_table,
           file = here("DataWork",
                       "Output",
                       "Raw",
                       "summary-statistics-formatted.xlsx"))

# Aggregate tables ###########################################################

census_region <-
  census %>%
  group_by(region) %>%
  summarise(`Number of States` = n_distinct(state),
            `Total Population` = sum(pop))


# Run regression ######################################################

reg1 <-
  lm(divorce ~ pop + popurban + marriage,
   census)

