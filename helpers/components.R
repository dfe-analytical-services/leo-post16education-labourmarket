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
        insert_text(inputId = "tech_link", text = paste("You can view the published report and data tables at:","<br>", a(href = "https://www.gov.uk/government/publications/post-16-education-and-labour-market-activities-pathways-and-outcomes-leo" , "Longitudinal Education Outcomes (LEO): post-16 education and labour market activities, pathways and outcomes.", style = "font-family: GDS Transport, arial, sans-serif; font-size :17px;"),
                                                        "<br>","For more information, please refer to the technical report: ", "<br>",
                                                        a(href = "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/993969/Technical_Report_for_Education_and_Labour_Market_Pathways_of_Individuals__LEO_.pdf", "Technical Report for Education and Labour Market Pathways of Individuals (LEO)", style = "font-family: GDS Transport, arial, sans-serif; font-size :17px;"))),
        
        h2(tags$b("Contents")),
        #actionButton("tutorial", " User Guide", icon = icon("info",class = NULL, lib="font-awesome")),
        fluidRow(
          column(
            width = 6,
            h3(tags$b("Earnings trajectory")),
            p("This tab looks at the average earnings of individuals in employment for key stage 4 cohorts 2001/02 to 2006/07 over 15 years. You can build on the 
          presented plots by selecting breakdowns you wish to see and compare. There is also a function to compare with the overall average for all individuals.", class = "normal-text"),
          h3(tags$b("Main activities")),
          p("This tab looks at the main activities for individuals for key stage 4 cohorts 2001/02 to 2006/07 over 15 years. You can compare the main activities by selecting multiple breakdowns.",class = "normal-text"),
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
              tags$li("Key stage 4 attainment"),
              tags$li("Region of school"),
              tags$li("IDACI (Income Deprivation Affecting Children Index) quintiles")
            ), 
            p("For more information on the above definitions, see pages 18 to 20 of the", a(href ="https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/990668/Research_report_-_Post_16_education_and_labour_market_activities_pathways_and_outcomes__LEO_.pdf", " main report."), class = "normal-text"),
            p("With populations of:", class = "normal-text"),
            tags$ul(
              tags$li("All individuals"),
              tags$li("Graduates and non-graduates"),
              tags$li("Non-graduates: level 3 and above and level 2 or below")
            ),
          )
        ),
        fluidRow(
          details(
            inputId = "accessible_user_guide",
            label = "Accessible version of the user guide:",
            help_text = (
              tags$ul(
                 tags$h2("How to use this dashboard", style = "font-family: GDS Transport, arial, sans-serif; font-size :20px; font-weight: bold"),
              "Use the navigation bar on the left to select which tab you want to view.",
              tags$br(),
              tags$h2("Dashboard Structure", style = "font-family: GDS Transport, arial, sans-serif; font-size :20px; font-weight: bold"),
              tags$ul(
                tags$li(tags$b("Introduction - "),"a basic introduction to the tool and provides links to the research report and the technical report."), 
                tags$li(tags$b("Earnings trajectory - "),"looks at the average earnings of individuals in employment. You can build on the 
          presented plots by selecting breakdowns you wish to see and compare. There is also a function to compare with the overall average for all individuals."),
          tags$li(tags$b("Main activities - "),"looks at the main activities for individuals. You can compare the main activities by selecting multiple breakdowns."),
          tags$li(tags$b("Accessibility statement - "),"contains the accessibility statement for this tool."),
          tags$li(tags$b("Feedback and suggestions - "),"contains links for a user feedback form and a form for reporting any bugs or errors found within the tool.")),
          #tags$br(),
          tags$h2("Interactive Plots User Guide", style = "font-family: GDS Transport, arial, sans-serif; font-size :20px; font-weight: bold"),
          tags$ul(
            tags$li("Hover over lines/bars in the plot to see specific values."), 
            tags$li("The bar along the top of the plots contains extra interactive features such as download as PNG and/or resize plot and zoom."),
            tags$li("Click \"View full screen\" to display the plots as full screen."),
            tags$li("To exit full screen, click \"Exit full screen\" or press the escape key (Esc)."),
            #tags$br(),
            tags$h3("Using the Key", style = "font-family: GDS Transport, arial, sans-serif; font-size :19px; font-weight: bold"),
            tags$li("Double clicking a line/value in the key will isolate the value in the plot."),
            tags$li("Double clicking the same value again will restore the original plot"),
            tags$li("Single clicking a line/value in the key will remove that line/value from the plot"))
              )
            )
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
        style = "padding: 12px;",
        fluidRow(
          p("Average earnings of individuals in employment for key stage 4 cohorts 2001/02 to 2006/07 over 15 years.", class = "normal-text"),
          p("The graph shows this data as a line chart where the x-axis is ", tags$b("Years after key stage 4"), " and the y-axis is ", tags$b("Average earnings.")) 
        )
      ),
      div(
        class = "inputs_box",
        style = "min-height:100%; height = 100%; overflow-y: visible",
      fluidRow(
          column(
            width = 3,
            pickerInput(
              inputId = "earn_select1",
              label = "Choose a population: ",
              choices = c("All individuals","Graduates and non-graduates","Non-graduates: level 3 and above and level 2 or below"),
              selected = NULL
            )
          ),
          column(
            width = 3,
            pickerInput(inputId = "earn_subcat",
                        label = "Select a sub-group: ",
                        choices = NULL,
                        selected = NULL,
                        multiple = FALSE,
                        width ="100%",
                        inline = FALSE
                        
            )
            
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
             checkbox_Input(inputId = "comparisoncheck",
          cb_labels = "Compare with all individuals",
          checkboxIds = "Yes",
          label = "",
          hint_label = NULL,
          small = TRUE)
           ),
          #column(width = 3,
          #       p("Download the data", style = "font-weight:bold; color:white; font-size:14px;"),
          #       downloadButton("downloadearnings", "Download data as csv file", class = "Download_button")
          #)
        ),
      #   fluidRow(
      #     column(width = 6,
      #            p("Download the data", style = "font-weight:bold; color:white; font-size:14px;"),
      #            downloadButton("downloadearnings", "Download data as csv file", class = "Download_button")
      #            )
      # )
        
      ),
      div(
        style = "padding: 12px;",
      #   fluidRow(
      #     label_hint(
      #   "earn_label",
      #   "Average earnings of individuals in employment for key stage 4 cohorts 2001/02 to 2006/07 over 15 years."
      # )),
      #p("Download the data", style = "font-weight:bold; color:black; font-size:14px;"),
      # fluidRow(
      #   downloadButton("downloadearnings", "Download data as csv file", class = "Download_button"),
      #   tags$br(),
      # ),
      
      fluidRow(label_hint("earningslabel",
                          paste(htmlOutput("ern_choice_txt"))),
               #label_hint("descr_act", paste("The graph shows this data as a line chart where the x-axis is ", tags$b("Years after key stage 4"), " and the y-axis is ", tags$b("Average earnings"), ".")),
      #),
      #fluidRow(
        insert_text(inputId = "tech_link", text = paste("For details of the definitions of the breakdowns used, please refer to the technical report: ", "<br>",
                                                        a(href = "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/993969/Technical_Report_for_Education_and_Labour_Market_Pathways_of_Individuals__LEO_.pdf", "Technical Report for Education and Labour Market Pathways of Individuals (LEO)", style = "font-family: GDS Transport, arial, sans-serif; font-size :17px;"))),
        
      ),
      fluidRow(tabsetPanel(
              type = "tabs",
              tabPanel(title = "Earnings trajectory",
                       br(),
                         div(
                           #id = "main-activities-plot",
                         class = "plotly-full-screen",
                             plotly::plotlyOutput(
                             outputId = "earningsplot",
                             height = "100%"),
                           ),
                       
                       br(),
                       details(
                         inputId = "earnings_notes",
                         label = "Notes on earnings trajectory data:",
                         help_text = (
                           tags$ul(
                             tags$li("Average (median) annualised earnings over time are shown for all individuals and different sub-groups, using earnings of individuals that are in paid employment during that year."), 
                             tags$li("As the dataset includes several cohorts of individuals, their earnings at the same time point are from different tax years e.g. year 1 for the 2001/02 KS4 academic year cohort is 2003-04 but for the 2006/07 KS4 academic year cohort it is 2008-09. To allow comparisons like for like, we inflate earnings from all years to the most recent tax year (2017-18)."),
                             tags$br(),
                             p(" More detail on this methodology is available in the", a(href = "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/993969/Technical_Report_for_Education_and_Labour_Market_Pathways_of_Individuals__LEO_.pdf", "Technical Report.", style = "font-family: GDS Transport, arial, sans-serif; font-size :17px;")))
                         )
                       )
                       ),
              tabPanel(title = "Table of data",
                       DT::dataTableOutput("table_earnings_tbl")
                       )


            )),
      fluidRow(
        br(),
        downloadButton("downloadearnings", "Download data as csv file", class = "Download_button"),
        #br(),
      )
      ),
      
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
        style = "padding: 12px;",
        fluidRow(
          p("Main activities of individuals for key stage 4 cohorts 2001/02 to 2006/07 over 15 years.", class = "normal-text"),
          p("The graph shows this data as a 100% stacked column chart where the x-axis is ", tags$b("Years after key stage 4"), " and the y-axis is ", tags$b("Percentage"), " of population, with activities categorised by colour.", class = "normal-text")
        )
      ),
      div(
        class = "inputs_box",
        style = "min-height:100%; height = 100%; overflow-y: visible",
      fluidRow(
        width = 12,
        column(width = 4,
               pickerInput(
                 inputId = "activity_select1",
                 label = "Choose a population: ",
                 choices = c("All individuals","Graduates and non-graduates","Non-graduates: level 3 and above and level 2 or below"),
                 selected = NULL
               )
        ),
        column(width=4,
               pickerInput(inputId = "sub_group_picker",
                           label = "Select a sub-group: ",
                           choices = NULL,
                           selected = NULL,
                           multiple = FALSE,
                           width ="100%",
                           inline = FALSE
                 
               )),

        column(width = 4,
               pickerInput(inputId = "picker1",
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
        # column(width = 3,
        #        p("Download the data", style = "font-weight:bold; color:white; font-size:14px;"),
        #        downloadButton("downloadtrajectories", "Download data as csv file"))
      ),
      # fluidRow(
      #   column(width = 6,
      #          p("Download the data", style = "font-weight:bold; color:white; font-size:14px;"),
      #          downloadButton("downloadtrajectories", "Download data as csv file"))
      # )
      ),
      div(
        style = "padding: 12px;",
      fluidRow(
        #label_hint("act_label", "Main activities of individuals for key stage 4 cohorts 2001/02 to 2006/07 over 15 years."),
        label_hint(
          "activitieslabel", paste(htmlOutput("act_choice_txt"))
        ),
        #label_hint("descr_act", paste("The graph shows this data as a 100% stacked column chart where the x-axis is ", tags$b("Years after key stage 4"), " and the y-axis is ", tags$b("Percentage"), " of population, with activities categorised by colour."))
      #),
      #fluidRow(
        insert_text(inputId = "tech_link", text = paste("For details of the definitions of the breakdowns used, please refer to the technical report: ", "<br>",
                                                        a(href = "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/993969/Technical_Report_for_Education_and_Labour_Market_Pathways_of_Individuals__LEO_.pdf", "Technical Report for Education and Labour Market Pathways of Individuals (LEO)", style = "font-family: GDS Transport, arial, sans-serif; font-size :17px;"))),
        
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
                       id = "main-activites-plot",
                       class = "plotly-full-screen",
                        div(
                          class = "act-plotly",
                         plotly::plotlyOutput(
                         outputId = "activitiesplot",
                         height = "100%",
                         width = "auto"
                       )
                       ),
                       br()
            ),
            details(
              inputId = "main_activities_notes",
              label = "Notes on main activities data:",
              help_text = (
                tags$ul(
                  tags$li(tags$b("Activity not captured - "),"the individual could not be found in the labour market or education datasets for that tax year."), 
                  tags$li(tags$b("No sustained activity - "),"the individual had some paid employment, participated in some learning or claimed some out-of-work benefits in the tax year, but did not fulfil any of the activity requirements."),
                  tags$li(tags$b("Out of work benefits - "),"the individual was claiming out-of-work benefits for at least 1 day in each of (at least) 6 consecutive months of the tax year."),
                  tags$li(tags$b("Employment - "),"the individual was in paid employment for at least one day in each of the 12 months of the tax year."),
                  tags$li(tags$b("Higher Education (HE) - "),"the individual was studying for a qualification of at least level 4 in a UK higher education institution for at least one day in each of six consecutive months of the tax year."),
                  tags$li(tags$b("Adult FE - "),"applicable to years 3 to 15 only. The individual had a learning aim in the Individualised Learning Record (ILR) for at least one day in each of 6 consecutive months of the tax year. This includes classroom learning and apprenticeships at any level."),
                  tags$li(tags$b("Other education - "),"applicable to years 1 to 2 only. The individual had a learning aim in the Individualised Learning Record (ILR) aims data for at least one day in each of 6 consecutive months of the tax year. This includes classroom learning at level 2 or below and apprenticeships any level."),
                  tags$li(tags$b("KS5 - "),"the individual was entered for one or more level 3 qualifications (A levels or equivalent) and was aged 16 to 18 at the start of the academic year (in English institutions) in the tax year which overlaps the start of the academic year."),
                  tags$br(),
                  p("Where the requirements for more than one activity have been met, the main activity is selected using a hierarchy (education supersedes out-of-work benefits supersedes employment). More detail on this methodology is available in the", a(href = "https://assets.publishing.service.gov.uk/government/uploads/system/uploads/attachment_data/file/993969/Technical_Report_for_Education_and_Labour_Market_Pathways_of_Individuals__LEO_.pdf", "Technical Report.", style = "font-family: GDS Transport, arial, sans-serif; font-size :17px;")))
              )
            )),
            tabPanel(title = "Table of data",
                     DT::dataTableOutput("table_activities_tbl"))
            
          ),
          br(),
          downloadButton("downloadtrajectories", "Download data as csv file")

      )
      )
 ##     
    )
    )
   )
}


