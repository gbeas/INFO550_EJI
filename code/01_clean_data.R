here::i_am("code/01_clean_data.R")
library(dplyr)
library(labelled)
library(tidycensus)
library(tigris)
library(sf)

absolute_path_west <- here::here("derived_data/data_west_aspatial.rds")

data_west_aspatial <- readRDS(absolute_path_west)

####################

# Aggregating estimated proportions per census tract to county level
county_avg <- data_west_aspatial %>% 
  group_by(countyfp) %>%
  mutate(E_TOTPOP = as.numeric(gsub(",", "", E_TOTPOP))) %>%
  summarise(mean_pop = mean(E_TOTPOP, na.rm = T),
            mean_pov200 = mean(EP_POV200, na.rm = T),
            mean_mintry = mean(EP_MINRTY, na.rm = T),
            mean_hlthFlag = mean(F_HVM, na.rm = T),
            mean_pm = mean(E_PM, na.rm = T),
            mean_toxic = mean(E_TRI, na.rm = T),
            mean_asthma = mean(EP_ASTHMA, na.rm = T),
            mean_bp = mean(EP_BPHIGH, na.rm = T),
            mean_cancer = mean(EP_CANCER, na.rm = T),
            mean_ment = mean(EP_MHLTH, na.rm = T),
            mean_diab = mean(EP_DIABETES, na.rm = T))

# Obtaining spatial data
# tidycensus::census_api_key('census_api_key_here', overwrite = TRUE, install = TRUE)
options(tigris_use_cache = T)

# Download the geometry/shapes for all US counties
us <- counties(cb = TRUE, resolution = '5m',
               class = 'sf',                  # data in sf format
               year = 2020)

# Subsetting to only texas
texas_geo <- us %>%
  filter(STATEFP == '48') %>%
  select(GEOID, STATEFP, COUNTYFP, NAME) %>%
  mutate(COUNTYFP, COUNTYFP = as.numeric(COUNTYFP))

# Merging county_avg data with us data to obtain spatial variables for mapping
county_avg_geo <- texas_geo %>%
  right_join(county_avg, by = c("COUNTYFP" = "countyfp"))

saveRDS(
  county_avg_geo,
  file = here::here("derived_data", "county_avg_geo.rds")
)

saveRDS(
  texas_geo,
  file = here::here("derived_data", "texas_geo.rds")
)





