library(tidycensus)
library(tigris)
library(sf)

tidycensus::census_api_key('census_api_key_here', overwrite = TRUE, install = TRUE)

options(tigris_use_cache = T)

# Download the geometry/shapes for all US counties
us <- counties(cb = TRUE, resolution = '5m',  # specify  a 'light weight' resolution
               class = 'sf',                  # we want the data in sf format
               year = 2020)

# Subsetting to only texas and adjacent states
us_map <- us %>%
  filter(STATEFP %in% c('48', '35', '40', '08')) %>%
  select(GEOID, STATEFP, COUNTYFP, NAME) %>%
  mutate(COUNTYFP, COUNTYFP = as.numeric(COUNTYFP))

# Subsetting to only texas
texas <- us %>%
  filter(STATEFP == '48') %>%
  select(GEOID, STATEFP, COUNTYFP, NAME) %>%
  mutate(COUNTYFP, COUNTYFP = as.numeric(COUNTYFP))


# Merging county_avg data with us data to obtain spatial variables for mapping
county_avg_geo <- texas %>%
  right_join(county_avg, by = c("COUNTYFP" = "countyfp"))

# Saving county_avg_geo to data/ folder
saveRDS(
  county_avg_geo,
  file = here::here("data/conuty_avg_geo.rds")
)



# tmap multiple objects

