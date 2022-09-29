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
  # sayHello()
  
  
  # ---- Earnings Trajectory Page ------------------------------------------------
  
  # Second user input asking for the subpopulation, changes depending on the first population input 
  observeEvent(input$earn_select1, {
    updateSelectizeInput(session = session,
                         inputId = "earn_subcat",
                         choices = unique(earnings_data_all[earnings_data_all$col1 == input$earn_select1, "col2"]),
                         server = TRUE)
  })
  
  #reactive for the third picker - subgroups
  observeEvent(eventExpr ={
    input$earn_select1
    input$earn_subcat},{
      
      updatePickerInput(
        session = session,
        inputId = "earn_picker",
        label = NULL,
        selected = unique(earnings_data_all[earnings_data_all$col1 == input$earn_select1 & earnings_data_all$col2 == input$earn_subcat, "Subpopulation"])[1],
        choices = unique(earnings_data_all[earnings_data_all$col1 == input$earn_select1 & earnings_data_all$col2 == input$earn_subcat, "Subpopulation"]),
        choicesOpt = NULL,
        options = NULL,
        clearOptions = TRUE
      )
    }
  )
  
  
  output$ern_choice_txt <- renderText({
    picker_choices_earn <- paste(input$earn_picker, collapse = " & ")
    c(paste("You have selected the", tags$b(input$earn_subcat)," sub-group for ", tags$b(input$earn_select1), ". With specific breakdown(s) of ", paste("<b>", picker_choices_earn,"</b>"), paste(".")))
    #c(paste("You have selected to see the", tags$b(input$earn_select1),"population, subpopulation of ", tags$b(input$earn_subcat)," and specific characteristic(s) of ")
    #  ,paste("<b>", picker_choices,"</b>"), paste("."))
  })
  
  
  # Observe event looking at the population, subpopulation and comparison checkbox,
  # Looks to see if the box is checked. If box is not checked (null), then the plot without the national average line is plotted.
  # If it is checked, plot choices including the national average line.
  observeEvent(eventExpr = {
    input$comparisoncheck
    input$earn_select1
    input$earn_subcat
    input$earn_picker},
    {
      # Checks to see if the user has selected to compare the trajectories with the national average or not
      # if the checkbox has not been checked
      if(is.null(input$comparisoncheck)){
        # Double checks to see if the user has picked a values for the subgroups. If they have not, it returns an error message.
        output$earningsplot <- plotly::renderPlotly({
          validate(
            need(!is.null(input$earn_picker), "Please select at least one breakdown.")
          )
          plot_earnings(input$earn_select1, input$earn_subcat, input$earn_picker)
        })
        
        # Displays the data plotted as a table.
        output$table_earnings_tbl <- DT ::renderDataTable(
          DT::datatable(table_earnings(input$earn_select1, input$earn_subcat, input$earn_picker),
                        options = list(dom = 'ftp',
                                       pageLength = 10), colnames = c("Years after KS4", "Average Earnings (£)", "Subpopulation")) %>%
            formatCurrency("Average Earnings",currency = "", interval = 3, mark = ",", digits=0)
        )
      }else{
        # else( i.e the box has been checked) then it will call on functions that include the national average into the plots and tables
        output$earningsplot <- plotly::renderPlotly({
          validate(
            need(!is.null(input$earn_picker), "Please select at least one breakdown.")
          )
          plot_earnings_comparison(input$earn_select1, input$earn_subcat, input$earn_picker)
        })
        
        output$table_earnings_tbl <- DT ::renderDataTable(
          DT::datatable(table_earnings_comparison(input$earn_select1, input$earn_subcat, input$earn_picker),
                        options = list(dom = 'ftp',
                                       pageLength = 10), colnames = c("Years after KS4", "Average Earnings (£)", "Subpopulation"), rownames = FALSE) %>%
            formatCurrency("Average Earnings",currency = "", interval = 3, mark = ",", digits=0))
      }
    })
  
  
  # observeEvent(input$earn_picker,{
  #   output$activitiesplot <- plotly::renderPlotly({
  #     validate(
  #       need(!is.null(input$earn_picker), "Please select at least one characteristic.")
  #     )
  #     plot_activities(input$earn_select1, input$earn_subcat, input$earn_picker)
  #   })
  # })
  
  
  #Download button
  #For some reason downloading when the check is null doesn't work.
  #   observeEvent(eventExpr = {
  #     input$earn_select1
  #     input$earn_subcat
  #     input$comparisoncheck},
  #     if(is.null(input$comparisoncheck)){
  #       
  #       output$downloadearnings <- downloadHandler(
  #         filename = function() {
  #           paste("Earnings_Trajectory",input$earn_select1,input$earn_subcat,".csv", sep = "_")
  #         },
  #         content = function(file) {
  #           write.csv(table_earnings(input$earn_select1, input$earn_subcat), file, row.names = FALSE)
  #         }
  #       )
  #     }else{
  #       output$downloadearnings <- downloadHandler(
  #         filename = function() {
  #           paste("Earnings_Trajectory",input$earn_select1,input$earn_subcat,"ave_comparison.csv", sep = "_")
  #         },
  #         content = function(file) {
  #           write.csv(table_earnings(input$earn_select1, input$earn_subcat), file, row.names = FALSE)
  #         }
  #       )
  #     }
  # )
  
  # Reactive download for the earnings trajectory that changes the name depending on the first two value picked
  observeEvent(eventExpr = {
    input$earn_select1
    input$earn_subcat
    input$earn_picker},
    output$downloadearnings <- downloadHandler(
      filename = function() {
        paste("Earn_Traj",input$earn_select1,input$earn_subcat,".csv", sep = "_")
      },
      content = function(file) {
        write.csv(table_earnings(input$earn_select1, input$earn_subcat, input$earn_picker), file, row.names = FALSE)
      }
    )
  )
  
  
  
  # ---- Main Activity Page ------------------------------------------------------  
  
  # Second input that responds to the first population choice
  # observeEvent(input$activity_select1,{
  #   updateSelectizeInput(session = session,
  #                        inputId = "activity_subcat",
  #                        choices = unique(activities_data_all[activities_data_all$col1 == input$activity_select1, "col2"]),
  #                       # choices = unique(activities_main_categories[activities_main_categories$types == input$activity_select1, "names"]),
  #                        server = TRUE)
  # })
  
  observeEvent(input$activity_select1,{
    updatePickerInput(session = session,
                      inputId = "sub_group_picker",
                      selected = unique(activities_data_all[activities_data_all$col1 == input$activity_select1, "col2"])[1],
                      choices = unique(activities_data_all[activities_data_all$col1 == input$activity_select1, "col2"]),
                      # choices = unique(activities_main_categories[activities_main_categories$types == input$activity_select1, "names"]),
                      choicesOpt = NULL,
                      options = NULL,
                      clearOptions = TRUE)
  })
  
  # Another observe event that responds to the first and second choices, giving users ability to choose specific characteristics to view
  # observeEvent(eventExpr = {
  #   input$activity_select1
  #   input$activity_subcat},
  #   {
  #     updatePickerInput(
  #       session = session,
  #       inputId = "picker1",
  #       label = NULL,
  #       selected = unique(activities_data_all[activities_data_all$col1 == input$activity_select1 & activities_data_all$col2 == input$activity_subcat, "Subpopulation"])[1],
  #       choices = unique(activities_data_all[activities_data_all$col1 == input$activity_select1 & activities_data_all$col2 == input$activity_subcat, "Subpopulation"]),
  #       choicesOpt = NULL,
  #       options = NULL,
  #       clearOptions = TRUE
  #     )
  #   })
  
  observeEvent(eventExpr = {
    input$activity_select1
    input$sub_group_picker},
    {
      updatePickerInput(
        session = session,
        inputId = "picker1",
        label = NULL,
        selected = unique(activities_data_all[activities_data_all$col1 == input$activity_select1 & activities_data_all$col2 == input$sub_group_picker, "Subpopulation"])[1],
        choices = unique(activities_data_all[activities_data_all$col1 == input$activity_select1 & activities_data_all$col2 == input$sub_group_picker, "Subpopulation"]),
        choicesOpt = NULL,
        options = NULL,
        clearOptions = TRUE
      )
    })
  
  # This is a space to give the user an error message when you do not pick a value in the picker
  # observeEvent(input$picker1,{
  #   output$activitiesplot <- plotly::renderPlotly({
  #     validate(
  #       need(!is.null(input$picker1), "Please select at least one breakdown.")
  #     )
  #     plot_activities(input$activity_select1, input$activity_subcat, input$picker1)
  #   })
  # })
  
  observeEvent(input$picker1,{
    output$activitiesplot <- plotly::renderPlotly({
      validate(
        need(!is.null(input$picker1), "Please select at least one breakdown.")
      )
      plot_activities(input$activity_select1, input$sub_group_picker, input$picker1)
    })
  })
  
  # Output sentence to display and confirm the choices of the user.
  # output$act_choice_txt <- renderText({
  #   picker_choices_act <- paste(input$picker1, collapse = " & ")
  #   
  #   c(paste("You have selected the", tags$b(input$activity_subcat)," sub-group for ", tags$b(input$activity_select1), ". With specific breakdown(s) of ", paste("<b>", picker_choices_act,"</b>"), paste(".")))
  #   
  # })
  
  output$act_choice_txt <- renderText({
    picker_choices_act <- paste(input$picker1, collapse = " & ")
    
    c(paste("You have selected the", tags$b(input$activity_subcat)," sub-group for ", tags$b(input$sub_group_picker), ". With specific breakdown(s) of ", paste("<b>", picker_choices_act,"</b>"), paste(".")))
    
  })
  
  
  # This produces a table alternative of the data
  # output$table_activities_tbl <- DT ::renderDataTable(
  #   DT::datatable(table_activities(input$activity_select1, input$activity_subcat, input$picker1), options = list(dom = 'ftp', pageLength = 10), colnames = c("Years after KS4", "Activity", "Subpopulation", "Percentage (%)"), rownames = FALSE) %>%
  #     formatRound('Percentage', digits =0)
  # )
  # 
  output$table_activities_tbl <- DT ::renderDataTable(
    DT::datatable(table_activities(input$activity_select1, input$sub_group_picker, input$picker1), options = list(dom = 'ftp', pageLength = 10), colnames = c("Years after KS4", "Activity", "Subpopulation", "Percentage (%)"), rownames = FALSE) %>%
      formatRound('Percentage', digits =0)
  )
  
  #Download Handler for main activities page
  # output$downloadtrajectories <- downloadHandler(
  #   filename = function() {
  #     paste("Main_activities",input$activity_select1,input$activity_subcat, paste(input$picker1,collapse = "_"),".csv", sep = "_")
  #   },
  #   content = function(file) {
  #     write.csv(table_activities(input$activity_select1, input$activity_subcat, input$picker1), file, row.names = FALSE)
  #   }
  # )
  
  output$downloadtrajectories <- downloadHandler(
    filename = function() {
      paste("Main_activities",input$activity_select1,input$sub_group_picker, paste(input$picker1,collapse = "_"),".csv", sep = "_")
    },
    content = function(file) {
      write.csv(table_activities(input$activity_select1, input$sub_group_picker, input$picker1), file, row.names = FALSE)
    }
  )
  
}
