function(input, output, session) {
  
  pe_ratio <- .2
  
  
  output$histogram <- renderHighchart(
    hc <- highchart() %>%
      hc_add_series(
        name = "log total return",
        data = s_p_log_time_series_tr
      )
  )
}