# Draw Lunch Time

getLunchTime <- function(dayRequest){
  if(lastDayRequest != dayRequest){
    if(dayRequest == "Tuesday" & !SkipThisWeek){
      TodaysLunchTime <<- "It is Group Meeting! Lunch time heavily depends on length of such, 
                 which is by no means predictable..."
      LunchTime <- "GroupMeeting"
      SkipThisWeek <<- T
    }else if(dayRequest %in% c("Saturday","Sunday")){
      TodaysLunchTime <<- "It is the Weekend. You have to care for your lunch yourself"
      LunchTime <- "Weekend"
    }else{
      drawnMinutes <- sample(1:30,1)
      startTime <- as.POSIXct("11:30:00", format = "%H:%M:%S")
      new_time <- as.POSIXct(startTime + (60 * drawnMinutes))
      LunchTime <- format(new_time, format = "%H:%M")
      TodaysLunchTime <<- paste0("Today's Lunch Time is: ",LunchTime)
      if(dayRequest == "Tuesday"){
        SkipThisWeek <<- F
      }
    }
    
    # Save stats to table
    stats = paste0(c(as.character(Sys.Date()),dayRequest,LunchTime,NA),collapse = ",")
    write(
      stats,
      file = "www/LunchTimeOverview.csv",
      sep = ",",
      append = T
    )
    
    lastDayRequest <<- dayRequest
  }
  

  
  return(TodaysLunchTime)
}
