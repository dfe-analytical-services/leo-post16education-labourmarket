# shiny app development and appearance
library(shiny)
library(shinyGovstyle)
library(shinycssloaders)

# data import and manipulation
library(dplyr)
library(purrr)
library(rjson)
library(readr)

# visuals
library(plotly)
library(ggplot2)

# geo-spatial data and mapping
library(sf)
library(leaflet)
library(leaflet.extras)
library(viridis)

source("helpers/import_data.R", encoding = "UTF-8")
source("helpers/components.R", encoding = "UTF-8")
source("helpers/generate_sankey_nodes.R", encoding = "UTF-8")

# Reading shape files - https://cengel.github.io/R-spatial/intro.html#loading-shape-files-into-r

earnings_by_region = readr::read_csv(
  file = "data/dummy_earnings_data.csv",
  show_col_types = FALSE
)

regions <- sf::read_sf(
  dsn = "shapes",
  layer = "Regions_December_2018_EN_BFC"
) %>%
sf::st_transform('+proj=longlat +datum=WGS84')

map_data <- regions %>%
  left_join(
    earnings_by_region,
    by = c("rgn18cd" = "RegionID")
  )
