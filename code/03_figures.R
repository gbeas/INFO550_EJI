library(tmap)

here::i_am("code/03_figures.R")

county_avg <- readRDS(
  file = here::here("derived_data", "county_avg_geo.rds")
)

texas <- readRDS(
  file = here::here("derived_data", "texas.rds")
)

# Estimated population; for reference
tm_shape(texas) +
  tm_borders(alpha = 0.4) +
  tm_shape(county_avg) +
    tm_fill("mean_pop",
            style = "quantile",
            palette = "BuPu") +
  tm_borders() +
  tm_layout()

# Variables of interest for visual comparison of spatial distribution
descriptive_panel <- tm_shape(texas) +
  tm_borders(alpha = 0.4) +
  tm_shape(county_avg) +
  tm_fill(c("mean_cancer","mean_toxic", "mean_pov200", 
            "mean_mintry", "mean_hlthFlag", "mean_pm"),
          style = "quantile",
          palette = "YlOrRd") +
  tm_borders() +
  tm_layout()

tmap_save(descriptive_panel, 
          file = here::here("output/map_panel.png"))
