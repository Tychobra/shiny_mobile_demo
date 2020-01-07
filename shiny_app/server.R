function(input, output, session) {
  
  # pe_ratio <- .2
  sel_t_bill_geo <- 1.05
  
  pe_ratio <- reactive({
    input$pe_pct_weight / 100
  })
  
  avg_complete_metric <- reactive({
    
    pe_weight_input <- pe_ratio()
    t_duration_geo_selected <- sel_t_bill_geo
    
    pe_component = (1 / avg_pe_100) * pe_weight_input 
    shiller_component = (1 / avg_shiller_100) * (1 - pe_weight_input)
    nick_metric = ( shiller_component + pe_component ) * ( 1 / t_duration_geo_selected )
    
  })
  
  current_complete_metric <- reactive({
    
    pe_weight_input <- pe_ratio()
    most_recent_t_bill_selected <-  1.02 #hard coded for now

    pe_component = ( 1 / (metrics[1, ]$pe ) ) * pe_weight_input
    shiller_component = (1 / (metrics[1, ]$shiller) ) * (1 - pe_weight_input)
    nick_metric = (shiller_component + pe_component ) * ( 1 / most_recent_t_bill_selected )
    
  })
  
  complete_metric_over_time <- reactive({
    
    pe_weight_input <- pe_ratio()
    most_recent_t_bill_selected <-  1.02 #hard coded for now
    
    metrics <- metrics %>%
      select(date, shiller, pe, t_bill_10) %>%
      mutate(
        pe_component = ( 1 / pe ) * pe_weight_input,
        shiller_component = (1 / shiller) * (1 - pe_weight_input)
      ) %>%
      mutate(
        nick_metric = (shiller_component + pe_component ) * ( 1 / most_recent_t_bill_selected )
      ) %>%
      select(date, nick_metric)
    
    xts::xts(x = metrics$nick_metric, order.by = metrics$date)
  })

  output$histogram <- renderHighchart({
    plot_data <- complete_metric_over_time()
    
    highchart() %>%
      hc_add_series(
        name = "total log return",
        data = s_p_log_time_series_tr
      ) %>%
      hc_add_series(
        name = "Nick's metric",
        data = plot_data
      )
    
  })
}