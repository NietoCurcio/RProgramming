ui <- fluidPage(
  leafletOutput("map", height = "400px")
)

server <- function(input, output) {
  output$map <- renderLeaflet({
    leaflet() %>%
    addTiles() %>%
    setView(-53.1805017, -14.2400732, 4) %>%
    addMarkers(-53.1805017, -14.2400732, popup = "Brazil Felipe")
  })
}

shinyApp(ui, server)