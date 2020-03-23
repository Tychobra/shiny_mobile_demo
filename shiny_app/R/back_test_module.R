
back_test_module_ui <- function(id) {
  
  ns <-  NS(id)

    f7List(
      br(),
      f7Tooltip(
        f7Slider(
          ns('not_buy_point'),
          label = "Not Buy Point",
          min = 0,
          max = 7,
          step = 0.1,
          value = 2
        ), 'Balance starts at $0 with a monthly $100 income stream available to invest.
               Select a Nick Metric value under which you will not invest the income stream.  
               PE weight can be adjusted on Graph tab.'
      ),
      br(),
      f7Align(
        side = "center",
        f7Block(
          strong = TRUE,
          inset = TRUE,
          f7BlockHeader("Ending Balance($100 invested monthly no matter what)"),
          h1(textOutput(ns('benchmark_end_balance')))
        )
      ),
      f7Align(
        side = "center",
        f7Block(
          strong = TRUE,
          inset = TRUE,
          f7BlockHeader("Ending Balance($100 investment posponed under Not Buy Point)"),
          h1(textOutput(ns('end_balance')))
        )
      )
    )
}

back_test_module <- function(input, output, session, pe_ratio) {
  
  most_recent_tr <- s_p_daily_tr[nrow(s_p_daily_tr),]$sp_500_tr
  
  ##creating table to be used in simulation
  s_p_monthly_investment_table <- s_p_daily_tr %>%
    select(date = Date, tr_close = sp_500_tr) %>%
    mutate(end_dollar_value = most_recent_tr / tr_close * 100)
  
  
  
  ##incorporating passed "nick metric" values into table and removed "NA" rows(first two rows)
  investment_with_nick_metrics <- reactive({
    # req(input$pe_pct_weight)
    pe_ratio <- pe_ratio() #input$pe_pct_weight / 100
    
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
  
}

