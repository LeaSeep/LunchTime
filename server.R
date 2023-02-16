# server ----

server <- function(input, output, session) {
  
  # current time
  output$output <- renderText({
    invalidateLater(1000, session)
    paste("The current time is", format(Sys.time(), "%H:%M:%S"))
  })
  
  #
  output$TodaysLunchTime <- renderText({
    #
  })
}
