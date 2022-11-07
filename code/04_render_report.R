here::i_am(
  "code/04_render_report.R"
)

rmarkdown::render(
  here::here("EJI_report_gnb.Rmd"),
  knit_root_dir = here::here()
)
