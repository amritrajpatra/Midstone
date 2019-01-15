setwd("~/Box Sync/NSS/RStudio/Immigration/Amrit_Project")

library(tidyverse)
library(ggplot2)
library(magrittr)
library(readxl)
library(dplyr)
library(RCurl)
library(XML)
library(plotly)


# Import DHS data 
df_2017  <-  read_excel("./data/2017.xlsx", na = c("D","-"), skip = 3)
df_2016  <-  read_excel("./data/2016.xlsx", na = c("D","-"), skip = 3)

# Clean the data
df_2017  <-  df_2017[-c(1:11), -2] 
df_2017  <-  df_2017[ , !(names(df_2017) %in% c("U.S. Armed Services Posts", "U.S. Territories1","Guam", "Unknown"))]
df_2017  <-  head(df_2017,-5)
colnames(df_2017)[1]  <-  'country'
stk_2017  <- stack(df_2017, select= -country)
names(stk_2017) <- c("migrant", "State_name")
stk_2017$from  <-  rep(df_2017$country,(ncol(df_2017)-1))
stk_2017$year <-  rep(2017,(ncol(df_2017)-1))

df_2016  <-  df_2016[-c(1:11), -2] 
df_2016  <-  df_2016[ , !(names(df_2016) %in% c("U.S. Armed Services Posts", "U.S. Territories1","Guam", "Unknown"))]
df_2016  <-  head(df_2016,-5)
colnames(df_2016)[1]  <-  'country'
stk_2016  <- stack(df_2016, select= -country)
names(stk_2016) <- c("migrant", "State_name")
stk_2016$from  <-  rep(df_2016$country,(ncol(df_2016)-1))
stk_2016$year <-  rep(2016,(ncol(df_2016)-1))

# Compare the columns
names(stk_2017) == names(stk_2016)
# Combine the dataset
stk_17_16 <- rbind(stk_2017, stk_2016)

# Inclusion of US state coordinates 
us_states <- read.csv("./data/50_us_states_all_data.csv")
migr <- left_join(x=stk_17_16, y=us_states, by = 'State_name')
migr1 <- migr %>% drop_na() %>% group_by(year, State) %>% summarize(total = sum(migrant))


# Convert to RDS file
saveRDS(migr1, file = "migr1_test.RDS")

# Plotting

l <- list(color = toRGB("white"), width = 2)
g <- list(
  scope = 'usa',
  projection = list(type = 'albers usa'),
  showlakes = FALSE,
  lakecolor = toRGB('white')
)

plot_geo(migr1, locationmode = 'USA-states') %>%
  add_trace(
    z = ~total, locations = ~State,
    colors = 'Blues'
  ) %>%
  colorbar(title = "Migration") %>%
  layout(
    #title = 'Percentage Heart Disease Prevalence',
    #titlefont = list(size = 24),
    #margin = list(t = 50), 
    geo = g)


########################



# Batch process code


file_path <- "./data/"
length(list.files(file_path))  # How many files are there?
list.files(file_path)  # Show the files

#path = paste(file_path, 2017,".xlsx",sep="")

batch_process = function(year){
  setwd("~/Box Sync/NSS/RStudio/Immigration/Amrit_Project/")
  file_path <- "./data/"
  path  <-  paste(file_path, as.character(year),".xlsx",sep="")
  df_year <- read_excel(path, na = c("D","-"), skip = 3)
  df_year  <-  df_year[-c(1:11), -2]
  df_year  <-  df_year[ , !(names(df_year) %in% c("U.S. Armed Services Posts", "U.S. Territories1","Guam", "Unknown"))]
  df_year  <-  head(df_year,-5)
  colnames(df_year)[1]  <-  'country'
  stk_year  <- stack(df_year, select= -country)
  names(stk_year) <- c("migrant", "State_name")
  stk_year$from  <-  rep(df_year$country,(ncol(df_year)-1))
  stk_year$year <-  rep(year,(ncol(df_year)-1))
  stk_year
  }
for(i in c(2002:2017)){ 
  if (i == 2002){
  data <- batch_process(i)    
  }
  else{
    data <- rbind(data, batch_process(i))
  }
print(i)
  }

class(data$migrant)

# Inclusion of US state coordinates 
us_states <- read.csv("./data/50_us_states_all_data.csv")
migr <- left_join(x=data, y=us_states, by = 'State_name')
migr1 <- migr %>% drop_na() %>% group_by(year, State) %>% summarize(total = sum(migrant))
# Convert to RDS file
saveRDS(migr1, file = "migr1_test.RDS")

  
# batch_process <- function(path, extension) {
#   file_names <- list.files(path, pattern = extension)
#   data_list <- lapply(paste0(path, file_names), read.csv)
#   data_frame <- bind_rows(data_list)
#   data_frame
#   }


######

# Import DHS data 
df_20031  <-  read_excel("./data/20031.xlsx", na = c("D","-"), skip = 3)
df_2003  <-  read_excel("./data/2003.xlsx", na = c("D","-"), skip = 3)
sapply(df_2003, class)
df_2003 <- as.numeric(df_2003, c("D","-"))

sapply(df_20031, class)
df_2003  <-  read_excel("./data/2003.xlsx", na = c("D","-"), skip = 3)
sapply(df_2003, class)

df_20032  <-  read_excel("./data/20032.xlsx", na = c("D","-"), skip = 3)
sapply(df_20032, class)

# Inclusion of US state coordinates 
us_states <- read.csv("./data/50_us_states_all_data.csv")
migr <- left_join(x=data, y=us_states, by = 'State_name')
migr1 <- migr %>% drop_na() %>% group_by(year, State) %>% summarize(total = sum(migrant))

# Convert to RDS file
saveRDS(migr1, file = "migr1_test.RDS")
