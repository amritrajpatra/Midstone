library(shinydashboard)
library(tidyverse)
library(ggplot2)
library(plotly)
  

#saveRDS(all_overdoses, file = "all_overdoses.RDS")

migr1_test_RDS <- readRDS(file = "migr1_test.RDS")
years <- as.data.frame(migr1_test_RDS) %>% 
  select(year) %>% 
  unique()

years <- sort(years$year, decreasing = TRUE)


# #saveRDS(opioids_prescribed_by_state, file = "opioids_prescribed_by_state.RDS")
# 
# opioids_prescribed_by_state_RDS <- readRDS(file = "opioids_prescribed_by_state.RDS")
# states <- as.data.frame(opioids_prescribed_by_state_RDS) %>% 
#   select(State) %>% 
#   unique()
# 
# state <- sort(states$State)

