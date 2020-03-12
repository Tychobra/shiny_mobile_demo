function(input, output, session) {
  
  # Chart Tab ---------------------------------------------------
  # callModule(
  #   chart_module,
  #   "chart",
  #   metrics_ = metrics
  # )
  pe_ratio <- reactive({
    input$pe_pct_weight / 100
  })

  ##reactive to current interest rate of a selected t-bill duration
  discount_rate_ <- reactive({
    discount_slider_df %>%
      filter(t_bill_duration == input$t_bill_duration) %>%
      pull(value_current_discount[1])
  })

  discount_rate <- discount_rate_ %>% debounce(1000)

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

    pe_component = ( 1 / (current_pe_ratios$pe_current ) ) * pe_weight_input
    shiller_component = (1 / (current_pe_ratios$pe_shiller_current) ) * (1 - pe_weight_input)
    nick_metric = (shiller_component + pe_component ) * ( 1 / most_recent_t_bill_selected )

  })

output$current_metric <- renderText( {
  current <- paste(round(100 * current_complete_metric()[1], digits = 2), "%")
  current
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

  output$return_graph <- renderHighchart({
    plot_data <- complete_metric_over_time()
    s_p_dat <- s_p_log_time_series_tr

    mean_metric <- mean(complete_metric_over_time()) * 100

    q1_metric <- unname(quantile(complete_metric_over_time(), probs = 0.25) * 100)
    q3_metric <- unname(quantile(complete_metric_over_time(), probs = 0.75) * 100)

    out <-  highchart() %>%
      hc_add_series(
        name = "Total Log Return(S&P)",
        data = s_p_log_time_series_tr * 100,
        type = "line",
        tooltip = list(
          valueDecimals = 2
        )
      ) %>%
      hc_add_series(
        name = "Nick's Metric",
        data = plot_data * 100,
        type = "line",
        tooltip = list(
          valueDecimals = 2,
          valueSuffix = "%"
        )
      ) %>%
      hc_xAxis(
        title = "Year",
        type = "datetime"
      ) %>%
      hc_yAxis(
        tickInterval = 1,
        min = 0
      )

    plot_lines_mean <- list(
      value = mean_metric,
      color = "red",
      label = list(text = paste("Mean", ":", round(mean_metric, 2), "%"))
    )

    plot_lines_q1 <- list(
      value = q1_metric,
      color = "blue",
      label = list(text = paste("25th Percentile", ":", round(q1_metric, 2), "%"))
    )

    plot_lines_q3 <- list(
      value = q3_metric,
      color = "blue",
      label = list(text = paste("75th Percentile", ":", round(q3_metric, 2), "%"))
    )

    if(input$show_avg == TRUE & input$show_q1 == FALSE & input$show_q3 == FALSE) {
      out <- out %>%
        hc_yAxis(
          plotLines = list(
            plot_lines_mean
          )
        )
    }

    if(input$show_avg == TRUE & input$show_q1 == TRUE & input$show_q3 == FALSE) {
      out <- out %>%
        hc_yAxis(
          plotLines = list(
            plot_lines_mean,
            plot_lines_q1
          )
        )
    }

    if(input$show_avg == TRUE & input$show_q1 == TRUE & input$show_q3 == TRUE) {
      out <- out %>%
        hc_yAxis(
          plotLines = list(
            plot_lines_mean,
            plot_lines_q1,
            plot_lines_q3
          )
        )
    }

    if(input$show_avg == TRUE & input$show_q1 == FALSE & input$show_q3 == TRUE) {
      out <- out %>%
        hc_yAxis(
          plotLines = list(
            plot_lines_mean,
            plot_lines_q3
          )
        )
    }

    if(input$show_avg == FALSE & input$show_q1 == TRUE & input$show_q3 == TRUE) {
      out <- out %>%
        hc_yAxis(
          plotLines = list(
            plot_lines_q1,
            plot_lines_q3
          )
        )
    }

    if(input$show_avg == FALSE & input$show_q1 == FALSE & input$show_q3 == TRUE) {
      out <- out %>%
        hc_yAxis(
          plotLines = list(
            plot_lines_q3
          )
        )
    }

    if(input$show_avg == FALSE & input$show_q1 == TRUE & input$show_q3 == FALSE) {
      out <- out %>%
        hc_yAxis(
          plotLines = list(
            plot_lines_q1
          )
        )
    }


    out
  })

  # Back-test Tab ---------------------------------------
  
  most_recent_tr <- s_p_daily_tr[nrow(s_p_daily_tr),]$Close
  
  ##creating table to be used in simulation
  s_p_monthly_investment_table <- s_p_daily_tr %>%
    select(date = Date, tr_close = Close) %>%
    mutate(end_dollar_value = most_recent_tr / tr_close * 100)
  
  
  
  ##incorporating passed "nick metric" values into table and removed "NA" rows(first two rows)
  investment_with_nick_metrics <- reactive({
    # req(input$pe_weight_backtest)
    pe_ratio <- input$pe_pct_weight / 100
    
    out <- s_p_monthly_investment_table %>%
    left_join(metrics, by = "date") %>%
    select(c("date","tr_close", "end_dollar_value", "pe", "shiller","t_bill_3m", "t_bill_6m", "t_bill_1", "t_bill_2", "t_bill_3", "t_bill_5", "t_bill_7", "t_bill_10", "t_bill_20" , "t_bill_30")) %>%
    filter(!is.na(pe)) %>%
    mutate( nick_metric = ( pe_ratio * (1 / pe) + ( 1 - pe_ratio ) * ( 1 / shiller) )  * 1 / (1 + t_bill_10/100) )
    
    out
  })
  
  observe({
    req(investment_with_nick_metrics())
  })
  
  ##finding ending value of investment strategy of $100 per month beginning 1-Feb-1990
  investment_end_value_100_per_month <- reactive({
    round(sum(investment_with_nick_metrics()$end_dollar_value), 2)
    
  })
    
  
  
  ## making purchase decision react to slider(hold off buying until metric is high enough again)
  sum_with_delays <- reactive({
    
    
    buy_point <- input$not_buy_point / 100
    cash_to_deploy <- 0
    n_rows <- nrow(investment_with_nick_metrics())
    return_value <- numeric(n_rows)
    
    for (i in seq_len(n_rows)) {
      
      cash_to_deploy <- cash_to_deploy + 1
      the_row <- investment_with_nick_metrics()[i, ]
      
      if (the_row$nick_metric > buy_point) {
        
        return_value[i] <- the_row$end_dollar_value * cash_to_deploy
        cash_to_deploy <- 0
        
      }
    }
    
    round(sum(return_value) + cash_to_deploy*100, 2 )
    
  })
  
  ##Box output renders
  output$benchmark_end_balance <- renderText( {
      investment_end_value_100_per_month()
  })
  
  
  output$end_balance <- renderText( {
      sum_with_delays()
  })
  
  
  # Details of analyisis ------------------------------------------------------------
}


