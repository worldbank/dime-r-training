# Spatial Data in R
# DIME FC Training 
# June 2018

# FIRST RUN MASTER FILE TO DEFINE FILEPATHS

# *** HOUSEHOLD DATA **** ------------------------------------------------------

# Load Household Data ----------------------------------------------------------
library(sp)
library(rgdal)
library(rgeos)
library(raster)

hh_data <- read.csv(file.path(finalData,"HH_data.csv"))
str(hh_data)

# Make a Basic Map -------------------------------------------------------------
library(ggplot2)
ggplot() +
  geom_point(data=hh_data, 
             aes(x=longitude_scramble, y=latitude_scramble, color=food_security),
             size=.7)

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
library(ggmap)
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
hh_data_sdf <- hh_data
coordinates(hh_data_sdf) <- ~longitude_scramble+latitude_scramble
crs(hh_data_sdf) <- CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0")

hh_data_sdf

hh_data_sdf@data

hh_data_sdf@coords

hh_data_sdf@data$food_security
hh_data_sdf$food_security # short-cut

plot(hh_data_sdf)

# Spatial Operations -----------------------------------------------------------
library(rgeos)

# Buffer
hh_data_sdf_buff <- gBuffer(hh_data_sdf, width= 0.5/111, byid=T) #buffer by about 10km
plot(hh_data_sdf_buff)

# Reproject
head(hh_data_sdf@coords)
hh_data_sdf_newproj <- spTransform(hh_data_sdf, CRS("+init=epsg:3857"))
head(hh_data_sdf_newproj@coords)

# Calculating distance
dist_matrix <- gDistance(hh_data_sdf_newproj, byid=T)
dist_matrix[1:7,1:7]

# Interactive Maps -------------------------------------------------------------
library(leaflet)
library(dplyr)

imap_1 <- leaflet() %>%
  addProviderTiles("OpenStreetMap") %>% 
  addCircles(data=hh_data_sdf)
imap_1

# Save Interactive Map ---------------------------------------------------------
library(htmlwidgets)
saveWidget(imap_1, file=file.path(Output,"interactive_map.html"))

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
crs(ag_fields)

# HH Survey Location Projection
crs(hh_data_sdf)

# Reproject plot data to have same projection as HH survey data
hh_dd_proj <- as.character(crs(hh_data_sdf))
ag_fields <- spTransform(ag_fields, CRS(hh_dd_proj))

# Examine Agricultural Fields Spatial Dataframe --------------------------------
plot(ag_fields)

ag_fields

ag_fields@polygons

head(ag_fields)

# Aggregate/Dissolve Polygon ---------------------------------------------------
ag_fields <- aggregate(ag_fields, by = "site")
plot(ag_fields)

# Buffer Polygon by Very Small Amount (get rid of weird tic) -------------------
ag_fields <- gBuffer(ag_fields, width=0.000001/111, byid=T)
plot(ag_fields)

# Merge Variables with Polygon -------------------------------------------------
ag_fields_data <- read.csv(file.path(finalData, "plot_data.csv"))
ag_fields <- merge(ag_fields, ag_fields_data, by="site")
summary(ag_fields@data)

# Convert Spatial Dataframe to Dataframe for ggplot ----------------------------
library(broom)

ag_fields_df <- tidy(ag_fields, region="site")
head(ag_fields_df)

ag_fields_df <- merge(ag_fields_df, ag_fields, by.x="id", by.y="site")
head(ag_fields_df)

# Make a Map -------------------------------------------------------------------
ggplot() + 
  geom_polygon(data = ag_fields_df, aes(x = long, y=lat, group=group, 
                                        fill=expend_food_yearly_mean))

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
library(RColorBrewer)
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
library(ggrepel)

ag_map2 + geom_text_repel(data=ag_fields_center, aes(label=site, x=longitude, y=latitude))

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
leaflet() %>%
  addProviderTiles("OpenStreetMap") %>% 
  addPolygons(data=ag_fields)

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
rwa_adm <- getData('GADM', country='RWA', level=3)
rwa_adm
head(rwa_adm)

# Import Vegetation Data
rwa_veg <- read.csv(file.path(finalData, "rwanda_vegetation.csv"))
head(rwa_veg)

# Simplify the polygon
rwa_adm_simple <- gSimplify(rwa_adm, tol=0.003) # simplifies the polygon

# Resulting layer from gSimplify has no variables, so need to add a variable back in
rwa_adm_simple$OBJECTID <- rwa_adm$OBJECTID 
