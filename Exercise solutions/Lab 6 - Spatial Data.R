# ------------------------------------------------------------------------------ #
#                                                                                #
#                                     DIME                                       #
#                               Spatial Data in R                                #
#                                                                                #
# ------------------------------------------------------------------------------ #

# PART 1: a regular data frame ---------------------------------------------------

  # Loading the data
  hh_data <- read.csv(file.path(finalData,"HH_data.csv"))
  
  str(hh_data)
  
  # Get a basemap
  centroid <-  c(30.46586, -2.014172)            # Choose a point to center the map on
  
  basemap <- get_map(location = centroid,        # Get map
                     zoom = 11,                  # Higher numbers zoom in, lower zoom out
                     maptype = "hybrid")         # See ?get_map for other map options
  
  # Plot map with household data
  ggmap(basemap) +                               # Load basemap 
    geom_point(data = hh_data,                   # Add points
               aes(x = longitude_scramble, 
                   y = latitude_scramble, 
                   color = food_security),
               size = .7) +
    coord_quickmap() +                           # Make sure the map isn't distorted
    theme_void() +                               # Remove gray color from background
    scale_color_manual(values = c("green",       # Set colors so they're more intuitive
                                  "orange",
                                  "red")) +
    labs(title="Household Food Security",        # Add titles
         color="Food Security") 
  
# PART 2: a spatial data frame ---------------------------------------------------
  
  # Load data
  rwanda_l1 <- getData('GADM', country='RWA', level=1)
  rwanda_l2 <- getData('GADM', country='RWA', level=2)
  
  # Access the dataframe containing the database
  rwanda_l1@data
  
  # Quick plot of Rwanda's first and second administrative divisions
  plot(rwanda_l1, lwd = 2)
  plot(rwanda_l2, add = TRUE)
  
  # Transform the shapefile into a data set
  rwanda_l1_df <- tidy(rwanda_l1, region = "ID_1")
  rwanda_l2_df <- tidy(rwanda_l2, region = "ID_2")
  head(rwanda_l2_df)
  
  # Merging spatial data and original data set
  rwanda_l1_df <- merge(rwanda_l1_df, rwanda_l1, 
                        by.x="id", by.y="ID_1")
  
  rwanda_l2_df <- merge(rwanda_l2_df, rwanda_l2, 
                        by.x="id", by.y="ID_2")
  
  # Create a bounding box around Rwanda
  area <- bbox(rwanda_l1)                 # bbox() only works with spatial data
  
  # Get the basemap from Google Maps
  basemap <- get_map(location = area,
                     zoom = 8,
                     maptype = "satellite")
  
  # Create map
  ggmap(basemap) +                         ## Add basemap
    geom_polygon(data = rwanda_l2_df,      ## Map second administrative division
                 aes(x = long,
                     y = lat,
                     group = group,
                     fill = id),            # One color fill per id
                 alpha = .2) +              # Set transparence of fill
    geom_polygon(data = rwanda_l1_df,      ## Map first administrative division
                 aes(x = long,
                     y = lat,
                     group = group),
                 colour = "black",          # Set color of line
                 alpha = 0) +               # Set transparence of fill
    coord_fixed(xlim = c(28.8, 31),         # Crop map to remove unnecessary borders
                ylim = c(-3,-1)) +
    theme_void() +                          # Remove ticks
    theme(legend.position = "none")         # Remove legend

  