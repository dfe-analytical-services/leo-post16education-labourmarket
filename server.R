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
  
  # observeEvent(input$btn1, {
  #   updateNavlistPanel(
  #     session,
  #     "navlistPanel",
  #     selected = "panel2"
  #   )
  # })
  
# ---- Earnings Trajectory Page ------------------------------------------------
  
  # Second user input asking for the subpopulation, changes depending on the first population input 
 observeEvent(input$earn_select1, {
  updateSelectizeInput(session = session,
                       inputId = "earn_subcat",
                       choices = unique(earnings_main_categories[earnings_main_categories$types == input$earn_select1, "names"]),
                       server = TRUE)
   })
  
  # Output to display and confirm the choices of the user.
    output$ern_choice_txt <- renderText({ 
    paste("You have selected to see the", tags$b(input$earn_select1),"population, subpopulation of ", tags$b(input$earn_subcat), ".")
  })
    
  # Observe event looking at the population, subpopulation and comparison checkbox,
  # Looks to see if the box is checked. If box is not checked (null), then the plot without the national average line is plotted.
  # If it is checked, plot choices including the national average line.
  observeEvent(eventExpr = {
    input$comparisoncheck
    input$earn_select1
    input$earn_subcat},
    {
      if(is.null(input$comparisoncheck)){
        
        output$earningsplot <- plotly::renderPlotly({
          plot_earnings(input$earn_select1, input$earn_subcat)
        })
        
        # Displays the data plotted as a table.
        output$table_earnings_tbl <- DT ::renderDataTable(
          DT::datatable(table_earnings(input$earn_select1, input$earn_subcat),
                        options = list(dom = 'ftp',
                                       pageLength = 10))
        )
      }else{
        output$earningsplot <- plotly::renderPlotly({
          plot_earnings_comparison(input$earn_select1, input$earn_subcat)
        })
        
        output$table_earnings_tbl <- DT ::renderDataTable(
          DT::datatable(table_earnings_comparison(input$earn_select1, input$earn_subcat),
                        options = list(dom = 'ftp',
                                       pageLength = 10)))
      }
    })
  

  
  #Download button
  observeEvent(eventExpr = {
    input$earn_select1
    input$earn_subcat
    input$comparisoncheck},
    if(is.null(input$comparisoncheck)){
      
      output$downloadearnings <- downloadHandler(
        filename = function() {
          paste("Earnings_Trajectory",input$earn_select1,input$earn_subcat,".csv", sep = "_")
        },
        content = function(file) {
          write.csv(table_earnings(input$earn_select1, input$earn_subcat), file, row.names = FALSE)
        }
      )
    }else{
      output$downloadearnings <- downloadHandler(
        filename = function() {
          paste("Earnings_Trajectory",input$earn_select1,input$earn_subcat,"ave_comparison.csv", sep = "_")
        },
        content = function(file) {
          write.csv(table_earnings(input$earn_select1, input$earn_subcat), file, row.names = FALSE)
        }
      )
    }
)

  
  #output$value <- renderPrint({ input$comparisoncheck })
 
  
# ---- Main Activity Page ------------------------------------------------------  
  
  # Second input that responds to the first population choice
 observeEvent(input$activity_select1,{
   updateSelectizeInput(session = session,
                        inputId = "activity_subcat",
                        choices = unique(activities_main_categories[activities_main_categories$types == input$activity_select1, "names"]),
                        server = TRUE)
 })
 
  # Another observe event that responds to the first and second choices, giving users ability to choose specific characteristics to view
 observeEvent(eventExpr = {
   input$activity_select1 
   input$activity_subcat},
   {
   updateSelectizeInput(session = session,
                        inputId = "activity_subsubcat",
                        choices = unique(activities_data_all[activities_data_all$col1 == input$activity_select1 & activities_data_all$col2 == input$activity_subcat, "Subpopulation"]),
                        server = TRUE)
 })
 
 # Output to display and confirm the choices of the user.
 output$act_choice_txt <- renderText({ 
   paste("You have selected to see the", tags$b(input$activity_select1),"population, subpopulation of ", tags$b(input$activity_subcat)," and specific characteristic of ", tags$b(input$activity_subsubcat), ".")
 })
 
 
  # This then plots it
  output$activitiesplot <- plotly::renderPlotly({
    plot_activities(input$activity_select1, input$activity_subcat, input$activity_subsubcat)
  })
  
  # This produces a table alternative of the data
  output$table_activities_tbl <- DT ::renderDataTable(
    DT::datatable(table_activities(input$activity_select1, input$activity_subcat, input$activity_subsubcat), options = list(dom = 'ftp', pageLength = 10))
  )
  
