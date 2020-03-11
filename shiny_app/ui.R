f7Page(
  title = "S&P Valuation",
  f7TabLayout(
    panels = f7Panel(
      side = 'left',
      theme = "light",
      effect = 'cover',
      f7PanelMenu(
        f7Slider(
          "pe_pct_weight",
          label = "P/E Weights (%)",
          min = 0,
          max = 100,
          value = 20
        )
      )),
    navbar = f7Navbar(
      title = 'Valuation',
      left_panel = TRUE
    ),
# UI Chart tab --------------------------------------------
    f7Tabs(
      animated = TRUE,
      id = 'tabs',
      f7Tab(
        tabName = 'Graph',
        active = TRUE,
        f7List(
          f7Row(
            column(
              width = 4,
              offset = 8,
                f7Picker(
                  "t_bill_duration",
                  label = "Treasury used as Discount Rate",
                  choices = discount_slider_df$t_bill_duration
                )
            ),
            br(),
            column(
              width = 12,
              highchartOutput('return_graph')
            ),
            column(
              width = 4,
              offset = 4,
              textOutput('current_metric')
            )
          )
        )
      ),
# UI Back-test tab --------------------------------------------
      f7Tab(
        tabName = "Back-test",
        f7List(
          f7Tooltip(
            f7Slider(
              'not_buy_point',
              label = "Not Buy Point",
              min = 0,
              max = 7,
              step = 0.1,
              value = 2
            ), 'Balance starts at $0 with a monthly $100 income stream available to invest.
             Select a Nick Metric value under which you will not invest the income stream.'
          ),
          br(),
          br(),
          f7Block(
            strong = TRUE,
          f7BlockHeader(text = '$100/month Investment'),
            valueBoxOutput(
              'benchmark_end_balance'
            ),
            f7BlockHeader(text = 'Posponed Investment When Nick Metric is below Not Buy Point'),
            valueBoxOutput(
              'end_balance'
            )
          )
        )
      )
    )
  )
)

