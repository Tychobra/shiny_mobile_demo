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
          verbatimTextOutput("basis_point_dif")
        ),
        column(
          width = 12,
          h1("Weight of Forward P/E"),
          ),
          column(width = 12, 
                 sliderInput("fwd_pe_weight", label = "Forward P/E Weight", min = 0, max = 1, value = .5, step = .05))
      )
    ),
    tabItem(
      tabName = "details_of_analysis",
      fluidRow(
        box(
          title = "Analysis Detail",
          collapsible = TRUE,
          width = 12,
          fluidRow(
            column(
              3,
              DTOutput("yields_table")
            ),
            column(
              width = 3,
              DTOutput("egr_table")
            )
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
