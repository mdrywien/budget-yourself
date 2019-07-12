if (!require("pacman")) install.packages("pacman")
pacman::p_load(
  shiny,
  shinydashboard,
  DT,
  dplyr,
  rhandsontable,
  plotly,
  tidyr,
  glue)

source("functions/data_prep.R")