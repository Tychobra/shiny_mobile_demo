function(input, output, session) {
  
  ##PE weight reactive
  sel_pe_weight <- reactive({
    hold_pct_weight_label <- input$pe_pct_weight
    
    slider_df %>%
      filter(slider_df$pct_label == hold_pct_weight_label) %>%
      pull('value')
  })
  ##Discount rate reactive
  sel_t_bill_discount <- reactive({
    hold_t_bill_discount <- input$t_bill_discount_used
    
    discount_slider_df %>%
      filter(discount_slider_df$discount_rate == hold_t_bill_discount) %>%
      pull("value_current_discount")
  })
  
  
  
  ##discount rate reactive used in the average calculation
  sel_t_bill_discount_geo <- reactive({
    hold_t_bill_discount <- input$t_bill_discount_used
    
    discount_slider_df %>%
      filter(discount_slider_df$discount_rate == hold_t_bill_discount) %>%
      pull("value_geo_discount")
  })
  

  
  # calculates nick metrics for all months using data from "metrics" dataframe
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
  
  source('server/1_s_dashboard.R', local = TRUE)
  
  source('server/2_s_details_of_analysis.R', local = TRUE)
  
  source('server/3_s_strategy_back_test.R', local = TRUE)
  
  source('server/4_s_saved_params.R', local = TRUE)
  
}