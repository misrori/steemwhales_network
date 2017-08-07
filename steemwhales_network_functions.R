library(jsonlite)
library(networkD3)
library(data.table)

#####################################################
###  my followers network  ######

get_network <- function(name){
  a <- fromJSON(paste('https://webapi.steemdata.com/Accounts?where=name==',name,sep = ""))
  
  my_names<- data.frame(id = seq(from= 1,to = (as.numeric(a$`_items`$following_count)), by = 1))
  my_names$Name <- as.character(unlist(a$`_items`$following))
  
  my_names <- rbind(data.frame(id=0, Name = name),my_names)
  my_names$group <-1
  my_names$size <-1
  
  my_links <- data.frame(source=0, target= 1:nrow(my_names)-1)
  my_links <- my_links[2:nrow(my_links),]
  my_links$value <- 1
  
  net<- forceNetwork(Links = my_links, Nodes = my_names,
                     Source = "source", Target = "target", zoom = T,
                     Value = "value", NodeID = "Name",Nodesize = 'size',fontSize = 15,
                     Group = "group", opacity = 1, arrows = F,  bounded = F)
  return(net)
}


get_source_target <- function(name){
  
  a <- fromJSON(paste('https://webapi.steemdata.com/Accounts?where=name==',name,sep = ""))
  
  if (isTRUE(a$`_items`$following_count!=0)==FALSE){
    return(NULL)
  }else if(a$`_items`$following_count==0){
    print('nem követek senkit')
    return(NULL)
  }else{
    my_following <- data.frame(target=unlist(a$`_items`$following))
    my_following$target <- as.character(my_following$target)
    my_following$source <- name
    my_following <- my_following[,c(2,1)]
    return(my_following)
  }
  
  
}



get_group_network <- function(my_names){
  
  
  my_df <- data.frame()
  for (i in my_names){
    my_df <- rbind(my_df, get_source_target(i))
  } 
  nevek_list <- data.frame(nevek = unique(c(unique(my_df$source), unique(my_df$target))))
  nevek_list$nevek <- as.character(nevek_list$nevek)
  nevek_list$id <- 0:(nrow(nevek_list)-1)
  
  nevek_list <- data.table(nevek_list)
  my_df <- data.table(my_df )
  setkey(nevek_list, nevek)
  setkey(my_df, source)
  
  my_df$source_id <- nevek_list[my_df][,id]
  
  setkey(my_df, target)
  
  my_df$target_id <- nevek_list[my_df][,id]
  my_df$value <- 1
  nevek_list$group <-1
  nevek_list$size <-1
  setorder(nevek_list,id)
  
  net <- forceNetwork(Links = my_df, Nodes = nevek_list,
                      Source = "source_id", Target = "target_id", zoom = T,
                      Value = "value", NodeID = "nevek",Nodesize = 'size',fontSize = 15,
                      Group = "group", opacity = 1, arrows = T,  bounded = F)
  return(net)
}


get_group_network_data <- function(my_names){
  
  
  my_df <- data.frame()
  for (i in my_names){
    my_df <- rbind(my_df, get_source_target(i))
  } 
  nevek_list <- data.frame(nevek = unique(c(unique(my_df$source), unique(my_df$target))))
  nevek_list$nevek <- as.character(nevek_list$nevek)
  nevek_list$id <- 0:(nrow(nevek_list)-1)
  
  nevek_list <- data.table(nevek_list)
  my_df <- data.table(my_df )
  setkey(nevek_list, nevek)
  setkey(my_df, source)
  
  my_df$source_id <- nevek_list[my_df][,id]
  
  setkey(my_df, target)
  
  my_df$target_id <- nevek_list[my_df][,id]
  my_df$value <- 1
  nevek_list$group <-1
  nevek_list$size <-1
  setorder(nevek_list,id)
  
  my_df_list <- list(node = nevek_list,edge=my_df)
  
  
  return(my_df_list)
}


get_group_network_from_data <- function(my_df_list){
  
  net <- forceNetwork(Links = my_df_list$edge, Nodes = my_df_list$node,
                      Source = "source_id", Target = "target_id", zoom = T,
                      Value = "value", NodeID = "nevek",Nodesize = 'size',fontSize = 15,
                      Group = "group", opacity = 1, arrows = T,  bounded = F)
  return(net)
}
