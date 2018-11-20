library(stargazer)
library(tidyverse)

# File paths

if (Sys.getenv("USERNAME") == "luiza"){
  projectFolder  <- "C:/Users/luiza/Documents/GitHub/dime-r-training"
  
}

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
rawOutput         <- file.path(dataWorkFolder,"Output","Raw")

# Load CSV data
whr <- read.csv(file.path(finalData,"whr_panel.csv"), 
                header = T,
                stringsAsFactors = F)






#### Construct a duplicated df
x1 <- whr
x1$stat <- "mean"

x2 <- whr
x2$stat <- "N"

x12 <- rbind(x1,x2)


#### Collapse
happy_table2 <-
  aggregate(happy_score ~ stat +  region + year,
            data = x12,
            FUN = mean)

happy_table2 <-
  rename(happy_table2, value = happy_score)

#### Freq df

freqdf <- 
  as.data.frame(table(whr$region, whr$year))



#### replace values
happy_table2$value[happy_table2$stat == "N"] <- freqdf$Freq

happy_table2 <- 
  select(happy_table2, region, year, stat, value)


#### Reshape
ht_wd <- 
  spread(happy_table2, 
         key = year, 
         value = value)

#### Cosmetics 

ht_wd$region[as.integer(row.names(ht_wd)) %% 2 == 0] <- ""

stargazer(ht_wd, summary = F, type = "text")

