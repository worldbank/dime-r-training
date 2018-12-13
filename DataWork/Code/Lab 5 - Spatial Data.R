# Spatial Data Analysis with R

# Setup ------------------------------------------------------------------------
library(maptools)
library(rgdal)
library(ggplot2)
library(broom)
library(ggmap)
library(raster)
library(leaflet)

# Define the filepath to the Final data folder
finalData <- "~/Documents/GitHub/dime-r-training/DataWork/DataSets/Final"

# *** Load a Shapefile ---------------------------------------------------------
worldmap <- readOGR(dsn=finalData, layer="worldmap")

# If the above line doesn't work, try this:
# library(maptools)
# worldmap <- readShapeSpatial(file.path(finalData,"worldmap.shp"))
# crs(worldmap) <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

#### Plot Shapefile
plot(worldmap)

#### Plot Subset of Shapefile
plot(worldmap[1:42,])

#### Look inside spatial dataframe

# Coordinate Reference System
worldmap@proj4string

# Dataframe
worldmap@data

# *** Mapping with ggplot: Polygons --------------------------------------------

#### Make map of the world
ggplot() +
  geom_polygon(data=worldmap, aes(x=long, y=lat, group=group))

#### Make tidy dataframe of world map 
# Make tidy dataframe
worldmap$id <- row.names(worldmap) 
worldmap_tidy <- tidy(worldmap)

# Merge our variables back in
worldmap_tidy <- merge(worldmap_tidy, worldmap@data, by="id")

#### Make happiness scores
ggplot() +
  geom_polygon(data=worldmap_tidy, aes(x=long, y=lat, 
                                       group=group, 
                                       fill = hppy_sc)) +
  theme_void()

#### Make a prettier map with ggplot
ggplot() +
  geom_polygon(data=worldmap_tidy, aes(x=long, y=lat, 
                                       group=group, 
                                       fill = hppy_sc)) +
  theme_void() +
  coord_quickmap() + # Removes distortions
  labs(fill="Happiness\nScore") +
  scale_colour_gradient(low = "firebrick4",
                        high = "chartreuse2")

##### Exercise 1: Make of map of just Africa #####

# WRITE YOUR CODE HERE! 





# *** Mapping with ggplot: Points ----------------------------------------------
#### Load World Bank data
wb_projects <- read.csv(file.path(finalData, "wb_projects.csv"))

##### Exercise 3: Add World Bank Projects to Map #####

# WRITE YOUR CODE HERE! 





# *** Mapping with ggplot: Lines -----------------------------------------------

##### Exercise 3: Add trunk roads to map #####
trunk_roads <- readOGR(dsn=finalData, layer="troads")

# If the above line doesn't work, try this:
# library(maptools)
# trunk_roads <- readShapeSpatial(file.path(finalData,"troads.shp"))
# crs(worldmap) <- CRS("+proj=utm +zone=30 +a=6378249.145 +b=6356514.96582849 +units=m +no_defs")

# WRITE YOUR CODE HERE! 





#### Check Projections
# World Map Projection
worldmap@proj4string

# Trunk Roads Projection
trunk_roads@proj4string

#### Reproject Data
trunk_roads_reprj <- spTransform(trunk_roads, CRS("+init=epsg:4326"))

#### Add trunk roads to map
ggplot() +
  geom_polygon(data=africa_tidy, aes(x=long, y=lat, 
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
  scale_fill_gradient(low = "firebrick4",
                      high = "chartreuse2")

#### Add Roads to Legend
ggplot() +
  geom_polygon(data=africa_tidy, aes(x=long, y=lat, 
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
  scale_fill_gradient(low = "firebrick4",
                      high = "chartreuse2") +
  scale_color_manual(values=c("blue")) # MANUALY DEFINE COLOR HERE

# *** Basemap ------------------------------------------------------------------
#### Basemap of Nairobi
nairobi <- c(left = 36.66, 
             bottom = -1.44, 
             right = 37.10, 
             top = -1.15)
nairobi_map <- get_stamenmap(nairobi, 
                             zoom = 12, 
                             maptype = "toner-lite")

ggmap(nairobi_map)

#### World Bank Projects in Nairobi
kenya_projects <- subset(wb_projects, recipients == "Kenya")

ggmap(nairobi_map) + 
  geom_point(data=wb_projects, aes(x=longitude,
                                   y=latitude),
             color="orange") +
  theme_void()

#### Exercise 4: Make Size of Point Correspond with Commitment #####

# WRITE YOUR CODE HERE! 

# *** Interactive Map ----------------------------------------------------------

#### Create Spatial Points Dataframe

# Create Spatial Points Dataframe
coordinates(kenya_projects) <- ~longitude+latitude

# Define Projection
crs(kenya_projects) <- CRS("+init=epsg:4326")

# Plot 
plot(kenya_projects, pch=16, cex=.5)

#### Interactive Map
leaflet() %>%
  addCircles(data=kenya_projects) %>% 
  addTiles()

#### Better Interactive Map
leaflet() %>%
  addCircles(data=kenya_projects,
             popup = ~project_title,
             radius = ~sqrt(commitments)*5,
             weight = 1,
             color = "orange") %>%
  addProviderTiles(providers$Stamen.Terrain)

##### Exercise 5: Add Two Layers on Map #####

# WRITE YOUR CODE HERE! 

#### Add Layers and Buttons to Interactive Map
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

# *** Spatial Operations -------------------------------------------------------
#### GADM Data
ken_adm1 <- getData('GADM', country='KEN', level=1)

#### Crop Roads to Kenya
trunk_roads_kenya <- gIntersection(trunk_roads_reprj, ken_adm1)

# Convert back to spatial points dataframe (instead of spatial points)
trunk_roads_kenya$id <- 1:length(trunk_roads_kenya)

#### Calculate Distance to Road
distance_matrix <- gDistance(kenya_projects, trunk_roads_kenya, byid=T)
kenya_projects$dist_road <- apply(distance_matrix, 2, min)

###### Exercise 6: Map of World Bank Projects Near Roads #####
kenya_projects_df <- kenya_projects@data
kenya_projects_df$long <- kenya_projects@coords[,1]
kenya_projects_df$lat <- kenya_projects@coords[,2]

# WRITE YOUR CODE HERE! 
