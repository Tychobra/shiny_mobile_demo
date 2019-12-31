function(input, output, session) {
  
  output$histogram <- renderHighchart(
    hchart(hist(rnorm(100)))
  )
}