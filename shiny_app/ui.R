
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
    
# UI Chart tab ------------------------------------------------

      f7Tabs(
        animated = TRUE,
        id = 'tabs',
        f7Tab(
          tabName = 'graph',
          active = TRUE,
          f7Slider(
            "pe_pct_weight",
            label = "P/E Weights (%)",
            min = 0,
            max = 100,
            value = 20
          ),
          chart_module_ui(
            "chart"
          )
        ),
        
# UI Back-test tab --------------------------------------------

        f7Tab(
          tabName = "Back Test",
          back_test_module_ui(
            "back_test"
          )
        ),

# UI List Tab -------------------------------------------------

        f7Tab(
          tabName = "List Tab",
          list_module_ui(
            "list_module"
          )
        )
      )
    )
  )

