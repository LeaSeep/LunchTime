# User Interface ----

## Set Up ----
library(shiny)
library(shinyWidgets)


ui <- fluidPage(
  tags$style(
    HTML('
      /* Keyframes for pulsating animation */
      @keyframes pulsate {
        0% { transform: scale(1); }
        50% { transform: scale(1.2); }
        100% { transform: scale(1); }
      }

      /* Styles for the text */
      .lunchtime-text {
        font-family: "Cinzel", serif;
        font-weight: normal;
        font-size: 800%;
        text-shadow: 10px 10px 10px #9bb3a3;
        color: #050000;
      }
      /* Styles for the pulsating animation */
      .pulsate {
        animation-name: pulsate;
        animation-duration: 2s;
        animation-timing-function: ease-in-out;
        animation-iteration-count: infinite;
      }
    ')
  ),

  setBackgroundImage(
    src = "HasenAUA.png"
  ),
  
  h3(textOutput("output"), style ="color: #050000"),

  mainPanel(
    br(),
    br(),
    h1(strong(textOutput("TodaysLunchTime")),
       class = "pulsate",
       style = "font-family:'Cinzel', serif;font-weight: normal; font-size: 800%; text-shadow: 10px 10px 10px #9bb3a3; color: #050000;",
       align ="center")
  )
)
