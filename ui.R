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

shinyjs::useShinyjs()

ui <- fluidPage(
  tags$head(
    tags$link(
      rel = "stylesheet", 
      type = "text/css", 
      href = "style.css")
  ),
  shinyGovstyle::header(
    main_text = "DfE", 
    secondary_text = "Attendance prediction", 
    logo = "shinyGovstyle/images/moj_logo.png"
  ),
  shiny::navlistPanel(
    "",
    id = "navlistPanel",
    widths = c(2, 8),
    well = FALSE,
    tabPanelOne(),
    tabPanelTwo(),
    tabPanelThree(),
    tabPanelFour()
  ),
  gov_layout(
    size = "full",
    tags$br(),
    tags$br(),
    tags$br(),
    tags$br(),
    tags$br()
  ),
  tags$script(
    "$(document).ready(function () {
      $('button').on('click', function (e) {
        let buttonText = e.target.innerText;
        if (buttonText.includes('next page')) {
          window.scrollTo(0, 0);
        }
      });
    });"
  ),
  footer(full = TRUE)
)
