 #------------------------------------------------------------------------------ #
 #                                                                               #
 #                                    DIME                                       #
 #                       Introduction to R for Stata users                       #
 #                               MASTER SCRIPT                                   #
 #                                                                               #
 #------------------------------------------------------------------------------ #

# PURPOSE:    Set-up configurations and run scripts that are part of DIME's R
#             Training

# NOTES:      Version 3

# WRITTEN BY: Luiza Cardoso de Andrade, Robert A. Marty, Leonardo Viotti

#                                                     Last modified in Dec 2018


### PART 1: Select sections to run ----------------------------------------------
# Exercise 1 
foo <- "beginner"
ls(foo)
rm(foo)
 
### PART 2: Load packages -------------------------------------------------------

  # If you selected the option to install packages, install them
  install.packages(c("stargazer", "swirl"), dependencies = TRUE)
  
  
  # Load all packages -- this is equivalent to using library(package) for each
  # package listed before
  library(swirl)

# Exercise 6 - Load all packages
library(stargazer)
library(swirl)
library(tidyverse)
library(openxlsx)
library(ggplot2)
library(plotly)

# Exercise 7 - Using loop to load all packages
packages <- c("swirl", "stargazer", "tidyverse", "openxlsx", "ggplot2", "plotly")
sapply(packages, library, character.only = TRUE)

# Exercise 8 - indentation
sapply(c(1.2, 
         2.5), 
       round)

# Exercise 9 - Use if statement to create section switch
# Variation 1
PACKAGES <- 1
if (PACKAGES == 1) {
  install.packages(packages,
                   dependencies = TRUE)
}
# Variation 2
PACKAGES <- TRUE
if (PACKAGES == TRUE) {
  install.packages(packages,dependencies = T)
}
# Variation 3
if (PACKAGES) {
  install.packages(packages,dependencies = T)
}

### PART 3: Set folder folder paths ---------------------------------------------

  #-------------#
  # Root folder #
  #-------------#
  
  # Add your username and folder path here
  projectFolder  <- "C:/Users/WB546716/Documents/GitHub/dime-r-training"

  #--------------------#
  # Project subfolders #
  #--------------------#

  dataWorkFolder    <- file.path(projectFolder,"DataWork")

  Data              <- file.path(dataWorkFolder,"DataSets")
  rawData           <- file.path(Data,"Raw")
  intData           <- file.path(Data,"Intermediate")
  finalData         <- file.path(Data,"Final")
  Code              <- file.path(dataWorkFolder,"Code")
  Doc               <- file.path(dataWorkFolder,"Documentation")
  Output            <- file.path(dataWorkFolder,"Output")
  rawOutput         <- file.path(Output,"Raw")
  finalOutput       <- file.path(Output,"Final")

 
### PART 4: Load data ---------------------------------------------------------
# Exercise 11 - load data
whr <- read.csv(file.path(finalData,"whr_panel.csv"),
                  header = T)
  
### PART 5: Run selected sections ---------------------------------------------
# Exercise 12 
source(file.path(Code, "Lab 2"),
         verbose = T,
         echo = T)
source(file.path(Code, "Lab 3"),
         verbose = T,
         echo = T)
  
### Assignment  ------------------------------------------------------------------
new.packages <- packages[!(packages %in% installed.packages()[,"Package"])]
if(length(new.packages)) {
    install.packages(new.packages)
  }