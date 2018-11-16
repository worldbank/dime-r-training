#------------------------------------------------------------------------------#

#			R training - World happiness report data processing

#------------------------------------------------------------------------------#  


# Load the pacakge than contains ToothGrowth dataset
library(datasets)

# File paths

if (Sys.getenv("USERNAME") == "WB501238"){
  projectFolder  <- "C:/Users/WB501238/Documents/GitHub/dime-r-training"
  
}

if (Sys.getenv("USERNAME") == "Leonardo"){
  projectFolder  <- "C:/Users/Leonardo/Documents/GitHub/dime-r-training"
  
}

if (Sys.getenv("USERNAME") == "WB519128"){
  projectFolder <- file.path("C:/Users/WB519128/Documents/GitHub/dime-r-training")
}

# File paths
dataWorkFolder    <- file.path(projectFolder,"DataWork")

Data              <- file.path(dataWorkFolder,"DataSets")
finalData         <- file.path(Data,"Final")


#------------------------------------------------------------------------------#  
# Load CSV data
whr15 <- read.csv(file.path(Data,"Raw/WHR2015.csv"), header = T)
whr16 <- read.csv(file.path(Data,"Raw/WHR2016.csv"), header = T)
whr17 <- read.csv(file.path(Data,"Raw/WHR2017.csv"), header = T)


#### Fix countries and regions in 2017
whr17$Region <- ""

whr17$Country <- as.character(whr17$Country)
whr17$Country[whr17$Country == "Taiwan Province of China"] <- "Taiwan" 
whr17$Country[whr17$Country == "Hong Kong S.A.R., China"] <- "Hong Kong" 

whr17$Region <- whr16$Region[match(whr17$Country, whr16$Country)]

# countries added in 2017

whr17$Region[whr17$Country == "Mozambique"] <- "Sub-Saharan Africa"
whr17$Region[whr17$Country == "Lesotho"] <- "Sub-Saharan Africa"
whr17$Region[whr17$Country == "Central African Republic"] <- "Sub-Saharan Africa"




#### Standardize varibles

#Year variable
whr15$year <- 2015
whr16$year <- 2016
whr17$year <- 2017


keepVars <-   c("Country",
                "Region",
                "year",
                "Happiness.Rank",
                "Happiness.Score",
                "Economy..GDP.per.Capita.", 
                "Family",
                "Health..Life.Expectancy.",
                "Freedom",
                "Trust..Government.Corruption.",
                "Generosity",
                "Dystopia.Residual")

whr15 <- whr15[,keepVars] 
whr16 <- whr16[,keepVars]
whr17 <- whr17[,keepVars]




#------------------------------------------------------------------------------#  
# Append
whr <- rbind(whr17, whr16, whr15)

# Rename variaables
newVar_names <-   c("country",
                    "region",
                    "year",
                    "happy_rank",
                    "happy_score",
                    "gdp_pc", 
                    "family",
                    "health",
                    "freedom",
                    "trust_gov_corr",
                    "generosity",
                    "dystopia_res")
names(whr) <- newVar_names
                
#------------------------------------------------------------------------------#  
#### Export ####

write.csv(whr,
          file.path(Data, "whr_panel.csv"),
          na = "",
          row.names = F)
ggplot(data = whr,
       aes(x = trust_gov_corr,
           y = happy_score,
           col = region)) + geom_point()
