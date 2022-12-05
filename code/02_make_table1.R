library(gtsummary)

here::i_am("code/02_make_table1.R")

county_avg <- readRDS(
  file = here::here("derived_data", "county_avg_geo.rds")
)

health_mod <- glm(mean_hlthFlag ~ mean_pm + mean_pov200 + mean_mintry, 
                  data = county_avg)

reg_table <- tbl_regression(health_mod) |>
  add_global_p()

saveRDS(reg_table,
        file = here::here("output/reg_table.rds"))
