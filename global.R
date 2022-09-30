# Just incase you need to install it
#devtools::install_github('ukgovdatascience/govstyle')

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

#library(shina11y)


source("helpers/import_data.R", encoding = "UTF-8")
source("helpers/components.R", encoding = "UTF-8")


# These colours have been copied from the original main report - meant to replicate the plots in the report as much as possible
DFE_bar_col <- c("#44546a","#70ad47","#4472c4","#ffc000","#a5a5a5", "#c55a11","#ed7d31","#5b9bd5")


# ---- Earnings Trajectory plots ------------------------------------------------
# Function without the national average line
plot_earnings <- function(input1, input2, input3){
  temp <- earnings_data_all %>%
    filter(col1 == input1, col2 == input2, Subpopulation %in% input3)
  
  p_earnings <- ggplot(temp, aes(`Years after KS4`, `Average Earnings`, color = Subpopulation, linetype = Subpopulation))+
    geom_line()+
    ylab("Average earnings £ (annual)")+
    xlab("Years after key stage 4 (full tax years)")+
    scale_y_continuous(limits = c(0, 41000),breaks = seq(0, 40000, by = 5000), label = comma, expand = c(0,0))+
    scale_x_continuous(limits = c(1, 15),breaks = seq(1, 15, by = 1))+
    govstyle::theme_gov()+
    theme(panel.grid.major.y = element_line("grey",size = 0.25, "solid"),
          panel.background = element_rect(fill = "white", color = "white"),
          plot.background = element_rect(fill = "white", color = "white"))
  
  
  plotly::ggplotly(p_earnings ,res = 1200, mode = "lines", tooltip = c("Years after KS4", "Average Earnings", "linetype")) %>%
    layout(hovermode = "x unified", autosize = T, showlegend = TRUE, annotations = list(x = 1, y = -0.0, text = "Source: Longitudinal Educational Outcomes dataset",
                                                                                        xref='paper', yref='paper', showarrow = F, 
                                                                                        xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                                                                        font = list(size = 10)),
           title = list(text = 'Average earnings of individuals in employment \nfor KS4 cohorts 2001/02 to 2006/07', font = list(size = 18)), margin = list(t = 50, b = 50)) %>%
    config(displayModeBar = TRUE)

}

#plot_earnings("National", "Major ethnic group", c("Chinese", "White"))

table_earnings <- function(input1, input2, input3){
  temp <- earnings_data_all %>%
    filter(col1 == input1, col2 == input2, Subpopulation %in% input3) %>%
    select(`Years after KS4`, `Average Earnings`, Subpopulation)
  temp
}


# ---- National average comparison ---------------------------------------------
plot_earnings_comparison <- function(input1, input2, input3){
  temp <- earnings_data_all %>%
    filter(col1 == input1, col2 == input2, Subpopulation %in% input3)
  
  p_earnings2 <- ggplot(temp, aes(`Years after KS4`, `Average Earnings`, color = Subpopulation, linetype = Subpopulation))+
    geom_line()+
    ylab("Average Earnings £ (annual)")+
    xlab("Years after key stage 4 (full tax years)")+
    scale_y_continuous(limits = c(0, 41000),breaks = seq(0, 40000, by = 5000), label = comma, expand = c(0,0))+
    scale_x_continuous(limits = c(1, 15),breaks = seq(1, 15, by = 1))+
    govstyle::theme_gov()+
    theme(panel.grid.major.y = element_line("grey",size = 0.25, "solid"),
                                panel.background = element_rect(fill = "white", color = "white"),
                                plot.background = element_rect(fill = "white", color = "white"))
  
  p_earnings2 <- p_earnings2 + geom_line(data = national_earnings, aes(x = `Years after KS4`, y = `Average Earnings`))
  
  plotly::ggplotly(p_earnings2 , res = 1200, mode = "lines", tooltip = c("Years after KS4", "Average Earnings", "linetype")) %>%
    layout(hovermode = "x unified", autosize = T, showlegend = TRUE,annotations = list(x = 1, y = -0.0, text = "Source: Longitudinal Education Outcomes dataset",
                                                                                          xref='paper', yref='paper', showarrow = F, 
                                                                                          xanchor='right', yanchor='auto', xshift=0, yshift=0,
                                                                                          font = list(size = 10)),
           title = list(text = 'Average earnings of individuals in employment \nfor KS4 cohorts 2001/02 to 2006/07', font = list(size = 18)), margin = list(t = 50, b = 50)) %>%
    config(displayModeBar = TRUE)
}

