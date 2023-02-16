# Draw Lunch Time

# 1. draw a minute between 1:30 (sample)
# 2. put in the new lunch time 11:30 + 1.
# 3. check if it is tuesday (every two weeks)

getLunchTime <- function(){
  if(weekdays(Sys.Date())=="Tuesday" & SkipThisWeek){
    result <- "It is Group Meeting! Lunch time heavily depends on length of such, 
               which is by no means predictable..."
    SkipThisWeek <<- F
  }else{
    drawnMinutes <- sample(1:30,1)
    startTime <- as.POSIXct("12:30:00", format = "%H:%M:%S")
    new_time <- as.POSIXct(startTime + (60 * drawnMinutes))
    LunchTime <- format(new_time, format = "%H:%M")
    result <- paste0("Today's Lunch Time is: ",LunchTime)
  }
  return(result)
}
