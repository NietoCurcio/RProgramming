data <- readOGR("https://rstudio.github.io/leaflet/json/us-states.geojson")

# Montana <- data[data$name == "Montana", ]
# typeof(Montana@polygons)
# slotNames(Montana@polygons[[1]])
# Montana@polygons[[1]]@labpt

bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
pal <- colorBin(palette = "YlOrRd", domain = data$density, bins = bins)
pal_blues <- colorBin(palette = "Blues", domain = data$density, bins = bins)

# could be used sprintf with placeholders %s for string and %g for double
popups <- str_glue(
  "
  <p>
    <strong
      style='font-weight: bold; padding: 3px 8px; font-size: 15px;'
    >{data$name}
    </strong>
    <br/>
    {data$density} people / mi<sup>2</sup>
  </p>
  "
) %>% lapply(htmltools::HTML)

ui <- bootstrapPage(
  includeCSS("www/style.css"),
  leafletOutput(
    "map",
    width = "100%",
    height = "100%"
  ),
  absolutePanel(
    top = 10,
    right = 10,
    fixed = TRUE,
    width = "400px",
    div(
      style = "opacity: 0.7; background: #FFFFEE; padding: 8px;",
      helpText("US Population Density"),
      textOutput("text"),
      br(),
      br(),
      plotOutput("plot")
    )
  )
)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet(data) %>%
    setView(lat = 37.8, lng = -96, zoom = 4) %>%
    addTiles() %>%
    addPolygons(
      color = "#ffffff",
      weight = 2,
      opacity = 1,
      fillOpacity = 0.7,
      dashArray = "3",
      fillColor = ~pal(density),
      smoothFactor = 0.2,
      highlightOptions = highlightOptions(
        color = "#333333",
        dashArray = "0",
        weight = 4,
        bringToFront = TRUE
      ),
      popup = ~popups,
      layerId = ~name
    ) %>%
    addLegend(
      position = "bottomleft",
      pal = pal,
      values = ~density,
      opacity = 0.8
    )
  })

  observe({
    click <- input$map_shape_click

    if (is.null(click)) return()

    filtered <- data[data$name == click$id, ]
    name <- filtered$name

    lng <- click$lng
    lat <- click$lat

    leafletProxy("map") %>%
        setView(lng = lng, lat = lat, zoom = 5) %>%
        clearMarkers() %>%
        clearPopups() %>%
        addMarkers(lng = lng, lat = lat, popup = name)
  })

  country_clicked <- reactive({
    click <- input$map_shape_click
    click$id
  })

  output$text <- renderText({
      paste(
        "Country:",
        if (!is.null(country_clicked())) country_clicked() else "None"
      )
    })

  output$plot <- renderPlot({
    ggplot(data = data@data, aes(x = density)) + geom_histogram(binwidth = 20)
  })
}

shinyApp(ui, server)