#plot_earnings_comparison("National", "Major ethnic group", c("Chinese", "White"))

table_earnings_comparison <- function (input1, input2, input3){
  temp <- earnings_data_all %>%
    filter(col1 == input1, col2 == input2, Subpopulation %in% input3) %>%
    select(`Years after KS4`, `Average Earnings`, Subpopulation) %>%
    rbind(national_earnings) %>%
    distinct()
  temp
}

#table_earnings_comparison("National", "Ethnicity Major", c("Chinese", "White"))

#------------------------------------------------------------------------------------
#---- Plotting Main activities stacked bar charts -----------------------------------

plot_activities <- function(input1, input2, input3){
  temp <- activities_data_all %>%
    filter(col1 == input1, col2 == input2, Subpopulation %in% input3) %>%
    select(`Years after KS4`, `Activity`, Subpopulation, Percentage)

  # Displays the legend in order of the bars
  temp$Activity <- factor(temp$Activity, levels = c("Activity not captured", "No sustained activity", "Out of work benefits", "Employment", "Higher education", "Adult FE","Other Education","KS5"))


  by_subpopulation <- temp %>%
    group_by(Subpopulation) %>%
    tidyr::nest() %>%
    mutate(plot = map(data, ~ggplot(temp, aes(`Years after KS4`, Percentage, fill = Activity, group = Subpopulation, text = format(ifelse(round(Percentage,0) > 1, round(Percentage,0), ""), 2))) +
                        geom_bar(position = 'stack', stat = 'identity')+
                        ylab("Percentage (%)")+
                        xlab("Years after key stage 4")+
                        geom_text(size = 3,
                                  position = position_stack(vjust = 0.5),
                                  label = format(ifelse(round(temp$Percentage,0) > 1, round(temp$Percentage,0), ""), 2),
                                  colour = ifelse(temp$Activity == "Activity not captured", "white", ifelse(temp$Activity == "Out of work benefits", "white", "black")))+
                        scale_fill_manual(values= DFE_bar_col) +
                        scale_y_continuous(limits = c(0, 105),breaks = seq(0, 100, by = 10), expand = c(0,0))+
                        scale_x_continuous(breaks = seq(1, 15, by = 1))+
                        govstyle::theme_gov()+
                        theme(panel.grid.major.y = element_line("grey",size = 0.25, "solid"),
                              panel.background = element_rect(fill = "white", color = "white"),
                              plot.background = element_rect(fill = "white", color = "white"))+
                        facet_wrap(~Subpopulation, scales = "free", ncol = 2, dir = "h")))

  plotly::ggplotly(by_subpopulation$plot[[1]], height = ((floor(length(input3)/2))*400 + (length(input3)%%2)*400),
                   res = 1200, mode = "bar", tooltip = c("Activity","Subpopulation", format("Percentage", 2))) %>%
    layout(autosize = F, showlegend = TRUE, barmode = "stack", legend=list(traceorder = "normal"), 
           title = list(text = paste0('Main Activities of individuals for KS4 cohorts 2001/02 to 2006/07',
                                      '<br>',
                                      '<sup>',
                                      'Source: Longitudinal Education Outcomes dataset',
                                      '</sup>'), x=0, y = 1.8, font = list(size = 18)), 
           margin = list(t = 80, r = 0, b = 50, l= 0, unit = "px")) %>%
    config(displayModeBar = TRUE)%>%
    style(hoverinfo = "none", traces = c((length(input3)*8+1): (length(input3)*16))) #This chooses which traces' tooltip shouldn't appear
  #problem with this is that when you add new charts the number of traces changes and then you could need to specify with traces been to show or not

}
#height = ((floor(length(input3)/2))*400 + (length(input3)%%2)*400)
table_activities <- function(input1, input2, input3){
  temp <- activities_data_all %>%
    filter(col1 == input1, col2 == input2, Subpopulation %in% input3) %>%
    select(`Years after KS4`, `Activity`, Subpopulation, Percentage)
  temp
}


