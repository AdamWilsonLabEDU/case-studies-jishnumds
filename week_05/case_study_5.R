# Load necessary libraries
library(spData)
library(sf)
library(tidyverse)
library(units)

# Define the Albers Equal Area projection
albers <- "+proj=aea +lat_1=29.5 +lat_2=45.5 +lat_0=37.5 +lon_0=-96 +x_0=0 +y_0=0 +ellps=GRS80 +datum=NAD83 +units=m +no_defs"

# Load world and US states datasets
data(world)
data(us_states)

# Filter the Canada dataset and transform it to the Albers Equal Area projection
canada <- world %>%
  filter(name_long == "Canada") %>%
  st_transform(crs = albers)

# Create a 10 km buffer around Canada
canada_buffer <- st_buffer(canada, dist = 10000)

# Filter the New York state dataset and transform to Albers Equal Area projection
new_york <- us_states %>%
  filter(NAME == "New York") %>%
  st_transform(crs = albers)

# Calculate the intersection of the Canada buffer and New York state
ny_border <- st_intersection(new_york, canada_buffer)

# Calculate the area of the border region in km^2
border_area <- st_area(ny_border) %>%
  set_units("km^2") %>%
  as.numeric()

# Plot the border region
ggplot() +
  geom_sf(data = new_york, fill = "gray90") +
  geom_sf(data = ny_border, fill = "red") +
  labs(title = "New York Land within 10km", subtitle = "Canadian Border Buffer") +
  theme_minimal()

# Print the calculated area
print(paste("Area within 10km of the Canadian border in New York:", round(border_area, 2), "km^2"))
