function(input, output, session) {
  
  sel_pe_weight <- reactive({
    hold_pct_weight_label <- input$pe_pct_weight
    
    slider_df %>%
      filter(slider_df$pct_label == hold_pct_weight_label) %>%
      pull('value')
  })
  
  sel_t_bill_discount <- reactive({
    hold_t_bill_discount <- input$t_bill_discount_used
    
    discount_slider_df %>%
      filter(discount_slider_df$discount_rate == hold_t_bill_discount) %>%
      pull("value_current_discount")
  })
  
  sel_t_bill_discount_geo <- reactive({
    hold_t_bill_discount <- input$t_bill_discount_used
    
    discount_slider_df %>%
      filter(discount_slider_df$discount_rate == hold_t_bill_discount) %>%
      pull("value_geo_discount")
  })
  
  # calculates nick metrics for all months using data from "metrics" dataframe
  #
  # @return a data frame with x columns:
  # date, pe, shiller, t-bill 10,s&p price, pe component, shiller component, nick_metric
  complete_metric <- reactive({
    hold_pe_weight <- sel_pe_weight()
    t_duration_geo_selected <- sel_t_bill_discount_geo()
    
    metrics %>%
      mutate(
        pe_component = (1 / pe) * hold_pe_weight, 
        shiller_component = (1 / shiller) * (1 - hold_pe_weight),
        nick_metric = (sqrt(egr_geo_mean) * ( shiller_component + pe_component )) * ( egr_geo_mean / t_duration_geo_selected )
      )
  })
  
  historical_chart_prep <- reactive({
    hold <- complete_metric()
    xts::xts(x = hold$nick_metric, order.by = hold$date)
  })
  
  avg_complete_metric <- reactive({
    pe_weight_input <- sel_pe_weight()
    t_duration_geo_selected <- sel_t_bill_discount_geo()
      
    pe_component = (1 / avg_pe_100) * pe_weight_input 
    shiller_component = (1 / avg_shiller_100) * (1 - pe_weight_input)
    nick_metric = ( sqrt(egr_geo_mean)*( shiller_component + pe_component )) * ( egr_geo_mean / t_duration_geo_selected )
  })
  
  current_complete_metric <- reactive({
    pe_weight_input <- sel_pe_weight()
    c_p_adjustment <- s_p_latest / s_p_first_day_of_month
    most_recent_t_bill_selected <-  1 + (sel_t_bill_discount() / 100) 
    
    pe_component = ( 1 / (c_p_adjustment * metrics[1, ]$pe ) ) * pe_weight_input
    shiller_component = (1 / ( c_p_adjustment * metrics[1, ]$shiller) ) * (1 - pe_weight_input)
    nick_metric = (sqrt(egr_geo_mean)*( shiller_component + pe_component )) * ( egr_geo_mean / most_recent_t_bill_selected ) 
  })
  
  complete_metric_box_prep <- reactive({
    (current_complete_metric() * 100) %>%
      round(3) %>%
      paste0('%')
  })
  output$current_complete_metric_box <- renderValueBox({
    valueBox(
      value = complete_metric_box_prep(),
      subtitle = "Current",
      width = 12
    )
  })
  
  output$buy_sell_rec_box <- renderValueBox({
    valueBox(
      value = buy_sell_rec(),
      subtitle = "Recommendation",
      width = 12,
      color = "black"
    )
  })
  
  avg_complete_metric_box_prep <- reactive({
    (avg_complete_metric()*100) %>%
    round(2) %>%
    paste0("%")
  })
  output$avg_complete_metric_box <- renderValueBox({
    valueBox(
      value = avg_complete_metric_box_prep(),
      subtitle = "Average",
      width = 12,
      color = "red"
    )
  })
  
# ##Display S&P price check box
  output$historical_chart <- renderHighchart({
    plot_data <- historical_chart_prep()
    hold_avg <- avg_complete_metric()
    include_s_p <- input$turn_on_sp_overlay
    include_log_s_p <- input$turn_on_log_sp_overlay
    include_s_p_tr <- input$turn_on_s_p_tr_overlay
    
    hc_out <- highchart(type = "stock") %>%
      hc_title(text = "Nick metric(blue line) being higher than the average(red line) suggests S&P was cheap") %>%
      hc_legend(
        enabled = FALSE
      ) %>%
      hc_xAxis(
        type = 'datetime'
      ) %>%
      hc_tooltip(
        pointFormat = '<span style="color:{point.color}">\u25CF</span> {series.name}: <b>{point.y:.4f}</b><br/>'
      ) %>%
      hc_yAxis(
        title = list(text = "Nick's Metric"),
        min = 0,
        plotLines = list(
          list(
            color = '#FF0000',
            width = 2,
            value = avg_complete_metric()  
          )
        )
      ) %>%
      hc_add_series(
        data = plot_data,
        name = "Nick's Metric"
       )
    
    if (isTRUE(include_s_p)) {
      hc_out <- hc_out %>%
        hc_add_series(
          data = sp_time_series,
          name = "S&P price/40000",
          color = "green"
        )
    }
    if(isTRUE(include_log_s_p))  {
      hc_out <- hc_out %>%
        hc_add_series(
        data = sp_log_time_series,
        name = "log S&P price",
        color = "orange"
        )
    }
    if (isTRUE(include_s_p_tr)) {
      hc_out <- hc_out %>%
        hc_add_series(
          data = s_p_daily_tr_time_series,
          name = "S&P TR",
          color = "purple"
        )
    }
    hc_out
  })
  
  
  
  buy_sell_rec <- reactive({
    metric_vs_avg_dif <- current_complete_metric() - avg_complete_metric()

    cut(metric_vs_avg_dif, c(-Inf, -.01, -0.005, 0, 0.01, Inf),
        right = FALSE,
        labels = c("stong sell", "sell", "hold", "buy", "strong buy")
    )
  })
  
  
  source('server/2_s_details_of_analysis.R', local = TRUE)
  
}