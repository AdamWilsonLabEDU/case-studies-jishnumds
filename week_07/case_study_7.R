# Load necessary libraries
library(ggplot2)
library(spData)

# Load the world dataset
data(world)

# Filter out missing GDP data
world <- world %>% filter(!is.na(gdpPercap))

# Create the density plot
ggplot(world, aes(x = gdpPercap, fill = continent)) +
  geom_density(alpha = 0.5) +
  scale_fill_viridis_d() +
  labs(title = "GDP Per Capita Distribution by Continent",
    x = "GDP Per Capita",
    y = "Density",
    fill = "Continent") +
  theme_minimal()
