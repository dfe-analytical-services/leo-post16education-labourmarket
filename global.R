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
library(ggthemes)
library(scales)

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
DFE_bar_colours2 <- c("#1d70b8","#f47738","#A55BC7","#28a197","#DD1B22","#ffbf47","#d53880","#059552")

#DFE_bar_col <- c("#5b9bd5","#ed7d31", "#c55a11","#a5a5a5","#ffc000","#4472c4","#70ad47","#44546a")
DFE_bar_col <- c("#44546a","#70ad47","#4472c4","#ffc000","#a5a5a5", "#c55a11","#ed7d31","#5b9bd5")

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

# plot_earnings <- function(input1, input2){
#   temp <- earnings_data_all %>%
#     filter(col1 == input1, col2 == input2)
#   
#   p_earnings <- ggplot(temp, aes(`Years after KS4`, `Average Earnings`, color = Subpopulation, linetype = Subpopulation))+
#     geom_line()+
#     ylab("Average Earnings (£)")+
#     xlab("Years after KS4")+
#     #scale_color_manual(values= Dfe_colours) +
#     govstyle::theme_gov() 
#     
#   
#   plotly::ggplotly(p_earnings ,res = 1200, mode = "lines", tooltip = c("Years after KS4", "Average Earnings", "linetype")) %>%
#     layout(hovermode = "x unified", autosize = T, showlegend = TRUE) %>%
#     config(displayModeBar = TRUE)
# }

plot_earnings <- function(input1, input2, input3){
  temp <- earnings_data_all %>%
    filter(col1 == input1, col2 == input2, Subpopulation %in% input3)
  
  p_earnings <- ggplot(temp, aes(`Years after KS4`, `Average Earnings`, color = Subpopulation, linetype = Subpopulation))+
    geom_line()+
    ylab("Average earnings £ (annual)")+
    xlab("Years after key stage 4 (full tax years)")+
    scale_y_continuous(limits = c(0, 36000),breaks = seq(0, 35000, by = 5000), label = comma, expand = c(0,0))+
    scale_x_continuous(limits = c(1, 15),breaks = seq(1, 15, by = 1))+
    #scale_color_manual(values= Dfe_colours) +
    govstyle::theme_gov()+
    theme(panel.grid.major.y = element_line("grey",size = 0.25, "solid"),
          panel.background = element_rect(fill = "white", color = "white"),
          plot.background = element_rect(fill = "white", color = "white"))
  
  
  plotly::ggplotly(p_earnings ,res = 1200, mode = "lines", tooltip = c("Years after KS4", "Average Earnings", "linetype")) %>%
    layout(hovermode = "x unified", autosize = T, showlegend = TRUE) %>%
    config(displayModeBar = TRUE)

}

#plot_earnings("National", "Ethnicity Major", c("Chinese", "White"))

table_earnings <- function(input1, input2, input3){
  temp <- earnings_data_all %>%
    filter(col1 == input1, col2 == input2, Subpopulation %in% input3) %>%
    select(`Years after KS4`, `Average Earnings`, Subpopulation)
  temp
}


#theme testing----------------------------
# plot_earnings_test <- function(input1, input2, input3){
#   temp <- earnings_data_all %>%
#     filter(col1 == input1, col2 == input2, Subpopulation %in% input3)
# 
#   p_earnings <- ggplot(temp, aes(`Years after KS4`, `Average Earnings`, color = Subpopulation, linetype = Subpopulation))+
#     geom_line()+
#     ylab("Average earnings £ (annual)")+
#     xlab("Years after key stage 4 (full tax years)")+
#     #ylim(0, 35000)+
#     scale_y_continuous(limits = c(0, 36000),breaks = seq(0, 35000, by = 5000), label = comma, expand = c(0,0))+
#     scale_x_continuous(limits = c(1, 15),breaks = seq(1, 15, by = 1))+
#     #scale_color_manual(values= Dfe_colours) +
#     govstyle::theme_gov() +
#     theme(panel.grid.major.y = element_line("grey",size = 0.25, "solid"),
#           panel.background = element_rect(fill = "white", color = "white"),
#           plot.background = element_rect(fill = "white", color = "white"))
# 
# 
#   plotly::ggplotly(p_earnings ,res = 1200, mode = "lines", tooltip = c("Years after KS4", "Average Earnings", "linetype")) %>%
#     layout(hovermode = "x unified", autosize = T, showlegend = TRUE) %>%
#     config(displayModeBar = TRUE)
# 
# }
# 
# plot_earnings_test("National", "All", "Overall Average")


