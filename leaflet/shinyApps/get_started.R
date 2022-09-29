library(leaflet)

m <- leaflet() %>%
addTiles() %>%
# addMarkers(lng = -43.22469033505183, lat = -22.912580882439794, popup = "The birthplace of R")
setView(-71.0382679, 42.3489054, zoom = 4)
m  # Print the map


m %>% fitBounds(-72, 40, -70, 43)
m %>% clearBounds()
m

df <- data.frame(Lat = 1:10, Long = rnorm(10))
leaflet(df) %>% addTiles() %>% setView(-71.0382679, 42.3489054, zoom = 4)

leaflet(df) %>% addCircles(lng = ~Long, lat = ~Lat)

leaflet() %>% addCircles(data = df)
leaflet() %>% addCircles(data = df, lat = ~ Lat, lng = ~ Long)

library(maps)
map_states <- map("state", fill = TRUE, plot = FALSE)
leaflet(data = map_states) %>% addTiles() %>% addPolygons(fillColor = topo.colors(20, alpha = NULL), stroke = FALSE)

m <- leaflet() %>% addTiles()
df <- data.frame(
  lat = rnorm(100),
  lng = rnorm(100),
  size = runif(100, 5, 20),
  color = sample(colors(), 100)
)
m <- leaflet(df) %>% addTiles()
m %>% addCircleMarkers(radius = ~size, color = ~color, fill = FALSE)
m %>% addCircleMarkers(radius = runif(100, 4, 10), color = c("red"))

m <- leaflet() %>% setView(lng = -71.0589, lat = 42.3601, zoom = 12)
m %>% addTiles()
m %>% addProviderTiles(providers$Stamen.Toner)
m %>% addProviderTiles(providers$CartoDB.Positron)
m %>% addProviderTiles(providers$Esri.NatGeoWorldMap)
names(providers)
names(providers)[str_detect(names(providers), "OpenStreetMap")]
match("Esri.NatGeoWorldMap", providers)

m <- leaflet() %>% addTiles() %>% setView(-93.65, 42.0285, zoom = 4)
m
m %>% addWMSTiles(
  "http://mesonet.agron.iastate.edu/cgi-bin/wms/nexrad/n0r.cgi",
  layers = "nexrad-n0r-900913",
  options = WMSTileOptions(format = "image/png", transparent = TRUE),
  attribution = "Weather data © 2012 IEM Nexrad"
)

m %>% addProviderTiles(providers$MtbMap) %>% addProviderTiles(providers$Stamen.TonerLines, options = providerTileOptions(opacity = 0.35)) %>% addProviderTiles(providers$Stamen.TonerLabels)
