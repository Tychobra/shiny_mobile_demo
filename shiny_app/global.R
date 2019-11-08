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

# # convert the t bills columns into a long tidy data frame
# t_bill_geo_means <- metrics %>%
#   select(date, t_bill_3m:t_bill_30) %>%
#   tidyr::pivot_longer(t_bill_3m:t_bill_30, names_to = 'duration', values_to = 'value')
# 
# # convert to rates and calculate geometric means
# t_bill_geo_means <- t_bill_geo_means %>%
#   mutate(value = 1 + value / 100) %>%
#   group_by(duration) %>%
#   summarize(geo_mean = geo_mean(value)) %>%
#   ungroup()


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
  value_current_discount = current_treasury_rates,
  value_geo_discount = t_bill_geo_means$geo_mean
  
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

        

  



