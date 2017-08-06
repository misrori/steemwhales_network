library(rvest)
library(data.table)
my_url_list<- paste("https://steemwhales.com/?p=",c(1:4),"&s=total", sep = "")

adat <- data.table()
for(i in my_url_list) {
  print(i)
  adat_help <-read_html(i)%>%
    html_nodes("table") %>%
    html_table()
  t<- adat_help[[1]]
  adat <- rbind(adat,t)
} 

names(adat) <- c('Rank',	'Name',	'Rep',	'Post_Count',	'Followers',	'Following',	'Posting',	'Curation',
                 'Steem',	'Steem_Power',	'Steem_Dollars',	'Estimated_Value')


write.csv(adat, 'whales.csv', row.names = F)
