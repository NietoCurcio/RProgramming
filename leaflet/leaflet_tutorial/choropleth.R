library(leaflet)
library(tidyverse)
library(rgdal)
library(shiny)

data <- readOGR("https://rstudio.github.io/leaflet/json/us-states.geojson")

class(data)
summary(data)
str(data@data)
glimpse(data)

# pal <- colorQuantile(palette = "YlOrRd", domain = data$density)
bins <- c(0, 10, 20, 50, 100, 200, 500, 1000, Inf)
pal <- colorBin(palette = "YlOrRd", domain = data$density, bins = bins)

labels <- sprintf(
  "<strong style='font-weight: bold; padding: 3px 8px; font-size: 15px;'>%s</strong><br/>%g people / mi<sup>2</sup>",
  data$name,
  data$density
)
labels <- lapply(labels, htmltools::HTML)

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
    label = ~labels
  ) %>%
  addLegend(
    position = "bottomleft",
    pal = pal,
    values = ~density,
    opacity = 0.8
  )

# Using Shiny

runApp("./leaflet/shinyApps/choropleth")
