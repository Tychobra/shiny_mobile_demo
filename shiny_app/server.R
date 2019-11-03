function(input, output, session) {
   ##complete_avg_metric <- reactive({
    ##sqrt(1+.084)*((1/26.1)*(1-input$fwd_pe_weight)+(1/23.99)*(input$fwd_pe_weight))*(((1+.084)/(1+.0435)))
    ## ".084" is CAGR since 1991
    ## "26.1" is mean shiller PE since 1991
    ## "23.99" is mean PE since 1991
    ## ".0435 is CAGR of ten year treasury since 1991
 ## })
  
  
  ##output$basis_point_dif <- renderText({
   ## complete_avg_metric()
 ## })
  
  output$yields_table <- renderDT({
    out <- t_bill_yield
    
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