# ---- National average comparison ---------------------------------------------
plot_earnings_comparison <- function(input1, input2, input3){
  temp <- earnings_data_all %>%
    filter(col1 == input1, col2 == input2, Subpopulation %in% input3)
  
  p_earnings2 <- ggplot(temp, aes(`Years after KS4`, `Average Earnings`, color = Subpopulation, linetype = Subpopulation))+
    geom_line()+
    ylab("Average Earnings £ (annual)")+
    xlab("Years after key stage 4 (full tax years)")+
    scale_y_continuous(limits = c(0, 36000),breaks = seq(0, 35000, by = 5000), label = comma, expand = c(0,0))+
    scale_x_continuous(limits = c(1, 15),breaks = seq(1, 15, by = 1))+
    #scale_color_manual(values= Dfe_colours) +
    govstyle::theme_gov()+
    theme(panel.grid.major.y = element_line("grey",size = 0.25, "solid"),
                                panel.background = element_rect(fill = "white", color = "white"),
                                plot.background = element_rect(fill = "white", color = "white"))
  
  p_earnings2 <- p_earnings2 + geom_line(data = national_earnings, aes(x = `Years after KS4`, y = `Average Earnings`, color = "black"))
  
  plotly::ggplotly(p_earnings2 , res = 1200, mode = "lines", tooltip = c("Years after KS4", "Average Earnings", "linetype")) %>%
    layout(hovermode = "x unified", autosize = T, showlegend = TRUE) %>%
    config(displayModeBar = TRUE)
}

#plot_earnings_comparison("National", "Ethnicity Major", c("Chinese", "White"))

table_earnings_comparison <- function (input1, input2, input3){
  temp <- earnings_data_all %>%
    filter(col1 == input1, col2 == input2, Subpopulation %in% input3) %>%
    select(`Years after KS4`, `Average Earnings`, Subpopulation) %>%
    rbind(national_earnings) %>%
    distinct()
  temp
}

#table_earnings_comparison("National", "Ethnicity Major", c("Chinese", "White"))

#---- Plotting Main activities stacked bar charts -----------------------------------

plot_activities <- function(input1, input2, input3){
  temp <- activities_data_all %>%
    filter(col1 == input1, col2 == input2, Subpopulation %in% input3) %>%
    select(`Years after KS4`, `Activity`, Subpopulation, Percentage)
  
  #temp$Activity <- factor(temp$Activity, levels = c("KS5","Other Education", "Adult FE", "Higher education", "Employment", "Out of work benefits", "No sustained activity", "Activity not captured"))
  temp$Activity <- factor(temp$Activity, levels = c("Activity not captured", "No sustained activity", "Out of work benefits", "Employment", "Higher education", "Adult FE","Other Education","KS5"))

  
  by_subpopulation <- temp %>%
    group_by(Subpopulation) %>%
    tidyr::nest() %>%
    mutate(plot = map(data, ~ggplot(temp, aes(`Years after KS4`, Percentage, fill = Activity, group = Subpopulation, text = format(ifelse(round(Percentage,0) > 1, round(Percentage,0), ""), 2))) +
                        geom_bar(position = 'stack', stat = 'identity')+
                        ylab("Percentage (%)")+
                        xlab("Years after Key Stage 4")+
                        geom_text(size = 3, 
                                  position = position_stack(vjust = 0.5), 
                                  label = format(ifelse(round(temp$Percentage,0) > 1, round(temp$Percentage,0), ""), 2),
                                  colour = ifelse(temp$Activity == "Activity not captured", "white", ifelse(temp$Activity == "Out of work benefits", "white", "black")))+
                        scale_fill_manual(values= DFE_bar_col) +
                        scale_y_continuous(limits = c(0, 105),breaks = seq(0, 100, by = 10))+
                        scale_x_continuous(breaks = seq(1, 15, by = 1))+
                        #scale_fill_brewer(palette = "Paired")+
                        govstyle::theme_gov()+
                        theme(panel.grid.major.y = element_line("grey",size = 0.25, "solid"),
                              panel.background = element_rect(fill = "white", color = "white"),
                              plot.background = element_rect(fill = "white", color = "white"))+
                        facet_wrap(~Subpopulation, scales = "free", ncol = 2)))
  
  plotly::ggplotly(by_subpopulation$plot[[1]], height = ((length(input3)/2 + length(input3)%%2)*300), res = 1200, mode = "bar", tooltip = c("Activity","Subpopulation", format("Percentage", 2))) %>%
    layout(autosize = T, showlegend = TRUE, barmode = "stack", legend=list(traceorder = "normal")) %>%
    config(displayModeBar = TRUE)%>%
    style(hoverinfo = "none", traces = c((length(input3)*8+1): (length(input3)*16))) #This chooses which traces' tooltip shouldn't appear
  #problem with this is that when you add new charts the number of traces changes and then you could need to specify with traces been to show or not
  
}

