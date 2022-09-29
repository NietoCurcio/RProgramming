library(leaflet)
library(leaflet.extras)
library(tidyverse)
library(htmltools)

# Notes from interactive-maps-with-leaflet-in-r datacamp course

# Forcing focus on an area -----------------------------------------------------------
leaflet(options = leafletOptions(minZoom = 4, maxZoom = 8)) %>%
  addTiles() %>%
  setView(lat = -73, lng = 40, zoom = 7) %>%
  setMaxBounds(lng1 = -72 + .05, lat1 = 41 + .05, lng2 = - 74 + .05, lat2 = 39 + .05)


data <- data.frame(
  state = c("NY", "Belgium"),
  lon = c(-73, 5),
  lat = c(40, 50)
)

m <- leaflet(data = as.tibble(data)) %>%
  addTiles() %>%
  setView(lat = 50.88, lng = 4.71, zoom = 5) %>%
  addMarkers(lng = ~lon, lat = ~lat, popup = ~state)
m
m %>% clearBounds()
m %>% clearBounds() %>% clearMarkers()

# Using dplyr ------------------------------------------------------------------------

schools <- data.frame(
  name = c("A", "B", "C", "D", "E", "F", "G", NA),
  state = c("RJ", "RJ", "SP", "SP", "DF", "MG", NA, "MG"),
  sector_label = c("Private", "Public", "Public", "For-Profit", "Public", "Public", "Private", "Private"),
  lat = c(-22.7104, -22.8764, -23.4599, -23.69, -15.80, -19.85, NA, NA),
  lng = c(-43.5769, -43.8060, -46.60, -46.69, -47.91, -44.06, NA, NA)
)

valid_schools <- schools %>% summarize_all(funs(sum(is.na(.))))
schools[is.na(schools$name), ]

schools %>% drop_na()
schools %>% group_by(state) %>% count() %>% arrange(desc(n))
RJ_SP_schools <- schools %>% filter(state == "RJ", sector_label == "Public")
RJ_SP_schools

labels <- str_glue("<strong> {RJ_SP_schools$name} felipe</strong>") %>% lapply(htmltools::HTML)

leaflet(RJ_SP_schools) %>% addProviderTiles("CartoDB") %>% addCircleMarkers(lat = ~lat, lng = ~lng, radius = 3, label = ~labels)

# addSearchOSM() addReverseSearchOSM() addResetMapButton() ---------------------------
library(leaflet.extras)

leaflet() %>% addTiles() %>% addSearchOSM()
leaflet() %>% addTiles() %>% addSearchOSM() %>% addResetMapButton() %>% addResetMapButton()

ipeds <- read.csv("leaflet/hd2021.csv") %>% select(c("INSTNM", "LONGITUD", "LATITUDE", "SECTOR"))
ipeds <- read.csv("leaflet/hd2021.csv") %>% select(c("INSTNM", "LONGITUD", "LATITUDE"))
ipeds <- sample_n(ipeds, 1000)

leaflet(data = ipeds) %>% addTiles() %>% addCircleMarkers(lng = ~LONGITUD, lat = ~LATITUDE, label = ~INSTNM, radius = 3)

# Groups and Layers ------------------------------------------------------------------

schools %>% drop_na()
schools %>% group_by(state) %>% count() %>% arrange(desc(n))
public_schools <- schools %>% drop_na() %>% filter(sector_label == "Public")
private_schools <- schools %>% drop_na() %>% filter(sector_label == "Private")
profit_schools <- schools %>% drop_na() %>% filter(sector_label == "For-Profit")

pal <- colorFactor(c("red", "blue", "darkgreen"), schools$sector_label)

leaflet() %>%
  addTiles(group = "osm") %>%
  addProviderTiles("CartoDB", group = "CartoDB") %>%
  addProviderTiles("Esri", group = "Esri") %>%
  addCircleMarkers(data = public_schools, label = ~name, color = ~pal(sector_label), group = "Public") %>%
  addCircleMarkers(data = private_schools, label = ~name, color = ~pal(sector_label), group = "Private") %>%
  addCircleMarkers(data = profit_schools, label = ~name, color = ~pal(sector_label), group = "For-Profit") %>%
  addLayersControl(
    overlayGroups = c("Public", "Private", "For-Profit"),
    baseGroups = c("OSM", "CartoDB", "Esri"),
    options = layersControlOptions(collapsed = FALSE)
  )


