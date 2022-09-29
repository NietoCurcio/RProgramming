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
put text, Input (widgets) and Output objects (reactive elements) or HTML elements as data.

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

Output objects, basic arguments "outputId":

- dataTableOutput
- htmlOutput (or uiOutput)
- imageOutput
- plotOutput
- tableOutput
- textOutput
- verbatimTextOutput

Output object takes two steps, it first defines where and how (width, heigth, etc) the output will be displayed in the UI, then in the server function builds the output in which will use input$inputId data in order to be reactive.

## Server function

Basic structure:

```R
server <- function(input, output) {
  output$outputId <- renderFunction({
  # ...
  })
}

```

The output is a list-like, in this list must be created an element with its name matching the name defined in the reactive element (Output object). The created element will be assigned to the output of the `render*` functions. Use the `render*` function that corresponds to the output object being used.

Render functions, basic arguments R expression {} (set of instructions, this expression should return the data that matches the Output object or reactive element (text, plot, data frame, etc.)):

- renderDataTable
- renderImage
- renderPlot
- renderPrint
- renderTable
- renderText
- renderUI

Use the value stored in a Widget (Input object) in the expression made in the `render*` function, this will make the Output object react to the user interaction. Thinking in React terms, the Widgets stores the state of the application (like useState), if we use the state or data inside a `render*` function, it will react. The app's state is stored in the `input` list-like, each element name corresponds to the Widget inputId defined in the UI object. Shiny rebuilds the output that depends on the widget modified, i.e. `inputId` being used in the `render*` function of an `output$outputId`.

In the server, a build object must be inside a render function to output the object. Example of functions that returns build objects: ggplot (renderPlot), paste (renderText), HTML function tag (renderUI), head or data.frame (renderTable).

We can only use the reactive values, input$inputId, inside a reactive context. There are 3 main reactive contexts:

- `render*` functions:

```R
output$outputId <- renderPlot({
  plot(rnorm(input$num))
  })
```

- `observe` function:

```R
observe({
  print(input$num1)
  print(input$num2)
  })
```

- `reactive` function, to make a reactive variable, notice that x depends on input$num. All input widgets are reactive variables:

```R
x <- reactive({
  input$num + 1
})

y <- reactive({
  x() + input$num2
})

observe({
  print(input$num)
  print(x())
  print(y())
  })
```

## Shiny with Leaflet

Through leafletOutput output object and renderLeaflet render function, we can integrate Leaflet maps with Shiny. To get started with Leaflet you create a map object and add a Tile layer, then add layers to make present features in the map, such as Markers or setting the initial view position. The map looks interesting when we provide a data object through `leaflet(data = data)`, in that way we can addPolygons together with colors, labels, highlightOptions and popups corresponding to the data. The data object consists of spatial data, usually in the format of "sp" (as SpatialPolygonDataframe), "sf", map objects from maps package, matrices and data frames with latitude and longitude information. Leaflet [quick_start](/leaflet/) file and [leaflet_tutorial](/leaflet/leaflet_tutorial/) folder shows its functionality.
