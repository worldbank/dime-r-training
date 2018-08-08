# ------------------------------------------------------------------------------ #
#                                                                                #
#                                     DIME                                       #
#                          Descriptive Staticstics in R                          #
#                                                                                #
# ------------------------------------------------------------------------------ #


# Set up ----------------------------------------------------------------------
  
  # Install stargazer
  install.packages("stargazer",
                   dependencies = TRUE)
  # Load stargazer
  library(stargazer)

  lwh <- read.csv(file.path(finalData,"lwh_clean.csv"),
                  header = T)
  
# EXERCISE 1: Summary statistics ------------------------------------------------
  
  summary(lwh)
  
# EXERCISE 2: Frequencies tables ------------------------------------------------
  
  # Year of data collection
  table(lwh$year)
  
  # Gender of household head per year
  table(lwh$gender_hhh, lwh$year)
  
# EXERCISE 3: Stargazer ---------------------------------------------------------
  
  # A descriptive table with stargazer
  stargazer(lwh,
            digits = 1,
            type = "text")
  

# EXERCISE 4: Aggregate ---------------------------------------------------------
  
  # Aggregate income by year and treatment status
  year_inc_tab <-
    aggregate(x = lwh$income_total_win,
              by = list(year = lwh$year,
                        treatment = lwh$treatment_hh),
              FUN = mean)
  

# EXERCISE 5: Reshape -----------------------------------------------------------
  
  # Aggregate income by year and treatment status
  year_inc_tab <- reshape(year_inc_tab,
                          idvar = "treatment",
                          timevar = "year",
                          direction = "wide")
  
# EXERCISE 6: Names -------------------------------------------------------------
  names(year_inc_tab) <- c("Treatment Status", 2012, 2013, 2014, 2016, 2018)
  
# EXERCISE 7: Export table to Excel ---------------------------------------------
  
  write.xlsx(year_inc_tab,
              file = file.path(Output, "year_inc_tab.xlsx"),
              row.names = F)
  