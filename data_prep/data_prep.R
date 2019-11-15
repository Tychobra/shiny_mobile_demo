library(Quandl)
library(dplyr)
library(lubridate)
library(tidyverse)


shiller_table_month <- Quandl("MULTPL/SHILLER_PE_RATIO_MONTH")
pe_table_month <- Quandl("MULTPL/SP500_PE_RATIO_MONTH")
treasury_table_month <- Quandl("USTREASURY/YIELD", collapse="monthly") 
s_p_table_month <- Quandl("YALE/SPCOMP", api_key="b4H5zGkcGuqDGi_tGr4H")


shiller_100_year <- shiller_table_month[1:1200, ]
pe_100_year <- pe_table_month[1:1200, ]
s_p_100_year <- s_p_table_month[1:1200, ]

treasuries_out <- treasury_table_month %>%
  # select(date = date, t_bill_10 = `10 YR`) %>%
  mutate(date = Date + lubridate::days(1))  %>%
  select(-Date)

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
  filter(!is.na(`10 YR`))

## adding log return column


start_s_p_price <- metrics$s_p_price[nrow(metrics)]

metrics <- metrics %>%
  mutate(log_returns = log( s_p_price /  start_s_p_price)) %>%
  select(-`1 MO`) %>%
  select(-`2 MO`)


## name the rows
names(metrics) <- c(
  "date",
  "shiller",
  "pe",
  "t_bill_3m",
  "t_bill_6m",
  "t_bill_1",
  "t_bill_2",
  "t_bill_3",
  "t_bill_5",
  "t_bill_7",
  "t_bill_10",
  "t_bill_20",
  "t_bill_30",
  "s_p_price",
  "log_return"
)

saveRDS(
  metrics,
  "shiny_app/data/metrics.RDS"
)
##create geo mean func
geo_mean = function(x, na_rm = TRUE){
  exp(sum(log(x[x > 0]), na.rm = na_rm) / length(x))
}

# convert the t bills columns into a long tidy data frame
t_bill_geo_means <- metrics %>%
  select(date, t_bill_3m:t_bill_30) %>%
  tidyr::pivot_longer(t_bill_3m:t_bill_30, names_to = 'duration', values_to = 'value')

# convert to rates and calculate geometric means
t_bill_geo_means <- t_bill_geo_means %>%
  mutate(value = 1 + value / 100) %>%
  group_by(duration) %>%
  summarize(geo_mean = geo_mean(value)) %>%
  ungroup()

saveRDS(
  t_bill_geo_means,
  "shiny_app/data/t_bill_geo_means.RDS"
)

egr_geo_mean <- egr_data %>%
  mutate(growth_rate = 1 + earning_growth) %>%
  pull("growth_rate") %>%
  geo_mean()

saveRDS(
  egr_geo_mean,
  "shiny_app/data/egr_geo_mean.RDS"
)

