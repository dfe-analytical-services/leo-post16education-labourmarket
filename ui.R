#
# This is the user-interface definition of a Shiny web application. You can
# run the application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#
# The documentation for this GOVUK components can be found at:
#
#    https://github.com/moj-analytical-services/shinyGovstyle
#

library(shiny)
library(shinyjs)
library(shinyGovstyle)

shinyjs::useShinyjs()

ui <- fluidPage(
  tags$head(
    tags$link(rel = "stylesheet", type = "text/css", href = "style.css")
  ),
  shinyGovstyle::header("DfE", "Attendance prediction", logo = "shinyGovstyle/images/moj_logo.png"),
  shiny::navlistPanel(
    "",
    id = "nav",
    widths = c(2, 8),
    well = FALSE,
    tabPanelOne(),
    shiny::tabPanel(
      "Text Types",
      value = "panel2",
      gov_layout(
        size = "full",
        heading_text("Page 2", size = "l"),
        label_hint(
          "label2",
          "These are some examples of the types of user\n                   text inputs that you can use"
        ),
        heading_text("date_Input", size = "s"),
        date_Input(
          inputId = "date1",
          label = "What is your date of birth?",
          hint_label = "For example, 31 3 1980"
        ),
        heading_text("text_Input", size = "s"),
        text_Input(inputId = "txt1",
                   label = "Event name"),
        heading_text("text_area_Input",
                     size = "s"),
        text_area_Input(
          inputId = "text_area1",
          label = "Can you provide more detail?",
          hint_label = "Do not include personal or financial information,\n          like your National Insurance number or credit card details."
        ),
        text_area_Input(
          inputId = "text_area2",
          label = "How are you today?",
          hint_label = "Leave blank to trigger error",
          error = T,
          error_message = "Please do not leave blank",
          word_limit = 300
        ),
        heading_text("button_Input",
                     size = "s"),
        button_Input("btn2", "Go to next page"),
        button_Input("btn3", "Check for errors", type = "warning")
      )
    ),
    shiny::tabPanel(
      "Feedback Types",
      value = "panel3",
      gov_layout(
        size = "one-half",
        heading_text("Page 3", size = "l"),
        label_hint(
          "label3",
          "These are some examples of the types of user\n                   feedback inputs that you can use"
        ),
        heading_text("tag_Input", size = "s"),
        tag_Input("tag1",
                  "NAVY"),
        tag_Input("tag2", "RED", "red"),
        tag_Input("tag3", "BLUE", "blue"),
        tag_Input("tag4",
                  "YELLOW", "yellow"),
        shiny::tags$br(),
        shiny::tags$br(),
        heading_text("details", size = "s"),
        details(
          inputId = "detID",
          label = "Help with nationality",
          help_text = "We need to know your nationality so we can work out\n              which elections you're entitled to vote in. If you cannot provide\n              your nationality, you'll have to send copies of identity\n              documents through the post."
        ),
        heading_text("insert_text", size = "s"),
        insert_text(inputId = "insertId",
                    text = "It can take up to 8 weeks to register a lasting\n                        power of attorney if there are no mistakes in the\n                        application."),
        heading_text("warning_text", size = "s"),
        warning_text(inputId = "warn", text = "You can be fined up to £5,000 if you do\n              not register."),
        heading_text("panel_output", size = "s"),
        panel_output(
          inputId = "panId",
          main_text = "Application complete",
          sub_text = "Your reference number <br> <strong>HDJ2123F</strong>"
        ),
        heading_text("noti_banner", size = "s"),
        noti_banner(
          "notId",
          title_txt = "Important",
          body_txt = "You have 7 days left to send your application.",
          type = "standard"
        )
      )
    )
  ),
  gov_layout(size = "full",
             tags$br(),
             tags$br(),
             tags$br(),
             tags$br(),
             tags$br()),
  footer(full = TRUE)
)
