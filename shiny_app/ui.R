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
    menuItem(
      "Strategy Back-test",
      tabName = "strategy_back_test",
      icon = icon("balance-scale")
    ),
    sliderTextInput(
      "pe_pct_weight",
      label = "Weights",
      choices = slider_df$pct_label,
      width = "100%",
      selected = "20%"
    ),
    sliderTextInput(
      "t_bill_discount_used",
      label = "T-bill to use as discount rate",
      choices = discount_slider_df$discount_rate,
      width = "100%",
      selected = "10 year"
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
    source('ui/1_ui_dashboard.R', local = TRUE)$value,
    
    source('ui/2_ui_details_of_analysis.R', local = TRUE)$value,
    
    source('ui/3_ui_strategy_back_test.R', local = TRUE)$value
    
  )
)


dashboardPage(
  header,
  sidebar,
  body,
  skin = "black"
)
