f7Page(
  title = "S&P Valuation",
  f7TabLayout(
    panels = f7Panel(
      side = 'left',
      theme = "light",
      f7PanelMenu(
        f7PanelItem(tabName = "tab_main", title = "Home", active = TRUE),
        f7PanelItem(tabName = "tab_details", title = "Details")
      )),
    navbar = f7Navbar(
      title = 'Valuation',
      left_panel = TRUE
    ),
    f7Tabs(
      animated = TRUE,
      id = 'tabs',
      f7Tab(
        tabName = 'Graph',
        active = TRUE,
        f7List(
          f7Slider(
            "pe_pct_weight",
            label = "P/E Weights (%)",
            min = 0,
            max = 100,
            value = 20
          ),
          f7Picker(
            "t_bill_duration",
            label = "Treasury used as Discount Rate",
            choices = discount_slider_df$t_bill_duration
          ),
          br(),
          highchartOutput('histogram')
        )
      ),
      f7Tab(
        tabName = "Back-test",
        f7List(
          h2('Benchmark: Buys every month $100 worth'),
          h4('Uses a 20% PE weight'),
          f7Slider(
            'not_buy_point',
            label = 'Value under which $100 investment is delayed (%)',
            min = 0,
            max = 10,
            step = 0.2,
            value = 2
          ),
          valueBoxOutput(
            'benchmark_end_balance'
          ),
          valueBoxOutput(
            'end_balance'
          )
        )
      )
    )
  )
)

