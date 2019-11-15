library(quantmod)
library(tibble)
library(rio)

s_p_daily <- quantmod::getSymbols(
  "^GSPC", src = "yahoo",
  auto.assign = FALSE
)

s_p_daily <- as.data.frame(s_p_daily)

s_p_daily$date <- rownames(s_p_daily)

s_p_daily$date <- as.Date(s_p_daily$date)

s_p_daily <- s_p_daily %>%
  select(
    date,
    close = GSPC.Close
  ) %>%
  filter(date > as.Date(Sys.Date() - 31))

saveRDS(
  s_p_daily,
  "shiny_app/data/s_p_daily.RDS"
)


##Fetching S&P total return values
s_p_daily_tr <- import('data_prep/provided/^SP500TR (2).csv')

s_p_daily_tr <- as_tibble(s_p_daily_tr)

s_p_daily_tr$Date <- as.Date(s_p_daily_tr$Date)
  
saveRDS(
  s_p_daily_tr,
  "shiny_app/data/s_p_daily_tr.RDS"
)

##Converting for use in log TR
start_s_p_tr_price <- s_p_daily_tr[1, ]$Close

s_p_daily_tr_log <- s_p_daily_tr %>%
  mutate(log_returns = log( s_p_daily_tr$Close /  start_s_p_tr_price))

saveRDS(
  s_p_daily_tr_log,
  "shiny_app/data/s_p_daily_tr_log.RDS"
)




