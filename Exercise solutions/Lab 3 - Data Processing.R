# ------------------------------------------------------------------------------ #
#                                                                                #
#                                     DIME                                       #
#                              Data Processing in R                              #
#                                                                                #
# ------------------------------------------------------------------------------ #

# PART 1: Set up -----------------------------------------------------------------

  # Install packages
  install.packages(c("readstata13","dplyr"),
                   dependencies = TRUE)
  
  # Load packages
  library(dplyr)
  library(readstata13)
  
  #  Set folder paths
  projectFolder  <- "YOUR/FOLDER/PATH"
  finalData <- file.path(projectFolder, "DataWork", "DataSets", "Final")
  rawlData <- file.path(projectFolder, "DataWork", "DataSets", "Raw")
  
  # Load panel data
  panel <- read.csv(file.path(rawData,"lwh_panel.csv"))

  # Load endline data
  endline <- read.dta13(file.path(rawData,"endline_data_raw.dta"))

# PART 1: Explore data ----------------------------------------------------------
  
  # See objects' formats
  class(endline)
  class(panel)
  
  # How many observations and variables?
  dim(endline)
  dim(panel)  
  
  # Variables names
  names(endline)
  
  # Data set structure
  str(panel)
  
  # Variable structure
  str(panel$treatment_hh)
  
# PART 2: ID variables ------------------------------------------------------------
  
  # Uniquely identifying?
  sum(duplicated(panel[,c("hh_code","year")]))
  # Fully identifiying?
  sum(is.na(panel$year))
  sum(is.na(panel[,c("hh_code","year")]))
  
  # Create panel ID
  panel$id <- (panel$hh_code * 10000) + panel$year
  
  # Check properties
  sum(duplicated(panel$id))
  sum(is.na(panel$id))
  
  # Here's a shortcut similar to the isid variable in Stata
  length(unique(panel$id, na.rm = TRUE)) == length(panel$id)
  
# PART 3: Drop variables ------------------------------------------------------------
    
  # List variables we want in the final data set
  id_vars          <- c("hh_code", "wave", "year", "treatment_hh",
                        "treatment_site", "site_code")
  demographic_vars <- c("gender_hhh", "age_hhh", "num_dependents", "read_and_write")
  yield_vars       <- c("w_gross_yield_a", "w_gross_yield_b")
  food_vars        <- c("expend_food_yearly", "expend_food_lastweek", "wdds_score")
  
  head(names(panel), 40)
  income_vars      <- income_vars <- names(panel)[28:37]
    
  names(panel)[grep("area", names(panel))]
  plot_area_vars   <- c("w_gross_yield_a", "w_gross_yield_b", "w_gross_yield_c")

  
  # Subset data set
  lwh <- panel[,c(id_vars,
                      demographic_vars,
                      yield_vars,
                      food_vars,
                      income_vars,
                      plot_area_vars)]
  
# PART 4: Factor variables -------------------------------------------------------------------
  
# Create a factor variable
  
  # The numeric variable
  table(lwh$gender_hhh)
  
  # Turn numeric variable into factor
  lwh$gender_hhh <- factor(lwh$gender_hhh,
                           levels = c(0, 1),
                           labels = c("Female", "Male"))
  
  # The factor variable
  table(lwh$gender_hhh)
  
# Order an existing factor variable
  
  # Unordered factor
  str(panel$wave)
  levels(panel$wave)
  table(panel$wave, panel$year)
  
  # Ordered factor
  panel$wave <- factor(panel$wave,
                       c("Baseline", "FUP1&2", "FUP3", "FUP4", "Endline"),
                       ordered = T)
  str(panel$wave)
  table(panel$wave, panel$year)
  
# PART 5: Construct indicators -------------------------------------------------------------
  
  # Aggregate income
  lwh$income_total <- rowSums(lwh[,income_vars], na.rm = TRUE)
  lwh[,income_vars] <- NULL
    
  # A customized function to winsorize observations at the 90th percentile
  winsor <- function(x) {
    x[x > quantile(x, 0.9, na.rm = T)] <- 
      quantile(x, 0.9, na.rm = T)
    return(x)
  }
  
  # Create winsorized income
  lwh$income_total_win <- winsor(lwh$income_total)
  
  # Create the trim function
  trim <- function(x) {
    x[x > quantile(x, 0.9, na.rm = T)] <- NA
    return(x)
  }
  
  # Trim income
  lwh$income_total_trim <- trim(lwh$income_total)
  
  # Compare variables
  summary(lwh$income_total)
  summary(lwh$income_total_win)
  summary(lwh$income_total_trim)
  
# PART 6: Save ------------------------------------------------------------------------------
  
  # Save the lwh data set
  write.csv(lwh,
            file.path(finalData,"lwh_clean.csv"),
            row.names = F)
  