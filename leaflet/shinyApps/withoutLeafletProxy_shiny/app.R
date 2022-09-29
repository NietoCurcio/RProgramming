ui <- fluidPage(
  tags$style(type = "text/css", "html, body {width: 100%; height: 100%}"),
  leafletOutput(outputId = "map", width = "1000px", height = "1000px"),
  absolutePanel(
    top = 20,
    right = 50,
    sliderInput(
      "range",
      "Select the magnitude range",
      min = min(quakes$mag),
      max = max(quakes$mag),
      value = c(min(quakes$mag), max(quakes$mag))
    )
  )
)

server <- function(input, output, session) {
  filtered <- reactive({
    quakes[quakes$mag >= input$range[1] & quakes$mag <= input$range[2], ]
  })

  # observe({
  #   print(head(quakes[quakes$mag >= input$range[1] & quakes$mag <= input$range[2], ]))
  # })

  output$map <- renderLeaflet({
    leaflet(data = filtered()) %>%
      addTiles() %>%
      addMarkers()
  })
}

shinyApp(ui, server)