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
  # use_tota11y(),
  tags$html(lang = "en"),
  tags$title("Longitudinal Education Outcomes (LEO): post-16 education and labour market activities and outcomes"),
  tags$head(
    tags$link(
      rel = "stylesheet",
      type = "text/css",
      href = "style.css"
    ),
    tags$link(
      rel = "shortcut icon",
      href = "dfefavicon.png"
    ),
    tags$style(
      HTML(
        "
      .shiny-output-error-validation {
        color: red;
        font-size:20px;
        font-weight:bold;
      }

    .normal-text{
      color: #0B0C0C;
      font-family: GDS Transport, arial, sans-serif;
      font-size: 18px;
    }

      li {
      font-family: GDS Transport, arial, sans-serif;
      font-size: 18px;
      }

    .inputs_box {
      min-height: 90vh;
      padding: 19px;
      margin-bottom: 20px;
      background-color: #1d70b8;
      border: 1px solid #e3e3e3;
      border-radius: 4px;
      -webkit-box-shadow: inset 0 1px 1px rgb(0 0 0 / 5%);
      box-shadow: inset 0 1px 1px rgb(0 0 0 / 5%);
      color: #fff;

    }

    p{
      color: #0B0C0C;
      font-family: GDS Transport, arial, sans-serif;
      font-size: 18px;
    }

    h2{
    font-weight: bold;
    }

    h3{
    font-weight: bold;
    }

    .govuk-label.govuk-checkboxes__label{
    color: white;

    }"
      )
    )
  ),
  shinyGovstyle::header(
    main_text = "",
    secondary_text = "Longitudinal Education Outcomes (LEO): post-16 education and labour market activities and outcomes",
    logo = "images/DfE_logo_primary.png",
    logo_width = 125,
    logo_height = 72,
    main_link = "https://www.gov.uk/government/organisations/department-for-education",
    secondary_link = "https://www.gov.uk/government/publications/post-16-education-and-labour-market-activities-pathways-and-outcomes-leo"
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
    header = actionButton("tutorial", " User Guide", icon = icon("info", class = NULL, lib = "font-awesome"), style = "margin-top: 10px;float:  right;"),
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
    src = "script.js"
  ),
  tags$script(HTML(
    "
    $('img.govuk-header__logotype-crown-fallback-image').prop('alt','');

    $(document).keyup(function(e) {
      if (e.key === 'Escape') {
        $('html').find('.full-screen').removeClass('full-screen').trigger('resize').hide().show();

        let buttons = document.getElementsByClassName('fullscreen-button');

        if(buttons.length > 0) {
          for (let i = 0; i < buttons.length; i++) {
            $('.fullscreen-button').text('View full screen');
            $(buttons[i]).parent().attr('data-full_screen', 'false');
            $('body').css('overflow-y', 'scroll');
          }
        }
      }
    });

    function plotZoom(el){
        el = $(el);
        var parent = el.parent().parent();
        if(el.attr('data-full_screen') === 'false') {
            $('html').css('visibility', 'hidden');
            parent.addClass('full-screen').trigger('resize').hide().show();
            $('.fullscreen-button').text('Exit full screen');
            el.attr('data-full_screen', 'true');
            $('body').css('overflow-y', 'hidden');
            setTimeout(function() {
              $('html').css('visibility', 'visible');
            }, 700);

        } else {
            parent.removeClass('full-screen').trigger('resize').hide().show();
            $('.fullscreen-button').text('View full screen');
            el.attr('data-full_screen', 'false');
            $('body').css('overflow-y', 'scroll');
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
