# Spatial Data in R
# DIME FC Training 
# June 2018

# FIRST RUN MASTER FILE TO DEFINE FILEPATHS

# *** HOUSEHOLD DATA **** ------------------------------------------------------

# Load Household Data ----------------------------------------------------------
library(broom)
library(sp)
library(RColorBrewer)
library(rgdal)
library(rgeos)
library(ggrepel)
library(raster)
library(ggplot2)
library(ggmap)
library(rgeos)
library(leaflet)
library(dplyr)
library(htmlwidgets)

hh_data <- read.csv(file.path(finalData,"HH_data.csv"))

# Make a Basic Map -------------------------------------------------------------


# Make a Better Map ------------------------------------------------------------
hh_map1 <- ggplot() +
  
  # Points
  geom_point(data=hh_data, 
             aes(x=longitude_scramble, y=latitude_scramble, color=food_security),
             size=.7) +
  
  # Other elements to improve map
  coord_quickmap() + # make sure the map doesn't look distorted. Can also use
  # coord_map(), but sometimes makes the process slow
  theme_void() +
  scale_color_manual(values=c("green", "orange", "red")) +
  labs(title="Household Food Security", color="Food Security") +
  theme(plot.title = element_text(hjust = 0.5, face="bold")) # center and bold title
hh_map1

# Add a Basemap ----------------------------------------------------------------
basemap <- get_map(location = c(lon=mean(hh_data$longitude_scramble), 
                                lat=mean(hh_data$latitude_scramble)), 
                   zoom=10,
                   maptype="roadmap") # roadmap, satellite, etc. See help(get_map)

hh_map2 <- ggmap(basemap) +
  geom_point(data=hh_data, 
             aes(x=longitude_scramble, 
                 y=latitude_scramble, 
                 color=food_security),
             size=.7) +
  coord_quickmap() + # make sure the map doesn't look distorted. Can also use
  # coord_map(), but sometimes makes the process slow
  theme_void() +
  labs(title="Household Food Security", color="Food Security") +
  theme(plot.title = element_text(hjust = 0.5, face="bold")) +
  scale_color_manual(values=c("green", "orange", "red"))
hh_map2

# Trim Basemap -----------------------------------------------------------------
hh_map2 + 
  scale_x_continuous(limits = c(min(hh_data$longitude_scramble), 
                                max(hh_data$longitude_scramble)), 
                     expand = c(.03, .03)) +
  scale_y_continuous(limits = c(min(hh_data$latitude_scramble), 
                                max(hh_data$latitude_scramble)), 
                     expand = c(.03, .03))

# Spatial Dataframe ------------------------------------------------------------
crs(hh_data_sdf) <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")


# Spatial Operations -----------------------------------------------------------

# Buffer

# Reproject
hh_data_sdf_newproj <- spTransform(hh_data_sdf, CRS("+init=epsg:3857"))

# Calculating distance
dist_matrix <- gDistance(hh_data_sdf_newproj, byid=T)

# Interactive Maps -------------------------------------------------------------

# Save Interactive Map ---------------------------------------------------------

# Better Interactive Map -------------------------------------------------------
pal <- colorFactor(
  palette = c("Green","Yellow","Red"),
  domain = hh_data_sdf$food_security)

imap_2 <- leaflet() %>%
  addProviderTiles("Stamen.Terrain") %>% 
  addCircleMarkers(data=hh_data_sdf,
                   radius=3,
                   fillOpacity=1,
                   color=~pal(food_security),
                   stroke=F, # remove outer-circle around circle
                   popup=~food_security) %>% # variable to display when click feature
  # Add legend for points layer
  addLegend(pal = pal, 
            values = hh_data_sdf$food_security,
            title = "Food Security")
imap_2

# *** POLGON DATA **** ---------------------------------------------------------

# Load and Prep Plot-Level Data ------------------------------------------------
setwd(finalData) # set filepath to folder with shapefile
ag_fields <- readOGR(dsn=".", layer="allsitessubset", verbose = FALSE)

# Plot File Projection

# HH Survey Location Projection

# Reproject plot data to have same projection as HH survey data

# Examine Agricultural Fields Spatial Dataframe --------------------------------

