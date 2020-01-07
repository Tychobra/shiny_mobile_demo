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
          f7Tooltip(
            f7Slider(
              'not_buy_point',
              label = 'Cutoff',
              min = 0,
              max = 7,
              step = 0.1,
              value = 2
            ), 'Balance starts at $0 with a monthly $100 income stream available to invest.
             You can select a minimum Nick Metric(NM) cutoff under which your monthly income
             is saved until the NM exceeds the cutoff'
          ),
          f7Tooltip(
            f7Slider(
              'pe_weight_backtest',
              label = 'PE Weight',
              min = 0,
              max = 100,
              step = 1,
              value = 20
            ), 'To Calculate the NM, a weighted PE / Shiller PE is used.  Select the desired weight here'
          ),
          f7Block(
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
)

