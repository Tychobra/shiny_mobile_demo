
db_trigger <- reactiveVal(0)

saved_params <- reactive({
  db_trigger()
  
  dbGetQuery(conn, 'SELECT * FROM params')
})

#reactive to render table which is displayed in ui
output$saved_params_table <- renderDT({
  out <- saved_params()
  
  datatable(
    out,
    rownames = FALSE
  )
})

params_prep <- eventReactive(input$save_params, {
  
  out <- list(
    email = 'nick.merlino@tychobra.com',
    pe_pct = sel_pe_weight(),
    discount = input$t_bill_discount_used
  )
  
  out$uid <- digest::digest(list(
    runif(1), 
    Sys.time()
  ))
  
  out
})

observeEvent(params_prep(), {
  
  dat <- params_prep()
  
  tryCatch({
    
    dbExecute(
      conn,
      'INSERT INTO params (uid, email, pe_pct, discount) VALUES ($1, $2, $3, $4)',
      params = list(
        dat$uid,
        dat$email,
        dat$pe_pct,
        dat$discount
      )
    )
    
    db_trigger(db_trigger() + 1)
    tychobratools::show_toast('success', 'params successfully added to db')
  }, error = function(err) {
    print(err)
    tychobratools::show_toast('error', 'error adding params to db')
    
  })
})
