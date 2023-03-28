## R for Stata Users
## March 2023
## Exercise solutions
## Session: Geospatial data
## Note: Exercises should be run in order for the code to work

## Loading libraries ====
library(here)
library(tidyverse)
library(sf)
library(rworldmap)
library(ggmap)
library(wesanderson)

## Loading data ====
whr_panel   <- read_rds(here("DataWork",
                             "DataSets",
                             "Final",
                             "whr_panel.RDS"))
wb_projects <- read_csv(here("DataWork",
                             "DataSets",
                             "Final",
                             "wb_projects.csv"))
worldmap <- getMap(resolution="low")

## Exercise 1 ====
# Selecting variables in data layer
worldmap@data <-
  worldmap@data %>%
  select(ADMIN, REGION, continent, POP_EST, GDP_MD_EST)
# Summarizing
summary(worldmap@data)

## Exercise 2 ====
worldmap <- 
  st_as_sf(worldmap)

## Exercise 3 ====
# Mollweid projection
worldmap_moll <-
  worldmap %>%
  st_transform("+proj=moll")
# Mercator projection
worldmap_mercator <-
  worldmap %>%
  st_transform("EPSG:3857")

## Exercise 4 ====
# Pre-processing and join (slide 36)
worldmap <-
  worldmap %>%
  mutate(country = as.character(ADMIN),
         country = str_replace_all(country, "United States of America", "United States"),
         country = str_replace_all(country, "Northern Cyprus", "North Cyprus"),
         country = str_replace_all(country, "Hong Kong S.A.R.", "Hong Kong"),
         country = str_replace_all(country, "Republic of Serbia", "Serbia"),
         country = str_replace_all(country, "Somaliland", "Somaliland Region"),
         country = str_replace_all(country, "West Bank", "Palestinian Territories"),
         country = str_replace_all(country, "Democratic Republic of the Congo", "Congo (Kinshasa)"),
         country = str_replace_all(country, "Republic of the Congo", "Congo (Brazzaville)"),
         country = str_replace_all(country, "United Republic of Tanzania", "Tanzania"))
whr_panel <-
  whr_panel %>% 
  filter(year == 2015)
worldmap <-
  worldmap %>%
  left_join(whr_panel)
# Exercise
ggplot(worldmap) +
  geom_sf(aes(fill = happiness_score))

## Exercise 5 ====
ggplot(worldmap %>%
         filter(REGION != "Antarctica")) +
  geom_sf(aes(fill = happiness_score)) +
  labs(fill = "Happiness Score") +
  scale_fill_gradient(low = "blue",
                      high = "yellow") +
  theme_void() +
  theme(legend.position = "top")

## Exercise 6 ====
ggplot() +
  geom_point(data = wb_projects,
             aes(x = longitude,
                 y = latitude))

## Exercise 7 ====
wb_projects <-
  st_as_sf(wb_projects, 
           coords = c("longitude", "latitude"), 
           crs = 4326)

## Exercise 8 ====
wb_projects_moll <-
  st_transform(wb_projects,
               "+proj=moll")

## Exercise 9 ====
# 1 Create a polygon of Mozambique by subsetting the worldmap sf
mozambique <-
  worldmap %>%
  filter(country == "Mozambique")
# 2 Make sure the Moz polygon and the wb_projects shapefile
# have the same projection.
# We know from exercise 7 that wb_projects is in projection CRS 4326
# Now we have to apply the same to mozambique
mozambique <-
  mozambique %>%
  st_transform(crs = 4326)
# 3 Create a shapefile containing only Moz projects using
# one of the sf functions in the previous image.
# We'll use st_intersection()
mozambique_projects <-
  st_intersection(mozambique, wb_projects)
# 4 Create a map with the resulting data and customize as you like
ggplot() +
  geom_sf(data = mozambique) +
  geom_sf(data = mozambique_projects) +
  theme_void()
  