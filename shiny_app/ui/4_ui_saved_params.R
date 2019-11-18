

##add an action button to ui.(when selected it save current pe and discount selections)
tabItem(
  tabName = "saved_params",
  fluidRow(
    column(
      width = 12,
      actionButton(
        'save_params',
        'Save Params'
      ),
      DTOutput('saved_params_table')
    )
  )
)
