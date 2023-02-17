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
    file <- readLines("www/LunchTimeOverview.csv")
    length <- length(file)
    last_line <- file[length]
    last_line_parts <-strsplit(last_line,",")[[1]]
    if(last_line_parts[4]=="NA"){
      # check if reasonable time to record Lunch Time proposed LT >11:30
      browser()
      if(as.POSIXct(last_line_parts[3],format="%H:%M")>as.POSIXct("11:30:00", format = "%H:%M:%S")){
        actionButton("ActualLunch", "Click to record actual Lunch Time",icon = icon("check"))
      }else{
        actionButton("MisuseDetected", "Click to record actual Lunch Time",icon = icon("check"))
      }
    }else{
     strong("actual Lunch Time has been recorded!",style="color:white")
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
    output$ActualLunch_UI <- renderUI({NULL})
  })
  
  observeEvent(input$MisuseDetected,{
    session$sendCustomMessage(type = 'testmessage',
                              message = 'Thank you for clicking')
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


