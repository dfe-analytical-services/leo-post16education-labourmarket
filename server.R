#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)
library(ggplot2)
library(plotly)
library(govstyle)
library(dplyr)
library(rjson)

# Define server logic 
server <- function(input, output, session) {
  sayHello()
  
  observeEvent(input$btn1, {
    updateNavlistPanel(
      session,
      "navlistPanel",
      selected = "panel2"
    )
  })
  
  output$plot <- renderPlotly({
    mpg_mean <- mean(mtcars$mpg)
    ggplotly(
      ggplot(
        data = mtcars, 
        mapping = aes(
          x = wt, 
          y = mpg,
          col = factor(cyl),
          text = row.names(mtcars)
        )
      ) 
      + geom_point()
      + geom_hline(
        aes(
          yintercept = mpg_mean,
        ),
        linetype = "dashed",
        colour = 'black',
        size=0.4
      )
      + annotate(
        geom="text", 
        label="Mean", 
        x=1, 
        y=mpg_mean + 1, 
        vjust=-1
      )
      + govstyle::theme_gov()
    ) 
  })
  
  output$sankey <- renderPlotly({
    # Lift from https://plotly.com/r/sankey-diagram/#basic-sankey-diagram
    
    json_file <- "https://raw.githubusercontent.com/plotly/plotly.js/master/test/image/mocks/sankey_energy.json"
    json_data <- fromJSON(paste(readLines(json_file), collapse=""))
    
    fig <- plot_ly(
      type = "sankey",
      domain = list(
        x =  c(0,1),
        y =  c(0,1)
      ),
      orientation = "h",
      valueformat = ".0f",
      valuesuffix = "TWh",
      
      node = list(
        label = json_data$data[[1]]$node$label,
        color = json_data$data[[1]]$node$color,
        pad = 15,
        thickness = 15,
        line = list(
          color = "black",
          width = 0.5
        )
      ),
      
      link = list(
        source = json_data$data[[1]]$link$source,
        target = json_data$data[[1]]$link$target,
        value =  json_data$data[[1]]$link$value,
        label =  json_data$data[[1]]$link$label
      )
    ) 
    fig <- fig %>% layout(
      title = "Energy forecast for 2050<br>Source: Department of Energy & Climate Change, Tom Counsell via <a href='https://bost.ocks.org/mike/sankey/'>Mike Bostock</a>",
      font = list(
        size = 10
      ),
      xaxis = list(showgrid = F, zeroline = F),
      yaxis = list(showgrid = F, zeroline = F)
    )
    
    fig
  })
  
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(zoom = 9, lng = 0, lat = 51)
  })
}
