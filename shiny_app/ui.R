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
          ),
          br(),
          f7Block(
            f7BlockHeader(
              "What is P/E weight?"
            ),
            em(
              "P/E weight allows you select how much contribution the current P/E and shiller P/E have.
              For example, a selected weight of 0.2 means that the current P/E is weighted 20% and the shiller PE is weighted 80%"
            )
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
            f7Picker(
              "t_bill_duration",
              label = "Treasury used as Discount Rate",
              choices = discount_slider_df$t_bill_duration,
              value = "10 year"
            ),
            highchartOutput('return_graph'),
            f7Float(
              side = "right",
              f7checkBox(
                'show_avg',
                label = "Show Mean"
              )
            ),
            f7Align(
              box(
                h3(textOutput('current_metric'))
              ),
              side = "center"
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
          f7Align(
            side = "center",
            f7Block(
              strong = TRUE,
              inset = TRUE,
              f7BlockHeader("Ending Balance($100 invested monthly no matter what)"),
                h1(textOutput('benchmark_end_balance'))
            )
          ),
          f7Align(
            side = "center",
            f7Block(
              strong = TRUE,
              inset = TRUE,
              f7BlockHeader("Ending Balance($100 investment posponed under Not Buy Point)"),
              h1(textOutput('end_balance'))
            )
          )
        )
      )
    )
  )
)

