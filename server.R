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
    # Adapted from https://plotly.com/r/sankey-diagram/#basic-sankey-diagram
    
    if (input$sankey_filter == "all") {
      selected_pathways = list(
        source = c(0,1,0,2,3,3),
        target = c(2,3,3,4,4,5),
        value =  c(8,4,2,8,4,2)
      )
    }
    
    if (input$sankey_filter == "fsm") {
      selected_pathways = list(
        source = c(0,1,0,2,3,3,2),
        target = c(2,3,3,4,4,5,6),
        value =  c(3,2,1,1,2,1,3)
      )
    }
    
    fig <- plot_ly(
      type = "sankey",
      orientation = "h",
      
      node = list(
        label = c("KS5", "other_education", "HE 2", "adult_FE", "employed_final", "HE_final", "unknown_final"),
        color = c("#f47738", "#f47738", "#f47738", "#f47738", "#1d70b8", "#1d70b8"),
        pad = 15,
        thickness = 20,
        line = list(
          color = "black",
          width = 0.5
        )
      ),
      
      link = selected_pathways
    )
    fig <- fig %>% layout(
      title = "Education pathway outcomes POC",
      font = list(
        size = 10
      ),
      plot_bgcolor = 'white',
      paper_bgcolor = 'white'
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
      addFullscreenControl() %>%
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
