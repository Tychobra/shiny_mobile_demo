test_module_ui <- function(id) {
  ns <- NS(id)
  
      f7Slider(
        "pe_pct_weight",
        label = "P/E Weights (%)",
        min = 0,
        max = 100,
        value = 20
      )
}

# test_module <- function(input, output, session) {
#   ns <- session$ns
# }