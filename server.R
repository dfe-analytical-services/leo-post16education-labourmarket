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

  # Second user input for earnings Trajectory page - subgroups
  observeEvent( # looks at the first user input choice
    input$earn_select1,
    {
      # updates the second picker with the new filtered values and has a default of the first one in the array
      updatePickerInput(
        session = session,
        inputId = "earn_subcat",
        selected = unique(earnings_data_all[earnings_data_all$col1 == input$earn_select1, "col2"])[1],
        choices = unique(earnings_data_all[earnings_data_all$col1 == input$earn_select1, "col2"]),
        choicesOpt = NULL,
        options = NULL,
        clearOptions = TRUE
      )
    }
  )

  # reactive for the third picker - breakdowns
  observeEvent( # looks at the 1st and 2nd user inputs
    eventExpr = {
      input$earn_select1
      input$earn_subcat
    }, {
      # updates the last picker with the filtered choices from inputs 1 and 2 and defaults to the first in array
      updatePickerInput(
        session = session,
        inputId = "earn_picker",
        label = NULL,
        selected = unique(earnings_data_all[earnings_data_all$col1 == input$earn_select1 &
          earnings_data_all$col2 == input$earn_subcat, "Subpopulation"])[1],
        choices = unique(earnings_data_all[earnings_data_all$col1 == input$earn_select1 &
          earnings_data_all$col2 == input$earn_subcat, "Subpopulation"]),
        choicesOpt = NULL,
        options = NULL,
        clearOptions = TRUE
      )
    }
  )

  # reactive text to display the choices made by the user.
  output$ern_choice_txt <- renderText({
    picker_choices_earn <- paste(input$earn_picker, collapse = " & ")
    c(paste("You have selected the", tags$b(input$earn_subcat), " sub-group for ", tags$b(input$earn_select1), ". With specific breakdown(s) of ", paste("<b>", picker_choices_earn, "</b>"), paste(".")))
  })


  # Observe event looking at the population, subpopulation and comparison checkbox,
  # Looks to see if the box is checked. If box is not checked (null), then the plot without the national average line is plotted.
  # If it is checked, plot choices including the national average line.
  observeEvent(eventExpr = {
    input$comparisoncheck
    input$earn_select1
    input$earn_subcat
    input$earn_picker
  }, {
    # Checks to see if the user has selected to compare the trajectories with the national average or not
    # if the checkbox has not been checked
    if (is.null(input$comparisoncheck)) {
      # Double checks to see if the user has picked a values for the subgroups. If they have not, it returns an error message.
      output$earningsplot <- plotly::renderPlotly({
        validate(
          need(!is.null(input$earn_picker), "Please select at least one breakdown.")
        )
        # input$earn_select1, input$earn_subcat,
        plot_earnings(input$earn_picker)
      })

      # Displays the data plotted as a table.
      output$table_earnings_tbl <- DT::renderDataTable(
        DT::datatable(table_earnings(input$earn_select1, input$earn_subcat, input$earn_picker),
          options = list(
            dom = "ftp",
            pageLength = 10
          ), colnames = c("Years after KS4", "Average Earnings (£)", "Subpopulation")
        ) %>%
          formatCurrency("Average Earnings", currency = "", interval = 3, mark = ",", digits = 0)
      )
    } else {
      # else( i.e the box has been checked) then it will call on functions that include the national average into the plots and tables
      output$earningsplot <- plotly::renderPlotly({
        validate(
          need(!is.null(input$earn_picker), "Please select at least one breakdown.")
        )
        # input$earn_select1, input$earn_subcat,
        plot_earnings_comparison(input$earn_picker)
      })

      output$table_earnings_tbl <- DT::renderDataTable(
        DT::datatable(table_earnings_comparison(input$earn_select1, input$earn_subcat, input$earn_picker),
          options = list(
            dom = "ftp",
            pageLength = 10
          ), colnames = c("Years after KS4", "Average Earnings (£)", "Subpopulation"), rownames = FALSE
        ) %>%
          formatCurrency("Average Earnings", currency = "", interval = 3, mark = ",", digits = 0)
      )
    }
  })

  # Reactive download for the earnings trajectory that changes the name depending on the first two values picked
  observeEvent(
    eventExpr = {
      input$earn_select1
      input$earn_subcat
      input$earn_picker
    },
    output$downloadearnings <- downloadHandler(
      filename = function() {
        paste("Earn_Traj", input$earn_select1, input$earn_subcat, ".csv", sep = "_")
      },
      content = function(file) {
        write.csv(table_earnings(input$earn_select1, input$earn_subcat, input$earn_picker), file, row.names = FALSE)
      }
    )
  )



  # ---- Main Activity Page ------------------------------------------------------

  # Second user input - subgroups
  observeEvent( # looks at the first user input choice
    input$activity_select1,
    {
      # updates the second picker with the new filtered values and has a default of the first one in the array
      updatePickerInput(
        session = session,
        inputId = "sub_group_picker",
        selected = unique(activities_data_all[activities_data_all$col1 == input$activity_select1, "col2"])[1],
        choices = unique(activities_data_all[activities_data_all$col1 == input$activity_select1, "col2"]),
        choicesOpt = NULL,
        options = NULL,
        clearOptions = TRUE
      )
    }
  )

  # third user input - breakdowns
  observeEvent( # looks at the 1st and 2nd user inputs
    eventExpr = {
      input$activity_select1
      input$sub_group_picker
    }, {
      # updates the last picker with the filtered choices from inputs 1 and 2 and defaults to the first in array
      updatePickerInput(
        session = session,
        inputId = "picker1",
        label = NULL,
        selected = unique(activities_data_all[activities_data_all$col1 == input$activity_select1 &
          activities_data_all$col2 == input$sub_group_picker, "Subpopulation"])[1],
        choices = unique(activities_data_all[activities_data_all$col1 == input$activity_select1 &
          activities_data_all$col2 == input$sub_group_picker, "Subpopulation"]),
        choicesOpt = NULL,
        options = NULL,
        clearOptions = TRUE
      )
    }
  )


  observeEvent(input$picker1, {
    output$activitiesplot <- plotly::renderPlotly({
      # validation to make sure that the user has picked at least one breakdown
      validate(
        need(!is.null(input$picker1), "Please select at least one breakdown.")
      )
      # input$activity_select1, input$sub_group_picker,
      plot_activities(input$picker1)
    })
  })

  # reactive text to display what the user has picked
  output$act_choice_txt <- renderText({
    picker_choices_act <- paste(input$picker1, collapse = " & ")

    c(paste("You have selected the", tags$b(input$sub_group_picker), " sub-group for ", tags$b(input$activity_select1), ". With specific breakdown(s) of ", paste("<b>", picker_choices_act, "</b>"), paste(".")))
  })


  output$table_activities_tbl <- DT::renderDataTable(
    DT::datatable(table_activities(input$activity_select1, input$sub_group_picker, input$picker1), options = list(dom = "ftp", pageLength = 10), colnames = c("Years after KS4", "Activity", "Subpopulation", "Percentage (%)"), rownames = FALSE) %>%
      formatRound("Percentage", digits = 0)
  )

  # Reactive download for the main activities data that changes the name depending on the first two values picked
  output$downloadtrajectories <- downloadHandler(
    filename = function() {
      paste("Main_activities", input$activity_select1, input$sub_group_picker, paste(input$picker1, collapse = "_"), ".csv", sep = "_")
    },
    content = function(file) {
      write.csv(table_activities(input$activity_select1, input$sub_group_picker, input$picker1), file, row.names = FALSE)
    }
  )


  observeEvent(input$tutorial, {
    showModal(div(
      class = "user_guide_popup",
      modalDialog(
        title = "User Guide",
        tags$h5("How to use this dashboard", style = "font-family: GDS Transport, arial, sans-serif; font-size :20px; font-weight: bold"),
        "Use the navigation bar on the left to select which tab you want to view.",
        tags$br(),
        tags$h5("Dashboard Structure", style = "font-family: GDS Transport, arial, sans-serif; font-size :20px; font-weight: bold"),
        tags$ul(
          tags$li(tags$b("Introduction - "), "a basic introduction to the tool and provides links to the research report and the technical report."),
          tags$li(tags$b("Earnings trajectory - "), "looks at the average earnings of individuals in employment. You can build on the
          presented plots by selecting breakdowns you wish to see and compare. There is also a function to compare with the overall average for all individuals."),
          tags$li(tags$b("Main activities - "), "looks at the main activities for individuals. You can compare the main activities by selecting multiple breakdowns."),
          tags$li(tags$b("Accessibility statement - "), "contains the accessibility statement for this tool."),
          tags$li(tags$b("Feedback and suggestions - "), "contains links for a user feedback form and a form for reporting any bugs or errors found within the tool.")
        ),
        # tags$br(),
        tags$h5("Interactive Plots User Guide", style = "font-family: GDS Transport, arial, sans-serif; font-size :20px; font-weight: bold"),
        tags$ul(
          tags$li("Hover over lines/bars in the plot to see specific values."),
          tags$li("The bar along the top of the plots contains extra interactive features such as download as PNG and/or resize plot and zoom."),
          tags$li("Click \"View full screen\" to display the plots as full screen."),
          tags$li("To exit full screen, click \"Exit full screen\" or press the escape key (Esc)."),
          # tags$br(),
          tags$h6("Using the Key", style = "font-family: GDS Transport, arial, sans-serif; font-size :19px; font-weight: bold"),
          tags$li("Double clicking a line/value in the key will isolate the value in the plot."),
          tags$li("Double clicking the same value again will restore the original plot"),
          tags$li("Single clicking a line/value in the key will remove that line/value from the plot")
        ),
        easyClose = TRUE,
      ),
      footer = modalButton("Dismiss")
    ))
  })
}
