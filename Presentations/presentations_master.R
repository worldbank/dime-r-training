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
  
  packages  <- c("readstata13",
                 "foreign",
                 "doBy", 
                 "broom", 
                 "dplyr",
                 "stargazer",
                 "ggplot2", 
                 "plotly", 
                 "ggrepel",
                 "RColorBrewer", 
                 "wesanderson",
                 "sp", 
                 "rgdal", 
                 "rgeos", 
                 "raster", 
                 "velox",
                 "ggmap", 
                 "rasterVis", 
                 "leaflet",
                 "htmlwidgets", 
                 "geosphere",
                 "tidyr")
  
  invisible(sapply(packages, library, character.only = TRUE))
  
  
  
  #------------------------------------------------------------------------------#
  #### 3. File pahts ####
  
  # Macro paths
  if (Sys.getenv("USERNAME") == "luiza"){
    projectFolder  <- "C:/Users/luiza/Documents/GitHub/dime-r-training"
    Data           <- "C:/Users/luiza/Dropbox/WB/NISR R Training/Data"
  }
    
  if (Sys.getenv("USERNAME") == "Leonardo"){
    projectFolder  <- "C:/Users/Leonardo/Documents/GitHub/dime-r-training"
    Data           <- "C:/Users/Leonardo/Dropbox/Work/WB/Mission/Aug. 2018 Rwanda/NISR R Training/Data"
  }

  # Micro paths
  rawData           <- file.path(Data,"Raw")
  finalData         <- file.path(Data,"Final")
  