

most_recent_tr <- s_p_daily_tr[nrow(s_p_daily_tr),]$Close

##creating table to be used in simulation
s_p_monthly_investment_table <- s_p_daily_tr %>%
  select(date = Date, tr_close = Close) %>%
  mutate(end_dollar_value = most_recent_tr / tr_close * 100)

##encorperating passed "nick metric" values into table and removed "NA" rows(first two rows)
investment_with_nick_metrics <- s_p_monthly_investment_table %>%
    left_join(metrics, by = "date") %>%
    select(c("date","tr_close", "end_dollar_value", "pe", "shiller","t_bill_3m", "t_bill_6m", "t_bill_1", "t_bill_2", "t_bill_3", "t_bill_5", "t_bill_7", "t_bill_10", "t_bill_20" , "t_bill_30")) %>%
    filter(!is.na(pe))  %>%
    mutate( nick_metric = ( 0.2 * (1 / pe) + 0.8 * ( 1 / shiller) )  * sqrt(egr_geo_mean) * egr_geo_mean / (1 + t_bill_10/100) )

##finding ending value of investment strategy of $100 per month beginning 1-Feb-1990
investment_end_value_100_per_month <- round(sum(investment_with_nick_metrics$end_dollar_value), 2)

##output render
output$investment_end_value_100_per_month <- renderValueBox( {
  valueBox(
    investment_end_value_100_per_month,
    "End Value",
    color = "green"
  )
})

## making purchase decision react to slider(hold off buying until metric is high enough again)
sum_with_delays <- reactive({

  buy_point <- input$not_buy_point
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

output$sum_with_delays <- renderValueBox( {
  valueBox(
    sum_with_delays(),
    "End Value"
  )
})