#p<-plot_activities("National", "Ethnicity Major", testinput3)
#plotly_json(p)

table_activities <- function(input1, input2, input3){
  temp <- activities_data_all %>%
    filter(col1 == input1, col2 == input2, Subpopulation %in% input3) %>%
    select(`Years after KS4`, `Activity`, Subpopulation, Percentage)
  temp
}

#---- Testing (delete later)--------------------------------------------------
#testinput3 <- c("Asian")
#length(testinput3)
#temp <- activities_data_all %>%
#  filter(col1 == "National", col2 == "Ethnicity Major", Subpopulation %in% testinput3) %>%
#  select(`Years after KS4`, `Activity`, Subpopulation, Percentage)

#temp$Activity <- factor(temp$Activity, levels = c("Activity not captured", "No sustained activity", "Out of work benefits", "Employment", "Higher education", "Adult FE","Other Education","KS5"))


# by_type <- temp %>%
#   group_by(Subpopulation, Activity) %>%
#   tidyr::nest() %>%
#   mutate(plot = map(data, ~ggplot(temp, aes(`Years after KS4`, Percentage, fill = Activity, group = Subpopulation, text = format(ifelse(round(Percentage,0) > 1, round(Percentage,0), ""), 2))) +
#                       geom_bar(position = 'stack', stat = 'identity')+
#                       ylab("Percentage (%)")+
#                       xlab("Years after Key Stage 4")+
#                       geom_text(size = 3, 
#                                 position = position_stack(vjust = 0.5), 
#                                 label = format(ifelse(round(temp$Percentage,0) > 1, round(temp$Percentage,0), ""), 2),
#                                 colour = ifelse(temp$Activity == "Activity not captured", "white", ifelse(temp$Activity == "Out of work benefits", "white", "black")))+
#                       scale_fill_manual(values= DFE_bar_col) +
#                       scale_y_continuous(limits = c(0, 105),breaks = seq(0, 100, by = 10))+
#                       scale_x_continuous(breaks = seq(1, 15, by = 1))+
#                       #scale_fill_brewer(palette = "Paired")+
#                       govstyle::theme_gov()+
#                       theme(panel.grid.major.y = element_line("grey",size = 0.25, "solid"),
#                             panel.background = element_rect(fill = "white", color = "white"),
#                             plot.background = element_rect(fill = "white", color = "white"))+
#                       facet_wrap(~Subpopulation, scales = "free", ncol = 2)))

#plot_height = (length(testinput3)/2 + length(testinput3)%%2)*500

# p<-plotly::ggplotly(by_type$plot[[1]], height = ((length(testinput3)/2 + length(testinput3)%%2)*350), res = 1200, mode = "bar", tooltip = c("Activity","Subpopulation", "Percentage")) %>%
#   layout(autosize = T, showlegend = TRUE, barmode = "stack", legend=list(traceorder = "normal")) %>%
#   config(displayModeBar = TRUE) %>%
#   style(hoverinfo = "none", traces = c((length(testinput3)*8+1): (length(testinput3)*16)))
# 
# 
# 
# p_json <- plotly_json(p)

# p <- plotly_build()
# p$x$data[[1]]$x
#
#print(paste0(fromJSON(p_json$x$data)$data, ": "))


#traces of bars plotnumber * 8 - 1
# i.e. 4 plots 0:31 is the traces for bars and then plotnumber*16
# bar_traces<- c(0:((length(testinput3)*8)-1))
# text_traces<- c((length(testinput3)*8+1): (length(testinput3)*16)-1)