tabPanelFour <- function(){
  return(
    shiny::tabPanel(
      title = "Accessibility statement",      
      value = "panel8",
      gov_layout(
        size = "full",
        heading_text("Accessibility statement", size = "l"),
        h2("Using this dashboard"),
        p("This R-shiny dashboard is run by Department for Education (DfE). We follow the recommendations of the WCAG 2.1 requirements."),
        p("We want as many people as possible to be able to use the report by: "),
        tags$ul(
          tags$li("Navigating most of the dashboard using keyboard and speech recognition software"), 
          tags$li("Use most of the dashboard using a screen reader (including the most recent version of JAWS)"),
          tags$li("Using assistive technologies such as ZoomText and Fusion"),
          tags$li("Using different platforms including laptops, tablets and mobile phones"),
          tags$li("Zoom in up to 300% without the text spilling off the screen")),
        
        h2("How accessible this dashboard is"),
        p("We know some parts of this dashboard are not fully accessible, for example:"),
        tags$ul(
          tags$li("Screen reader and keyboard users cannot navigate through the interactive graphs effectively. An accessible alternative is provided in a CSV format for users to download on this dashboard."), 
          tags$li("Users may have difficultly reading the graph due to the use of colour. An accessible alternative is provided in a CSV format for users to download on this dashboard."),
          tags$li("Speech recognition users may not be able to use commands for the drop downs ‘Accessible version of the user guide:’, ‘Notes on earnings trajectory data:’, ‘Notes on main activities data:’ and all the list boxes within this dashboard effectively. Mouse grid is an accessible alternative. "),
          tags$li("Keyboard users may find it difficult to navigate through the dashboard due to the lack of instructions and interactive elements not working in a logical way. To navigate through the navigation bar, use the arrow keys and press tab to enter into the page."),
          tags$li("Keyboard users cannot navigate through the list boxes in a logical way. To use the dropdowns, the space bar and the up and down arrow keys can be used to expand the drop down. The tab key must be used to navigate through the options and enter must be clicked to choose an option."),
          tags$li("Tick boxes can only be selected using the space bar rather than the enter key."),
          tags$li("The screen reader, which reads out the instructions for the list boxes, gives users incorrect information on how to use these elements. Though it states arrow keys must be used to select an option, tab must be used instead of the arrow keys."),
          tags$li("While using the tab key to navigate through the different selections of the list boxes, the screen reader does not read out the text to the users."),
          tags$li("Some users are not able to reflow up to 300% on this dashboard."),
          tags$li("Some text and interactive elements may not translate well to a screen reader."),
          tags$li("Some features within the tables of data may be limited to users of assistive technology."),
          tags$li("The interactive user guide on each page, when clicked, does not get automatic focus. The focus lies on the page behind and is not announced to assistive technology users when it appears. There is an accessible alternative of the user guide on the 'Introduction' page.")
          ),
        
        h2("Reporting accessibility problems with this dashboard"),
        p("We are always looking to improve the accessibility of this service. If you find any problems not listed on this page or think we’re not meeting the accessibility requirements, fill out this form: "),
        tags$ul(
          tags$li(a(href = "https://forms.office.com/r/pEKGshfvgU" , "feedback and suggestions form."))
        ),
        
        h2("Enforcement procedure"),
        p("The Equality and Human Rights Commission (EHRC) is responsible for enforcing the accessibility regulations. If you’re not happy with how we respond to your complaint, contact the ", a(href = "https://www.equalityadvisoryservice.com/" , "Equality Advisory and Support Service (EASS).")),
        
        
        h2("Technical information about this dashboard's accessibility"),
        p("The Department for Education is committed to making its dashboards accessible, in accordance with the Public Sector Bodies (Websites and Mobile Applications) (No. 2) Accessibility Regulations 2018."),
        
        
        h2("Compliance status"),
        p("This dashboard is partially compliant with the Web Content Accessibility Guidelines version 2.1 AA standard, due to the non-compliances listed."),
        
        h2("Non-compliance with the accessibility regulations"),
        p("The content below is non-accessible:"),
        tags$ul(
          tags$li("Graphs will not always reflow correctly depending on aspect ratio of screen. This can cause loss of information. This fails WCAG 2.1 A success criterion 1.4.10 (Reflow)."),
          tags$li("No guidance given to keyboard or screen reader users on how to navigate through the list box elements and navigation bar. This fails WCAG 2.1 A success criterion 3.3.2 (Labels or Instructions)."),
          tags$li("For some tablets and phone devices, when viewing vertically may not reflow correctly which can cause loss of information. This fails WCAG 2.1 A success criterion 1.3.4 (Orientation)."),
          tags$li("List box elements within this dashboard do not work in a logical manor when navigating with a keyboard. Some keys do not work as expected. This fails WCAG 2.1 A success criterion 2.1.1 (Keyboard)."),
          tags$li("Features within all the graphs cannot be navigated to using the keyboard. This means certain features will not be available to keyboard users. This fails WCAG 2.1 A success criterion 2.1.1 (Keyboard)."),
          tags$li("Some text is not read out in a consistent way while using screen readers. This fails WCAG 2.1 A success criterion 4.1.1 (Parsing)."),
          tags$li("List box elements do not have accessible names that can be programmatically determined. This may affect users of assistive technologies. This fails WCAG 2.1 A success criterion 4.1.2 (Name, Role, Value)."),
          tags$li("Instructions for the list box elements read out while using a screen reader do not work in the way as they are instructed. This fails WCAG 2.1 A success criterion 3.3.2 (Labels or Instruction) & success criterion 4.1.1 (Parsing)."),
          tags$li("Text is not read out on a screen reader when using the tab key to navigate through all the list box options. This fails WCAG 2.1 A success criterion 4.1.1 (Parsing) & success criterion 4.1.2 (Name, Role, Value)."),
          tags$li("Features within all the graphs cannot be navigated to using assistive technologies. This means certain features will not be available to users of assistive technologies. This fails WCAG 2.1 A success criterion 4.1.1 (Parsing)."),
          tags$li("Text is not read out in a logical manner as text within the list boxes is repeated while using a screen reader. This fails WCAG 2.1 A success criterion 4.1.1 (Parsing) & A success criterion 4.1.2 (Name, Role, Value)."),
          tags$li("The search bar within the tables of data do not have accessible names that can be programmatically determined. This My affect users of assistive technologies. This fails WCAG 2.1 A success criterion 4.1.2 (Name, Role, Value)."),
          tags$li("The search bar within the tables of data do not have accessible names that can be programmatically determined. This My affect users of assistive technologies. This fails WCAG 2.1 A success criterion 4.1.2 (Name, Role, Value)."),
          tags$li("Certain buttons within the table of data tab are unable to be pressed while using a screen reader. This fails WCAG 2.1 A success criterion 4.1.1 (Parsing)."),
          tags$li("Focus can get lost when navigating through the page after ‘View full screen’ is clicked. This fails WCAG 2.1 A success criterion 2.4.7 (Focus Visible)."),
          tags$li("Screen reader reads out text which is not on the current page once ‘View full screen’ has been navigated to. This fails WCAG 2.1 A success criterion 4.1.1 (Parsing)."),
          tags$li("Due to the limitations of using RShiny and the shinyGovstyle package, some parsing errors may occur when using assistive technologies. This may specifically be affected when using the 'user guide' and 'view full screen' features. This fails WCAG 2.1 A success criterion 4.1.1 (Parsing)."),
          tags$li("Some keyboard users may have difficulty when using the ‘View full screen’ due to a missing keyboard event handler. This fails WCAG 2.1 A success criterion 2.1.1 (Keyboard).")
          ),
        p("In October 2023, we will review the dashboard again and hope to address these errors."),
        
        h2("How we tested this dashboard"),
        p("This dashboard was last tested on [02/12/2022]. The test was carried out by the DfE."),
        p("Testing was carried out using:"),
        tags$ul(
          tags$li("Dragon NaturallySpeaking (V15.5), a voice recognition (speech to text) program which requires minimal user interface from a mouse or keyboard."),
          tags$li("JAWS (2021), a screen reader (text to speech) program developed for users whose vision loss prevents them from seeing screen content or navigating with a mouse."),
          tags$li("Zoomtext (2020), a magnification and reading program tailored for low-vision users. It enlarges and enhances everything on screen, echoes typing and essential program activity, and reads screen content."),
          tags$li("Fusion (2020), is a hybrid of ZoomText with its screen magnification and visual enhancements, coupled with the power and speed of JAWS for screen reading functionality."),
          tags$li("Sortsite (V6.45), a one-click web automation testing tool."),
          tags$li("Shinya11y, an R shiny automation testing package."),
        ),
        p("At the time of testing, these were the DfE’s supported versions of accessibility software."),
        
        h2("Testing methodology and browser compatibility"),
        h3("Testing Methodology"),
        p("The service was manually tested following the user acceptance scripts which involved:"),
        tags$ul(
          tags$li("using Screen readers (Jaws)"),
          tags$li("manual visual and programmatic testing"),
          tags$li("using only a keyboard to navigate through the service"),
          tags$li("using only speech recognition to navigate through the service"),
          tags$li("using automations testing tools such as Sortsite and Shinya11y")),
        p("During testing, the following disabilities were considered:"),
        tags$ul(
          tags$li("Keyboard Only: The user has a motor impairment that limits them to using only a keyboard to operate a computer."),
          tags$li("Voice Activation: The user has a motor impairment that limits them to using only voice commands to operate a computer via assistive technology such as a microphone and dictation software."),
          tags$li("Screen Reader: The user has a visual impairment that limits them to using accessibility software such as a screen reader to operate a computer via keyboard control and feedback via audible descriptions of visual elements."),
          tags$li("Low Vision: The user has a visual impairment that limits their access to content presented at 100% magnification. The user utilises system/browser controls or accessibility software to increase screen magnification."),
          tags$li("Deaf or Hard of Hearing: The user has a hearing impairment that limits their access to audio content."),
          tags$li("Learning Difficulties: The user has a learning disability that limits their access to content that is presented in a way that requires a high level of literacy.")
        ),
        h3("Browser compatibility"),
        p("The browsers used were Edge Chromium and Chrome as these are standard in the DfE and its agencies. The operating system used was Windows."),
        br(),
        p("This statement was prepared on 10th October 2022."),
        p("This statement was last updated on 2nd December 2022."),

      )
    )
  )
}

tabPanelFive <- function(){
  return(
    shiny::tabPanel(
      title = "Feedback and suggestions",      
      value = "panel9",
      gov_layout(
        size = "full",
        heading_text("Feedback and suggestions", size = "l"),
        h2("Give us feedback"),
        p("If you have any feedback or suggestions for improvement, please submit them using our", a(href = "https://forms.office.com/r/pEKGshfvgU" , "feedback and suggestions form.")),
        
        p("If you spot any errors or bugs, please submit them using our", a(href = "https://forms.office.com/r/3CTN3DGyzF", "errors and bugs report form."))
      )
    )
  )
}
