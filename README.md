# Exploration of Environmental Justice Index variables in West Texas counties

------------------------------------------------------------------------

## Report description

The Environmental Justice Index (EJI) pulls data on 36 environmental, social, and health factors from a number of sources, including the U.S. Census Bureau, the U.S. EPA, and the CDC, to rank U.S. census tracts based on cumulative impacts of environmental injustice on health.[^1] This report explores a subset of the variables that go into the cumulative impact measures and specific health outcomes included by the EJI in West Texas counties. 

Results of the analysis presented in the report include Table 1 summarizing the results of a linear regression model to quantify the association between annual average number of days above the PM2.5 regulatory standard and average county health scores. There is also a bar plot of the average health scores by county and a map of the outcome to provide spatial context.

[^1]: https://experience.arcgis.com/experience/10788c3e860d489e9e8a63a2238bb63d

------------------------------------------------------------------------

## Relevant Make rules

### Generating the report locally

To generate the final report, set working directory to `EJI_project` directory. Run `Make report.html` or simply `make` in the terminal, and the html file, titled `EJI_report_gnb`, should appear in the project directory.

### Resotring the package environment

To restore packages necessary to prodcue the final report, make sure working directory is set to `EJI_project`. Run `make install` in the terminal.

### Docker image build

To build docker image run `make eji_project`

### Run docker container to build report

Mac M1: make final_report/report_m1.html

Mac Intel: make final_report/report_mac.html

Windows: make final_report/report_wind.html

Final report will be found in the `final_report` subdirectory




------------------------------------------------------------------------

## Code description

`code/00_clean_data.R`

  - read in raw data from `raw_data/` folder
  - subset West Texas counties and variables of interest
  - save West Texas data as `data_west_aspatial.rds` in `derived_data/` folder

`code/01_clean_data.R`

  - read West Texas subset from `derived_data/` folder
  - aggregate to county level
  - merge aggregate data with U.S. Census spatial data
  - save county aggregate data with spatial data as `county_avg_geo.rds` in `derived_data/` folder
  - save Texas county geo borders as `texas_geo.rds` in `derived_data/` folder

`code/02_make_table1.R`

  - read `county_avg_geo.rds` from `derived_data/` folder
  - runs linear regression model and creates table of output
  - save table to `output/` folder

`code/03_figures.R`

  - read `county_avg_geo.rds` from `derived_data/` folder
  - create disease map of 
  - save maps to `output/` folder

`code/04_render_report.R`

  - renders `EJI_report_gnb.Rmd`

`EJI_report_gnb.Rmd`

  - read in `reg_table.rds` and `figure1.rds`
  - import map
  - includes interpretation of results
  
## A note on the data

Data obtained from EJI is included in `raw_data/`. However, spatial data for mapping was obtained through the U.S. census and this requires a unique Census API key to download locally. For the purpose of this project, cleaned data with geography has been saved in `derived_data/` and included in the GitHub repository.



