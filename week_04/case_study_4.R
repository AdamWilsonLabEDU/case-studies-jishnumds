# Load libraries
library(tidyverse)
library(nycflights13)

# Find the farthest airport
farthest_airport <- flights %>%
  select(dest, distance) %>%
  group_by(dest) %>%
  summarize(max_distance = max(distance), .groups = "drop") %>%
  arrange(desc(max_distance)) %>%
  slice(1) %>%
  left_join(airports, by = c("dest" = "faa")) %>%
  pull(name) %>%
  as.character()

# Print result
print(farthest_airport)
