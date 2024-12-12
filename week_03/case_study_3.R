# Load necessary libraries
library(ggplot2)
library(gapminder)
library(dplyr)

# Filter the dataset to remove Kuwait
gapminder_filtered <- gapminder %>%
  filter(country != "Kuwait")

# Plot #1: Wealth and life expectancy through time
plot1 <- ggplot(gapminder_filtered, aes(x = gdpPercap, y = lifeExp, color = continent, size = pop / 100000)) +
  geom_point(alpha = 0.7) +
  facet_wrap(~year, nrow = 1) +
  scale_y_continuous(trans = "sqrt") +
  scale_size(range = c(1, 10)) +
  theme_bw() +
  labs(
    title = "Wealth and Life Expectancy Through Time",
    x = "GDP per Capita",
    y = "Life Expectancy",
    size = "Population (100k)",
    color = "Continent"
  )

# Prepare data for Plot #2
gapminder_continent <- gapminder_filtered %>%
  group_by(continent, year) %>%
  summarize(
    gdpPercapweighted = weighted.mean(gdpPercap, w = pop),
    weighted_lifeExp = weighted.mean(lifeExp, w = pop),
    total_population = sum(pop)
  )

# Plot #2: Continent-level trends with raw data
plot2 <- ggplot(gapminder_filtered, aes(x = year, y = gdpPercap, color = continent)) +
  geom_line(aes(group = country), alpha = 0.4) +
  geom_point() +
  geom_line(data = gapminder_continent, aes(x = year, y = gdpPercapweighted, group = continent), color = "black", size = 1) +
  geom_point(data = gapminder_continent, aes(x = year, y = gdpPercapweighted, size = total_population / 100000), color = "black") +
  facet_wrap(~continent, nrow = 1) +
  theme_bw() +
  labs(
    title = "GDP per Capita by Continent Over Time",
    x = "Year",
    y = "GDP per Capita",
    size = "Population (100k)",
    color = "Continent"
  )

# Save both plots as PNG files
ggsave("wealth_life_expectancy_plot1.png", plot = plot1, width = 15, height = 6)
ggsave("gdp_per_capita_plot2.png", plot = plot2, width = 15, height = 6)

# Print plots to view in RStudio
print(plot1)
print(plot2)