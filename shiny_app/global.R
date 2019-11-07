library(dplyr)
library(highcharter)
library(DT)
library(shinydashboard)
library(tychobratools) # remotes::install_github("tychobra/tychobratools")
library(shinyWidgets)
library(lubridate)

tychobratools::hc_global_options()

metrics <- readRDS('data/metrics.RDS')
s_p_daily <- readRDS('data/s_p_daily.RDS')

egr_data <- read.csv(
  "data/egr_data.csv",
  stringsAsFactors = FALSE
)

geo_mean = function(x, na_rm = TRUE){
  exp(sum(log(x[x > 0]), na.rm = na_rm) / length(x))
}

avg_shiller_100 <- mean(metrics$shiller)
avg_pe_100 <- mean(metrics$pe)

egr_geo_mean <- egr_data %>%
  mutate(growth_rate = 1 + earning_growth) %>%
  pull("growth_rate") %>%
  geo_mean()

t_ten_geo_mean <- metrics %>%
  mutate(yield_plus_one = 1 + t_bill_10/100) %>%
  pull("yield_plus_one") %>%
  geo_mean()

t_bill_geo_means <- metrics %>%
  select(t_bill_3m:t_bill_30)  %>%
  mutate(t_3_m_geo = 1 + t_bill_3m/100)  %>%
  mutate(t_6_m_geo = 1 + t_bill_6m/100) %>%
  mutate(t_1_y_geo = 1 + t_bill_1/100) %>%
  mutate(t_2_y_geo = 1 + t_bill_2/100) %>%
  mutate(t_3_y_geo = 1 + t_bill_3/100) %>%
  mutate(t_5_y_geo = 1 + t_bill_5/100) %>%
  mutate(t_7_y_geo = 1 + t_bill_7/100) %>%
  mutate(t_10_y_geo = 1 + t_bill_10/100) %>%
  mutate(t_20_y_geo = 1 + t_bill_20/100) %>%
  mutate(t_30_y_geo = 1 + t_bill_30/100) %>%
  select(t_3_m_geo:t_30_y_geo) %>%
  # pull("t_3_m_geo") %>%
  geo_mean()

  

sp_time_series <- xts::xts( x = metrics$s_p_price / 40000, order.by = metrics$date)
sp_log_time_series <- xts::xts( x = metrics$log_return / 30, order.by = metrics$date)

slider_df <- tibble(
  pct_label = c(
    "All Shiller","10%",
    "20%", "30%", "40%",
    "50%","60%","70%",
    "80%","90%","All P/E"
  ),
  value = seq(0,1,by = .1)
)

## grab current discount rates
current_treasury_rates <- metrics %>%
  filter(date == max(date)) %>%
  select(t_bill_3m:t_bill_30) %>%
  unlist(use.names = FALSE)
  
discount_slider_df <- tibble(
  discount_rate = c(
     "3 month", "6 month",
     "1 year", "2 year",
     "3 year", "5 year",
     "7 year","10 year", 
     "20 year", "30 year"
  ),
  value2 = current_treasury_rates
  # value2 = c(
  #   1.54,
  #   1.57,	1.53,	1.52,
  #   1.52,	1.51,	1.60,
  #   1.69,	2.00,	2.17)
)

s_p_latest <- s_p_daily %>%
  filter(date == max(date)) %>%
  pull("close")

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

        

  



