here::i_am("code/01_clean_data.R")
library(dplyr)
library(labelled)
library(tidycensus)
library(tigris)
library(sf)

# Saving absolute file path to data
absolute_path <- here::here("raw_data/DataRecords.csv")

# Loading raw data
raw_data <- read.csv(absolute_path, header = T)

####################

# Subset to include only West Texas counties and just the variables of interest
data_west <- raw_data %>%
  filter(COUNTY %in%   c("Andrews", "Crockett", "Mason", "Reagan", "Terrell", "Borden", "Dawson", 
                         "Irion", "McCulloch", "Reeves", "Tom Green", "Coke", "Ector", "Kimble", 
                         "Menard", "Schleicher", "Upton", "Concho", "Gaines", "Loving", "Midland",
                         "Sterling", "Ward", "Crane", "Glasscock", "Martin", "Pecos", "Sutton", "Winkler")) %>%
  select(COUNTY, OBJECTID, statefp, countyfp, tractce, affgeoid, geoid, 
         name, StateAbbr, StateDesc, Location, E_DAYPOP, E_TOTPOP, EP_POV200, EP_BPHIGH, EP_ASTHMA, EP_CANCER, EP_MHLTH, EP_DIABETES,
         F_ASTHMA, E_OZONE, E_PM, E_DSLPM, E_PARK, E_ROAD, E_AIRPRT, F_HVM, E_NPL, E_TRI, EP_MINRTY)

# Save cleaned dataset in data folder as data.west
saveRDS(
  data_west,
  file = here::here("derived_data", "data_west.rds")
)

####################

# Aggregating estimated proportions per census tract to county level
county_avg <- data_west %>% 
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
texas <- us %>%
  filter(STATEFP == '48') %>%
  select(GEOID, STATEFP, COUNTYFP, NAME) %>%
  mutate(COUNTYFP, COUNTYFP = as.numeric(COUNTYFP))

# Merging county_avg data with us data to obtain spatial variables for mapping
county_avg_geo <- texas %>%
  right_join(county_avg, by = c("COUNTYFP" = "countyfp"))

saveRDS(
  county_avg_geo,
  file = here::here("derived_data", "county_avg_geo.rds")
)

saveRDS(
  texas,
  file = here::here("derived_data", "texas.rds")
)





