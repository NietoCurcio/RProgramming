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

Inside the the UI object we can use HTML elements, for example:

```R
  img(src = "image.jpg", style = "width: 50px;")
```

```R
  HTML("<img src='image.jpg' style='width: 50px;' />")
```

There are a variaety of functions represeting HTML elements, such as h1, p, strong, em, etc.

> You can add content to your Shiny app by placing it inside a **Panel** function

In the functions that goes inside fluidPage, for example, sidebarPanel, mainPanel and navbarPage, we can
put text, Input and Output objects (widgets) or HTML elements as data.

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
- numericInput
- radioButtons
- selectInput
- sliderInput
- submitButton
- textInput

See [Widgets gallery](https://shiny.rstudio.com/gallery/widget-gallery.html)

All outputs goes in `mainPanel`, args "outputId":

- tableOutput
- plotOutput
- verbatimTextOutput

## Server function

Basic structure:

```R
output$outputId <- render({
  # ...
})
```

- renderPlot
- renderPrint
- renderTable