#------ COmmented out -----------------------------------------------------------
  # output$plot2 <- plotly::renderPlotly({
  #   mpg_mean <- mean(mtcars$mpg)
  #   ggplotly(
  #     ggplot(
  #       data = mtcars, 
  #       mapping = aes(
  #         x = wt, 
  #         y = mpg,
  #         col = factor(cyl),
  #         text = row.names(mtcars)
  #       )
  #     ) 
  #     + geom_point()
  #     + geom_hline(
  #       aes(
  #         yintercept = mpg_mean,
  #       ),
  #       linetype = "dashed",
  #       colour = 'black',
  #       size=0.4
  #     )
  #     + annotate(
  #       geom="text", 
  #       label="Mean", 
  #       x=1, 
  #       y=mpg_mean + 1, 
  #       vjust=-1
  #     )
  #     + govstyle::theme_gov()
  #   ) 
  # })
  # 
  # output$sankey <- plotly::renderPlotly({
  #   # Adapted from https://plotly.com/r/sankey-diagram/#basic-sankey-diagram
  #   
  #   dfe_orange = 'rgba(244, 119, 56, 0.4)'
  #   dfe_blue = 'rgba(29, 112, 184, 0.4)'
  #   dfe_dark = 'rgba(0, 0, 0, 0.4)'
  #   
  #   pathways <- readr::read_csv("data/sankey-data.csv") %>% 
  #   mutate(
  #     path_color = case_when(
  #       to == "adultFE" ~ dfe_orange,
  #       to == "highereducation" ~ dfe_orange,
  #       to == "not captured" ~ dfe_dark,
  #       TRUE ~ dfe_blue)
  #   )
  #   
  #   if (input$sankey_filter == "all") {
  #     sankey_node_mappings <- generate_sankey_node_mappings(
  #       df = pathways %>%
  #         filter(group == "All")
  #     )
  #     
  #     selected_pathways = list(
  #       source = sankey_node_mappings[[2]],
  #       target = sankey_node_mappings[[3]],
  #       value =  sankey_node_mappings[[4]],
  #       color = sankey_node_mappings[[5]]
  #     )
  #   }
  #   
  #   if (input$sankey_filter == "fsm") {
  #     sankey_node_mappings <- generate_sankey_node_mappings(
  #       df = pathways %>%
  #         filter(group == "FSM")
  #     )
  #     
  #     selected_pathways = list(
  #       source = sankey_node_mappings[[2]],
  #       target = sankey_node_mappings[[3]],
  #       value =  sankey_node_mappings[[4]],
  #       color = sankey_node_mappings[[5]]
  #     )
  #   }
  #   
  #   fig <- plot_ly(
  #     type = "sankey",
  #     orientation = "h",
  #     
  #     node = list(
  #       label = sankey_node_mappings[[1]],
  #       color = get_label_node_colors(sankey_node_mappings[[1]]),
  #       pad = 15,
  #       thickness = 20,
  #       line = list(
  #         color = "black",
  #         width = 0.5
  #       )
  #     ),
  #     
  #     link = selected_pathways
  #   )
  #   fig <- fig %>% layout(
  #     title = "Education pathway outcomes POC",
  #     font = list(
  #       size = 10
  #     ),
  #     plot_bgcolor = 'white',
  #     paper_bgcolor = 'white'
  #   )
  #   
  #   fig
  # })
  
  # Mapping code adapted from https://rstudio.github.io/leaflet/choropleths.html
  # For guidance on colour palettes see: 
  #   - https://rstudio.github.io/leaflet/colors.html 
  #   - https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/1069686/Research_reports_guidance_March_2022.pdf
  
  # bins <- c(20000, 21000, 22000, 23000, 24000, 25000, 26000, 27000, 28000)
  # 
  # pal <- colorBin(
  #   palette = c('#cfdce3', '#9fb9c8', '#7095ac', '#407291', '#104f75'), 
  #   domain = map_data$`Average Earnings`, 
  #   bins = bins
  # )
  # 
  # labels <- sprintf(
  #   "<strong>%s</strong><br/>£%g",
  #   map_data$rgn18nm, 
  #   map_data$`Average Earnings`
  # ) %>% lapply(htmltools::HTML)
  # 
  # output$mymap <- leaflet::renderLeaflet({
  #   leaflet() %>% 
  #     setView(lng = -1.61, lat = 52.909, zoom = 7) %>% 
  #     addProviderTiles(providers$CartoDB.Positron) %>%
  #     addFullscreenControl() %>%
  #     addPolygons(
  #       data = map_data, 
  #       fillColor = ~pal(`Average Earnings`),
  #       popup = paste(
  #         paste("<b>", map_data$rgn18nm, "</b><br />"), 
  #         as.character(paste("£", map_data$`Average Earnings`))
  #       ),
  #       color = "gray",
  #       dashArray = "3",
  #       opacity = 0.7,
  #       stroke = TRUE, 
  #       fillOpacity = 0.7, 
  #       smoothFactor = 0.5,
  #       weight = 1,
  #       highlightOptions = highlightOptions(
  #         weight = 5,
  #         color = "#666",
  #         dashArray = "",
  #         fillOpacity = 0.7,
  #         bringToFront = TRUE
  #       ),
  #       label = labels,
  #       labelOptions = labelOptions(
  #         style = list("font-weight" = "normal", padding = "3px 8px"),
  #         textsize = "15px",
  #         direction = "auto"
  #       )
  #     ) %>% 
  #     addLegend(
  #       pal = pal, 
  #       values = map_data$`Average Earnings`, 
  #       opacity = 0.7, 
  #       title = "Average earnings",
  #       position = "topright"
  #     )
  # })
  
}
