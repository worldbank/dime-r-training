#------------------------------------------------------------------------------ #
#                                                                               #
#                                    DIME                                       #
#                              Spatial Data in R                                #
#                         master script w/ solutions                            #
#                                                                               #
#------------------------------------------------------------------------------ #

### Setup ----------------------------------------------------------------------

# Install packages - if you have not installed those before
install.packages(c("rgdal", "ggmap", "raster", "leaflet"), dependencies = TRUE)

# load packages 
library(maptools)
library(rgdal)
library(ggplot2)
library(broom)
library(ggmap)
library(raster)
library(leaflet)
library(tidyverse)
library(rgeos)

# Define the filepath to the Final data folder
finalData <- "C:/Users/WB546716/Documents/GitHub/dime-r-training/DataWork/DataSets/Final"

# Load a Shapefile 
worldmap <- readOGR(dsn=finalData, layer="worldmap")

# If the above line doesn't work, try this:
# library(maptools)
# worldmap <- readShapeSpatial(file.path(finalData,"worldmap.shp"))
# crs(worldmap) <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

# If this fails, try running this:
# load(file.path(finalData, "spatialdata.Rda"))

# Plot Shapefile
plot(worldmap)

# Plot Subset of Shapefile
plot(worldmap[1:42,])

# Look inside spatial dataframe

# Coordinate Reference System
worldmap@proj4string

# Dataframe
head(worldmap@data,3)

### Mapping with ggplot: Polygons --------------------------------------------

## Make map of the world
ggplot() +
  geom_polygon(data=worldmap, aes(x=long, y=lat, group=group))

## Make tidy dataframe of world map 
# Make tidy dataframe
worldmap$id <- row.names(worldmap) 
worldmap_tidy <- tidy(worldmap)

# Merge our variables back in
worldmap_tidy <- merge(worldmap_tidy, worldmap@data, by="id")

# Make happiness scores
ggplot() +
  geom_polygon(data=worldmap_tidy, aes(x=long, y=lat, 
                                       group=group, 
                                       fill = hppy_sc)) +
  theme_void()

# Make a prettier map with ggplot
ggplot() +
  geom_polygon(data=worldmap_tidy, aes(x=long, y=lat, 
                                       group=group, 
                                       fill = hppy_sc)) +
  theme_void() +
  coord_quickmap() + # Removes distortions
  labs(fill="Happiness\nScore") +
  scale_fill_gradient(low = "firebrick4",
                        high = "chartreuse2")

### Exercise 1: Make of map of just Africa -------------------------------------

africaonly <- subset(worldmap_tidy, REGION == "Africa")

ggplot() +
  geom_polygon(data=africaonly, aes(x=long, y=lat,
                               group = group,
                               fill = hppy_sc)) +
  theme_void() +
  coord_quickmap() +
  labs(fill = "Happiness\nScore") +
  scale_fill_gradient(low = "rosybrown2",
                      high = "red3")


### Mapping with ggplot: Points ----------------------------------------------
# Load World Bank data
wb_projects <- read.csv(file.path(finalData, "wb_projects.csv"))
names(wb_projects)

### Exercise 2: Add World Bank Projects to Map --------------------------------

ggplot() +
  geom_polygon(data=africaonly, aes(x=long, y=lat,
                                    group = group,
                                    fill = hppy_sc)) +
  geom_point(data=wb_projects, aes(x=longitude, y=latitude),
                                   size=0.1)+
  theme_void() +
  coord_quickmap() +
  labs(fill = "Happiness\nScore") +
  scale_fill_gradient(low = "rosybrown2",
                      high = "red3")


### Mapping with ggplot: Lines -----------------------------------------------

### Exercise 3: Add trunk roads to Map ---------------------------------------
# Set up the data
trunk_roads <- readOGR(dsn=finalData, layer="troads")

# If the above line doesn't work, try this:
# library(maptools)
# trunk_roads <- readShapeSpatial(file.path(finalData,"troads.shp"))
# crs(worldmap) <- CRS("+proj=utm +zone=30 +a=6378249.145 +b=6356514.96582849 +units=m +no_defs")

ggplot() +
  geom_polygon(data=africaonly, aes(x=long, y=lat,
                                    group = group,
                                    fill = hppy_sc)) +
  geom_path(data=trunk_roads_reprj, aes(x=long, y=lat,
                                  group = group)) +
  geom_point(data=wb_projects, aes(x=longitude, y=latitude),
             size=0.1)+
  theme_void() +
  coord_quickmap() +
  labs(fill = "Happiness\nScore") +
  scale_fill_gradient(low = "rosybrown2",
                      high = "red3")



#### Check Projections
# World Map Projection
worldmap@proj4string

# Trunk Roads Projection
trunk_roads@proj4string

#### Reproject Data
trunk_roads_reprj <- spTransform(trunk_roads, CRS("+init=epsg:4326"))

#### Add trunk roads to map
ggplot() +
  geom_polygon(data=africaonly, aes(x=long, y=lat, 
                                     group=group, 
                                     fill = hppy_sc)) +
  geom_path(data=trunk_roads_reprj, aes(x=long, y=lat, 
                                        group=group)) +
  geom_point(data=wb_projects, aes(x=longitude,
                                   y=latitude),
             size=.1) +
  theme_void() +
  coord_quickmap() + # Removes distortions
  labs(fill="Happiness\nScore") +
  scale_fill_gradient(low = "rosybrown2",
                      high = "red3")

