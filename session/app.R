library(shiny)
library(stringr)

outerUI <- function(id) {
  ns <- NS(id)

  tagList(
    textInput(inputId = ns("text"), label = "text label", value = 5),
    textInput(inputId = ns("text2"), label = "text label", value = 6)
  )
}

# https://stackoverflow.com/questions/51708815/accessing-parent-namespace-inside-a-shiny-module
# https://stackoverflow.com/questions/67978609/passing-additional-parameters-to-moduleserver-in-r-shiny-app-accessing-parent-e
# https://stackoverflow.com/questions/54750932/updatetabsetpanel-with-shiny-module
innerServer <- function(id, parent) {
  moduleServer(id, function(input, output, session) {
    observe({
      print(paste("inneServer", "parent$input$text:", parent$input$text))

      updateTextInput(
        session = parent,
        inputId = "text",
        value = 10
      )
    })
  })
}

innerServer1 <- function(id, input_parent, parent) {
  moduleServer(id, function(input, output, session) {
    observe({
      print(paste("inneServer1", "input$text2:", input$text2))
      print(paste("inneServer1", "input_parent$text2:", input_parent$text2))
      print(paste("inneServer1", "parent$input$text2:", parent$input$text2))
      print(paste("inneServer1", "session$input$text2:", session$input$text2))

      updateTextInput(
        session = session,
        inputId = "text2",
        value = 20
      )
    })
  }, session = parent)
  # I don't understand the session argument, I thought it should modify "session" to parent
}

outerServer <- function(id) {
  moduleServer(id, function(input, output, session) {
    innerServer("md", session)
    innerServer1("md", input, session)
  })
}

ui <- fluidPage(
  outerUI("md")
)

server <- function(input, output, session) {
  outerServer("md")
}

shinyApp(ui, server, options = options(shiny.reactlog = TRUE))
