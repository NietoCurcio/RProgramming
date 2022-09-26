library(maps)
library(mapproj)
library(stringr)

source("helpers.R")

counties <- readRDS("data/counties.rds")
colors <- c(white = "darkgreen", black = "black", hispanic = "orange", asian = "purple")

ui <- fluidPage(
  titlePanel("censusVis"),

  sidebarLayout(
    sidebarPanel(
      helpText("Create demographic maps with 
        information from the 2010 US Census."),
      selectInput("var",
                  label = "Choose a variable to display",
                  choices = c("Percent White" = "white", "Percent Black" = "black",
                              "Percent Hispanic" = "hispanic", "Percent Asian" = "asian"),
                  selected = "Percent White"),

      sliderInput("range",
                  label = "Range of interest:",
                  min = 0, max = 100, value = c(0, 100))
    ),

    mainPanel(plotOutput("map"))
  )
)

server <- function(input, output) {
  output$map <- renderPlot({
    percent_map(
      counties[, input$var],
      color = colors[input$var],
      str_interp("% ${input$var}"),
      min = input$range[1],
      max = input$range[2]
    )
  })

  # Or...
  # args <- switch(input$var,
  #     "white" = list(counties$white, "darkgreen", "% White"),
  #     "black" = list(counties$black, "black", "% Black"),
  #     "hispanic" = list(counties$hispanic, "darkorange", "% Hispanic"),
  #     "asian" = list(counties$asian, "darkviolet", "% Asian"))
  # # args$min <- input$range[1]
  # args[[4]] <- input$range[1]
  # args[[5]] <- input$range[2]
  # do.call(percent_map, args)
}

shinyApp(ui = ui, server = server)
