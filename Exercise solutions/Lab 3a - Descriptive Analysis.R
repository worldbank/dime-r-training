

# Setting the stage --------------------------------------------------------------------------------

# Set folder paths
projectFolder <- "EDIT/THIS/FILE/PATH/dime-r-training"


dataWorkFolder    <- file.path(projectFolder,"DataWork")
Data              <- file.path(dataWorkFolder,"DataSets")
finalData         <- file.path(Data,"Final")
rawOutput         <- file.path(dataWorkFolder,"Output","Raw")

# Load packages
packages <- c("tidyverse", 
              "skimr", 
              "huxtable",
              "lfe")
install.packages("pacman") # this package tests if a package is installed before loading, and installs it if it is not
pacman::p_load(packages, 
               character.only = TRUE)

# Load data
census <- 
  readRDS(file.path(finalData, "census.RDS"))

# Exploring the data -------------------------------------------------------------------------------

  # Summarizing continuous variables
  summary(census)
  
  # One way tabulation of categorical variable
  table(census$region)
  
  # Two way tabulation of categorical variable
  table(census$region, census$state)
  
  # Exploring datasets with skimr
  full_skim <-
    skim(census)
  
  summ_table <-
    census %>%
    skim(pop,
         popurban,
         medage,
         death,
         marriage,
         divorce)
  
  # Show only numeric variables
  summ_table <-
    census %>%
    skim(pop,
         popurban,
         medage,
         death,
         marriage,
         divorce) %>%
    filter(skim_type == "numeric")
  
  # Use custom function for skimr
  summary_stats <- 
    skim_with(numeric = sfl(Mean = mean, # Variable name = statistic
                            Median = median, 
                            SD = sd, 
                            Min = min, 
                            Max = max),
              append = FALSE) # Remove all default statistics
  
  census %>% 
    my_stats()
  
# Export descriptive tables --------------------------------------------------------------------------
  
  # Prepare table to be exported 
  summary_stats_table <-
    census %>% 
    summary_stats() %>% # Use custom function
    yank("numeric") %>% # keep only numeric variables on the table
    select(-n_missing, -complete_rate) # remove daulft statistics 
  
  # Extract variable labels from data frame
  census_dictionary <-
    data.frame("Variable" = attributes(census)$var.labels,
               "name" = names(census))
  
  # Prepare table to be exported 
  summary_stats_table <- #<<
    summary_stats_table %>% #<<
    rename(name = skim_variable) %>% # Rename var with var names so we can merge the datasets 
    left_join(census_dictionary) %>% # Merge to variable labels
    select(-name) %>% # Keep only variable labels instead of names
    as_hux # Convert it into a huxtable object
  
  # Beautifying table
  summary_stats_table <- 
    summary_stats_table %>% 
    relocate(Variable) %>%  # Make variable labels the first column 
    set_header_rows(1, TRUE) %>% # Use stats name as table header 
    set_header_cols("Variable", TRUE)  %>%  # Use variable name as row header
    set_number_format("\"%9.0f\"" ) %>% # Don't round large numbers
    theme_basic() # Set a theme for quick formatting
  
  # Export to Excel
  quick_xlsx(summary_stats_table,
             file = file.path(rawOutput, "summary-stats-basic.xlsx"))
  
  # Export to LaTeX
  quick_latex(summary_stats_table,
              file = file.path(rawOutput, "summary-stats-basic.tex"))
  
# Aggregating observations -----------------------------------------------------------------------------
  
  region_stats <- 
    census %>% 
    group_by(region) %>%
    summarise(`Number of States` = n_distinct(state),
              `Total Population` = sum(pop),
              `Average Population` = mean(pop),
              `SD of Population` = sd(pop))
  
  region_stats_table <-
    region_stats %>%
    rename(Region = region) %>%
    as_hux %>%
    set_header_cols("Region", TRUE)  %>% 
    theme_bright()
  
  number_format(region_stats_table) <- "%6.0f"
  
  quick_xlsx(region_stats_table,
             file = file.path(rawOutput, "region-stats.xlsx"))
  
  quick_latex(region_stats_table,
              file = file.path(rawOutput, "region-stats.tex"))
  

# Running regressions -----------------------------------------------------------------------------------
  
  # Simple regression
  reg1 <-
    lm(divorce ~ pop + popurban + marriage, 
       census)
  
  summary(reg1)
  
  # Adding fixed effects
  reg2 <-
    felm(divorce ~ pop + popurban + marriage | region | 0 | 0, 
         census)
  
  summary(reg2)
  
  # Format regression table
  huxreg(reg1, reg2,
         coefs = c("Population" = "pop", # Show variable labels instead of names
                   "Urban population"  = "popurban",
                   "Number of marriages" = "marriage"),
         statistics = c("N. obs." = "nobs")) %>%
    add_rows(c("Region FE", "No", "Yes"),
             after = 7)
  