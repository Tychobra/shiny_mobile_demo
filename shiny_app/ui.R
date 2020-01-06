f7Page(
  title = "S&P Valuation",
  f7TabLayout(
    panels = f7Panel(
      side = 'left',
      theme = "light",
      f7PanelMenu(
        'menu',
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
        highchartOutput('histogram')
      ),
      f7Tab(
        tabName = "Back-test"
      )
    )
  )
)
