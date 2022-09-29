library(leaflet)
library(tidyverse)

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
