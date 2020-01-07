function(input, output, session) {
  
  # Chart Page ---------------------------------------------------
  
  pe_ratio <- reactive({
    input$pe_pct_weight / 100
  })
  
  ##reactive to current interest rate of a selected t-bill duration
  discount_rate <- reactive({
    discount_slider_df %>%
      filter(t_bill_duration == input$t_bill_duration) %>%
      pull(value_current_discount[1])
  })
  
  ##reactive to grab geometric mean of a selected t-bill duration
  discount_geo_mean <- reactive({
    discount_slider_df %>%
      filter(t_bill_duration == input$t_bill_duration) %>%
      pull(value_geo_discount[1])
  })
  
  avg_complete_metric <- reactive({
    
    pe_weight_input <- pe_ratio()
    t_duration_geo_selected <- discount_geo_mean()
    
    pe_component = (1 / avg_pe_100) * pe_weight_input 
    shiller_component = (1 / avg_shiller_100) * (1 - pe_weight_input)
    nick_metric = ( shiller_component + pe_component ) * ( 1 / t_duration_geo_selected )
    
  })
  
  current_complete_metric <- reactive({
    
    pe_weight_input <- pe_ratio()
    most_recent_t_bill_selected <-  discount_rate() 
    
    pe_component = ( 1 / (metrics[1, ]$pe ) ) * pe_weight_input
    shiller_component = (1 / (metrics[1, ]$shiller) ) * (1 - pe_weight_input)
    nick_metric = (shiller_component + pe_component ) * ( 1 / most_recent_t_bill_selected )
    
  })
  
  complete_metric_over_time <- reactive({
    
    pe_weight_input <- pe_ratio()
    most_recent_t_bill_selected <-  discount_rate()
    
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
  
  # Back-test Page ---------------------------------------
  
  most_recent_tr <- s_p_daily_tr[nrow(s_p_daily_tr),]$Close
  
  ##creating table to be used in simulation
  s_p_monthly_investment_table <- s_p_daily_tr %>%
    select(date = Date, tr_close = Close) %>%
    mutate(end_dollar_value = most_recent_tr / tr_close * 100)
  
  
  
  ##encorperating passed "nick metric" values into table and removed "NA" rows(first two rows)
  investment_with_nick_metrics <- s_p_monthly_investment_table %>%
    left_join(metrics, by = "date") %>%
    select(c("date","tr_close", "end_dollar_value", "pe", "shiller","t_bill_3m", "t_bill_6m", "t_bill_1", "t_bill_2", "t_bill_3", "t_bill_5", "t_bill_7", "t_bill_10", "t_bill_20" , "t_bill_30")) %>%
    filter(!is.na(pe)) %>%
    mutate( nick_metric = ( .2 * (1 / pe) + ( 1 - .2 ) * ( 1 / shiller) )  * 1 / (1 + t_bill_10/100) )
  
  ##finding ending value of investment strategy of $100 per month beginning 1-Feb-1990
  investment_end_value_100_per_month <- round(sum(investment_with_nick_metrics$end_dollar_value), 2)
  
  
  ## making purchase decision react to slider(hold off buying until metric is high enough again)
  sum_with_delays <- reactive({
    
    buy_point <- input$not_buy_point / 100
    cash_to_deploy <- 0
    n_rows <- nrow(investment_with_nick_metrics)
    return_value <- numeric(n_rows)
    
    for (i in seq_len(n_rows)) {
      
      cash_to_deploy <- cash_to_deploy + 1
      the_row <- investment_with_nick_metrics[i, ]
      
      if (the_row$nick_metric > buy_point) {
        
        return_value[i] <- the_row$end_dollar_value * cash_to_deploy
        cash_to_deploy <- 0
        
      }
    }
    
    round(sum(return_value) + cash_to_deploy*100, 2 )
    
  })
  
  ##Box output renders
  output$benchmark_end_balance <- renderValueBox( {
    valueBox(
      investment_end_value_100_per_month,
      subtitle = "Benchmark: Invests $100/month",
      color = "green"
    )
  })
  
  output$end_balance <- renderValueBox( {
    valueBox(
      sum_with_delays(),
      subtitle = "Using Cutoff End Balance"
    )
  })
}


