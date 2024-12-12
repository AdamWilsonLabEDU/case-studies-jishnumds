# Load necessary libraries
library(tidyverse)
library(spData)
library(sf)
library(mapview)
library(foreach)
library(doParallel)
library(tidycensus)
# Installing packages
#install.packages(c("tidyverse", "spData", "sf", "mapview", "foreach", "doParallel", "tidycensus"))

#set census API key
census_api_key("8ecedbff9a6078afe27bbc78b40008bf2015c42e")

# Define the variables for racial groups
race_vars <- c(
  "Total Population" = "P1_001N",
  "White alone" = "P1_003N",
  "Black or African American alone" = "P1_004N",
  "American Indian and Alaska Native alone" = "P1_005N",
  "Asian alone" = "P1_006N",
  "Native Hawaiian and Other Pacific Islander alone" = "P1_007N",
  "Some Other Race alone" = "P1_008N",
  "Two or More Races" = "P1_009N"
)


options(tigris_use_cache = TRUE)
erie <- get_decennial(geography = "block", variables = race_vars, year=2020,
                      state = "NY", county = "Erie County", geometry = TRUE,
                      sumfile = "pl", cache_table=T)

# Crop the area to Buffalo 
erie <- st_crop(erie, xmin = -78.9, xmax = -78.85, ymin = 42.888, ymax = 42.92)

registerDoParallel(8) # Adjust based on the number of cores you want to use
getDoParWorkers()

# Convert `variable` to factor to loop through race categories
erie$variable <- factor(erie$variable)
race_points <- foreach(race = levels(erie$variable), .combine = rbind, .packages = c("sf", "dplyr")) %dopar% {
  
# Filter data for the current race
race_data <- filter(erie, variable == race)
  
# Generate points for each person within the polygons
points <- race_data %>%
  st_sample(size = .$value, exact = TRUE) %>%
  st_as_sf() %>%
  mutate(variable = race) # Add race as a new column
points
}

# Use mapview to create an interactive map
mapview(race_points, zcol = "variable", cex = 1, alpha = 0.7, stroke =FALSE)


