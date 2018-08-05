 ------------------------------------------------------------------------------ #
                                                                                #
                                     DIME                                       #
                        Introduction to R for Stata users                       #
                                MASTER SCRIPT                                   #
                                                                                #
 ------------------------------------------------------------------------------ #

# PURPOSE:    Set-up configurations and run scripts that are part of DIME's R
#             Training

# NOTES:      Version 2 - developed for NISR 

# WRITTEN BY: Luiza Cardoso de Andrade, Leonardo Viotti

#                                                     Last modified in Aug 2018

# PART 0: Clear boiler plate
  
  rm(list=ls())

# PART 1: Select sections to run 

 
# PART 2: Load packages   

  # If you selected the option to install packages, install them

  
  
  # Load all packages -- this is equivalent to using library(package) for each
  # package listed before
  library(swirl)
  library(stargazer)
  
# PART 3: Set folder folder paths 

  #-------------#
  # Root folder #
  #-------------#
  
  # Add your username and folder path here
  projectFolder  <- "C:/Users/luiza/Documents/GitHub/dime-r-training"

  #--------------------#
  # Project subfolders #
  #--------------------#

  dataWorkFolder    <- file.path(projectFolder, "DataWork")

  rawData           <- file.path(dataWorkFolder, "DataSets", "Raw")
  finalData         <- file.path(dataWorkFolder, "DataSets", "Final")
  Code              <- file.path(dataWorkFolder, "Code")
  Output            <- file.path(dataWorkFolder, "Output")

 

# PART 4: Run selected sections 