library(Quandl)
library(dplyr)
library(lubridate)
library(quantmod)


##this data being pulled has problems the dates don't always pull the most recent month.
##sometimes also data exist for dates in the future("ooooh spooooky")
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
##load egr data
egr_data <- read.csv(
  "shiny_app/data/egr_data.csv",
  stringsAsFactors = FALSE
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



library(tibble)
library(rio)

quantmod::getSymbols.yahoo(
  "^SP500TR",
  .GlobalEnv,
  return.class = 'xts',
  index.class  = 'Date',
  from = "1990-01-01",
  to = Sys.Date(),
  periodicity = "monthly"
)

SP500TR <- as.data.frame(SP500TR)

SP500TR <- SP500TR %>%
  select(SP500TR.Close)

names <- rownames(SP500TR)
row.names(SP500TR) <- NULL

SP500TR <- cbind(names, SP500TR)

names(SP500TR) <- c("Date", "sp_500_tr")

SP500TR$Date <- as_date(SP500TR$Date)

##Converting for use in log TR
start_s_p_tr_price <- s_p_tr[1, ]$sp_500_tr

s_p_tr_log <- SP500TR %>%
  mutate(log_returns = log( s_p_tr$sp_500_tr /  start_s_p_tr_price))

saveRDS(
  SP500TR,
  "shiny_app/data/s_p_tr.RDS"
)

saveRDS(
  s_p_tr_log,
  "shiny_app/data/s_p_tr_log.RDS"
)



# 
# ##old
# # s_p_daily <- quantmod::getSymbols(
# #   "^GSPC", src = "yahoo",
# #   auto.assign = FALSE
# # )
# 
# ## new
# 
# s_p_daily <- s_p_daily %>%
#   select(
#     date,
#     close = GSPC.Close
#   ) %>%
#   filter(date > as.Date(Sys.Date() - 31))
# 
# saveRDS(
#   s_p_daily,
#   "shiny_app/data/s_p_daily.RDS"
# )
# 
# 
# ##Fetching S&P total return values
# s_p_daily_tr <- quantmod::getSymbols(
#   "^SP500TR", src = "yahoo",
#   auto.assign = FALSE
# )
# 
# s_p_daily_tr <- as.data.frame(s_p_daily_tr)
# s_p_daily_tr <- as_tibble(s_p_daily_tr)
# 
# s_p_daily_tr$Date <- as.Date(s_p_daily_tr$Date)
# 
# saveRDS(
#   s_p_daily_tr,
#   "shiny_app/data/s_p_daily_tr.RDS"
# )
# 
# 
# ##Converting for use in log TR
# start_s_p_tr_price <- s_p_daily_tr[1, ]$Close
# 
# 
# # filter(date > as.Date(Sys.Date() - (20*365)) )
# s_p_daily_tr_log <- s_p_daily_tr %>%
#   mutate(log_returns = log( s_p_daily_tr$Close /  start_s_p_tr_price))
# 
# saveRDS(
#   s_p_daily_tr_log,
#   "shiny_app/data/s_p_daily_tr_log.RDS"
# )



# total_r <- Quandl("YALE/SP_RDSPD", api_key="b4H5zGkcGuqDGi_tGr4H", collapse = "monthly")
#   
# install.packages("BatchGetSymbols")
# library(BatchGetSymbols)
# 
# ?BatchGetSymbols
# sp500_log_tr <- BatchGetSymbols(
#   tickers = "^SP500TR",
#   first.date = "1990-01-01",
#   type.return = "log",
#   freq.data = "monthly"
# )



