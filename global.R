# shiny app development and appearance
library(shiny)
library(shinyGovstyle)
library(shinycssloaders)
library(shinyWidgets)

# data import and manipulation
library(dplyr)
library(purrr)
library(rjson)
library(readr)
library(readxl)

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
# source("helpers/generate_sankey_nodes.R", encoding = "UTF-8")
# 
# # Reading shape files - https://cengel.github.io/R-spatial/intro.html#loading-shape-files-into-r
# 
# earnings_by_region = readr::read_csv(
#   file = "data/dummy_earnings_data.csv",
#   show_col_types = FALSE
# )
# 
# regions <- sf::read_sf(
#   dsn = "shapes",
#   layer = "Regions_December_2018_EN_BFC"
# ) %>%
# sf::st_transform('+proj=longlat +datum=WGS84')
# 
# map_data <- regions %>%
#   left_join(
#     earnings_by_region,
#     by = c("rgn18cd" = "RegionID")
#   )



# Plotting functions -----------------------------------------------------------

# Plotting national average earnings
plot_all_earnings <- function(data){ # data here should be national_all
  p_all <- ggplot(data, aes(years_after_KS4, average))+
    geom_line()+
    ylab("Average Earnings (£)")+
    xlab("Years after KS4")
  plotly::ggplotly(p_all , res = 1200) %>%
    layout(hovermode = "x unified", autosize = T) %>%
    config(displayModeBar = TRUE)
}

# Plotting other average earnings

plot_other_earnings <- function(input1, input2, alldata){
  temp <- alldata %>%
    filter(col1 == input1, col2 == input2)
  
  p_other <- ggplot(temp, aes(years_after_KS4, average, color = subgroup))+
    geom_line()+
    ylab("Average Earnings (£)")+
    xlab("Years after KS4")
  
  plotly::ggplotly(p_other , res = 1200) %>%
    layout(hovermode = "x unified", autosize = T) %>%
    config(displayModeBar = TRUE)
}

