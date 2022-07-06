# shiny app development and appearance
library(shiny)
library(shinyGovstyle)
library(shinycssloaders)
library(shinyWidgets)
library(shinyjs)

# data import and manipulation
library(dplyr)
library(purrr)
library(rjson)
library(readr)
library(readxl)

# visuals
library(plotly)
library(ggplot2)
library(DT)

# geo-spatial data and mapping
library(sf)
library(leaflet)
library(leaflet.extras)
library(viridis)

source("helpers/import_data.R", encoding = "UTF-8")
source("helpers/components.R", encoding = "UTF-8")
# source("helpers/generate_sankey_nodes.R", encoding = "UTF-8")

# DfE colours
# All of the colours havE been take from this link: https://govuk-elements.herokuapp.com/colour/#colour-extended-palette
Dfe_colours <- c("#12436D","#F46A25", "#801650", "#28A197", "#505A5F", "#85994B", "#1D70B8", "#912B88", "#F499BE",
                 "#B58840", "#0B0C0C", "#6F72AF", "#D53880", "#00703C", "#FFDD00", "#D4351C")

#"#1D70B8","#F47738","#912B88","#28A197","#D53880" 

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

# Plotting other average earnings 

plot_earnings <- function(input1, input2){
  temp <- earnings_data_all %>%
    filter(col1 == input1, col2 == input2)
  
  p_earnings <- ggplot(temp, aes(`Years after KS4`, `Average Earnings`, color = Subpopulation, linetype = Subpopulation))+
    geom_line()+
    ylab("Average Earnings (£)")+
    xlab("Years after KS4")+
    scale_color_manual(values= Dfe_colours) +
    govstyle::theme_gov() 
    
  
  plotly::ggplotly(p_earnings ,res = 1200, mode = "lines", tooltip = c("Years after KS4", "Average Earnings", "linetype")) %>%
    layout(hovermode = "x unified", autosize = T, showlegend = TRUE) %>%
    config(displayModeBar = TRUE)
}

table_earnings <- function(input1, input2){
  temp <- earnings_data_all %>%
    filter(col1 == input1, col2 == input2) %>%
    select(`Years after KS4`, `Average Earnings`, Subpopulation)
  temp
}

# ---- National average comparison ---------------------------------------------
plot_earnings_comparison <- function(input1, input2){
  temp <- earnings_data_all %>%
    filter(col1 == input1, col2 == input2)
  
  p_earnings2 <- ggplot(temp, aes(`Years after KS4`, `Average Earnings`, color = Subpopulation, linetype = Subpopulation))+
    geom_line()+
    ylab("Average Earnings (£)")+
    xlab("Years after KS4")+
    scale_color_manual(values= Dfe_colours) +
    govstyle::theme_gov() 
  
  p_earnings2 <- p_earnings2 + geom_line(data = national_earnings, aes(x = `Years after KS4`, y = `Average Earnings`))
  
  plotly::ggplotly(p_earnings2 , res = 1200, mode = "lines", tooltip = c("Years after KS4", "Average Earnings", "linetype")) %>%
    layout(hovermode = "x unified", autosize = T, showlegend = TRUE) %>%
    config(displayModeBar = TRUE)
}

plot_earnings_comparison("National", "Gender")

table_earnings_comparison <- function (input1, input2){
  temp <- earnings_data_all %>%
    filter(col1 == input1, col2 == input2) %>%
    select(`Years after KS4`, `Average Earnings`, Subpopulation) %>%
    rbind(national_earnings) %>%
    distinct()
  temp
}

#table_earnings_comparison("National", "All")

#---- Plotting Main activities stacked bar charts -----------------------------------

plot_activities <- function (input1, input2, input3){
  temp <- activities_data_all %>%
    filter(col1 == input1, col2 == input2, Subpopulation %in% input3)
  
  temp$Activity <- factor(temp$Activity, levels = c("KS5","Other Education", "Adult FE", "Higher education", "Employment", "Out of work benefits", "No sustained activity", "Activity not captured"))
  
  p_activities <- ggplot(temp, aes(`Years after KS4`, Percentage, fill = Activity, group = Subpopulation)) +
    geom_bar(position = 'stack', stat = 'identity')+
    ylab("Percentage (%)")+
    xlab("Years after KS4")+
    scale_fill_manual(values= Dfe_colours) +
    govstyle::theme_gov()
  
  plotly::ggplotly(p_activities , res = 1200, mode = "bar") %>%
    layout(autosize = T, showlegend = TRUE, barmode = "stack", title = list(text = paste0(input1, " - ", input3),y = 0.95, x = 0.1, xanchor = 'Right', yanchor =  'top'), legend=list(traceorder = "normal")) %>%
    config(displayModeBar = TRUE)
}

testinput3 <- c("Female", "Male")
temp <- activities_data_all %>%
  filter(col1 == "National", col2 == "Gender", Subpopulation %in% testinput3) %>%
  select(`Years after KS4`, `Activity`, Subpopulation)
# 
# p_activities<- ggplot(temp %>% select(`Years after KS4`, Percentage, Subpopulation, Activity), aes(`Years after KS4`, Percentage, fill = Activity, group = Subpopulation)) +
#   geom_bar(position = 'stack', stat = 'identity')+
#   ylab("Percentage (%)")+
#   xlab("Years after KS4")+
#   scale_fill_manual(values= Dfe_colours) +
#   #scale_x_discrete(limits=c("KS5", "Adult FE", "Other Education", "Higher Education", "Employment", "Out of work benefits", "No sustained activity", "Activity not captured")) +
#   govstyle::theme_gov()
# 
# plotly::ggplotly(p_activities , res = 1200, mode = "bar") %>%
#   layout(autosize = T, showlegend = TRUE, barmode = "stack", legend=list(traceorder = "normal")) %>%
#   config(displayModeBar = TRUE)
# 
# 
# fig <- plot_ly(temp %>% group_by(Subpopulation), x = ~`Years after KS4`, y = ~Percentage, type = 'bar', name = temp$Activity)
# fig <- fig %>% layout(yaxis = list(title = 'Count'), barmode = 'stack', legend = list(traceorder = "normal")) 
# 
# fig


table_activities <- function(input1, input2, input3){
  temp <- activities_data_all %>%
    filter(col1 == input1, col2 == input2, Subpopulation %in% input3) %>%
    select(`Years after KS4`, `Activity`, Subpopulation)
  temp
}

#table_activities("National", "Gender", testinput3)


#plot_activities("national", "Gender", activities_data_all)
# table_earnings("national", "Gender")

# test1 <- "National"
# test2 <- "Ethnicity Major"
# test3 <- c("Mixed", "White", "Asian")
# test <- activities_data_all %>%
#   filter(col1 == "National", col2 == "Ethnicity Major", Subpopulation %in% test3)
# length(test3)
# test

# unique(activities_data_all[activities_data_all$col1 == test1 & activities_data_all$col2 == test2, "Subpopulation"])

