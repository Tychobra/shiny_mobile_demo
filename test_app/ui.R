
f7Page(
  title = "This is a tab layout",
  f7TabLayout(
    panels = tagList(
      f7Panel(
        side = "left",
        theme = "dark"
      )
    ),
    navbar = f7Navbar(
      title = "tabs",
      left_panel = TRUE,
      right_panel = FALSE
    ),
    f7Tabs(
      animated = TRUE,
      id = "tabs",
      f7Tab(
        tabName = "Tab 1",
        active = TRUE,
        # h3("This is the content on Tab 1")
        test_module_ui(
          'test'
        )
      ),
      f7Tab(
        tabName = "Tab 2",
        h3("This is the content on Tab 2")
      )
    )
  )
)