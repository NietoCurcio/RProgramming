library(shiny)

ui <- fluidPage(
  titlePanel("Widgets"),
  fluidRow(
    column(
      3,
      h3("Buttons"),
      actionButton(inputId = "action", label = "Action"),
      br(),
      submitButton(text = "Sbmit")
    ),
    column(
      3,
      h3("Single checkbox"),
      checkboxInput(inputId = "checkbox", label = "Choice 1", value = TRUE)
    ),
    column(
      3,
      checkboxGroupInput(
        inputId = "checkGroup",
        label = h3("Checkbox group"),
        choices = list("Choice 1" = 1, "Choice 2" = 2, "Choise 3" = 3),
        selected = 1
      )
    ),
    column(
      3,
      dateInput(
        inputId = "date",
        label = h3("Date Input"),
        value = "2022-09-25"
      )
    )
  ),
  fluidRow(
    column(
      3,
      dateRangeInput(inputId = "dates", label = h3("Date range"))
    ),
    column(
      3,
      fileInput(inputId = "file", label = h3("File input"))      
    ),
    column(
      3,
      h3("Help text"),
      helpText(
        "help text isn't a true widget,", 
        "but it provides an easy way to add text to",
        "accompany other widgets."
      )
    ),
    column(
      3,
      numericInput(inputId = "num", label = h3("Numeric Input"), value = 1)
    ),
    fluidRow(
      column(
        3,
        radioButtons(
          inputId = "radio",
          label = h3("Radio buttons"),
          choices = list("Choice 1" = 1, "Choice 2" = 2, Choice3 = 3, "Choice 4" = 4),
          selected = 2
        )
      ),
      column(
        3,
        selectInput(inputId = "select", label = h3("Select box"), choices = list("Choice 1" = 1, "Choice 2" = 2), selected = 2)
      ),
      column(
        3,
        sliderInput(inputId = "slider1", label = h3("Slider 1"), min = 0, max = 100, value = 50),
        sliderInput(inputId = "slider2", label = h3("Slider 2"), min = 0, max = 100, value = c(25, 75)),
      ),
      column(
        3,
        textInput(inputId = "text", label = h3("Text input"), value = "Text", placeholder = "Placeholder text")
      )
    )
  )
)

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)