public_schools %>% leaflet() %>% addTiles() %>%
  addCircleMarkers(
    radius = 3,
    label = ~htmltools::htmlEscape(name),
    color = ~pal(sector_label),
    group = "Public"
  )  %>% addSearchFeatures(
    targetGroups = "Public",
    options = searchFeaturesOptions(zoom = 10)
  )

schools %>% drop_na() %>% leaflet() %>% addTiles() %>%
  addCircleMarkers(
    radius = 3,
    label = ~htmltools::htmlEscape(name),
    color = ~pal(sector_label),
    clusterOptions = markerClusterOptions()
  ) %>% addLegend(position = "bottomright", pal = pal, values = ~sector_label)

# Polygons ---------------------------------------------------------------------------

# lat and lng stores point coordinates (represent a single point) of a observation in the df

# Spatial Data in R - spatial polygons dataframe
# this object holds five slots:
# data - one observation for each polygon
# polygons - coordinates to plot each polygon
# plotOrder - order to plot each of the polygons
# bbox - bounding box, the rectangle that all of the polygons fit within
# proj4string - coordinate reference system

# Acessing a slot:
# data@data
# data@polygons

# It's possible to join data into the spatial data dataframe with left_join function
# spdf@data %>% left_join(df, by = c("primary_key" = "foreign_key"))

dfA <- data.frame(passengerId = c(1, 2, 3), name = c("Felipe", "Guilherme", "Bianca"))
dfB <- data.frame(takeoffId = c(10, 11, 12), passId = c(3, 2, 1))

dfC <- dfA %>% left_join(dfB, by = c("passengerId" = "passId"))

# All together -----------------------------------------------------------------------

nycounties <- rgdal::readOGR("https://rstudio.github.io/leaflet/json/nycounties.geojson")
nycounties <- nycounties[10:20, ]
nycounties@data

cn_pal <- colorNumeric("Blues", log10(nycounties@data$pop))
cf_pal <- colorFactor("YlOrRd", nycounties$pop_label)

counties_lat_lng_df <- data.frame(
  county = nycounties@data$county,
  lng = c(-84.1802, -76.1978, -75.4560, -76.5855, -73.7871, -78.2414, -78.7132, -77.6608, -83.2237, -84.4058, -76.1425),
  lat = c(39.4357, 43.4243, 43.2304, 42.9285, 43.0735, 43.2454, 43.1880, 43.1511, 42.2931, 33.7636, 43.0487)
)

nycounties@data <- nycounties@data %>% left_join(counties_lat_lng_df, by = c("county" = "county"))

summary(nycounties@data$pop)
nycounties$pop_label <- cut(nycounties$pop, breaks = c(4700, 100000, 320000, 2600000), right = FALSE, labels = c("low", "medium", "high"))

nycounties_low <- nycounties[nycounties$pop_label == "low", ]
nycounties_medium <- nycounties[nycounties$pop_label == "medium", ]
nycounties_high <- nycounties[nycounties$pop_label == "high", ]

head(nycounties@data)
nycounties_low@data

leaflet() %>%
  addTiles(group = "OSM") %>%
  addProviderTiles("CartoDB", group = "Carto") %>% 
  addProviderTiles("Esri", group = "Esri") %>% 
  addPolygons(
    data = nycounties,
    weight = 1,
    fillOpacity = .75,
    color = ~cn_pal(log10(pop)),
    label = ~paste0(county, ": ", formatC(pop, big.mark = ",")),
    group = "county"
  ) %>%
  addCircleMarkers(
    data = nycounties_low,
    radius = 2,
    label = ~htmlEscape(county),
    color = ~cf_pal(pop_label),
    lat = ~lat,
    lng = ~lng,
    group = "low"
  ) %>% addCircleMarkers(
    data = nycounties_medium,
    radius = 2,
    label = ~htmlEscape(county),
    color = ~cf_pal(pop_label),
    lat = ~lat,
    lng = ~lng,
    group = "medium"
  ) %>% addCircleMarkers(
    data = nycounties_high,
    radius = 2,
    label = ~htmlEscape(county),
    color = ~cf_pal(pop_label),
    lat = ~lat,
    lng = ~lng,
    group = "high"
  ) %>% addLayersControl(
    baseGroups = c("OSM", "Carto", "Esri"),
    overlayGroups = c("low", "medium", "high", "county")
  ) %>% addLegend(
    data = nycounties,
    pal = cn_pal,
    values = ~log10(pop),
    opacity = .75,
    labFormat = labelFormat(transform = function(x) round(10^x))
  )
