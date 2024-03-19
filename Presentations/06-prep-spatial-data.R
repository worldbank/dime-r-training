# Make datasets

library(tidyverse)
library(sf)
library(geodata)
library(osmdata)
library(leaflet)
library(here)

# GADM: Manually change --------------------------------------------------------
country_sf <- gadm("Kenya", level=2, path = tempdir()) %>% st_as_sf()
city_sf    <- country_sf %>% filter(NAME_1 == "Nairobi")

# OSM --------------------------------------------------------------------------
#### Roads
roads_osm <- st_bbox(city_sf) %>%
  opq() %>%
  add_osm_feature(key = 'highway', value = c('motorway', 'motorway_link',
                                             'trunk', 'trunk_link',
                                             'primary', '	primary_link',
                                             'secondary', 'secondary_link',
                                             'tertiary', 'tertiary_link')) %>%
  osmdata_sf()

roads_sf <- roads_osm$osm_lines
roads_sf <- roads_sf %>% st_intersection(city_sf)
roads_sf <- roads_sf %>%
  select(osm_id, name, highway)

#### Schools
schools_osm <- st_bbox(city_sf) %>%
  opq() %>%
  add_osm_feature(key = 'amenity', value = c('school')) %>%
  osmdata_sf()

schools_sf <- schools_osm$osm_points
schools_sf <- schools_sf %>% st_intersection(city_sf)
schools_sf <- schools_sf %>%
  select(osm_id, name, amenity)

coords_df <- schools_sf %>%
  st_coordinates() %>%
  as.data.frame()

schools_df <- schools_sf %>% st_drop_geometry()
schools_df$longitude <- coords_df$X
schools_df$latitude  <- coords_df$Y

# Export -----------------------------------------------------------------------
data_dir <- here("DataWork", "DataSets", "Final")

write_sf(country_sf, file.path(data_dir, "country.geojson"), delete_dsn = T)
write_sf(city_sf,    file.path(data_dir, "city.geojson"), delete_dsn = T)
write_sf(roads_sf,   file.path(data_dir, "roads.geojson"), delete_dsn = T)
write_csv(schools_df, file.path(data_dir, "schools.csv"))


