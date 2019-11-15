tabItem(
  tabName = "strategy_back_test",
  fluidRow(
    column(
      width = 6,
      strong("Don't pushase under this level. Uses defaults: pe weight = 20%, T-bill discount uses 10 year"),
      br(),
      br(),
      sliderInput(
        "not_buy_point",
        label = "Value under which $100 investment is delayed",
        value = .035,
        min = 0.01,
        max = .1,
        step = .001
      ),
    ),
    column(
      width = 6,
      strong("Consistent 100$ Monthly Investments using recommended inputs: pe weight = 20%, T-bill discount uses 10 year"),
    )
  ),
  
  fluidRow(
    column(
      width = 12,
        valueBoxOutput(
          "sum_with_delays",
          width = 6
        ),
      valueBoxOutput(
        "investment_end_value_100_per_month",
        width = 6
      )
    )
  )
)