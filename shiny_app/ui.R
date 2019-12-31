f7Page(
  title = "S&P Valuation",
  f7TabLayout(
    panels = f7Panel(
      side = 'left',
      theme = "light"),
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
        # hist(
        #   rnorm(100)
        # )
      ),
      f7Tab(
        tabName = "Back-test"
      )
    )
  )
)
