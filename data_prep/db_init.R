library(RSQLite)
library(DBI)


# Create a connection object with SQLite
conn <- DBI::dbConnect(
  RSQLite::SQLite(), 
  'shiny_app/database/db.sqlite3'
)

#dbListTables(conn)

# Create a query to prepare the 'params' table with additional 'uid',
# & email, pe selected, and discount selected
create_params_table_query = "CREATE TABLE params (
  uid                             TEXT PRIMARY KEY,
  email                           TEXT,
  pe_pct                          REAL,
  discount                        TEXT,
  created_at                      TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
  modified_at                     TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP
)"

# dbExecute() executes a SQL statement with a connection object
# Drop the table if it already exists
DBI::dbExecute(conn, "DROP TABLE IF EXISTS params")
# Execute the query created above
DBI::dbExecute(conn, create_params_table_query)

# Read in the RDS file created in 'data_prep.R'

##creates tibble which is used as first seed data in database
init_params_table <- tibble::tibble(
  uid = 'hjkasfdhksa',
  email = 'nick.merlino@tychobra.com',
  pe_pct = 0.2,
  discount = '10 year'
)

# fill in the SQLite table with the values from the RDS file
DBI::dbWriteTable(
  conn,
  name = "params",
  value = init_params_table,
  overwrite = FALSE,
  append = TRUE
)

# List tables to confirm 'mtcars' table exists
dbListTables(conn)

# MUST disconnect from SQLite before continuing
dbDisconnect(conn)
