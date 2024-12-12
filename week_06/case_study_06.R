#install.packages("terra")
library(terra)
#install.packages("spData")
library(spData)
library(tidyverse)
#install.packages("sf")
library(sf)
#install.packages("ncdf4")
library(ncdf4)

# Download the HadCRUT dataset for absolute temperatures
download.file("https://crudata.uea.ac.uk/cru/data/temperature/absolute.nc","crudata.nc")

# read in the data using the rast() function from the terra package
tmean=rast("crudata.nc")
plot(tmean)

#Calculate the maximum temperature for each pixel
max_t <- max(tmean)
plot(max_t)

# Load the world countries dataset from the spData package
data("world")
#world <- world %>% filter(name_long != "Antarctica")
countries <- vect(world)   # Load the world countries dataset from the spData package 

# Extract the maximum temperature value for each country
max_temps <- terra::extract(max_t, countries, fun = max, na.rm=T, small=T)

# Combine the world dataset with the extracted maximum temperatures
world_clim <- bind_cols(world,max_temps)

# Plot the maximum temperature by country using ggplot2
ggplot(world_clim) + 
  geom_sf(data = world_clim, aes(fill= max)) +
  scale_fill_viridis_c(name="Maximum\nTemperature (C)") +
  labs(title = "Maximum Temperature (1961-1990) by Country") +
  theme(legend.position = "bottom")

# Find the hottest country in each continent
hottest_continents <- world_clim %>% 
  st_set_geometry (NULL) %>%
  group_by(continent) %>%                  # Group by continent
  top_n(1, max) %>%                        # Select the row with the highest max_temp in each continent
  arrange(continent) %>%                   # Arrange the result by continent
  select(name_long, continent, max) %>%    # Select only the relevant columns
  arrange(desc(max))

# Print the table
print(hottest_continents)




                        







