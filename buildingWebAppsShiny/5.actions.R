library(shiny)
library(ggplot2)
library(tidyverse)
library(plotly)

load(file.path(getwd(), "buildingWebAppsShiny", "movies.RData"))

ui <- fluidPage(
  selectInput("select", "Select Greeting", choices = c("Hello", "Bonjour")),
  textInput("name", "Enter name"),
  textOutput("greeting"),
  actionButton("show_greeting_modal", "Show greeting modal"),
  h3("Exemplo 2"),
  sidebarLayout(
    sidebarPanel(
      textInput("velocity", "Velocidade: "),
      textInput("distance", "Distancia: "),
      actionButton("show_time", "Calcular tempo"),
    ),
    mainPanel(
      textOutput("time")
    )
  ),
  h3("Exemplo 3"),
  textOutput("text_output1"),
  textOutput("text_output2")
)

server <- function(input, output, session) {

  # An `input$inputId` inside the isolate function does not
  # re-executes the data to be rendered, it makes the value
  # in `input$inputId` read-only.

  # 1. stop with isolate

  output$greeting <- renderText({
    paste0(isolate(input$select), ", ", input$name)
  })

  greeting_modal_text <- eventReactive(input$show_greeting_modal, {
    paste(input$select, input$name, "in a dialog")
  })

  # 2. trigger observeEvent

  observeEvent(input$show_greeting_modal, {
    showModal(modalDialog(greeting_modal_text()))
  })

  # Exemplo 2
  # 3. delay with eventReactive

  time <- eventReactive(input$show_time, {
    as.double(input$distance) / as.double(input$velocity)
  })

  output$time <- renderText({
    text <- str_glue("The time is {time()}")
    paste(text)
  })

  # Exemplo 3

  text_output <- reactive({
    print("I was called only once!")
    paste("Some text output")
  })

  output$text_output1 <- renderText({
    paste(text_output())
  })

  output$text_output2 <- renderText({
    paste(text_output())
  })
}

shinyApp(ui = ui, server = server)
