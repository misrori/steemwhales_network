library(jsonlite)
library(data.table)
library(networkD3)
source('steemwhales_network_functions.R')
whales <- data.table(read.csv('whales.csv', stringsAsFactors = F))
whales$Following <- as.numeric(gsub(',','',whales$Following))
whales <-whales[Following<100 & Following >3  ,]$Name



get_group_network(c('misrori', 'cuttie1979'))


adat <- get_group_network_data(whales)
  
get_group_network_from_data(adat)

my_table <- data.frame()
for(i in whales){
  print(i)
  t <- get_network(i)  
  my_table  <- rbind(my_table, t)
}