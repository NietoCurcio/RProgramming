ids <- paste("Marker", seq(1, 10))

ui <- bootstrapPage(
  tags$style(
    type = "text/css",
    "html, body { width: 100%; height: 100%; }"
  ),
  h5("Leaflet marker event with leafletProxy() and removeMarker()"),
  verbatimTextOutput("message"),
  leafletOutput("map", width = "100%", height = "100%")
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet(data = head(quakes, 10)) %>%
      addTiles() %>%
      addCircleMarkers(
        lng = ~long,
        lat = ~lat,
        layerId = ids,
        label = paste("LayerID =", ids)
      )
  })

  observe({
    leafletProxy("map") %>% removeMarker(input$map_marker_click$id)
  })

  observe({
    click <- input$map_marker_click
    if (is.null(click)) return()
    else output$message <- renderText({
      paste("Marker ID", click$id, "removed")
    })
  })
}

shinyApp(ui, server)