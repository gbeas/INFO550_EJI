report.html: EJI_report_gnb.Rmd code/04_render_report.R derived_data/county_avg_geo output/maps
	Rscript code/04_render_report.R

output/table1: code/02_make_table1.R derived_data/county_avg_geo
	Rscript code/02_make_table1.R

output/maps: code/03_figures.R derived_data/county_avg_geo
	Rscript code/03_figures.R
	
derived_data/county_avg_geo: code/01_clean_data.R raw_data/DataRecords.csv
	Rscript code/01_clean_data.R
	
.PHONY: clean
clean:
	rm -f *.html derived_data/*.rds output/*.png