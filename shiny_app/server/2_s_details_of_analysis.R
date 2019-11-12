
output$details_table <- renderDT({
  render_out <- complete_metric()
  
  datatable(
    render_out,
    rownames = FALSE,
    options = list(
      dom = "ft",
      pageLength = nrow(render_out),
      scrollX = TRUE
    )
  ) %>%
    formatRound(
      columns = c("pe_component", "shiller_component", "nick_metric", "log_return"),
      digits = 4
    )
})
