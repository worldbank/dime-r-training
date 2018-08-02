#------------------------------------------------------------------------------#
#                                                                              #
#                                     DIME                                     #
#                        Introduction to R for Stata users                     #                                     
#                               MASTER DO_FILE                                 #                           
#                                                                              #
#------------------------------------------------------------------------------#

# PURPOSE:    Set-up configurations and run scripts that are part of DIME's R 
#             Training

# NOTES:      
  
# WRITTEN BY: Luiza Cardoso de Andrade, Robert A. Marty, Leonardo Viotti

#                                                     Last modified in May 2018

# PART 0: Clear boiler plate --------------------------------------------------
  
  rm(list=ls())

# PART 1: Select sections to run ----------------------------------------------

  PACKAGES             <- 0
  Lab1                 <- 0
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
                 "RColorBrewer",
                 "sp", "rgdal", "rgeos", "raster", "velox",
                 "ggmap", "rasterVis", "leaflet",
                 "htmlwidgets", "geosphere")
  
  # If you selected the option to install packages, install them
  if (PACKAGES) {
    install.packages(packages,
                     dependencies = TRUE)
  }
  
  # Load all packages -- this is equivalent to using library(package) for each 
  # package listed before
  invisible(sapply(packages, library, character.only = TRUE))
  
# PART 3: Set folder folder paths --------------------------------------------

  #-------------#
  # Root folder #
  #-------------#
  
  # Add your username and folder path here (for Windows computers)
  # To find out what your username is, type Sys.getenv("USERNAME")
  if (Sys.getenv("USERNAME") == "Leonardo") {
    
    projectFolder  <- "C:/Users/Leonardo/Dropbox/Work/WB/Mission/Aug. 2018 Rwanda/NISR R Training"
    
  }
  
  #--------------------#
  # Project subfolders #
  #--------------------#

  Data              <- file.path(projectFolder,"DataSets")
  rawData           <- file.path(Data,"Raw")
  finalData         <- file.path(Data,"Final")
  Code              <- file.path(projectFolder,"Code")
  Doc               <- file.path(projectFolder,"Documentation")
  Output            <- file.path(projectFolder,"Output")
  rawOutput         <- file.path(Output,"Raw")
  finalOutput       <- file.path(Output,"Final")

 

# PART 4: Run selected sections -----------------------------------------------
  