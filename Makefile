report.html: EJI_report_gnb.Rmd code/04_render_report.R derived_data/county_avg_geo derived_data/data_west_aspatial output/maps output/table1
	Rscript code/04_render_report.R

output/table1: code/02_make_table1.R derived_data/county_avg_geo
	Rscript code/02_make_table1.R

output/maps: code/03_figures.R derived_data/county_avg_geo
	Rscript code/03_figures.R
	
derived_data/county_avg_geo: code/01_clean_data.R derived_data/data_west_aspatial
	Rscript code/01_clean_data.R
	
derived_data/data_west_aspatial: code/00_clean_data.R raw_data/DataRecords.csv
	Rscript code/00_clean_data.R
	
.PHONY: clean
clean:
	rm -f *.html derived_data/*aspatial.rds output/*.png *.pdf *.png output/*.rds
	
.PHONY: clean_all
clean_all:
	rm -f *.html derived_data/*.rds output/*.png
	
.PHONY: install
install:
	Rscript -e 'renv::restore(prompt = FALSE)'
	
# DOCKER

project_files = EJI_report_gnb.Rmd code/00_clean_data.R code/01_clean_data.R code/02_make_table1.R code/03_figures.R code/ code/04_render_report.R Makefile

renv_files = renv.lock renv/settings.dcf renv/activate.R

# build image
eji_project: $(project_files) $(renv_files)
	docker build -t eji_project .
	touch $@
	
# run container mac M1
final_report/report_m1.html:
	docker run --platform linux/amd64 -v "$$(pwd)/final_report":/project/final_report gbeas/eji_project
	
# run container Mac Intel
final_report/report_mac.html:
	docker run -v "$$(pwd)/final_report":/project/final_report gbeas/eji_project

	
# run container Windows
final_report/report_wind.html:
	docker run -v "$$/(pwd)/final_report":/project/final_report gbeas/eji_project

