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
