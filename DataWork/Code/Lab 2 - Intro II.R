 ------------------------------------------------------------------------------ #
                                                                                #
                                DIME Analytics                                  #
                        Introduction to R for Stata users                       #
                                MASTER SCRIPT                                   #
                                                                                #
 ------------------------------------------------------------------------------ #

# PURPOSE:    Set-up configurations and run scripts that are part of DIME's R
#             Training

# NOTES:      Version 4

# WRITTEN BY: Luiza Cardoso de Andrade, Robert A. Marty, Leonardo Viotti

#                                                   Last modified in April 2019

# PART 1: Select sections to run 

 
# PART 2: Load packages   

  
# PART 3: Set folder folder paths 

  #-------------#
  # Root folder #
  #-------------#
  
  # Add your username and folder path here
  projectFolder  <- "C:/Users/wb501238/Documents/GitHub/dime-r-training"

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

 
# PART 4: Load data
  
 whr <- read.csv(file.path(finalData,"whr_panel.csv"), 
                 header = T)
