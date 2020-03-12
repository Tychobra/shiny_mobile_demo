
chart_module_ui <- function(id) {
  ns <-  NS(id)
  
    f7List(
      f7Row(
        f7Slider(
          ns("pe_pct_weight"),
          label = "P/E Weights (%)",
          min = 0,
          max = 100,
          value = 20
        ),
        f7Picker(
          ns("t_bill_duration"),
          label = "Treasury used as Discount Rate",
          choices = discount_slider_df$t_bill_duration,
          value = "10 year"
        ),
        highchartOutput(ns('return_graph')),
        # f7Align(
          box(
            status = "primary",
            h3(textOutput(ns('current_metric')),
               title = "Current Value of Nick Metric"),
            side = "center"
          ),
        f7Float(
          side = "right",
          f7List(
            f7checkBox(
              ns('show_avg'),
             label = "Show Metric Mean"),
            f7checkBox(
              ns('show_q1'),
             label = "Show Metric 25th Percentile"),
            f7checkBox(
              ns('show_q3'),
             label = "Show Metric 75th Percentile")
          )
        )
      # )
    )
  )
}


chart_module <- function(input, output, session, metrics_) {
  
  ns <- session$ns
  
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
    
    metrics_ <- metrics_ %>%
      select(date, shiller, pe, t_bill_10) %>%
      mutate(
        pe_component = ( 1 / pe ) * pe_weight_input,
        shiller_component = (1 / shiller) * (1 - pe_weight_input)
      ) %>%
      mutate(
        nick_metric = (shiller_component + pe_component ) * ( 1 / most_recent_t_bill_selected )
      ) %>%
      select(date, nick_metric)
    
    xts::xts(x = metrics_$nick_metric, order.by = metrics_$date)
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
}







