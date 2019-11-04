function(input, output, session) {
  
  sel_pe_weight <- reactive({
    fwd_pe_weight_input <- input$fwd_pe_pct_weight / 100
  })
  
  complete_metric <- reactive({
    fwd_pe_weight_input <- sel_pe_weight()
      
    dat %>%
      mutate(
        pe_component = (1 / pe) * fwd_pe_weight_input, 
        shiller_component = (1 / shiller) * (1 - fwd_pe_weight_input),
        t_bill_discount = (1 + t_bill_10),
        nick_metric = (sqrt(egr_geo_mean) * ( shiller_component + pe_component )) * ( egr_geo_mean / t_bill_discount )
      )
  })
  
  observe({
    print(list(
      historical_chart_prep = historical_chart_prep()
    ))
  })
  
  historical_chart_prep <- reactive({
    hold <- complete_metric()
    
    xts::xts(x = hold$nick_metric, order.by = hold$date)
  })
  
  avg_complete_metric <- reactive({
    fwd_pe_weight_input <- sel_pe_weight()
    
    pe_component = (1 / avg_pe_since_1992) * fwd_pe_weight_input 
    shiller_component = (1 / avg_shiller_since_1992) * (1 - fwd_pe_weight_input)
    nick_metric = (sqrt(egr_geo_mean) * ( shiller_component + pe_component )) * ( egr_geo_mean / t_ten_geo_mean )
  })
  
  
  
  output$historical_chart <- renderHighchart({
    plot_data <- historical_chart_prep()
    hold_avg <- avg_complete_metric()
    
    highchart(type = "stock") %>%
      hc_title(text = "Nick's Metric") %>%
      hc_legend(
        enabled = FALSE
      ) %>%
      #hc_rangeSelector(
      #  selected = 4
      #) %>%
      hc_xAxis(
        type = 'datetime'
      ) %>%
      hc_yAxis(
        title = list(text = "Nick's Metric"),
        plotLines = list(
          list(
            color = '#FF0000',
            width = 2,
            value = avg_complete_metric()  
          )
        )
      ) %>%
      hc_add_series(
        data = plot_data
      ) 
  })

  # output$basis_point_dif <- renderText({
  #  complete_avg_metric() %>% 
  #     pull()
  # })
  
  output$yields_table <- renderDT({
    out <- complete_metric()
    
    datatable(
      out,
      rownames = FALSE,
      options = list(
        dom = "ft",
        pageLength = nrow(out)
      )
    )
    
  })
}