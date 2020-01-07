library(dplyr)
library(highcharter)
library(DT)
library(shinydashboard)
library(tychobratools) # remotes::install_github("tychobra/tychobratools")
library(shinyWidgets)
library(lubridate)
library(RSQLite)
library(DBI)
library(shinyMobile)

tychobratools::hc_global_options()

metrics <- readRDS('data/metrics.RDS')
s_p_daily <- readRDS('data/s_p_daily.RDS')
t_bill_geo_means <- readRDS('data/t_bill_geo_means.RDS')
s_p_daily_tr <- readRDS('data/s_p_daily_tr.RDS')
s_p_daily_tr_log <- readRDS('data/s_p_daily_tr_log.RDS')

avg_shiller_100 <- mean(metrics$shiller)
avg_pe_100 <- mean(metrics$pe)

s_p_log_time_series_tr <- xts::xts( x = s_p_daily_tr_log$log_returns, order.by = s_p_daily_tr_log$Date)

##creates df used in pe weight slider
# slider_df <- tibble(
#   pct_label = c(
#     "All Shiller","10%",
#     "20%", "30%", "40%",
#     "50%","60%","70%",
#     "80%","90%","All P/E"
#   ),
#   value = seq(0,1,by = .1)
# )

## grab current discount rates
current_treasury_rates <- metrics %>%
  filter(date == max(date)) %>%
  select(t_bill_3m:t_bill_30) %>%
  unlist(use.names = FALSE)

##pulling the most recent s&p close for adjustment to pe ratios
s_p_latest <- s_p_daily %>%
  filter(date == max(date)) %>%
  pull("close")

##pulling the most recent s&p close for adjustment to pe ratios
s_p_first_day_of_month <- s_p_daily %>%
  mutate(
    day = lubridate::day(date),
    month = lubridate::month(date)
  ) %>%
  filter(
    month == max(month), 
    day == min(day)
  ) %>%
  pull('close')
  