library(leaflet)
library(tidyverse)
library(shiny)
library(stringr)

# youtube playlist: https://www.youtube.com/playlist?list=PL6wLL_RojB5y8uL3uuIMnJ6JoTIFywQ-r

# Basic steps with leaflet ----------------------------------------------------------
# 1. create leaflet map object
# 2. add a basemap tile - it allows us to visualize and interact with the map
# The dafault basemap tile is the OSM with addTiles, we can use other basemap tiles with addProviderTiles
names(providers)[str_detect(names(providers), "OpenStreetMap")]
match("Esri", providers)

# setView and addMarkers functions
map <- leaflet() %>% addTiles() %>% setView(-53.1805017, -14.2400732, 4) %>%
  addMarkers(-53.1805017, -14.2400732, popup = "Brazil Felipe")
map

# saving HTML file -------------------------------------------------------------------
library(htmlwidgets)
saveWidget(widget = map, file = "map.html")

# shiny integration (leafletOutput and renderLeaflet) --------------------------------
runApp("./leaflet/shinyApps/leaflet_shiny", display.mode = "showcase")

# addCirclesMarks function -----------------------------------------------------------
quakes1 <- quakes[sample(nrow(quakes), 10), ]

colnames(quakes1) <- c("felipelat", "felipelong", "felipedepth", "felipemag", "felipestations")

# map the data passed in leaflet(data = data) with ~var
leaflet(data = quakes1) %>%
addProviderTiles(providers$Esri.WorldImagery) %>%
# addMarkers(lng = ~felipelong, lat = ~felipelat, label = ~felipedepth)
addCircleMarkers(lng = ~felipelong, lat = ~felipelat, label = ~felipedepth)

# addCirclesMarks with colors, legend and clusters --------------------------------
quakes1 <- quakes[sample(nrow(quakes), 50), ]
quakes1$magrange <- cut(quakes1$mag, breaks = c(4, 4.5, 5.5, 6), right = FALSE, labels = c("light", "moderate", "strong"))
head(quakes1)
levels(quakes1$magrange)
levels(quakes1$magrange)[1] < levels(quakes1$magrange)[3] & levels(quakes1$magrange)[1] < levels(quakes1$magrange)[2]
order(levels(quakes1$magrange))
palette <- colorFactor(palette = c("yellow", "red", "black"), domain = quakes1$magrange)

is.function(palette)
palette(quakes1$magrange)

leaflet(data = quakes1) %>%
addProviderTiles(providers$Esri.WorldImagery) %>%
addCircleMarkers(
  lng = ~long,
  lat = ~lat,
  color = ~palette(magrange),
  # label = ~mag
  # label = quakes1$mag
  # label = ~quakes1$mag
  label = paste("Magnitude=", quakes1$mag, "Type", quakes1$magrange),
  clusterOptions = markerClusterOptions()
) %>% addLegend(position = "bottomright", pal = palette, values = ~magrange, title = "Magnitude", opacity = 0.5)

# addCircles function -----------------------------------------------------------------

# addCircles have their radius specified in meters,
# while circle markers are specified in pixels.
# As a result, circles are scaled with the map as the user zooms in and out,
# while circle markers remain a constant size on the screen regardless of zoom level.

cities <- read.csv("./leaflet/pop.csv")

# highlightOptions adds the highlight on mousehover
leaflet(data = cities) %>% addTiles() %>%
addCircles(
  lng = ~Long,
  lat = ~Lat,
  # radius = ~Pop / 100
  radius = ~sqrt(Pop) * 30,
  popup = ~City,
  highlightOptions = highlightOptions(
    weight = 10,
    color = "darkgreen",
    fillColor = "lightgreen"
  ),
  label = paste(cities$City, "Felipe")
)

# Groups and Layers ------------------------------------------------------------------

leaflet(data = quakes) %>%
  addTiles(group = "OSM") %>%
  addProviderTiles(providers$Stamen.Toner, group = "Toner") %>%
  addProviderTiles(providers$Stamen.TonerLite, group = "Toner Lite") %>%
  addMarkers(lng = ~long, lat = ~lat, group = "Markers") %>%
  addCircleMarkers(lng = ~long, lat = ~lat, group = "Circle Markers") %>%
  addLayersControl(
    baseGroups = c("OSM", "Toner", "Toner Lite"),
    overlayGroups = c("Markers", "Circle Markers"),
    options = layersControlOptions(collapsed = FALSE)
  ) %>%
  hideGroup("Markers")

# Interactive map with React Inputs --------------------------------------------------
# 1. only using Reactive Inputs, maps gets recreated everytime
# 2. also using leafletProxy, update the map without recreating it
# Notice that, with leafletProxy, input$inputId does not goes inside renderLeaflet,
# it is setup in the leaftleProxy function in the observe function.

# Without leafletProxy:
runApp("./leaflet/shinyApps/withoutLeafletProxy_shiny")

# With leafletProxy:
runApp("./leaflet/shinyApps/withLeafletProxy_shiny")

# shape files and addPolygons --------------------------------------------------------

#download.file("http://thematicmapping.org/downloads/TM_WORLD_BORDERS_SIMPL-0.3.zip", destfile = "TM_WORLD_BORDERS_SIMPL-0.3.zip")
# unzip("leaflet/TM_WORLD_BORDERS_SIMPL-0.3.zip")

library(rgdal) # Geospatial Data Abstraction Library

myspdf <- readOGR(dsn = "leaflet/data", layer = "TM_WORLD_BORDERS_SIMPL-0.3")
head(myspdf)
summary(myspdf)
head(myspdf@data)
head(myspdf$NAME)
head(myspdf@data$NAME)
class(myspdf)
typeof(myspdf)

leaflet(data = myspdf) %>%
  addTiles()  %>%
  setView(lat = 10, lng = 0, zoom = 2) %>%
  addPolygons(
    fillColor = "darkgreen",
    highlightOptions = highlightOptions(
      weight = 5,
      color = "red",
      fillOpacity = 0.7,
      bringToFront = TRUE
    ),
    # label = myspdf$NAME
    # label = myspdf@data$NAME
    label = ~NAME
  )

library(geobr)
states <- read_state(
  year = 2019,
  showProgress = FALSE
  )
class(states)
typeof(states)
summary(states)
str(states)
head(states$geom)
head(states$name_state)
is.data.frame(states)
head(states)
names(states)

leaflet(data = states) %>%
  addTiles() %>%
  setView(lat = 10, lng = 0, zoom = 4) %>%
  addPolygons(
    fillColor = "darkgreen",
    highlightOptions = highlightOptions(
      weight = 5,
      color = "red",
      fillOpacity = 0.7,
      bringToFront = TRUE
    ),
    label = ~name_state
  )

runApp("./leaflet/shinyApps/clickEvent_shiny")

# removeMarker -----------------------------------------------------------------------

runApp("./leaflet/shinyApps/removeMarker_shiny")