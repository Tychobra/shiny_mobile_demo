
tabItem(
  tabName = "dashboard",
  fluidRow(
    column(
      width = 12,
      h2(
        strong("Nick Metric:"), 
        "Predicts future returns in excess of 10 year T-bill yield"
      ),
      br()
    ),
    valueBoxOutput(
      "current_complete_metric_box",
      width = 4
    ),
    valueBoxOutput(
      "avg_complete_metric_box",
      width = 4
    ),
    valueBoxOutput(
      "buy_sell_rec_box",
      width = 4
    ),
    box(
      dropdown(
        headerText = "* shows relative performance of log returns and returns, respectively",
        checkboxInput(
          "turn_on_sp_overlay",
          label = strong("S&P")
        ),
        checkboxInput(
          "turn_on_log_sp_overlay",
          label = strong("log S&P")
        ),
        checkboxInput(
          "turn_on_s_p_tr_overlay",
          label = strong("S&P TR")
        ),
        checkboxInput(
          "turn_on_s_p_tr_log_overlay",
          label = strong("log S&P TR"),
          value = TRUE
        )
      ),
      width = 12,
      highchartOutput("historical_chart")
    ),
    column(
      width = 12,
      strong("*S&P overlays above show relative performance of logrithmic S&P and S&P, respectively"),
      br(),
      br(),
      strong("Nick's metric uses a weighted combination of Price to Earnings ratio (PE),
                   and the Shiller PE as a predictor of future S&P 500 total return.  
                   It assumes future earnings growth will be consistent with historical averages,
                   and that earnings growth is a strong predictor of free cash flow (FCF) growth.
                   The metric uses the your choice of treasury yield duration as a discount rate for these predicted future FCF."
      ),
      br(),
      br(),
      strong("*Recommended settings: weight 20%, 10 year discount, and show log S&P TR")
    )
  )
)
