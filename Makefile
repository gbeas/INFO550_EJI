report.html: EJI_report_gnb.Rmd code/04_render_report.R output/table1.rds output/maps.png
	Rscript code/04_render_report.R

output/table1: code/02_make_table1.R derived_data/data_west.rds derived_data/county_avg_geo.rds
	Rscript code/02_make_table1.R

output/maps: code/03_figures.R derived_data/county_avg_geo.rds
	Rscript code/03_figures.R
	
.PHONY: clean
clean:
	rm -f *.html