

investment_with_nick_metrics <- s_p_monthly_investment_table %>%
  left_join(metrics, by = "date") %>%
  select(c("date","tr_close", "end_dollar_value", "pe", "shiller", "t_bill_10")) %>%
  filter(!is.na(pe))  %>%
  mutate( nick_metric = ( 0.2 * (1 / pe) + .8 * ( 1 / shiller) )  * sqrt(egr_geo_mean) * egr_geo_mean / (1 + t_bill_10/100) )

buy_point <- 0.06 

cash_to_deploy <- 0

n_rows <- nrow(investment_with_nick_metrics)
return_value <- rep(0, times = n_rows)
for (i in seq_len(n_rows)) {
  
  cash_to_deploy <- cash_to_deploy + 1
  
  the_row <- investment_with_nick_metrics[i, ]
  
  if (the_row$nick_metric > buy_point) {
    
    return_value[i] <- the_row$end_dollar_value * cash_to_deploy
    cash_to_deploy <- 0 
  } 
  
}

sum(return_value)




