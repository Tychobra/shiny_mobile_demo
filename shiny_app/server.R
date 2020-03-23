function(input, output, session) {

# Higher level: Outside Modules --------------------------------
  
  pe_ratio <- reactive({
    req(input$pe_pct_weight)
    
    input$pe_pct_weight / 100
  })
  

#  Chart Tab ---------------------------------------------------
  
  callModule(
    chart_module,
    "chart",
    metrics_ = metrics,
    pe_ratio = pe_ratio
  )

  # Back-test Tab ----------------------------------------------
  
  callModule(
    back_test_module,
    'back_test',
    pe_ratio = pe_ratio
  )
  
  # List Tab ---------------------------------------------------
  
  callModule(
    list_module,
    "list"
  )
  
}


