#------------------------------------------------------------------------------#

#			R training - Birds vs Planes cleaning

#------------------------------------------------------------------------------#  

# Seed setting
set.seed(666)


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

# Load CSV data

# bvp <- read.csv(file.path(Data,"AirplanesVsBirds.csv"), 
#                 header = T)

bvp <- read.csv(file.path(Data,"AirplanesVsBirds_original.csv"), 
                header = T)

#------------------------------------------------------------------------------#  
#### Keep vars ####

keepVars <- c("Record.ID",
              "Incident.Year",
              "Incident.Month",
              "Incident.Day",
              "Operator",             
              "Aircraft",             
              "Aircraft.Type",       
              "Aircraft.Make",        
              "Aircraft.Model" ,      
              "Aircraft.Mass" ,             
              "Engines",                         
              "Airport",
              "State",
              "Flight.Phase",
              "Visibility",
              "Precipitation",
              "Height",
              "Speed",
              "Species.Name",
              "Species.Quantity",
              "Flight.Impact",
              "Fatalities",
              "Injuries",
              "Engine.Ingested", 
              "Aircraft.Damage" )

bvpN <- bvp[, keepVars] 

#------------------------------------------------------------------------------#  
#### Rename Variables ####

names(bvpN) <- 
  c("record.ID",
    "year",
    "month",
    "day",
    "operator",             
    "aircraft",             
    "aircraft.Type",       
    "aircraft.Make",        
    "aircraft.Model" ,      
    "aircraft.Mass" ,             
    "engines",                         
    "airport",
    "state",
    "flight.phase",
    "visibility",
    "precipitation",
    "height",
    "speed",
    "species.name",
    "species.quantity",
    "flight.impact",
    "fatalities",
    "injuries",
    "engine.ingested", 
    "aircraft.damage" )



#------------------------------------------------------------------------------#  
#### Replace NAs in height and speed for flights with falalities and injuries ####


#### Height

bol_height<- (!is.na(bvpN$fatalities) | !is.na(bvpN$injuries)) & is.na(bvpN$height)

fake_height <- 100 + round( 1000*rexp(sum(bol_height), 10))

bvpN$height[bol_height] <- fake_height


#### Speed 

bol_speed <- (!is.na(bvpN$fatalities) | !is.na(bvpN$injuries)) & is.na(bvpN$speed)

fake_speed <- round(75 + 1000*rbeta(sum(bol_speed), 2, 15))

bvpN$speed[bol_speed] <- fake_speed



#------------------------------------------------------------------------------#  
#### Remove NA's ####


bvpN$height[bvpN$height > quantile(bvpN$height, 0.9999, na.rm = T) ] <- NA


bvpN <- bvpN[!is.na(bvpN$height)  & 
              !is.na(bvpN$speed)   & 
              !is.na(bvpN$engines) & 
              !is.na(bvpN$species.quantity),]

#------------------------------------------------------------------------------#  
#### Create continuous species quantities variable ####

# I'm using poison and exponential distribution to create random values with a 
# left skewed distribuition. I'm not respecting the intervals perfectly, but mostly


# The monst commun value
bvpN$s.quantity.c <- 1 

#### 2-10 birds

values1 <- 2 + rpois(sum(bvpN$species.quantity == '2-10')
                     , 1.5)

bvpN$s.quantity.c[bvpN$species.quantity == '2-10'] <- values1


#### 11-100 birds
values2 <- round( 11 + rexp(sum(bvpN$species.quantity == '11-100'),
                            .08))

bvpN$s.quantity.c[bvpN$species.quantity == '11-100'] <- values2


#### 100 + birds
values3 <- round(100 + rexp(sum(bvpN$species.quantity == 'Over 100'),
                            .01))

bvpN$s.quantity.c[bvpN$species.quantity == 'Over 100'] <- values3

#### Replace original variable
bvpN$species.quantity <- bvpN$s.quantity.c
bvpN$s.quantity.c <- NULL


#------------------------------------------------------------------------------#  
#### Export ####

write.csv(bvpN,
          file.path(Data, "AirplanesVsBirds.csv"),
          na = "",
          row.names = F)






#------------------------------------------------------------------------------#  
#### draft code ####

rem_IDs <- c(101093, 
             205032, 
             233542, 
             127931, 
             124681,
             258727)

foo <- bvpN[!(bvpN$record.ID %in% rem_IDs),]

bar <- foo[!is.na(foo$injuries) & foo$injuries > 1,]

#ggplotly(
ggplot(data = bar,
       aes(y = height,
           x = speed,
           color = species.quantity,
           size = injuries)) +
  geom_point()
#)
