library(tidyverse)
library(leaflet)
library(rgdal)

# Lines and Shapes -------------------------------------------------------------------

# In summary, shape files consist of spatial data files
# usually are in "sp" or "spdf", "sf" or the object from the map function
# the are also matrix and data frames with lng and lat columns

# Passing a data object in the leaflet() first argument allow us
# to define map colors, labels, etc based on the data

states <- readOGR(
  "./leaflet/leaflet_tutorial/data/cb_2013_us_state_20m.shp",
  # layer = "cb_2013_us_state_20m",
  GDAL1_integer64_policy = TRUE
)
class(states)
typeof(states)
summary(states)
summary(states@polygons)
head(states@data)

object.size(states)
simplified <- rmapshaper::ms_simplify(states)
object.size(simplified)

neStates <- subset(states, states$STUSPS %in% c(
  "CT", "ME", "MA", "NH", "RI", "VT", "NY", "NJ", "PA"
))
# neStates <- subset(simplified, simplified$STUSPS %in% c(
#   "CT", "ME", "MA", "NH", "RI", "VT", "NY", "NJ", "PA"
# ))

leaflet(neStates) %>%
  addPolygons(
    color = "#3fb430",
    weight = 1,
    smoothFactor = 0.5,
    opacity = 1.0,
    fillOpacity = 0.5,
    fillColor = ~colorQuantile("Blues", ALAND)(ALAND),
    highlightOptions = highlightOptions(
      color = "white",
      weight = 2,
      bringToFront = TRUE
    )
  )

# GeoJSON data (shapes) and colors ---------------------------------------------------

nycounties <- rgdal::readOGR("https://rstudio.github.io/leaflet/json/nycounties.geojson")
class(nycounties)
pal <- colorNumeric("Blues", NULL)
leaflet(nycounties) %>%
  addTiles() %>%
  addPolygons(
    stroke = FALSE,
    smoothFactor = 0.3,
    fillOpacity = 1,
    fillColor = ~pal(log10(pop)),
    # fillColor = ~colorNumeric("Blues", log10(pop))(log10(pop)),
    label = ~paste0(county, ": ", formatC(pop, big.mark = ","))
  ) %>%
  addLegend(
    pal = pal,
    values = ~log10(pop),
    opacity = 1.0,
    labFormat = labelFormat(transform = function(x) round(10^x))
  )

# colors functions color*, args:
# 1. colors palette - c("red", "green", "blue") por "Blues" for example
# 2. optionally, the range of inputs (domain), it makes the scaling consistent.
pal <- colorNumeric(c("red", "green", "blue"), 1:10)
pal(c(1, 6, 9, 10))
# color functions for continues input: colorNumeric, colorBin and colorQuantile
# color function for categorical input: colorFactor.
# the color palette can be: RColorBrewer palette, viridis palette, a vector of colors
# library(RColorBrewer)
# display.brewer.all()

countries <- readOGR("https://rstudio.github.io/leaflet/json/countries.geojson")
summary(countries)
head(countries$gdp_md_est)
head(countries@data)
is.data.frame(countries@data)

ggplot(data = countries@data, aes(x = gdp_md_est)) +
  geom_histogram(binwidth = 1000000)
hist(countries$gdp_md_est, breaks = 20)

# Continuous input, continuous colors (colorNumeric)
pal <- colorNumeric(
  palette = "Blues",
  domain = countries$gdp_md_est)

leaflet(countries) %>%
  addPolygons(
    stroke = FALSE,
    smoothFactor = 0.2,
    fillOpacity = 1,
    color = ~pal(gdp_md_est)
  ) %>%
  addLegend(
    pal = pal,
    values = ~gdp_md_est,
  )

# Continuous input, discrete colors (colorBin and colorQuantile)

binpal <- colorBin("Blues", countries$gdp_md_est)
leaflet(countries) %>%
  addPolygons(
    stroke = FALSE,
    smoothFactor = 0.2,
    fillOpacity = 1,
    color = ~binpal(gdp_md_est)
  )

qpal <- colorQuantile("Blues", countries$gdp_md_est, n = 7)
leaflet(countries) %>%
  addPolygons(
    stroke = FALSE,
    smoothFactor = 0.2,
    fillOpacity = 1,
    color = ~qpal(gdp_md_est)
  )

# Coloring categorical data

countries@data$category <- factor(sample.int(5L, nrow(countries), TRUE))

head(countries@data)

factpal <- colorFactor(topo.colors(5), countries$category)
leaflet(countries) %>%
  addPolygons(
    stroke = FALSE,
    smoothFactor = 0.2,
    fillOpacity = 1,
    color = ~factpal(category)
  )
