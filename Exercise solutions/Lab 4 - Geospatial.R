
# 1 Set the stage =============================================================
  
  install.packages("pacman")
  
  # Packages to be used
  packages <- 
    c("tidyverse",
      "sf",
      "rworldmap",
      "ggmap")
  
  # Load packages
  pacman::p_load(packages,
                 character.only = TRUE)
  
  
  # Set file paths
  projectFolder  <- "ENTER/FOLDER/PATH/dime-r-training"
  
  dataWorkFolder    <- file.path(projectFolder,"DataWork")
  Data              <- file.path(dataWorkFolder,"DataSets")
  finalData         <- file.path(Data,"Final")
  
  # Load data
  whr_panel   <- readRDS(file.path(finalData, "whr_panel.RDS"))
  wb_projects <- read_csv(file.path(finalData, "wb_projects.csv"))
  
# 2 Create special version of the wHR panel =================================
  
  # Load world map
  worldmap <- getMap(resolution="low")
  
  # 2.1 Explore spatial object ---------------------------------------------
  
  # Data element
  names(worldmap@data)
  head(worldmap@data)
  
  # Subset data
  worldmap@data <-
    worldmap@data %>%
    dplyr::select(ADMIN, REGION, continent, POP_EST, GDP_MD_EST)
  
  # Check current contents
  summary(worldmap@data)
  
  # Polygon element of spatial object
  plot(worldmap)
  
  # Projection element of spatial object
  worldmap@proj4string
  
  # 2.2 Project map -------------------------------------------------------
    
  # Create sf object
  worldmap <- 
    st_as_sf(worldmap)
  
  # Try two different projections
  worldmap_moll <-
    worldmap %>%
    st_transform("+proj=moll")
  
  worldmap_mercator <-
    worldmap %>%
    st_transform("EPSG:3857")
  
  # Plot Mollweid projection
  worldmap_moll %>% 
    select(REGION) %>%
    plot()
  
  # Plot Mercator projection
  worldmap_mercator %>% 
    select(REGION) %>%
    filter(REGION != "Antarctica") %>%
    plot()
  
  # 2.3 Merge map with WHR ----------------------------------------------
  
  # Adjust variables to make them compatible with WHR
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
  
  # Keep only one year of WHR
  whr_panel <-
    whr_panel %>% 
    filter(year == 2015)
  
  # Now join the two
  worldmap <-
    worldmap %>%
    left_join(whr_panel)
  
# 3 Visualize polygons ================================================
  
  ggplot(worldmap %>%
           filter(REGION != "Antarctica")) +
    geom_sf(aes(fill = happiness_score)) +
    labs(fill="Happiness Score") +
    scale_fill_gradient(low = "blue",
                        high = "yellow") +
    theme_void() +
    theme(legend.position = "top")
  
# 4 Visualize spatial points object ===================================
  
  # 4.1 Scatter plot -------------------------------------------------
  
  ggplot() +
    geom_point(data = wb_projects,
               aes(x=longitude,
                   y=latitude),
               size = .1) + # Smaller dots #<< 
    coord_quickmap() + # Correct distortion #<<
    theme_void() # Clean background #<<
  
  # 4.2 Add basemap --------------------------------------------------
  
  # Create an object with Africa only
  africa <-
    worldmap %>%
    filter(REGION == "Africa")
  
  # Calculate which part of the world we want images for
  # (this is called a bounding box)
  africa_box <- 
    st_bbox(africa) 
  
  # Save the basemap in an object
  africa_basemap <- 
    get_stamenmap(as.vector(africa_box),
                  zoom = 3, # The higher the zoom, the more details you get
                  maptype = "watercolor")
  
  # Add points on top of basemap
  ggmap(africa_basemap) + 
    geom_point(data = wb_projects,
               aes(x=longitude,
                   y=latitude),
               size = .1) +
    theme_void()
  
  # 4.3 Add points on top of hapinness score map -----------------------
  ggplot() +
    geom_sf(data = africa,
            aes(fill = happiness_score)) +
    geom_point(data = wb_projects,
               aes(x = longitude,
                   y = latitude),
               size = .1) +
    labs(fill="Happiness\nScore") +
    scale_fill_gradient(low = "blue",
                        high = "yellow") +
    theme_void() 

  # 4.4 Convert coordinates to sf object -------------------------------  
  wb_projects <-
    st_as_sf(wb_projects, 
             coords = c("longitude", "latitude"), 
             crs = 4326)

  
# 5 Challenge: create a map with Mozambique projects ===================
  
  # Keep only Mozambique map
  moz <-
    africa %>%
    filter(country == "Mozambique")
  
  # Keep only projects that intersect with the Mozambique map
  moz_projects <-
    st_intersection(wb_projects, 
                    moz)
  
  # Create variable indicating project sector
  moz_projects <-
    moz_projects %>%
    mutate(sector =
             ifelse(str_detect(ad_sector_names, "Transport"), "Transport",
                    ifelse(str_detect(ad_sector_names, "Agriculture"), "Agriculture",
                           "Other")))
  # Get a basemap
  moz_box <-
    st_bbox(moz)
  
  basemap <- 
    get_stamenmap(as.vector(moz_box),
                  zoom = 6, # The higher the zoom, the more details you get
                  maptype = "terrain-background")
  
  # Package used for our map
  install.packages("wesanderson")
  library(wesanderson)
  
  # Plot the map
  ggmap(basemap) + 
    geom_sf(data = moz, 
            inherit.aes = FALSE,
            fill = "white", 
            alpha = .6) +         # Transparency
    geom_sf(data = moz_projects,
            aes(color = sector),  # Each color is one sector
            inherit.aes = FALSE,
            size = 1) +
    labs(color = "Project sector") +
    theme_void() + 
    scale_color_manual(values = wes_palette("GrandBudapest1", 3)) # Add nice colors!
  