#### Add Roads to Legend
ggplot() +
  geom_polygon(data=africaonly, aes(x=long, y=lat, 
                                     group=group, 
                                     fill = hppy_sc)) +
  geom_point(data=wb_projects, aes(x=longitude,
                                   y=latitude),
             size=.1) +
  geom_path(data=trunk_roads_reprj, aes(x=long, y=lat, 
                                        group=group,
                                        color="Trunk Roads")) +
  theme_void() +
  coord_quickmap() + # Removes distortions
  labs(fill="Happiness\nScore",
       color="") + # REMOVE TITLE ABOVE TRUNK ROAD IN LEGEND
  scale_fill_gradient(low = "rosybrown2",
                      high = "red3") +
  scale_color_manual(values=c("navyblue")) # MANUALY DEFINE COLOR HERE

### Basemap ------------------------------------------------------------------
# Basemap of Nairobi
nairobi <- c(left = 36.66, 
             bottom = -1.44, 
             right = 37.10, 
             top = -1.15)
nairobi_map <- get_stamenmap(nairobi, 
                             zoom = 12, 
                             maptype = "toner-lite")

ggmap(nairobi_map)

# World Bank Projects in Nairobi
kenya_projects <- subset(wb_projects, recipients == "Kenya")

ggmap(nairobi_map) + 
  geom_point(data=wb_projects, aes(x=longitude,
                                   y=latitude),
             color="orange") +
  theme_void()

### Exercise 4: Make Size of Point Correspond with Commitment ----------------

ggmap(nairobi_map) +
  geom_point(data=kenya_projects_df, aes(x=long,y=lat,
                                      color = commitments,
                                      size = commitments))+
  scale_color_continuous(guide = "legend",
                        low="orange",
                        high="green2") +
  scale_size_continuous(guide="legend") +
  labs(size = "Aid\nCommitment",
       color="Aid\nCommitment") +
  theme_void()
  


### Interactive Map ----------------------------------------------------------

## Setup for interactive map

# Create Spatial Points Dataframe
coordinates(kenya_projects) <- ~longitude+latitude

# Define Projection
crs(kenya_projects) <- CRS("+init=epsg:4326")

# Plot 
plot(kenya_projects, pch=16, cex=.5)

# Interactive Map
leaflet() %>%
  addCircles(data=kenya_projects) %>% 
  addTiles()

# Better Interactive Map
leaflet() %>%
  addCircles(data=kenya_projects,
             popup = ~project_title,
             radius = ~sqrt(commitments)*5,
             weight = 1,
             color = "orange") %>%
  addProviderTiles(providers$Stamen.Terrain)

### Exercise 5: Add Two Layers on Map -----------------------------------------

##Add Layers and Buttons to Interactive Map
leaflet() %>%
  addCircles(data=subset(kenya_projects, 
                         ad_sector_names == "Transport and storage"),
             popup = ~project_title,
             radius = ~sqrt(commitments)*5,
             weight = 2.5,
             color = "orange",
             group = "Transport") %>%
  addCircles(data=subset(kenya_projects, 
                         ad_sector_names == "Water supply and sanitation"),
             popup = ~project_title,
             radius = ~sqrt(commitments)*5,
             weight = 2.5,
             color = "blue",
             group = "Water") %>%
  addProviderTiles(providers$Stamen.Terrain) %>%
  addLayersControl(overlayGroups = c("Transport", "Water"),
                   options = layersControlOptions(collapsed = FALSE))

### Spatial Operations -------------------------------------------------------
#### GADM Data
ken_adm1 <- getData('GADM', country='KEN', level=1)

#### Crop Roads to Kenya
trunk_roads_kenya <- gIntersection(trunk_roads_reprj, ken_adm1)

# Convert back to spatial points dataframe (instead of spatial points)
trunk_roads_kenya$id <- 1:length(trunk_roads_kenya)

#### Calculate Distance to Road
distance_matrix <- gDistance(kenya_projects, trunk_roads_kenya, byid=T)
kenya_projects$dist_road <- apply(distance_matrix, 2, min)

### Exercise 6: Map of World Bank Projects Near Roads -------------------------

# Convert spatial points back to dataframe
kenya_projects_df <- kenya_projects@data
kenya_projects_df$long <- kenya_projects@coords[,1]
kenya_projects_df$lat <- kenya_projects@coords[,2]
# Plotting
ken_adm2 <- getData('GADM', country = 'KEN', level = 0)
plot(ken_adm2)
ggplot()+
  geom_polygon(data = ken_adm2, aes(x = long, y = lat, group = group),
               fill = "papayawhip", color = "azure4") +
  geom_point(data = subset(kenya_projects_df, dist_road < 0.1),
             aes(x = long, y = lat, size = commitments/1000000),
             pch = 21, fill = "salmon1", color = "grey18") +
  geom_path(data=trunk_roads_kenya, aes(x=long, y=lat, 
                                        group=group,
                                        color = "Trunk Road")) +
  scale_color_manual(values = "salmon4") +
  labs(color = "", size = "World Bank\nCommitments\n(millions)",
       title = "World Bank Projects Near Trunk Roads") +
  coord_quickmap() +
  theme_void() +
  theme(plot.title = element_text(hjust = 0.5))