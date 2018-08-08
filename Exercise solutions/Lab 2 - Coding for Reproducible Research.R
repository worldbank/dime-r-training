# ------------------------------------------------------------------------------ #
#                                                                                #
#                                     DIME                                       #
#                        Introduction to R for Stata users                       #
#                                MASTER SCRIPT                                   #
#                                                                                #
# ------------------------------------------------------------------------------ #
  
  # PURPOSE:    Set-up configurations and run scripts that are part of DIME's R
  #             Training
  
  # NOTES:      Version 2 - developed for NISR 
  
  # WRITTEN BY: Luiza Cardoso de Andrade, Leonardo Viotti
  
  #                                                     Last modified in Aug 2018

# PART 0: Clear memory --------------------------------------------------
  
  rm(list=ls())

# PART 1: Select sections to run ----------------------------------------------

  INSTALL_PACKAGES     <- 0
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
                 "RColorBrewer", "wesanderson",
                 "sp", "rgdal", "rgeos", "raster", "velox",
                 "ggmap", "rasterVis", "leaflet",
                 "htmlwidgets", "geosphere")
  
  # If you selected the option to install packages, install them
  if (INSTALL_PACKAGES) {
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
  if (Sys.getenv("USERNAME") == "luiza") {
    
    projectFolder  <- "C:/Users/luiza/Documents/GitHub/dime-r-training"
    
  }
  
  # If you're using Mac, just add your folder path, without the if statement
  
  #--------------------#
  # Project subfolders #
  #--------------------#

  rawData           <- file.path(projectFolder, "Data", "Raw")
  finalData         <- file.path(projectFolder, "Data", "Final")
  Code              <- file.path(projectFolder ,"Code")
  Output            <- file.path(projectFolder, "Output")
 

# PART 4: Run selected sections -----------------------------------------------
  