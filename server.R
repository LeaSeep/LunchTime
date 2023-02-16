# server ----
source("utils.R")
TodaysLunchTime <<- "No Lunch"
lastDayRequest <<- "none"
SkipThisWeek <<- TRUE

server <- function(input, output, session) {
  
  # current time
  output$output <- renderText({
    invalidateLater(1000, session)
    paste("current time: ", format(Sys.time(), "%H:%M:%S"))
  })
   
  # Update Lunch Time only once a day
  ToDay <- weekdays(Sys.Date())

  #
  output$TodaysLunchTime <- renderText({
    getLunchTime(ToDay)
  })
}


