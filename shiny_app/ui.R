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
    tags$link(rel = "stylesheet", type = "text/css", href = "styles.css"),
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
          width = 6,
          fluidRow(
            column(
              width = 12, 
              sliderTextInput(
              "pe_pct_weight",
              label = "Weights",
              choices = slider_df$pct_label,
              width = "100%",
              selected = "20%"
              )
            ),
            column(
              width = 12,
              sliderTextInput(
                "t_bill_discount_used",
                label = "T-bill to use as discount rate",
                choices = discount_slider_df$discount_rate,
                width = "100%",
                selected = "10 year"
              )
            )
          ),
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
          dropdown(
            checkboxInput(
              "turn_on_sp_overlay",
              label = strong("show S&P")
            ),
            checkboxInput(
              "turn_on_log_sp_overlay",
              label = strong("show log S&P")
            )
          ),
          width = 12,
          highchartOutput("historical_chart")
        ),
        column(
          width = 12,
          strong("Nick's metric uses a weighted combination of Price to Earnings ratio (PE),
                 and the Shiller PE as a predictor of future S&P 500 total return.  
                 It assumes future earnings growth will be consistent with historical averages,
                 and that earnings growth is a strong predictor of free cash flow (FCF) growth.
                 The metric uses the your choice of treasury yield duration as a discount rate for these predicted future FCF."
          ),
          br(),
          br(),
          strong("*Recommended settings: weight 20%, 10 year discount, and show log S&P")
        )
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
              12,
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
