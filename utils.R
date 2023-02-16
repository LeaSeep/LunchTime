# Draw Lunch Time

getLunchTime <- function(dayRequest){
  if(lastDayRequest != dayRequest){
    if(dayRequest == "Tuesday" & !SkipThisWeek){
      TodaysLunchTime <<- "It is Group Meeting! Lunch time heavily depends on length of such, 
                 which is by no means predictable..."
      SkipThisWeek <<- T
    }else if(dayRequest %in% c("Saturday","Sunday")){
      TodaysLunchTime <<- "It is the Weekend. You have to care for your lunch yourself"
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
    
    lastDayRequest <<- dayRequest
  }
  return(TodaysLunchTime)
}
