# ------------------------------------------------------------------------------ #
#                                                                                #
#                                     DIME                                       #
#                              Data Processing in R                              #
#                                                                                #
# ------------------------------------------------------------------------------ #

  # List variables we want in the final data set
  id_vars          <- c("hh_code", "wave", "year", "treatment_hh",
                        "treatment_site", "site_code")
  demographic_vars <- c("gender_hhh", "age_hhh", "num_dependents", "read_and_write")
  yield_vars       <- c("w_gross_yield_a", "w_gross_yield_b")
  food_vars        <- c("expend_food_yearly", "expend_food_lastweek", "wdds_score")
  income_vars      <- income_vars <- names(lwh_panel)[29:38]
    
  names(lwh_panel)[grep("area", names(lwh_panel))]
  plot_area_vars   <- 

  
  # Subset data set
  lwh <- lwh_panel[,c(id_vars,
                      demographic_vars,
                      yield_vars,
                      food_vars,
                      income_vars,
                      plot_area_vars)]
  
  
  # A customized function to winsorize observations at the 90th percentile
  winsor <- function(x) {
    x[x > quantile(x, 0.9, na.rm = T)] <- 
      quantile(x, 0.9, na.rm = T)
    return(x)
  }
  

  