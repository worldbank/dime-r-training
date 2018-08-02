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
  
# EXERCISE 4:  ------------------------------------------------------------------
  
  # Vector with covariates to be kept
  covariates <- c("age_hhh",
                  "num_dependents",
                  "income_total_win",
                  "expend_food_yearly")
  # subset lwh
  lwh_simp <- lwh[, covariates]
  
  # Create vectors containing descriptives
  meanVec <- sapply(lwh_simp, mean, na.rm = T)
  sdVec <- sapply(lwh_simp, sd, na.rm = T)
  maxVec <- sapply(lwh_simp, max, na.rm = T)
  minVec <- sapply(lwh_simp, min, na.rm = T)
  
  # Combine all created vectors into a dataframe
  lwh_desc <- data.frame( Mean = meanVec,
                          StdDev = sdVec,
                          Max = maxVec,
                          Min = minVec)
  
  
# EXERCISE 4 (BONUS): :  --------------------------------------------------------
  
  
  t(
    sapply(lwh_simp, 
           function(x) {
             data.frame(N=sum(!is.na(x)), 
                        Mean= round(mean(x, na.rm = T), 2), 
                        StandDev= round(sd(x, na.rm = T), 2), 
                        Min= round(min(x, na.rm = T), 2), 
                        Max= round(max(x, na.rm = T), 2))
           }
    )
  )
  
# EXERCISE 5: Aggregate ---------------------------------------------------------
  
  # Aggregate income by year and treatment status
  year_inc_tab <-
    aggregate(x = lwh$income_total_win,
              by = list(year = lwh$year,
                        treatment = lwh$treatment_hh),
              FUN = mean)
  

# EXERCISE 6: Reshape -----------------------------------------------------------
  
  # Aggregate income by year and treatment status
  year_inc_tab <- reshape(year_inc_tab,
                          idvar = "treatment",
                          timevar = "year",
                          direction = "wide")
  
# EXERCISE 7: Names -------------------------------------------------------------
  names(year_inc_tab) <- c("Treatment Status", 2012, 2013, 2014, 2016, 2018)
  
# EXERCISE 8: Export table to Excel ---------------------------------------------
  
  write.xlsx(year_inc_tab,
              file = file.path(Output, "year_inc_tab.xlsx"),
              row.names = F)
  