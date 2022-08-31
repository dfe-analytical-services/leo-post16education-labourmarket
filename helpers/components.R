tabPanelOne <- function(){
  return(
    shiny::tabPanel(
      title = "Introduction",      
      value = "panel5",
      gov_layout(
        size = "full",
        heading_text("Introduction", size = "l"),
        p("This dashboard accompanies the post-16 education and labour market activities, pathways and outcomes (LEO) research report. 
          It is an interactive tool allowing for visualisation and exploration of the data published alongside the report. This report contains analysis of post-16 education and labour market activities and outcomes based on different socioeconomic, demographic and education factors.", class = "normal-text"),
        #p("This report contains analysis of post-16 education and labour market activities and outcomes based on different socioeconomic, demographic and education factors.", class = "normal-text"),
        #p("You can view the published report and data tables at:", class = "normal-text"),
        #a(href = "https://www.gov.uk/government/publications/post-16-education-and-labour-market-activities-pathways-and-outcomes-leo" , "Longitudinal Education Outcomes (LEO): post-16 education and labour market activities, pathways and outcomes.", style = "font-family: GDS Transport; font-size :17px;"),
        insert_text(inputId = "tech_link", text = paste("You can view the published report and data tables at:","<br>", a(href = "https://www.gov.uk/government/publications/post-16-education-and-labour-market-activities-pathways-and-outcomes-leo" , "Longitudinal Education Outcomes (LEO): post-16 education and labour market activities, pathways and outcomes.", style = "font-family: GDS Transport, arial, sans-serif; font-size :17px;"),
                                                        "<br><br>","For more information, please refer to the technical report: ", "<br>",
                                                        a(href = "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/993969/Technical_Report_for_Education_and_Labour_Market_Pathways_of_Individuals__LEO_.pdf", "Technical Report for Education and Labour Market Pathways of Individuals (LEO)", style = "font-family: GDS Transport, arial, sans-serif; font-size :17px;"))),
        
        h3(tags$b("Contents:")),
        fluidRow(
          column(
            width = 6,
            p(tags$b("Earnings trajectory")," - This tab looks at the average earnings of individuals in employment for key stage 4 cohorts 2001/02 to 2006/07 over 15 years. You can build on the 
          presented plots by selecting breakdowns you wish to see and compare. There is also a function to compare with the overall average for all individuals.", class = "normal-text"),
          p(tags$b("Main activities"), " - This tab looks at the main activities for individuals for key stage 4 cohorts 2001/02 to 2006/07 over 15 years. You can compare the main activities by selecting multiple breakdowns.",class = "normal-text"),
          ),
          column(
            width = 6,
            p("For each tab, the following sub-groups are available: ", class = "normal-text"),
            tags$ul(
              tags$li("Overall average"),
              tags$li("Gender"),
              tags$li("Free school meals (FSM) eligibility"),
              tags$li("Special educational needs (SEN)"),
              tags$li("Ethnicity (major and minor groups)"),
              tags$li("First language"),
              tags$li("School type"),
              tags$li("Region of school"),
              tags$li("Income Deprivation Affecting Children Index (IDACI)")
            ), 
            p("With populations of:", class = "normal-text"),
            tags$ul(
              tags$li("All individuals"),
              tags$li("Graduate and non-graduate"),
              tags$li("Level 3 or above and level 2 or below")
            ),
          )
        ),
        details(
          inputId = "plotuserguide",
          label = "Interactive Plots User Guide:",
          help_text = (
            tags$ul(
              tags$li("Hover over lines/bars in the plot to see specific values."), 
              tags$li("The bar along the top of the plots contains extra interactive features such as download as PNG and/or resize plot and zoom."),
              tags$br(),
              tags$b("Using the Key:"),
              tags$li("Double clicking a line/value in the key will isolate the value in the plot."),
              tags$li("Double clicking the same value again will restore the original plot"),
              tags$li("Single clicking a line/value in the key will remove that line/value from the plot"))
          )
        )
      )
    )
  )
}

tabPanelTwo <- function() {
  return(shiny::tabPanel(
    title = "Earnings trajectory",
    value = "panel6",
    gov_layout(
      size = "full",
      heading_text("Earnings trajectory", size = "l"),
      div(
        class = "inputs_box",
        style = "min-height:100%; height = 100%; overflow-y: visible",
        #status = "primary",
        #background = "light-blue",
      fluidRow(
          column(
            width = 3,
            selectInput(
              inputId = "earn_select1",
              label = "Choose a population: ",
              choices = c("All individuals" = "National",
                          "Graduates" = "Grads",
                          "Non-Graduates" = "Non-grads")
            )
          ),
          column(
            width = 3,
            selectizeInput(inputId = "earn_subcat",
                           label = "Select a sub-group: ",
                           choices = NULL,
                           selected = NULL),
            
          ),
          column(width = 3,
                 pickerInput(inputId = "earn_picker",
                             label = "Select breakdown(s):",
                             choices = NULL,
                             selected = NULL,
                             multiple = TRUE,
                             options = list('actions-box' = TRUE),
                             choicesOpt = NULL,
                             width = "100%",
                             inline = FALSE
                 )
          ),
          column(
            width = 3,
            p("Download data"),
            downloadButton("downloadearnings", "Download data as csv file")
          )
        ),
      div(
        class = "comp_check",
        fluidRow(
          column(
            width = 6,
            checkbox_Input(inputId = "comparisoncheck",
                           cb_labels = "Compare with all individuals",
                           checkboxIds = "Yes",
                           label = "",
                           hint_label = NULL,
                           small = TRUE)
          )
        )
      )
        
      ),
        fluidRow(
          label_hint(
        "earn_label",
        "Average earnings of individuals in employment for key stage 4 cohorts 2001/02 to 2006/07 over 15 years."
      )),
      fluidRow(label_hint("earningslabel",
                          paste(htmlOutput("ern_choice_txt")))),
      fluidRow(tabsetPanel(
              type = "tabs",
              tabPanel(title = "Earnings trajectory",
                       br(),
                         div(
                         class = "plotly-full-screen",
                         shinycssloaders::withSpinner(
                             plotly::plotlyOutput(
                             outputId = "earningsplot",
                             height = "100%")
                           ),
                           type = 8,
                           color = "#1D70B8",
                           size = 0.5)
                       ,
                       
                       br(),
                       ),
              tabPanel(title = "Table of data",
                       DT::dataTableOutput("table_earnings_tbl")
                       )


            )),
    #   sidebarLayout(
    #     sidebarPanel(
    #       width = 3,
    #       selectInput(
    #         inputId = "earn_select1",
    #         label = "Choose a population: ",
    #         choices = c("National level" = "National",
    #               "Graduate level" = "Grads",
    #               "Non-Graduate level" = "Non-grads")
    #       ),
    #       
    #       selectizeInput(inputId = "earn_subcat",
    #                      label = "Select a subpopulation: ",
    #                      choices = NULL,
    #                      selected = NULL),
    #       
    #       checkbox_Input(
    #         inputId = "comparisoncheck",
    #         cb_labels = "Compare with National Average",
    #         checkboxIds = "Yes",
    #         label = "",
    #         hint_label = NULL,
    #         small = TRUE
    #       ),
    #   #    checkboxInput("compcheck2", "Compare with National Average", value = TRUE, width = NULL),
    #       
    #       p("Download table of data as csv file."),
    #       downloadButton("downloadearnings", "Download")
    #     ),
    #     mainPanel(
    #       width = 9,
    #       tabsetPanel(
    #       type = "tabs",
    #       tabPanel(title = "Earnings Trajectory - Line chart",
    #                div(
    #                  class = "plotly-full-screen",
    #                  shinycssloaders::withSpinner(
    #                    plotly::plotlyOutput(
    #                      outputId = "earningsplot"
    #                    ),
    #                    type = 8,
    #                    color = "#1D70B8",
    #                    size = 0.5
    #                  )
    #                )
    #                ),
    #       tabPanel(title = "Table of data",
    #                DT::dataTableOutput("table_earnings_tbl")
    #                )
    #       
    #       
    #     )
    #   ),
    # )
  )))
}
tabPanelThree <- function(){
  return(
    shiny::tabPanel(
    title = "Main activities",
    value = "panel7",
    gov_layout(
      size = "full",
      heading_text("Main activities", size = "l"),
      div(
        class = "inputs_box",
        style = "min-height:100%; height = 100%; overflow-y: visible",
      fluidRow(
        column(width = 3,
               selectInput(
                 inputId = "activity_select1",
                 label = "Choose a population: ",
                 choices = c("All individuals" = "National",
                             "Graduates" = "Grads",
                             "Non-Graduates" = "Non-grads")
               )
               ),
        column(width = 3,
               selectizeInput(inputId = "activity_subcat",
                              label = "Select a sub-group: ",
                              choices = NULL,
                              selected = NULL)
        ),

        column(width = 3,
               pickerInput(inputId = "picker1",
                           label = "Select breakdown(s):",
                           choices = NULL,
                           selected = NULL,
                           multiple = TRUE,
                           options = list(),
                           choicesOpt = NULL,
                           width = "100%",
                           inline = FALSE
               )
         ),

        column(width =3,
               p("Download data"),
               downloadButton("downloadtrajectories", "Download data as csv file"))
      )),
      fluidRow(
        label_hint("act_label", "Main activities of individuals for key stage 4 cohorts 2001/02 to 2006/07 over 15 years."),
        label_hint(
          "activitieslabel", paste(htmlOutput("act_choice_txt"))
        )
      ),

      fluidRow(
        warning_text(inputId = "roundingwarn", text = "Due to the nature of rounding, the percentage breakdowns do not always sum to 100%.")
      ),

      fluidRow(
        tabsetPanel(
        type = "tabs",
        tabPanel(title = "Main activities",
                 br(),
                 div(
                   class = "plotly-full-screen",
                   #style = "padding-bottom:30px",
                   #br(),
                   shinycssloaders::withSpinner(
                     plotly::plotlyOutput(
                       outputId = "activitiesplot",
                       height = "100%"
                     ),
                     type = 8,
                     color = "#1D70B8",
                     size = 0.5
                   ),
                   br()
                 ),
                 br(),
        ),
          tabPanel(title = "Table of data",
                 DT::dataTableOutput("table_activities_tbl")
        )
      )
      )
    )
    )
   )
}


tabPanelFour <- function(){
  return(
    shiny::tabPanel(
      title = "Accessibility",      
      value = "panel8",
      gov_layout(
        size = "full",
        heading_text("Accessibility", size = "l"),
        label_hint(
          "label8",
          "Accessibility statement goes here"),
        p("Accessibility statement")
      )
    )
  )
}
tabPanelFive <- function(){
  return(
    shiny::tabPanel(
      title = "Feedback and Suggestions",      
      value = "panel9",
      gov_layout(
        size = "full",
        heading_text("Feedback and Suggestions", size = "l"),
        # label_hint(
        #   "label9",
        #   "Feedback and suggestions"
        # ),
        h2("Give us feedback"),
        p("If you have any feedback or suggetions for improvement, please submit then using our", a(href = "https://forms.office.com/r/pEKGshfvgU" , "feedback and suggestions form (This link will open in a new tab).")),
        
        p("If you spot any errors or bugs, please submit then using our", a(href = "https://forms.office.com/r/3CTN3DGyzF", "errors and bugs report form (This link will open in a new tab)."))
      )
    )
  )
}
