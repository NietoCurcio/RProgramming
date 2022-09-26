library(shiny)
library(stringr)

# Reactive
# 1. add a object into the UI
# 2. setup server function, how build the object

ui <- fluidPage(
  titlePanel(h1("censusVis")),
  sidebarLayout(
    sidebarPanel(
      helpText(
        "Create demographic maps with", 
        "information from the 2010 US Census."
      ),
      selectInput(
        inputId = "select_var",
        label = h3("Choose a variable to display"),
        choices = list(
          "Percent White" = 1,
          "Percent Black" = 2,
          "Percent Hispanic" = 3,
          "Percent Asian" = 4
        ),
        selected = 1
      ),
      sliderInput(
        inputId = "slider_interest",
        label = h3("Range of interest:"),
        min = 0,
        max = 100,
        value = c(0, 100)
      ),
      style = "width: 25vw;"
    ),
    mainPanel(
      textOutput(outputId = "select_var"),
      textOutput(outputId = "slider_interest"),
      htmlOutput(outputId = "slider_interest_verb")
    )
  )
)

server <- function(input, output) {
  output$select_var <- renderText({
    paste("You have selected", input$select_var)
  })

  output$slider_interest <- renderText({
    paste("You have chosen a range that goes from", input$slider_interest[1], "to", input$slider_interest[2])
  })

  output$slider_interest_verb  <- renderUI({
    tagList(
      HTML(
        str_interp(
          "
          <h1>Hello ${input$slider_interest[1]} - ${input$slider_interest[2]}, how are you? ${input$slider_interest}</h1>
          "
        )
      )
    )
  })
}

shinyApp(ui = ui, server = server)