# Aggregate/Dissolve Polygon ---------------------------------------------------

# Buffer Polygon by Very Small Amount (get rid of weird tic) -------------------

# Merge Variables with Polygon -------------------------------------------------
ag_fields_data <- read.csv(file.path(finalData, "plot_data.csv"))

# Convert Spatial Dataframe to Dataframe for ggplot ----------------------------

# Make a Map -------------------------------------------------------------------

# Make a Better Map ------------------------------------------------------------

ag_map1 <- ggplot() + 
  geom_polygon(data = ag_fields_df, aes(x = long, y=lat, group=group, 
                                        fill=expend_food_yearly_mean),
               color="black", size=0.25) + # Borders of polygons
  
  coord_quickmap() + # Make sure map doesn't look distorted
  theme_void() + # Set theme of plot 
  scale_fill_gradient(low = "orangered1", high = "green1") + # Color Gradient
  labs(fill="Food\nExpenditure", title="Annual Food Expenditure") + # Labels
  theme(plot.title = element_text(hjust = 0.5, face="bold")) # Center title
ag_map1

# Color Palettes ---------------------------------------------------------------
RColorBrewer::display.brewer.all()

# Map with Different Color Palette ---------------------------------------------
ag_map2 <- ggplot() + 
  geom_polygon(data = ag_fields_df, aes(x = long, y=lat, group=group, 
                                        fill=expend_food_yearly_mean),
               color="black", size=0.25) + # Borders of polygons
  
  coord_quickmap() + 
  theme_void() + 
  scale_fill_distiller(palette = "Spectral", direction = 1) + # Color Gradient
  labs(fill="Food\nExpenditure", title="Annual Food Expenditure") + 
  theme(plot.title = element_text(hjust = 0.5, face="bold")) 
ag_map2

# Add Text to Map [Way 1] ------------------------------------------------------

# Create dataframe of center of each plot with site name as variable
ag_fields_center <- gCentroid(ag_fields, byid=T) 
ag_fields_center <- as.data.frame(coordinates(ag_fields_center))

ag_fields_center$site <- ag_fields$site
names(ag_fields_center) <- c("longitude","latitude","site")

ag_map2 + geom_text(data=ag_fields_center, aes(label=site, x=longitude, y=latitude),
                    check_overlap = TRUE) # makes sure text doesn't overlap

# Add Text to Map [Way 2] ------------------------------------------------------


# Add Households to Map --------------------------------------------------------
ag_map2 <- ggplot() + 
  geom_polygon(data = ag_fields_df, aes(x = long, y=lat, group=group, 
                                        fill=expend_food_yearly_mean),
               color="black", size=0.25) + # Borders of polygons
  geom_point(data=hh_data, 
             aes(x=longitude_scramble, 
                 y=latitude_scramble, 
                 color="HH Location"), # Name an aesthetic want you want to 
                                       # appear on legend
             size=.1, alpha=.6) +
  scale_color_manual(values="black") + # Manually define color of points
  coord_quickmap() + 
  theme_void() +
  scale_fill_gradient(low = "orangered1", high = "green1") + 
  labs(fill="Food\nExpenditure", title="Annual Food Expenditure", 
       color="") + # Setting color="" makes the title above the legend item blank
  theme(plot.title = element_text(hjust = 0.5, face="bold")) 
ag_map2

# Interactive Map --------------------------------------------------------------

# Better Interactive Map -------------------------------------------------------
pal_foodexpend <- colorNumeric("RdYlGn", ag_fields$expend_food_yearly_mean)

imap_3 <- leaflet() %>%
  addProviderTiles("OpenStreetMap") %>%
  addPolygons(data=ag_fields,
              fillColor = ~pal_foodexpend(expend_food_yearly_mean),
              fillOpacity = 0.6,
              color="black", # color of line around polygons
              weight=1, # width of line around polygons
              popup=~site)
imap_3

# *** EXERCISE *** -------------------------------------------------------------
# Import Rwanda Administrative Zone 3 Polygon

# Import Vegetation Data
rwa_veg <- read.csv(file.path(finalData, "rwanda_vegetation.csv"))

# Simplify the polygon

# Resulting layer from gSimplify has no variables, so need to add a variable back in
