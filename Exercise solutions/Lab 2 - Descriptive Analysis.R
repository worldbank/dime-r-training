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
  
# EXERCISE 4: Export tables to LaTeX --------------------------------------------
  
  # Vector with covariates to be kept
  covariates <- c("age_hhh",
                  "num_dependents",
                  "income_total_win",
                  "expend_food_yearly")
  # subset lwh
  lwh_simp <- lwh[, covariates]
  
  # Set labels
  cov_labels <- c("Age of household head", "Number of dependents",
                  "Anual income (winsorized)", "Yearly food expediture")
  # Save table to latex
  stargazer(lwh_simp,
            covariate.labels = cov_labels,
            summary.stat = c("n", "mean", "sd", "min", "max"),
            digits = 1,
            out = file.path(rawOutput,"desc_table.tex"))
  
  
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
  
# EXERCISE 7: Create table from scratch -----------------------------------------
  
  # Label variables
  column_lab <- c("Treatment status", "2012", "2013", "2014", "2016", "2018")
  # Create table
  stargazer(year_inc_tab,
            summary = F,
            # Some extra formatting:
            covariate.labels = column_lab,
            title = "Total income by treatment status and year",
            header = F,
            digits = 1,
            rownames = F)
  
  
# EXERCISE 8: Export table to Excel ---------------------------------------------
  
  write.table(year_inc_tab,
              sep = ",",
              row.names = F,
              col.names = c("Treatment status",
                            "2012", "2013", "2014", "2016", "2018"),
              file = file.path(rawOutput, "year_inc_tab.csv"))
  
# BONUS: Export a regression table ----------------------------------------------
  
  # Run a Regression
  reg1 <- lm(expend_food_yearly ~
               income_total_win + num_dependents,
             data = lwh)
  
  # Set labels
  depvar_label <- "Yearly food expenditure (winsorized)"
  covar_labels <- c("Total income (winsorized)",
                    "Number of dependents")
  
  # Export regression table
  stargazer(reg1,
            title = "Regression table",
            dep.var.labels = depvar_label,
            covar_labels = covar_labels,
            digits = 2,
            header = F)