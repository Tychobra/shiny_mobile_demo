library(quantmod)
library(tibble)

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
s_p_daily_tr <- quantmod::getSymbols(
  "^SP500TR", src = "yahoo",
  auto.assign = FALSE
)

s_p_daily_tr <- as.data.frame(s_p_daily_tr)

s_p_daily_tr$date <- rownames(s_p_daily_tr)

s_p_daily_tr$date <- as.Date(s_p_daily_tr$date)

s_p_daily_tr <- s_p_daily_tr %>%
  select(
    date,
    close = SP500TR.Close
  ) 

  # filter(date > as.Date(Sys.Date() - (20*365)) )

saveRDS(
  s_p_daily_tr,
  "shiny_app/data/s_p_daily_tr.RDS"
)
