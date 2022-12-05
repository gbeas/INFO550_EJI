library(tmap)
library(ggplot2)
library(grid)
library(sf)

here::i_am("code/03_figures.R")

############ Maps ###############

county_avg <- readRDS(
  file = here::here("derived_data", "county_avg_geo.rds")
)

texas <- readRDS(
  file = here::here("derived_data", "texas_geo.rds")
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

# Average health flags per county -- MAIN MAP
health_flag <-
  tm_shape(county_avg) +
    tm_fill("mean_hlthFlag",
            style = "quantile",
            palette = "YlOrRd",
            title = "Mean # of flagged tracts") +
  tm_borders() +
  tm_compass(north = 0, type = "arrow", color.dark = "grey43", position = c("left", "top"), size = 1.2, text.color = "grey43") +
  tm_scale_bar(breaks = c(0,10,20,30), position = c(.9, .04), color.dark = "grey43") +
  tm_credits("Environmental Justice Index, 2022; U.S. Census Bureau, 2020", position = c("RIGHT", "BOTTOM")) +
  tm_layout(main.title = "Figure 2: Geograhpic distribution of average health score*, 2022", 
            main.title.pos = c("center", "top"), 
            inner.margins = c(0.05, 0.05, 0.05, 0.05), legend.format = c(digits = 2))
health_flag

# -- INSET MAP
tx_inset <- tm_shape(texas) + tm_borders(alpha = 0.4) +
  tm_shape(county_avg) +
  tm_fill(col = "grey45") + tm_borders()

tmap_save(health_flag,insets_tm = tx_inset,insets_vp=viewport(x=.1, y=.11, width=.2, height=.2), 
          filename = "output/flags_inset.png", dpi=600)


############ Other ###############

figure1 <- ggplot(data = county_avg, aes(x = NAME, y = mean_hlthFlag)) +
  geom_bar(aes(fill=flag_quant), stat="identity") +
  labs(title = "Figure 1: Average Health Score by County, West Texas, 2022", x = "County", 
       y = "Mean Health Score", fill = "quantile") +
  scale_fill_brewer(palette = "YlOrRd")
figure1 <- figure1 + theme_bw() + theme(axis.text.x = element_text(angle = 80, vjust = 0.5))
figure1

saveRDS(
  figure1,
  file = here::here("output/figure1.rds")
)
