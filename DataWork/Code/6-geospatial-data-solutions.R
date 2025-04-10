## R for Data Analysis
## Exercise solutions
## Session: Geospatial data
## Note: Exercises should be run in order for the code to work

## Installing libraries ====
install.packages(c("sf",
                   "leaflet",
                   "geosphere"),
                 dependencies = TRUE)

## Loading libraries ====
library(here)
library(tidyverse)
library(sf)
library(leaflet)
library(geosphere)


## Loading data amd some data wrangling====
# Load country_sf
country_sf <- 
  st_read(here("DataWork",
               "DataSets",
               "Final",
               "country.geojson"))
# Filtering Nairobi only
city_sf <- country_sf %>% 
  filter(NAME_1 == "Nairobi")

## Exercise 1 ====
## Load the roads data roads.geojson and name the object roads_sf
## Look at the first few observations
## Check the coordinate reference system
## Map the polyline
# Load roads data
roads_sf <- st_read(here("DataWork", "DataSets", "Final", "roads.geojson"))
# Some data exploration
head(roads_sf)
st_crs(roads_sf)
# Plot of roads
ggplot() +
  geom_sf(data = roads_sf)

## School location data =====
schools_df <- 
  read_csv(here("DataWork",
                "DataSets",
                "Final",
                "schools.csv"))

## Assigning the correct coordinates to schools data ====
schools_sf <- st_as_sf(schools_df, 
                       coords = c("longitude", "latitude"),
                       crs = 4326)

worldmap <- getMap(resolution="low")

## Statics maps ====
# Adding a variable with squared km
city_sf <- city_sf %>%
  mutate(area_m = city_sf %>% st_area() %>% as.numeric(),
         area_km = area_m / 1000^2)
# Plotting
ggplot() +
  geom_sf(data = city_sf,
          aes(fill = area_km)) +
  labs(fill = "Area") +
  scale_fill_distiller(palette = "Blues") + 
  theme_void()

## Exercise 2 ====
# Determine length of each line
st_length(roads_sf)

## Exercise 3 ====
# Make a static map of roads, coloring each road by its type.
# Hint: The highway variable indicates the type
ggplot() +
  geom_sf(data = roads_sf,
          aes(color = highway)) +
  theme_void() +
  labs(color = "Road Type")

## Exercise 4 ====
# Create a leaflet map with roads, using the roads_sf dataset
# Hint: Use addPolylines()
leaflet() %>%
  addTiles() %>%
  addPolylines(data = roads_sf)

## Exercise 5 ====
# Create a polyline of all trunk roads (dissolve it using st_combine),
# and buffer the polyline by 10 meters.
# In roads_sf, the highway variable notes road types.
roads_sf %>%
  filter(highway == "trunk") %>%
  summarise(geometry = st_combine(geometry)) %>%
  st_buffer(dist = 10)

## Exercise 6 ====
# Calculate the distance from the centroid of each second
# administrative division to the nearest trunk road.
city_cent_sf <- city_sf %>% st_centroid()
trunk_sf <- roads_sf %>%
  filter(highway == "trunk")
# Matrix: distance of each school to each motorway
dist_mat <- st_distance(city_cent_sf, trunk_sf)
# Take minimun distance for each school
dist_mat %>% apply(1, min) %>% head()

## Exercise 7 ====
# Determine which motorways intersect with a trunk road
trunk_sf <- roads_sf %>% filter(highway == "trunk")
motor_sf <- roads_sf %>% filter(highway == "motorway")
st_intersects(motor_sf, trunk_sf, sparse = F) %>% 
  apply(1, max) %>%
  head()

## Exercise 8 ====
# Create a map of schools that are within 1km of a motorway
motor_1km_sf <- roads_sf %>% 
  filter(highway == "motorway") %>%
  st_buffer(dist = 1000)
schools_nr_motor_sf <- schools_sf %>%
  st_intersection(motor_1km_sf)
leaflet() %>%
  addTiles() %>%
  addCircles(data = schools_nr_motor_sf)

## Exercise 9 ====
# Make a static map using of administrative areas,
# where each administrative area polygon displays
# the number of schools within the administrative area.
## Dataframe of number of schools per NAME_2
n_school_df <- schools_city_sf %>%
  st_drop_geometry() %>%
  group_by(NAME_2) %>%
  summarise(n_school = n()) %>%
  ungroup()
## Merge info with city_sf
city_sch_sf <- city_sf %>% left_join(n_school_df, by = "NAME_2")
## Map
p <- ggplot() +
  geom_sf(data = city_sch_sf,
          aes(fill = n_school))