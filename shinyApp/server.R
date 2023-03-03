# server ----
source("utils.R")
TodaysLunchTime <<- "No Lunch"
actualLunch_recorder <<- TRUE
SkipThisWeek <<- TRUE
current_time <<- format(Sys.time(),"%H:%M")

server <- function(input, output, session) {
  
  # current time

  time_zone_offset <- reactive(as.numeric(input$client_time_zone_offset) * 60 ) # in s 
  
  output$output <- renderText({
    invalidateLater(1000*30, session)
    current_time <<- format(Sys.time() - time_zone_offset(),"%H:%M")
    print(paste0("The current time is: ",current_time))
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
      print("Refresh")
      print(input$MisuseDetected) # Does this trigger refresh?
      print(input$ActualLunch)
      file <- readLines("www/LunchTimeOverview.csv")
      length <- length(file)
      last_line <- file[length]
      last_line_parts <- strsplit(last_line,",")[[1]]
      if(last_line_parts[4] == "NA"){
        # check if reasonable time to record Lunch Time proposed LT >= now()
        if(as.POSIXct(current_time, format = "%H:%M")>=as.POSIXct(last_line_parts[3], format = "%H:%M")){
          actionButton("ActualLunch", "Click to record actual Lunch Time",icon = icon("check"))
        }else{
          actionButton("MisuseDetected", "Click to record actual Lunch Time",icon = icon("check"))
        }
      }else{
        strong("Actual Lunch Time has been recorded!",style = "color:white; font-size: 200%")
      }
    })


  
  observeEvent(input$ActualLunch,{
    file <- readLines("www/LunchTimeOverview.csv")
    length <- length(file)
    last_line <- file[length] 
    last_line <- gsub("NA$",format(current_time),last_line)
    file[length] <- last_line
    write(
      file,
      file = "www/LunchTimeOverview.csv",
      sep = ","
    )

  })
  
  observeEvent(input$MisuseDetected,{
    print("MISUSE")
    shinyalert(title = "I SAID DO NOT MISUSE!", 
               type = "error",
               confirmButtonText = "I'm sorry and I promise to not do it again",
               imageUrl = "HasenDead.png")

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


