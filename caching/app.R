library(tidyverse)
library(shiny)

# caching reactive
shinyApp(
  ui = fluidPage(
    sliderInput("x", "x", 1, 10, 5),
    sliderInput("y", "y", 1, 10, 5),
    div("x * y: "),
    verbatimTextOutput("txt")
  ),
  server = function(input, output) {
    r <- reactive({
      message("Doing expensive computation...")
      Sys.sleep(2)
      input$x * input$y
    }) %>%
      bindCache(input$x, input$y)

    output$txt <- renderText(r())
  }
)

# Caching renderText
shinyApp(
  ui = fluidPage(
    sliderInput("x", "x", 1, 10, 5),
    sliderInput("y", "y", 1, 10, 5),
    div("x * y: "),
    verbatimTextOutput("txt")
  ),
  server = function(input, output) {
    output$txt <- renderText({
      message("Doing expensive computation...")
      Sys.sleep(2)
      input$x * input$y
    }) %>%
      bindCache(input$x, input$y)
  }
)

# the list of dependencies in bindCache is hashed,
# for very large data see https://shiny.rstudio.com/articles/caching.html#faq-large-cache-key
# 1. use a attribute of the data
# 2. use the dependency of the data
system.time(rlang::hash(ggplot2::diamonds))

for (i in 1:1000) {
  start1 <- Sys.time()
  rlang::hash(ggplot2::diamonds)
  t1 <- Sys.time() - start1

  start2 <- Sys.time()
  rlang::hash("2020")
  t2 <- Sys.time() - start2
  if (t1 <= t2) {
    print("FALSE")
    break
  }
}

# bindCache renderPlot
library(shiny)
library(magrittr)
shinyApp(
  fluidPage(
    sidebarLayout(
      sidebarPanel(
        sliderInput("n", "Number of points", 4, 32, value = 8, step = 4)
      ),
      mainPanel(plotOutput("plot"))
    )
  ),
  function(input, output, session) {
    output$plot <- renderPlot({
        Sys.sleep(2)  # Add an artificial delay
        rownums <- seq_len(input$n)
        plot(cars$speed[rownums], cars$dist[rownums],
          xlim = range(cars$speed), ylim = range(cars$dist))
      }) %>%
      bindCache(input$n)
  }
)

# bindCache and bindEvent
shinyApp(
  ui = fluidPage(
    sliderInput("x", "x", 1, 10, 5),
    sliderInput("y", "y", 1, 10, 5),
    actionButton("go", "Go"),
    div("x * y: "),
    verbatimTextOutput("txt")
  ),
  server = function(input, output) {
    r <- reactive({
      message("Doing expensive computation...")
      Sys.sleep(2)
      input$x * input$y
    }) %>%
      bindCache(input$x, input$y) %>%
      bindEvent(input$go)
      # first executes bindEvent(input$go), then bindCache(input$x, input$y) and finally
      # if the hashed list(input$x, input$y) isn't cached it will run the reactive expr

    output$txt <- renderText(r())
  }
)
# These are equivalent:
# eventReactive(input$button, { ... })
# reactive({ ... }) %>% bindEvent(input$button)