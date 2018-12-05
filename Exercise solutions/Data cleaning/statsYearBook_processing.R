#------------------------------------------------------------------------------#

#		UN stats year book data processing

#------------------------------------------------------------------------------#



if (Sys.getenv("USERNAME") == "Leonardo"){
  projectFolder  <- "C:/Users/Leonardo/Documents/GitHub/dime-r-training"
  dropbox <- "C:/Users/Leonardo/Dropbox/Work/WB/R Training/R training"
  
}

if (Sys.getenv("USERNAME") == "WB519128"){
  projectFolder <- file.path("C:/Users/WB519128/Documents/GitHub/dime-r-training")
  dropbox <- "C:/Users/WB519128/Dropbox/Work/WB/R Training/R training"
  
}

UNstatsDat <- file.path(dropbox,"Data/World/Raw/UN stats yearbook") 


#------------------------------------------------------------------------------#
#### Load data ####

pop <- read.csv(file.path(UNstatsDat, "T02_Pop.csv"), header = T, stringsAsFactors = F)
int <- read.csv(file.path(UNstatsDat,"T29_Internet.csv"), header = T, stringsAsFactors = F)
crime <- read.csv(file.path(UNstatsDat,"T12_Crime.csv"), header = T, stringsAsFactors = F)
#gdp <- read.csv(file.path(UNstatsDat,"T13_Gdp.csv"), header = T, stringsAsFactors = F)
#educ <- read.csv(file.path(UNstatsDat,"T07_Education.csv"), header = T, stringsAsFactors = F)
teach <- read.csv(file.path(UNstatsDat,"T08_Teachers.csv"), header = T, stringsAsFactors = F)
med <- read.csv(file.path(UNstatsDat,"T10_Health_Personnel.csv"), header = T, stringsAsFactors = F)

#------------------------------------------------------------------------------#
#### Basic cleaning  ####

treat <- 
  function(x){
    names(x) <- c("code",
                  "country",
                  "year",
                  "var",
                  "value",
                  "coomments",
                  "source")
    
    nonCountries <- c("Total, all countries or areas",
                      "Sub-Saharan Africa",
                      "Latin America & the Caribbean",
                      "South-central Asia",
                      "Australia and New Zealand",
                      "Oceania",
                      "Africa",
                      "Northern Africa",
                      "Eastern Africa",
                      "Middle Africa",
                      "Southern Africa",
                      "Western Africa",
                      "Americas",
                      "Northern America",
                      "Caribbean",
                      "Central America",
                      "South America",
                      "Asia",
                      "Central Asia",
                      "Eastern Asia",
                      "South-eastern Asia",
                      "Southern Asia",
                      "Western Asia",
                      "Europe",
                      "Eastern Europe",
                      "Northern Europe",
                      "Southern Europe",
                      "Western Europe",
                      "Melanesia")
    
    
    keepVars <- c("Population mid-year estimates (millions)",
                  "Sex ratio (males per 100 females)",
                  "Health personnel: Physicians (number)",
                  "Teachers at primary level (thousands)",
                  "Teachers at secondary level (thousands)",
                  "Intentional homicide rates per 100,000",
                  "Percentage of individuals using the internet")
    
    
    x$coomments <- NULL
    x$source <- NULL
    
    
    x <- x[!(x$country %in% nonCountries),]
    x <- x[x$year > 2014,]
    
    x <- x[x$var %in% keepVars,]
    
    x <- spread(x,
                key = var,
                value = value)
    
    
    
    return(x)
  }



pop <- treat(pop)
int <- treat(int)
crime <- treat(crime)
#gdp <- treat(gdp)
#educ <- treat(educ)
teach <-treat(teach)
med <- treat(med)


#------------------------------------------------------------------------------#
#### Merge ####

teach$year <- as.integer(teach$year)
teach$code <- as.integer(teach$code)


x1 <- pop %>%
  full_join(int, by = c("code", "year", "country")) %>%
  full_join(crime, by = c("code", "year", "country")) %>%
  full_join(teach, by = c("code", "year", "country")) %>%
  full_join(med, by = c("code", "year", "country")) 

whr <- 
rename(whr, code = coutry_code)

foo <- left_join(whr, x1, by = c("code", "year"))
