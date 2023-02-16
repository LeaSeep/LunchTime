# User Interface ----

## Set Up ----
library(shiny)

ui <- fluidPage(
  textOutput("output"),
  textOutput("TodaysLunchTime")
)
