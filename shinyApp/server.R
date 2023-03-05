# server ----
source("utils.R")
TodaysLunchTime <<- "No Lunch"
actualLunch_recorder <<- TRUE
SkipThisWeek <<- TRUE

current_time <<- format(Sys.time(),"%H:%M")
print("HELLO")
server <- function(input, output, session) {
  
  # current time

  time_zone_offset <- reactive(as.numeric(input$client_time_zone_offset)) 
  
  output$output <- renderText({
    invalidateLater(1000*30, session)
    current_time <<- format(Sys.time() - time_zone_offset(),"%H:%M")
    print(paste0("The current time is: ",current_time))
  })
  
  
  # Define a function to update the time value
  update_time <- function() {
    # Generate a random time string in the format "hh:mm"
    time <- draw_time()
    # Update the output with the new time value
    return(time)
  }

   
  # Update Lunch Time only once a day
  ToDay <- "Monday"# weekdays(Sys.Date())
  file <- readLines("www/LunchTimeOverview.csv")
  length <- length(file)
  lastDayRequest <<-  strsplit(file[length],",")[[1]][2]
  TodaysLunchTime <<- paste0("Today's Lunch Time is: ",strsplit(file[length],",")[[1]][3])
  TodaysLunchTime <<- getLunchTime(ToDay,T)
  # Insert a button if option to draw
  FIRST <- reactiveVal(value =F)
  if(lastDayRequest == ToDay){
    FIRST(FALSE)
    output$TodaysLunchTime <- renderText({
      TodaysLunchTime
    })
  }else{
    FIRST(TRUE)
    observeEvent(FIRST,{
      showModal(modalDialog(
        # Add a message to the modal with a line break
        HTML("Congrats, you are the first!<br>Let's draw Lunch"),
        tags$img(src = "https://cdn-icons-png.flaticon.com/512/1761/1761437.png", width = 50, height = 50),
        # Add a button to the modal
        footer = actionButton("draw_lunch", "Draw")
      ))
    })
    countDownOver <- eventReactive(input$draw_lunch,{
      removeModal()
      withProgress(message = 'Lunch time migh be: ',value = 0,{
        for(i in 1:10){
          # Increment the progress bar, and update the detail text.
          incProgress(1/10, detail = update_time())
          Sys.sleep(0.2)
        }
      })
      return("Done")
    })
    
    output$TodaysLunchTime <- renderText({
      print(countDownOver())
      TodaysLunchTime
    })
    
  }
  

    output$ActualLunch_UI <- renderUI({
      print("Refresh")
      print(input$MisuseDetected) # Does this trigger refresh?
      print(input$ActualLunch)
      file <- readLines("www/LunchTimeOverview.csv")
      length <- length(file)
      last_line <- file[length]
      last_line_parts <- strsplit(last_line,",")[[1]]
      if(last_line_parts[4] == "NA" ){
        # check if Event was recorded (no button then)
        if(last_line_parts[3] == "Weekend"){
          strong("Nothing to record",style = "color:white; font-size: 100%")
          # check if reasonable time to record Lunch Time proposed LT >= now() 
        }else if(as.POSIXct(current_time, format = "%H:%M")>=as.POSIXct(last_line_parts[3], format = "%H:%M")){
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


