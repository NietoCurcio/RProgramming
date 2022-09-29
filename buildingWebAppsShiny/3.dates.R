library(shiny)
library(ggplot2)
library(dplyr)

load(file.path(getwd(), "buildingWebAppsShiny", "movies.RData"))
min_date <- min(movies$thtr_rel_date)
max_date <- max(movies$thtr_rel_date)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      HTML(
        str_glue(
          "<p>Movies released between the following dates will be plotted. 
          Pick dates between ", min_date, " and ", max_date, ".
          </p>"
        )
      ),

      br(), br(),

      dateRangeInput(
        inputId = "date",
        label = "Select dates:",
        start = "2013-01-01", end = "2014-01-01",
        min = min_date, max = max_date,
        startview = "year"
      )
    ),

    mainPanel(
      plotOutput(outputId = "scatterplot")
    )
  )
)

server <- function(input, output, session) {
  output$scatterplot <- renderPlot({
    print("FELIPE")
    print(input$date[1])
    print(as.POSIXct(input$date[1]))
    print(as.POSIXlt(input$date[1]))

    movies_selected_date <- movies %>%
      filter(
        thtr_rel_date >= as.POSIXct(input$date[1]) & thtr_rel_date <= as.POSIXct(input$date[2])
      )

    ggplot(
      data = movies_selected_date,
      aes(x = critics_score, y = audience_score, color = mpaa_rating)
    ) + geom_point()
  })
}

shinyApp(ui = ui, server = server)
