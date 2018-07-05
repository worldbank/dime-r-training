# ------------------------------------------------------------------------------ #
#                                                                                #
#                                     DIME                                       #
#                          Descriptive Staticstics in R                          #
#                                                                                #
# ------------------------------------------------------------------------------ #


# Load data ----------------------------------------------------------------------

  lwh <- read.csv(file.path(finalData,"lwh_clean.csv"),
                  header = T)
  
# EXERCISE 1: Summary statistics ------------------------------------------------
  
# EXERCISE 2: Frequencies tables ------------------------------------------------
  
# EXERCISE 3: Stargazer ---------------------------------------------------------
  
# EXERCISE 4: Export tables to LaTeX --------------------------------------------
  
  # Vector with covariates to be kept
  covariates <- c("age_hhh",
                  "num_dependents",
                  "income_total_win",
                  "expend_food_yearly")
  # subset lwh
  lwh_simp <- lwh[, covariates]
  
  
# EXERCISE 5: Aggregate ---------------------------------------------------------
  

# EXERCISE 6: Reshape -----------------------------------------------------------
  
  
# EXERCISE 7: Create table from scratch -----------------------------------------
  
  
# EXERCISE 8: Export table to Excel ---------------------------------------------