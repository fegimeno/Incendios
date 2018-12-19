if (!require(devtools))
  install.packages("devtools")
devtools::install_github("rstudio/leaflet")
shiny::runGitHub("fegimeno/Incendios", ref="Rama-2")

