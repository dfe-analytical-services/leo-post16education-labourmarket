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
library(ggplot2)
library(plotly)
library(govstyle)
library(dplyr)

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
  
  output$plot <- renderPlotly({
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
}
