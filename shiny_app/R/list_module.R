
list_module_ui <- function(id)  {
  
  ns <-  NS(id)
  
  f7List(
    f7ListGroup(
      f7ListItem(
        'This'
      ),
      f7ListItem(
        'Is'
      ),
      f7ListItem(
        'Where'
      ),
      f7ListItem(
        'The'
      ),
      f7ListItem(
        'List'
      ),
      f7ListItem(
        'Items'
      ),
      f7ListItem(
        'Would'
      ),
      f7ListItem(
        'Go'
      ),
      f7ListItem(
        'Item_1'
      ),
      f7ListItem(
        'Item_2'
      ),
      f7ListItem(
        'Item_3'
      ),
      f7ListItem(
        'Item_4'
      ),
      f7ListItem(
        'Item_5'
      ),
      f7ListItem(
        'Item_6'
      ),
      f7ListItem(
        'Item_7'
      ),
      f7ListItem(
        'Item_8'
      ),
      title = "List Title",
    )
  )
  
}

list_module <- function(input, output, session) {
  
}