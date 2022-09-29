ui <- bootstrapPage(
  tags$style(type = "text/css", "html, body {width: 100%; height: 100%}"),
  leafletOutput("mymap", width = "100%", height = "100%"),
  absolutePanel(
    top = 10,
    right = 10,
    fixed = TRUE,
    tags$div(
      style = "opacity: 0.7; background: #FFFFEE; padding: 8px;",
      helpText("Welcome to the World map"),
      textOutput("text")
    )
  )
)

server <- function(input, output, session) {
  output$mymap <- renderLeaflet({
    leaflet(data = myspdf) %>%
      addTiles() %>%
      setView(lat = 10, lng = 0, zoom = 2) %>%
      addPolygons(
        fillColor = "green",
        highlightOptions = highlightOptions(
          weight = 5,
          color = "red",
          fillOpacity = 0.7,
          bringToFront = TRUE
        ),
        label = ~NAME,
        layerId = ~NAME
      )
  })

  observe({
    click <- input$mymap_shape_click
    print("FELIPE")
    print(click)

    sub <- myspdf[myspdf$NAME == click$id, c("LAT", "LON", "NAME")]
    lat <- sub$LAT
    lng <- sub$LON
    name <- sub$NAME

    if (is.null(click)) {
      return()
    } else {
      leafletProxy("mymap") %>%
      setView(lng = click$lng, lat = click$lat, zoom = 5) %>%
      clearMarkers() %>%
      addMarkers(lng = lng, lat = lat, popup = name)

      # this code could be inside another observe({})
      output$text <- renderText({
        paste(
          "Latitude =", lat,
          "Longitude =", lng,
          "Country =", name
        )
      })
    }
  })

  #observe({})
}

shinyApp(ui, server)