# server ----
source("utils.R")
TodaysLunchTime <<- "No Lunch"
actualLunch_recorder <<- TRUE
SkipThisWeek <<- TRUE

server <- function(input, output, session) {
  
  # current time
  output$output <- renderText({
    invalidateLater(1000, session)
    paste("current time: ", format(Sys.time(), "%H:%M:%S"))
  })
   
  # Update Lunch Time only once a day
  ToDay <- weekdays(Sys.Date())
  file <- readLines("www/LunchTimeOverview.csv")
  length <- length(file)
  lastDayRequest <<-  strsplit(file[length],",")[[1]][2]
  TodaysLunchTime <<- paste0("Today's Lunch Time is: ",strsplit(file[length],",")[[1]][3])
  #
  output$TodaysLunchTime <- renderText({
    getLunchTime(ToDay)
  })
  
  output$ActualLunch_UI <- renderUI({
    if(actualLunch_recorder){
      actionButton("ActualLunch", "Click to record actual Lunch Time",icon = icon("check"))
    }else{
      NULL
    }
  })
  
  observeEvent(input$ActualLunch,{
    file <- readLines("www/LunchTimeOverview.csv")
    length <- length(file)
    last_line <- file[length] 
    last_line <- gsub("NA$",format(Sys.time(), format = "%H:%M"),last_line)
    file[length] <- last_line
    write(
      file,
      file = "www/LunchTimeOverview.csv",
      sep = ","
    )
    actualLunch_recorder <<- F
    output$ActualLunch_UI <- renderUI({NULL})
    
  })
  
  output$downloadData <- downloadHandler(
    filename = function() {
      paste0("LunchTime_Stats_",format(Sys.Date(),format = "%y_%m_%d"),".csv")
    },
    content = function(file) {
      write.csv(read.csv("www/LunchTimeOverview.csv"), file, row.names = FALSE)
    }
  )
  
}


