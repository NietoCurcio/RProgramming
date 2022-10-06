library(tidyverse)
library(rgdal)
library(leaflet)
library(shiny)
library(RColorBrewer)
# App with leaflet

# 1. show the count of UFO sighted in a usa state, coloring by nb_sighted
# 2. show the points where a UFO has been sighted (lat and lng), in clusters

# 1. requires: a spdf object, in the spdf@data has to be a column "nb_sighted"
# for each state. It also requires a color palette to be defined. Use addPolygons

# 2. requires lat and lng

# Note: remember there are 4 color palette functions:
# Continuous input, continuous colors (colorNumeric)
# Continuous input, discrete colors (colorBin and colorQuantile)
# for factors or categorical input (alien shape is a categorical input) (colorFactor):

us_states <- read.csv("./aliens/us_states.csv")
map_data <- readOGR("https://rstudio.github.io/leaflet/json/us-states.geojson")
head(map_data@data)

UFO_data <- read.csv("./aliens/UFOs_coord.csv")
UFO_data$Shape <- factor(UFO_data$Shape)
str(UFO_data)
levels(UFO_data$Shape)

nb_sighted <- UFO_data %>% group_by(State) %>% count()
colnames(nb_sighted) <- c("Abbreviation", "nb_sighted")
head(nb_sighted)

map_data@data <- map_data@data %>% left_join(us_states, by = c("name" = "State"))
map_data@data <- map_data@data %>% left_join(nb_sighted, by = c("Abbreviation" = "Abbreviation"))
head(map_data@data)

pal <- colorBin(palette = "YlOrRd", domain = map_data@data$nb_sighted)
# pal_shapes <- colorFactor(palette = "Spectral", domain = UFO_data$Shape)
# pal_shapes <- colorRampPalette(c(brewer.pal(9, "Set1"), brewer.pal(8, "Set2"), brewer.pal(4, "Accent")))

popups_states <- str_glue(
  "
  <div>
    <h1>{map_data$Abbreviation}</h1>
    <p>
      <strong
        style='font-weight: bold; padding: 3px 8px; font-size: 15px;'
      >{map_data$name}
      </strong>
      <br/>
      Numbers sighted: {map_data$nb_sighted}
    </p>
  </div>
  "
) %>% lapply(htmltools::HTML)

leaflet() %>%
  addTiles() %>%
  addPolygons(
    data = map_data,
    weight = 2,
    fillOpacity = 0.7,
    dashArray = "3",
    fillColor = ~pal(nb_sighted),
    highlightOptions = highlightOptions(
      color = "#333333",
      dashArray = "0",
      weight = 4,
    ),
    popup = ~popups_states
  ) %>%
  addCircleMarkers(
    data =  UFO_data,
    lng = ~lng,
    lat = ~lat,
    radius = 3,
    label = ~paste0("Shape: ", Shape, "\n", "City: ", City),
    labelOptions = labelOptions(zIndex = 10),
    clusterOptions = markerClusterOptions(spiderfyDistanceMultiplier = 2.5)
  )
