library(dplyr)
library(highcharter)
library(DT)
library(shinydashboard)
library(tychobratools) # remotes::install_github("tychobra/tychobratools")

tychobratools::hc_global_options()

t_bill_yield <- read.csv(
  "data/t_bill_yield.csv",
  stringsAsFactors = FALSE
)

pe_data <- read.csv(
  "data/pe_data.csv",
  stringsAsFactors = FALSE
)

egr_data <- read.csv(
  "data/egr_data.csv",
  stringsAsFactors = FALSE
)

geo_mean = function(x, na_rm = TRUE){
  exp(sum(log(x[x > 0]), na.rm = na_rm) / length(x))
}

avg_shiller_since_1992 <- mean(pe_data$Shiller)
avg_pe_since_1992 <- mean(pe_data$pe)

egr_geo_mean <- egr_data %>%
  mutate(growth_rate = 1 + earning_growth) %>%
  pull("growth_rate") %>%
  geo_mean()




