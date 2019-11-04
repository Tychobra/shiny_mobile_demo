library(dplyr)
library(highcharter)
library(DT)
library(shinydashboard)
library(tychobratools) # remotes::install_github("tychobra/tychobratools")

tychobratools::hc_global_options()

dat <- read.csv(
  "data/financial_data.csv",
  stringsAsFactors = FALSE
)

dat <- dat %>%
  mutate(date = as.Date(date, format = "%m/%d/%y"))

egr_data <- read.csv(
  "data/egr_data.csv",
  stringsAsFactors = FALSE
)

geo_mean = function(x, na_rm = TRUE){
  exp(sum(log(x[x > 0]), na.rm = na_rm) / length(x))
}

avg_shiller_since_1992 <- mean(dat$shiller)
avg_pe_since_1992 <- mean(dat$pe)

egr_geo_mean <- egr_data %>%
  mutate(growth_rate = 1 + earning_growth) %>%
  pull("growth_rate") %>%
  geo_mean()

t_ten_geo_mean <- dat %>%
  mutate(yield_plus_one = 1 + t_bill_10) %>%
  pull("yield_plus_one") %>%
  geo_mean()






