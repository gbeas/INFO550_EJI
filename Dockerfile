FROM rocker/r-ubuntu

RUN apt-get update && apt-get -y install pandoc
RUN apt-get install -y libxml2-dev libcurl4-openssl-dev libssl-dev libfontconfig1-dev libudunits2-dev libgdal-dev

RUN mkdir /project
WORKDIR /project

RUN mkdir code
RUN mkdir output
RUN mkdir raw_data
RUN mkdir derived_data
RUN mkdir final_report

COPY code code
COPY Makefile .
COPY EJI_report_gnb.Rmd .
COPY output output
COPY raw_data raw_data
COPY derived_data derived_data

COPY .Rprofile .
COPY renv.lock .
RUN mkdir renv
COPY renv/activate.R renv
COPY renv/settings.dcf renv

RUN Rscript -e "renv::restore(prompt = FALSE)"

CMD make && mv EJI_report_gnb.html final_report
