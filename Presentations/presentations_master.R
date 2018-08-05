  #------------------------------------------------------------------------------#
  
  #			Presentations Master - R Trainings
  
  #------------------------------------------------------------------------------#
  
  #------------------------------------------------------------------------------#
  #### 1. SETTINGS ####
  
  # Set warnings 
  options(warn = 0)
  
  #### Delete everything already in R memory
  # (Equivalent to clear all in Stata)
  rm(list = ls())
  
  
  #------------------------------------------------------------------------------#
  #### 2. Load packages ####
  
  library(datasets)
  library(readstata13)
  library(ggplot2)
  library(stargazer)
  
  # Spatial
  library(sp)
  library(rgdal)
  library(rgeos)
  library(raster)
  library(ggmap)
  
  
  
  #------------------------------------------------------------------------------#
  #### 3. File pahts ####
  
  # Macro paths
  if (Sys.getenv("USERNAME") == "luiza"){
    # projectFolder  <- "C:/Users/Leonardo/Documents/GitHub/dime-r-training"
    # Data           <- "C:/Users/Leonardo/Dropbox/Work/WB/Mission/Aug. 2018 Rwanda/NISR R Training/Data"  }
  }
    
  if (Sys.getenv("USERNAME") == "WB501238"){
    # projectFolder  <- "C:/Users/Leonardo/Documents/GitHub/dime-r-training"
    # Data           <- "C:/Users/Leonardo/Dropbox/Work/WB/Mission/Aug. 2018 Rwanda/NISR R Training/Data"  \
    }
  
  if (Sys.getenv("USERNAME") == "Leonardo"){
    projectFolder  <- "C:/Users/Leonardo/Documents/GitHub/dime-r-training"
    Data           <- "C:/Users/Leonardo/Dropbox/Work/WB/Mission/Aug. 2018 Rwanda/NISR R Training/Data"
  }
  
  if (Sys.getenv("USERNAME") == "WB519128"){
    # projectFolder  <- "C:/Users/Leonardo/Documents/GitHub/dime-r-training"
    # Data           <- "C:/Users/Leonardo/Dropbox/Work/WB/Mission/Aug. 2018 Rwanda/NISR R Training/Data"
    }  
    
  # Micro paths
  rawData           <- file.path(Data,"Raw")
  finalData         <- file.path(Data,"Final")
  