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
data_west_aspatial <- raw_data %>%
  filter(COUNTY %in%   c("Andrews", "Crockett", "Mason", "Reagan", "Terrell", "Borden", "Dawson", 
                         "Irion", "McCulloch", "Reeves", "Tom Green", "Coke", "Ector", "Kimble", 
                         "Menard", "Schleicher", "Upton", "Concho", "Gaines", "Loving", "Midland",
                         "Sterling", "Ward", "Crane", "Glasscock", "Martin", "Pecos", "Sutton", "Winkler")) %>%
  select(COUNTY, OBJECTID, statefp, countyfp, tractce, affgeoid, geoid, 
         name, StateAbbr, StateDesc, Location, E_DAYPOP, E_TOTPOP, EP_POV200, EP_BPHIGH, EP_ASTHMA, EP_CANCER, EP_MHLTH, EP_DIABETES,
         F_ASTHMA, E_OZONE, E_PM, E_DSLPM, E_PARK, E_ROAD, E_AIRPRT, F_HVM, E_NPL, E_TRI, EP_MINRTY)

# Save cleaned dataset in data folder as data.west
saveRDS(
  data_west_aspatial,
  file = here::here("derived_data", "data_west_aspatial.rds")
)
