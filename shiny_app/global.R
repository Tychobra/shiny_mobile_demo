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

sp_time_series <- xts::xts(x = metrics$s_p_price / 40000, order.by = metrics$date)

slider_df <- tibble(
  pct_label = c(
    "All Shiller","10%",
    "20%", "30%", "40%",
    "50%","60%","70%",
    "80%","90%","All P/E"
  ),
  value = seq(0,1,by = .1)
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


        

  



