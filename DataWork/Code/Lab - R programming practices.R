 # ------------------------------------------------------------------------------ #
 #                                                                                #
 #                                DIME Analytics                                  #
 #                        Introduction to R for Stata users                       #
 #                                MASTER SCRIPT                                   #
 #                                                                                #
 # ------------------------------------------------------------------------------ #

# PURPOSE:    Set-up configurations and run scripts that are part of DIME's R
#             Training

# NOTES:      Version 5

# WRITTEN BY: Luiza Cardoso de Andrade, Robert A. Marty, Leonardo Viotti
# MODIFIED BY: Luis Eduardo San Martin

#                                                   Last modified in November 2020


# PART 1: Load packages

  
# PART 2: Set folder folder paths

  #-------------#
  # Root folder #
  #-------------#

  # Add your folder path here
  # Remember to replace backslashes ("\") with regular ones ("/")
  projectFolder  <- "YOUR/FOLDER/PATH/HERE"

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

 
# PART 3: Load data

