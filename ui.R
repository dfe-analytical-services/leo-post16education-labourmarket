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
      href = "style.css"),
    tags$style(
      HTML(
        "
      .shiny-output-error-validation {
        color: red;
        font-size:16px;
        font-weight:bold;
      }

    .normal-text{
      color: #0B0C0C;
      font-family: GDS Transport;
      font-size: 18px;
    }

      li {
      font-family: GDS Transport;
      font-size: 18px;
      }
    
    .inputs_box {
      min-height: 90vh;
      padding: 19px;
      margin-bottom: 20px;
      background-color: #337ebf;
      border: 1px solid #e3e3e3;
      border-radius: 4px;
      -webkit-box-shadow: inset 0 1px 1px rgb(0 0 0 / 5%);
      box-shadow: inset 0 1px 1px rgb(0 0 0 / 5%);
      color: #fff;
    
      }
    .comp_check {
    color: #fff;
    }"
      )
    )
  ),
  shinyGovstyle::header(
    main_text = "Department for Education", 
    secondary_text = "Longitudinal Education Outcomes (LEO): post-16 education and labour market activities and outcomes", 
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
    tabPanelFour(),
    tabPanelFive(),
    # tabPanelSix(),
    # tabPanelSeven(),
    # tabPanelEight(),
    # tabPanelNine()
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
    src="script.js"
  ),
  tags$script(HTML(
    "
    function plotZoom(el){
        el = $(el);
        var parent = el.parent().parent();
        if(el.attr('data-full_screen') === 'false') {
            $('html').css('visibility', 'hidden');
            parent.addClass('full-screen').trigger('resize').hide().show();
            $('.fullscreen-button').text('Exit full screen');
            el.attr('data-full_screen', 'true');
            setTimeout(function() {
              $('html').css('visibility', 'visible');
            }, 700);
            
        } else {
            parent.removeClass('full-screen').trigger('resize').hide().show();
            $('.fullscreen-button').text('View full screen');
            el.attr('data-full_screen', 'false');
        }
    }
    
    $(function(){
       $('.plotly-full-screen  .plotly.html-widget').append(
        `
        <div style='position: relative;'>
            <button onclick=plotZoom(this) class='plot-zoom' data-full_screen='false' title='Full screen'>
                <a href='#' class='govuk-link fullscreen-button'>View full screen</a>
            </button>
        </div>
        `); 
    })
    "
  )),
  footer(full = TRUE)
)
