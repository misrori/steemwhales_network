
get_network <- function(name){
  
  a <- fromJSON(paste('https://webapi.steemdata.com/Accounts?where=name==',name,sep = ""))
  
  if (isTRUE(a$`_items`$following_count!=0)==FALSE){
    return(NULL)
  }else if(a$`_items`$following_count==0){
    print('nem követek senkit')
    return(NULL)
  }else{
    my_df <- data.frame(target = unlist(a$`_items`$following))
    my_df$source <- name 
    my_df <- my_df[,c(2,1)]
    return(my_df)
  }
   
}


# 
# length(a$`_items`)
# 
 name <- 'steemit'
