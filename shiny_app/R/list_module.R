
list_module_ui <- function(id)  {
  
  ns <-  NS(id)
  
  f7List(
    f7ListGroup(
      f7ListItem(
        media = icon("google"),
        url = "https://finance.yahoo.com/quote/GOOGL/",
        right = "Google"
      ),
      f7ListItem(
        media = icon("charging-station"),
        right = 'Tesla',
        url = "https://finance.yahoo.com/quote/tsla/"
      ),
      f7ListItem(
        media = icon("square"),
        right = 'Square',
        url = "https://finance.yahoo.com/quote/sq/"
      ),
      f7ListItem(
        media = icon("apple"),
        right = 'Apple',
        url = "https://finance.yahoo.com/quote/appl/"
      ),
      f7ListItem(
        media = icon("facebook-square"),
        right = 'Facebook',
        url = "https://finance.yahoo.com/quote/fb/"
      ),
      title = "Highlighted Stocks",
    )
  )
  
}

list_module <- function(input, output, session) {
  
}