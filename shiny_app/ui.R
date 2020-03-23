f7Page(
  title = "S&P Valuation",
  init = f7Init(
    skin = "auto",
    theme = "dark"
  ),
  f7TabLayout(
    panels = tagList(
      f7Panel(
        inputId = "panel",
        side = 'left',
        effect = 'cover',
          f7PanelItem(
            "this is a panel selection",
            tabName = "hello_tab"
          )
        )
      ),
      navbar = f7Navbar(
        title = 'Valuation',
        left_panel = TRUE,
        right_panel = FALSE
      ),
# UI Chart tab --------------------------------------------
      f7Tabs(
        animated = TRUE,
        id = 'tabs',
        f7Tab(
          tabName = 'graph',
          active = TRUE,
          chart_module_ui(
            "chart"
          )
          # f7List(
          #   f7Row(
          #     f7Slider(
          #       "pe_pct_weight",
          #       label = "P/E Weights (%)",
          #       min = 0,
          #       max = 100,
          #       value = 20
          #     ),
          #     f7Picker(
          #       "t_bill_duration",
          #       label = "Treasury used as Discount Rate",
          #       choices = discount_slider_df$t_bill_duration,
          #       value = "10 year"
          #     ),
          #     highchartOutput('return_graph'),
          #     f7Align(
          #       box(
          #         status = "primary",
          #         h3(textOutput('current_metric')),
          #         title = "Current Value of Nick Metric"
          #       ),
          #       side = "center"
          #     ),
          #     f7Float(
          #       side = "right",
          #       f7List(
          #         f7checkBox(
          #           'show_avg',
          #           label = "Show Metric Mean"
          #         ),
          #         f7checkBox(
          #           'show_q1',
          #           label = "Show Metric 25th Percentile"
          #         ),
          #         f7checkBox(
          #           'show_q3',
          #           label = "Show Metric 75th Percentile"
          #         )
          #       )
          #     )
          #   )
          # )
        ),
# UI Back-test tab --------------------------------------------
        f7Tab(
          tabName = "back_test",
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
        ),
        f7Tab(
          tabName = "list_tab",
          f7List(
            f7ListGroup(
              f7ListItem(
                'ListItem 1'
              ),
              f7ListItem(
                'ListItem 2'
              ),
              f7ListItem(
                'ListItem 3'
              ),
              title = "List Title",
            )
          )
        )
      )
    )
  )

