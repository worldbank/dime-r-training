# ------------------------------------------------------------------------------ #
#                                                                                #
#                                     DIME                                       #
#                        Introduction to R for Stata users                       #
#                                  MAIN SCRIPT                                   #
#                                                                                #
# ------------------------------------------------------------------------------ #

# PURPOSE:    Set-up configurations and run scripts

# NOTES:      Version 2

# WRITTEN BY: Luiza Cardoso de Andrade, Leonardo Viotti

#                                                     Last modified in Mar 2023

# PART 1: Select sections to run ----------------------------------------------

Lab2                 <- 0
Lab3                 <- 0
Lab4                 <- 0
Lab5                 <- 0
Lab6                 <- 0

# PART 2: Load packages   -----------------------------------------------------

packages  <- c("readstata13","foreign",
               "doBy", "broom", "dplyr",
               "stargazer",
               "ggplot2", "plotly", "ggrepel",
               "RColorBrewer", "wesanderson",
               "sp", "rgdal", "rgeos", "raster", "velox",
               "ggmap", "rasterVis", "leaflet",
               "htmlwidgets", "geosphere")

# If you selected the option to install packages, install them
sapply(packages, function(x) {
  if (!(x %in% installed.packages())) {
    install.packages(x, dependencies = TRUE) 
  }
}
)

# Load all packages -- this is equivalent to using library(package) for each 
# package listed before
invisible(sapply(packages, library, character.only = TRUE))

# PART 3: Set folder folder paths --------------------------------------------

#-------------#
# Root folder #
#-------------#

# Add your username and folder path here (for Windows computers)
# To find out what your username is, type Sys.getenv("USERNAME")
if (Sys.getenv("USERNAME") == "luiza") {
  
  projectFolder  <- "C:/Users/luiza/Documents/GitHub/dime-r-training"
  
}

# If you're using Mac, just add your folder path, without the if statement

#--------------------#
# Project subfolders #
#--------------------#

rawData           <- file.path(projectFolder, "Data", "Raw")
finalData         <- file.path(projectFolder, "Data", "Final")
Code              <- file.path(projectFolder ,"Codes")
Output            <- file.path(projectFolder, "Output")


# PART 4: Run selected sections -----------------------------------------------

if (Lab2 == 1) {
  source(file.path(Code, "Lab 2 - Coding for Reproducible Research"))
}
if (Lab3 == 1) {
  source(file.path(Code, "Lab 3 - Data Processing"))
}
if (Lab4 == 1) {
  source(file.path(Code, "Lab 4 - Descriptive Analysis"))
}
if (Lab5 == 1) {
  source(file.path(Code, "Lab 5 - Data Visualization"))
}
if (Lab6 == 1) {
  source(file.path(Code, "Lab 6 - Spatial Data"))
}