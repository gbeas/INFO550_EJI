library(tidycensus)
library(tigris)
library(sf)

# Aggregating estimated proportions of health outcomes per census tract to county level
county_avg <- data_west %>% 
  group_by(countyfp) %>%
  summarise(mean_pov200 = mean(EP_POV200, na.rm = T),
            mean_mintry = mean(EP_MINRTY, na.rm = T),
            mean_hlthFlag = mean(F_HVM, na.rm = T),
            mean_pm = mean(E_PM, na.rm = T),
            mean_toxic = mean(E_TRI, na.rm = T),
            mean_asthma = mean(EP_ASTHMA, na.rm = T),
            mean_bp = mean(EP_BPHIGH, na.rm = T),
            mean_cancer = mean(EP_CANCER, na.rm = T),
            mean_ment = mean(EP_MHLTH, na.rm = T),
            mean_diab = mean(EP_DIABETES, na.rm = T))

# IS CHAR VAR NEEDS TO BE NUMERIC: mean_totpop = mean(as.numeric(E_TOTPOP), na.rm = T)

tidycensus::census_api_key('***REMOVED***', overwrite = TRUE, install = TRUE) 

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

