library(leaflet)
library(tidyverse)
library(rgdal)
library(shiny)

# app called in leaflet_tutorial/choropleth.R

data <- readOGR("https://rstudio.github.io/leaflet/json/us-states.geojson")
# View(data)
# slotNames(data)
# data@polygons[[1]] %>% leaflet()  %>% addTiles() %>% addPolygons()

# Montana <- data[data$name == "Montana", ]
# typeof(Montana@polygons)
# slotNames(Montana@polygons[[1]])
# Montana@polygons[[1]]@labpt

bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
pal <- colorBin(palette = "YlOrRd", domain = log(data$density), bins = 7)
pal_blues <- colorBin(palette = "Blues", domain = data$density, bins = bins)
# pal_quantile <- colorQuantile(palette = "Blues", domain = data$density, n = 8)
# previewColors(pal = pal_blues, values = seq(0, 1000, by = 100))

# could be used sprintf with placeholders %s for string and %g for double
# popups <- str_glue(
#   "
#   <p>
#     <strong
#       style='font-weight: bold; padding: 3px 8px; font-size: 15px;'
#     >{data$name}
#     </strong>
#     <br/>
#     {round(log(data$density), 2)} log(people / mi<sup>2</sup>)
#   </p>
#   "
# ) %>% lapply(htmltools::HTML)

showPopup <- function(stateName, lat, lng) {
  state <- data@data %>% filter(name == stateName)

  content <- str_glue(
    "
    <p>
      <strong
        style='font-weight: bold; padding: 3px 8px; font-size: 15px;'
      >{state$name}
      </strong>
      <br/>
      {round(log(state$density), 2)} log(people / mi<sup>2</sup>)
    </p>
    "
    ) %>% HTML

  leafletProxy("map") %>% addPopups(lng = lng, lat = lat, popup = content, layerId = state$name)
}

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
    draggable = TRUE,
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
      fillColor = ~pal(log(density)),
      smoothFactor = 0.2,
      highlightOptions = highlightOptions(
        color = "#333333",
        dashArray = "0",
        weight = 4,
        bringToFront = TRUE
      ),
      # popup = ~popups,
      layerId = ~name
    ) %>%
    addLegend(
      position = "bottomleft",
      pal = pal,
      values = ~log(density),
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

    isolate({
      showPopup(click$id, lat, lng)
    })
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

  dataInBounds <- reactive({
    if (is.null(input$map_bounds)) return(data@data[FALSE, ])

    bounds <- input$map_bounds

    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)

    filter <- data@polygons %>% sapply(function(x) {
      coords <- x@labpt
      lat <- coords[2]
      lng <- coords[1]

      if (
        (lat >= latRng[1] & lat <= latRng[2]) &
        (lng >= lngRng[1] & lng <= lngRng[2])
      )
      TRUE
      else
      FALSE
    })

    filteredData <- data@data[filter, ]
    # print(filteredData)
  })

  output$plot <- renderPlot({
    ggplot(data = dataInBounds(), aes(x = log(density))) + geom_histogram(binwidth = 1)
  })
}

shinyApp(ui = ui, server = server)

# Use of S4 objects study:
# library(tidyverse)

# setClass("Car", representation = representation(
#   name = "character",
#   price = "numeric",
#   numberDoors = "numeric",
#   typeEngine = "character",
#   mileage = "numeric"
# ))

# viper <- new("Car", name = "viper", price = 20000, numberDoors = 4, typeEngine = "V6", mileage = 143)
# bmw <- new("Car", name = "bmw", price = 20000, numberDoors = 2, typeEngine = "V6", mileage = 143)
# ferrari <- new("Car", name = "ferrari", price = 20000, numberDoors = 2, typeEngine = "V6", mileage = 143)

# l <- list(viper, bmw, ferrari)

# typeof(l[[1]])

# for (car in l) {
#   print(car@name)
#   print(car@numberDoors)
# }

# # l2 <- list(FALSE, TRUE, TRUE)
# # l2 <- c(FALSE, TRUE, TRUE)
# l2 <- l %>% sapply(function(x) {
#   print(x@numberDoors)
#   if (x@numberDoors == 2) TRUE else FALSE
# })

# l3 <- l[l2]
# length(l3)
