library(shiny)

ui <- fluidPage(

  # App title ----
  titlePanel("Hello Shiny!"),

  # Sidebar layout with input and output definitions ----
  sidebarLayout(

    # Sidebar panel for inputs ----
    sidebarPanel(

      # Input: Slider for the number of bins ----
      sliderInput(
        inputId = "binsTestando2",
        label = "Number of bins:",
        min = 5,
        max = 50,
        value = 30
      )
    ),

    # Main panel for displaying outputs ----
    mainPanel(

      # Output: Histogram ----
      plotOutput(outputId = "distPlotTestando")
    )
  )
)

# Define server logic required to draw a histogram ----
server <- function(input, output) {

  # Histogram of the Old Faithful Geyser Data ----
  # with requested number of bins
  # This expression that generates a histogram is wrapped in a call
  # to renderPlot to indicate that:
  #
  # 1. It is "reactive" and therefore should be automatically
  #    re-executed when inputs (input$bins) change
  # 2. Its output type is a plot
  output$distPlotTestando <- renderPlot({
    x <- faithful$waiting
    bins <- seq(min(x), max(x), length.out = input$binsTestando2 + 1)
    print("felipe")
    print(input$binsTestando2)

    hist(x,
      breaks = bins, col = "#75AADB", border = "white",
      xlab = "Waiting time to next eruption (in mins)",
      main = "Histogram of waiting times"
    )
  })
}

# ui and server can be defined in ui.R and server.R
# files separately

shinyApp(ui = ui, server = server)
