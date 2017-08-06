library(jsonlite)
source('steemwhales_network_functions.R')
whales <- read.csv('whales.csv', stringsAsFactors = F)
whales <- whales$Name

my_table <- data.frame()
for(i in whales){
  print(i)
  t <- get_network(i)  
  my_table  <- rbind(my_table, t)
}