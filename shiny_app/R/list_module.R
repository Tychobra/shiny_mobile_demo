
list_module_ui <- function(id)  {
  
  ns <-  NS(id)
  
  f7List(
    f7ListGroup(
      f7ListItem(
        'ListItem 1'
      ),
      f7ListItem(
        'ListItem 2'
      ),
      f7ListItem(
        'ListItem 3'
      ),
      title = "List Title",
    )
  )
  
}

list_module <- function(input, output, session) {
  
}