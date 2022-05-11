#
# This is the server logic of a Shiny web application. You can run the
# application by clicking 'Run App' above.
#
# Find out more about building applications with Shiny here:
#
#    http://shiny.rstudio.com/
#

library(shiny)
library(shinyjs)

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
}
