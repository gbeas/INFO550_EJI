# Exploration of Environmental Justice Index variables in West Texas counties

> DISCLAIMER: Contents of report are currently undergoing a major overhaul and are fully broken. There is nothing in the output/ folder because code for output is currently in development

------------------------------------------------------------------------

## Report description

The Environmental Justice Index (EJI) pulls data on 36 environmental, social, and health factors from a number of sources, including the U.S. Census Bureau, the U.S. EPA, and the CDC, to rank U.S. census tracts based on cumulative impacts of environmental injustice on health.[^1] This report explores a subset of the variables that go into the cumulative impact measures and specific health outcomes included by the EJI in West Texas counties. 

Results of this descriptive analysis presented in the report include Table 1 summarizing the values of variables of interest from the county-level aggregate data and a collection of maps exploring the spatial heterogeneity of health outcomes.

[^1]: https://experience.arcgis.com/experience/10788c3e860d489e9e8a63a2238bb63d

------------------------------------------------------------------------

## Generating the report

To generate the final report, set working directory to `EJI_project` directory. Run `Make report.html` or simply `make` in the terminal, and the html file, titled `EJI_report_gnb`, should appear in the project directory.

------------------------------------------------------------------------

## Code description

`code/01_clean_data.R`

  - read in raw data from `raw_data/` folder
  - subset West Texas counties and variables of interest
  - aggregate to county level
  - merge aggregate data with U.S. Census spatial data
  - save West Texas data as `data_west.rds` in `derived_data/` folder
  - save county aggregate data with spatial data as `county_avg_geo.rds` in `derived_data/` folder

`code/02_make_table1.R`

  - read `county_avg_geo.rds` from `derived_data/` folder
  - create table to display these characteristics
  - save table to `output/` folder

`code/03_figures.R`

  - read `county_avg_geo.rds` from `derived_data/` folder
  - create disease maps of health outcome
  - save maps to `output/` folder

`code/04_render_report.R`

  - renders `EJI_report_gnb.Rmd`

`EJI_report_gnb.Rmd`

  - read in `table.rds`
  - import maps
  - includes interpretation of results





