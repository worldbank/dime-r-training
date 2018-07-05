# ------------------------------------------------------------------------------ #
#                                                                                #
#                                     DIME                                       #
#                              Data Visualization                                #
#                                                                                #
# ------------------------------------------------------------------------------ #

# Set up -------------------------------------------------------------------------
  
  # Install packages
  install.packages(c("ggplot2","plotly"),
                   dependencies = TRUE)

  # Load packages
  library(ggplot2)
  library(plotly)

  # Set file paths
  projectFolder <- "YOUR/FOLDER/PATH"
  finalData <- file.path(projectFolder,
                         "DataWork","DataSets","Final")
  
  # Load LWH data
  lwh <- read.csv(file.path(finalData,"lwh_clean.csv"),
                  header = T)
  
  # Subset data
  covariates <- c("age_hhh",
                  "num_dependents",
                  "income_total_trim",
                  "expend_food_yearly",
                  "w_area_plots_a")
  lwh_simp <- lwh[,covariates]

# EXERCISE 1: Plot a whole data set -----------------------------------------------
  
  plot(lwh_simp)
  
# EXERCISE 2: Create a histogram --------------------------------------------------
  
  hist(lwh_simp$w_area_plots_a, 
       col = "green")
  
# EXERCISE 3: Create a boxplot ----------------------------------------------------
  
  boxplot(lwh_simp$expend_food_yearly ~ lwh_simp$num_dependents)
  
# EXERCISE 4: ggpplot -------------------------------------------------------------
  
  ggplot(data = lwh,
         aes(y = w_area_plots_b,
             x = w_gross_yield_b)) +
    geom_point()
  
# EXERCISE 5: Plot an aggregated data set -----------------------------------------
  
  # Aggregate anual income by year
  anualInc <-
    aggregate(x = lwh["income_total_trim"], # data.frame
              by = list(year = lwh$year), #list
              FUN = mean, na.rm = T) # function
  
  # Plot income by year
  ggplot(data = anualInc,
         aes(y = income_total_trim,
             x = year)) +
    geom_line()
  
  # Aggregate anual income by year and treatment status
  anualInc <-
    aggregate(x = lwh["income_total_trim"], 
              by = list(Year = lwh$year,
                        Treatment = lwh$treatment_hh),
              FUN = mean, na.rm = T) 
  
  # Plot income by year and treatment status
  ggplot(anualIncGen,
         aes(y = income_total_win,
             x = year,
             color = treatment,
             group = treatment)) +
    geom_line() +
    geom_point()
  
# EXERCISE 6: ggplot aesthectics ---------------------------------------------------
  
  # Subset lwh to 2018 and Rwamangana 35
  lwh_s <- lwh[lwh$year == 2018 & lwh$site_code == "Rwamangana 35", ]
  
  # Simple scatter plot
  ggplot(lwh_s, aes(x = w_area_plots_a,
                    y = income_total_trim)) +
    geom_point()
  
  # Adding women's dietary score to scatter plot
  ggplot(data = lwh_s,
         aes(y = w_area_plots_a,
             x = income_total_trim,
             color = factor(wdds_score))) +
    geom_point()
  
  # Adding food expenditure as well
  ggplot(data = lwh_s,
         aes(y = w_area_plots_a,
             x = income_total_trim,
             color = factor(wdds_score),
             size = expend_food_lastweek)) +
    geom_point()
  
  # Using a continuous variable for color instead of a categorical one
  ggplot(data = lwh_s,
         aes(y = w_area_plots_a,
             x = income_total_trim,
             color = w_gross_yield_a,
             size = expend_food_lastweek)) +
    geom_point()
  
# EXERCISE 7: Labelling in ggplot ----------------------------------------------------
  
  # A properly labelled plot
  ggplot(lwh_s, aes(y = w_area_plots_a,
                    x = income_total_trim,
                    size = expend_food_lastweek,
                    color = factor(wdds_score))) +
    geom_point() +
    ggtitle("My pretty plot") +
    xlab("Total Income (Wins.)") +
    ylab("Plot area in season A (Wins.)") +
    scale_color_discrete(name = "Women's dietary diversity score") +
    scale_size_continuous(name = "Food exp. last week")
  
# EXERCISE 8: Saving a plot ----------------------------------------------------------
  
  # Open PDF graphics device
  pdf(file = file.path(rawOutput, "Example plot.pdf"))
  
  # Plot
  ggplot(data = lwh_s,
         aes(y = w_area_plots_a,
             x = income_total_trim,
             color = factor(wdds_score),
             size = expend_food_lastweek)) +
    geom_point() +
    ggtitle("My pretty plot") +
    xlab("Total Income (Wins.)") +
    ylab("Plot area in season A (Wins.)") +
    scale_color_discrete(name = "Women's dietary diversity score") +
    scale_size_continuous(name = "Food exp. last week")
  
  # Close PDF graphics device
  dev.off()
  
# BONUS EXERCISE: Interactive graph --------------------------------------------------
  
  # Store graph in interactive_plot
  interactive_plot <- ggplot(data = lwh_s,
                             aes(y = w_area_plots_a,
                                 x = income_total_trim,
                                 color = factor(wdds_score))) +
                      geom_point()
  
  # Use ggplotly to create an interactive plot
  ggplotly(interactive_plot)
  
  