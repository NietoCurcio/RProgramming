# R Shiny Interactive web apps

Shiny app minimum structure:

```R
library(shiny)

ui <- fluidPage(
  #...
)

server <- function(input, output) {
  #...
}

shinyApp(ui = ui, server = server)
```

## UI object

Basic structure:

```R
fluidPage(
  titlePanel(""),
  sidebarLayout(
    sidebarPanel(
      # Input
    ),
    mainPanel(
      # Ouput
    )
  )
)
```

Inside the UI object we can use HTML elements, for example:

```R
  img(src = "image.jpg", style = "width: 50px;")
```

```R
  HTML("<img src='image.jpg' style='width: 50px;' />")
```

There are a variety of functions representing HTML elements, such as h1, p, strong, em, etc.

> You can add content to your Shiny app by placing it inside a **Panel** function

In the functions that go inside fluidPage, for example, sidebarPanel, mainPanel and navbarPage, we can
put text, Input (widgets) and Output functions (reactive elements) or HTML elements as data.

Input Widgets, basic arguments "inputId", "label":

- sliderInput
- selectInput
- numericInput
- actionButton
- checkboxGroupInput
- checkboxInput
- dateInput
- dateRangeInput
- fileInput
- helpText
- radioButtons
- submitButton
- textInput

See [Widgets gallery](https://shiny.rstudio.com/gallery/widget-gallery.html)

Output functions, basic arguments "outputId":

- dataTableOutput
- htmlOutput (or uiOutput)
- imageOutput
- plotOutput
- tableOutput
- textOutput
- verbatimTextOutput

Output function takes two steps, it first defines where and how (width, heigth, etc) the output will be displayed in the UI, then in the server function builds the output in which will use input$inputId data in order to be reactive.

There are packages that provide functions to integrate an object with leaflet, for example:

- leaflet::leafletOutput
- DT::DToutput
- plotly::plotlyOutput
- shinydashboard::[dropdownMenuOutput, infoBoxOutput, valueBoxOuput]

## Server function

Basic structure:

```R
server <- function(input, output) {
  output$outputId <- renderFunction({
  # ...
  })
}

```

The output is a list-like, in this list must be created an element with its name matching the name defined in the reactive element (Output function). The created element will be assigned to the output of the `render*` functions. Use the `render*` function that corresponds to the output function being used.

Render functions, basic arguments R expression {} (set of instructions, this expression should return the data that matches the Output function or reactive element (text, plot, data frame, etc.)):

- renderDataTable
- renderImage
- renderPlot
- renderPrint
- renderTable
- renderText
- renderUI

In the same way there are output objects (reactive endpoint), provided by third packages, there are also `render*` functions, for example:

- leaflet::renderLeaflet
- DT::renderDT
- plotly::renderPlotly
- shinydashboard::[renderMenu, renderInfoBox, renderValueBox]

Use the value stored in a Widget (Input object) in the expression made in the `render*` function, this will make the Output function react to the user interaction. Thinking in React terms, the Widgets stores the state of the application (like useState), if we use the state or data inside a `render*` function, it will react. The app's state is stored in the `input` list-like, each element name corresponds to the Widget inputId defined in the UI object. Shiny rebuilds the output that depends on the widget modified, i.e. `inputId` being used in the `render*` function of an `output$outputId`.

In the server, a build object must be inside a render function to output the object. Example of functions that returns build objects: ggplot (renderPlot), paste (renderText), HTML function tag (renderUI), head or data.frame (renderTable).

We can only use the reactive values, input$inputId, inside a reactive context. There are 3 main reactive contexts:

- `render*` functions:

```R
output$outputId <- renderPlot({
  plot(rnorm(input$num))
  })
```

- `observe` function can be used to perform actions with side-effects, for example, display a notification, plot, modal or table:

```R
observe({
  print(input$num1)
  print(input$num2)
  showNotification(
    paste("Num 2 value: ", input$num2)
  )
  })
```

- `reactive` function, used to return a value without side-effects, making a reactive variable. The reactive expressions also have caching functionality, notice that x depends on input$num. All input widgets are reactive variables:

```R
x <- reactive({
  input$num + 1
})

y <- reactive({
  x() + input$num2
  # invalidateLater(5000) # invalidate cache reactive context
})

observe({
  print(input$num)
  print(x())
  print(y())
  })
```

Reactive by event and trigger side-effect by event:

```R
var <- eventReactive(input$eventInputId, {
  # expression to set var value
})

observeEvent(input$eventInputId, {
  # expression to make a side-effect
})
```

Other interesting reactive contexts:

```R
# For real-time data
data <- reactiveFileReader(
  intervalMillis = 1000,
  session = session,
  filePath = "data.csv",
  readFnc = read.csv
)

# Polling a database or API
data <- reactivePoll(
  15000,
  session,
  checkFunc = function() DBI::dbGetQuery(dbConn, "SELECT MAX(updated) FROM table;"),
  # checkFunc must be a fast function, it returns a value, like a timestamp or count
  # or even last-modified, ETag http headers
  valueFunc = function() DBI::dbGetQuery(dbConn, "SELECT * FROM table LIMIT 10;")
)
```

The expression in the reactive function gets evaluated only when a reactive endpoint (or output object, `output$outputId`) calls its value in the render context (using the cached value or updating it), meanwhile observers always execute when its dependencies change, regardless of whether an input object is being used in a render function or not. Side-effects are used in an observer, these should not be in a reactive expression.

## Shiny with Leaflet

Through leafletOutput output function and renderLeaflet render function, we can integrate Leaflet maps with Shiny. To get started with Leaflet you create a map object and add a Tile layer, then add layers to present features in the map, such as Markers or setting the initial view position. The map looks interesting when we provide a data object through `leaflet(data = data)`, in that way we can addPolygons together with colors, labels, highlightOptions and popups corresponding to the data. The data object consists of spatial data, usually in the format of "sp" (as SpatialPolygonDataframe), "sf", map objects from maps package, matrices and data frames with latitude and longitude information (notice that a data frame with one lat and lng will represent a specific point for an observation).

Whereas a single point is represented in an observation by lat and lng features, a polygon is represented by a set of coordinates or points, the polygon of an observation is stored in a Spatial Polygon DataFrame object:

This object stores five slots:

- data: one observation (row in the dataframe) for each polygon.
- polygons: coordinates (points) to plot each polygon.
- plotOrder: order to plot each of the polygons.
- bbox: bounding box, the rectangle that all of the polygons fit within
- proj4string: projection string, coordinate reference system.

Acessing a slot:

```R
spdf@data
spdf@polygons
```

It's possible to join data into the spatial data dataframe with left_join function.

```R
spdf@data %>% left_join(df, by = c("primary_key" = "foreign_key"))
```

The [leaflet](/leaflet/) folder contains leaflet map examples and shiny apps.

## Shiny Dashboard

The `shinydashboard` package provides a set of functions, such as dashboardPage, dashboardHeader, dashboardSidebar and dashboardBody, to practically build dashboards.
