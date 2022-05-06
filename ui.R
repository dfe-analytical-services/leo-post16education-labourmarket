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
    tags$link(rel="stylesheet", type="text/css", href="style.css")
  ),
  shinyGovstyle::header("DfE", "Attendance prediction", logo="shinyGovstyle/images/moj_logo.png"),
  gov_layout(
    size = "full",
    tags$br(),
    tags$br(),
    tags$br(),
    tags$br(),
    tags$br()
  ),
  footer(full = TRUE)
)
