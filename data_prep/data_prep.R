library(Quandl)
library(dplyr)
library(lubridate)

shiller_table_month <- Quandl("MULTPL/SHILLER_PE_RATIO_MONTH")
pe_table_month <- Quandl("MULTPL/SP500_PE_RATIO_MONTH")
treasury_table_month <- Quandl("USTREASURY/YIELD", collapse="monthly") 
s_p_table_month <- Quandl("YALE/SPCOMP", api_key="b4H5zGkcGuqDGi_tGr4H")


shiller_100_year <- shiller_table_month[1:1200, ]
pe_100_year <- pe_table_month[1:1200, ]
s_p_100_year <- s_p_table_month[1:1200, ]

treasuries_out <- treasury_table_month %>%
  select(date = Date, t_bill_10 = `10 YR`) %>%
  mutate(date = date + lubridate::days(1))

s_p_out <- s_p_table_month %>%
  select(date = Year, s_p_price = "S&P Composite") %>%
  mutate(date = date + lubridate::days(1))

metrics <- shiller_100_year %>%
  left_join(pe_100_year, by = "Date")
  
names(metrics) <- c(
  "date",
  "shiller", 
  "pe")

metrics <- metrics %>%
  left_join(treasuries_out, by = "date") %>%
  left_join(s_p_out, by = "date")

# removed 1 rows where there was an extra shiller and pe metric at the end of the month
metrics <- metrics %>%
  filter(date != as.Date('2019-05-31'))

# remove all data before the first t-bill data
metrics <- metrics %>%
  filter(!is.na(t_bill_10))

names(metrics) <- c(
  "date",
  "shiller",
  "pe",
  "t_bill_10",
  "s_p_price"
)

saveRDS(
  metrics,
  "shiny_app/data/metrics.RDS"
)

