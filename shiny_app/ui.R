header <- dashboardHeader(
  title = "Dashboard"
)

sidebar <- dashboardSidebar(
  sidebarMenu(
    menuItem(
      "Dashboard",
      tabName = "dashboard",
      icon = icon("dashboard")
    ),
    menuItem(
      "Details of Analysis",
      tabName = "details_of_analysis",
      icon = icon("balance-scale")
    ),
    tags$div(
      style = "position: absolute; bottom: 0;",
      a(
        img(
          src = "https://res.cloudinary.com/dxqnb8xjb/image/upload/v1509563497/tychobra-logo-blue_dacbnz.svg",
          width = 50
        ),
        href = "https://tychobra.com/shiny"
      )
    )
  )
)

body <- dashboardBody(
  tags$head(
    #tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
    #tags$script(src = "custom.js"),
    tags$link(
      rel="icon",
      href="https://res.cloudinary.com/dxqnb8xjb/image/upload/v1499450435/logo-blue_hnvtgb.png"
    )
  ),
  tabItems(
    tabItem(
      tabName = "dashboard",
      fluidRow(
        column(
          width = 12,
          h1("Nick Metric: Predicts future returns in excess of 10 year T-bill yield"),
          br(),
          br()
        ),
        column(
          width = 5, 
          sliderTextInput(
            "pe_pct_weight",
            label = "Weights",
            choices = slider_df$pct_label,
            # min = 0,
            # max = 100,
            from_min = 0,
            from_max = 100,
            # value = 20, 
            # step = 5,
            # post = "%",
            width = "100%"
          )
        ),
        column(
          width = 1,
          checkboxInput(
            "turn_on_sp_overlay",
            label = strong("show S&P"),
          )
        ),
        valueBoxOutput(
          "current_complete_metric_box",
          width = 3
        ),
        valueBoxOutput(
          "avg_complete_metric_box",
          width = 3
        ),
        box(
          width = 12,
          highchartOutput("historical_chart")
        ),
        column(
          width = 12,
          strong("*Nick's metric uses a weighted combination of Price to Earnings ratio (PE),
                 and the Shiller PE as a predictor of future S&P 500 total return.  
                 It assumes future earnings growth will be consistent with historical averages,
                 and that earnings growth is a strong predictor of free cash flow (FCF) growth.
                 The metric uses the U.S. ten year treasury yield as a discount rate for these predicted future FCF."
          ),
          pullright = TRUE
        ),
      )
    ),
    tabItem(
      tabName = "details_of_analysis",
      fluidRow(
        box(
          title = "Analysis Detail",
          collapsible = TRUE,
          width = 9,
          fluidRow(
            column(
              3,
              DTOutput("details_table")
            ),
            # column(
            #   width = 3,
            #   DTOutput("egr_table")
            # )
          )
        )
      )
    )
  )
)


dashboardPage(
  header,
  sidebar,
  body,
  skin = "black"
)
