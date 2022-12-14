library(shiny)

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
    mainPanel()
  )
)

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)
