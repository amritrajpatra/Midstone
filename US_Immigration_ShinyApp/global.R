setwd("~/Box Sync/NSS/RStudio/Immigration/Amrit_Project/US_Immigration_ShinyApp/")

library(shiny)
library(shinydashboard)
library(shinythemes)
library(tidyverse)
library(magrittr)
library(ggplot2)
library(plotly)
library(streamgraph)
library(lazyeval)

library(packcircles)
library(ggiraph)
library(bubbles)
library(scales)
# library(maps)
# library(maptools)
# library(tmap)
# library(raster)
# library(tmaptools)
# library(leaflet)
# library(sf)


# Data for "Tab 1" 

immi <- readRDS(file = "immi.RDS")


# Data for "Tab 2" 

state_migr_rds <- readRDS(file = "state_migr.RDS")
years <- as.data.frame(state_migr_rds) %>% 
  dplyr::select(year) %>% 
  unique()

years <- sort(years$year, decreasing = TRUE)

# Select a State
states <- as.data.frame(state_migr_rds) %>% 
  dplyr::select(State_name) %>% 
  unique()

states <- sort(states$State_name)
#states <- append(states, "All")

# Select a country
from <- as.data.frame(state_migr_rds) %>%
  dplyr::select(country) %>%
  unique()

from <- sort(from$country)

# Data for "Illegal Immigrant Tab" 

m_illegals <- readRDS(file = "m_illegals.RDS")
mrg_states_illegal <- readRDS(file = "mrg_states_illegal.RDS")


#####


