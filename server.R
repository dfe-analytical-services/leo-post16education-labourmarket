#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

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
  
  output$plot <- plotly::renderPlotly({
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
  
  output$sankey <- plotly::renderPlotly({
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
  
  # Mapping code adapted from https://rstudio.github.io/leaflet/choropleths.html
  # For guidance on colour palettes see: 
  #   - https://rstudio.github.io/leaflet/colors.html 
  #   - https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1069686/Research_reports_guidance_March_2022.pdf
  
  bins <- c(20000, 21000, 22000, 23000, 24000, 25000, 26000, 27000, 28000)
  
  pal <- colorBin(
    palette = c('#cfdce3', '#9fb9c8', '#7095ac', '#407291', '#104f75'), 
    domain = map_data$`Average Earnings`, 
    bins = bins
  )
  
  labels <- sprintf(
    "<strong>%s</strong><br/>£%g",
    map_data$rgn18nm, 
    map_data$`Average Earnings`
  ) %>% lapply(htmltools::HTML)
  
  output$mymap <- leaflet::renderLeaflet({
    leaflet() %>% 
      setView(lng = -1.61, lat = 52.909, zoom = 7) %>% 
      addProviderTiles(providers$CartoDB.Positron) %>%
      addPolygons(
        data = map_data, 
        fillColor = ~pal(`Average Earnings`),
        popup = paste(
          paste("<b>", map_data$rgn18nm, "</b><br />"), 
          as.character(paste("£", map_data$`Average Earnings`))
        ),
        color = "gray",
        dashArray = "3",
        opacity = 0.7,
        stroke = TRUE, 
        fillOpacity = 0.7, 
        smoothFactor = 0.5,
        weight = 1,
        highlightOptions = highlightOptions(
          weight = 5,
          color = "#666",
          dashArray = "",
          fillOpacity = 0.7,
          bringToFront = TRUE
        ),
        label = labels,
        labelOptions = labelOptions(
          style = list("font-weight" = "normal", padding = "3px 8px"),
          textsize = "15px",
          direction = "auto"
        )
      ) %>% 
      addLegend(
        pal = pal, 
        values = map_data$`Average Earnings`, 
        opacity = 0.7, 
        title = "Average earnings",
        position = "topright"
      )
  })
}
