library(shiny)
library(ggplot2)
library(dplyr)

load(file.path(getwd(), "buildingWebAppsShiny", "movies.RData"))

ui <- fluidPage(
  br(),
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "y", label = "Y-axis:",
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
        selected = "audience_score"
      ),
      selectInput(
        inputId = "x", label = "X-axis:",
        choices = c("imdb_rating", "imdb_num_votes", "critics_score", "audience_score", "runtime"),
        selected = "critics_score"
      )
    ),

    mainPanel(
      plotOutput(outputId = "scatterplot", hover = "plot_hover"),
      dataTableOutput(outputId = "moviestable"),
      br()
    )
  )
)

server <- function(input, output, session) {
  output$scatterplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x, y = input$y)) +
      geom_point()
  })

  output$moviestable <- renderDataTable({
    nearPoints(movies, input$plot_hover) %>%
      select(title, audience_score, critics_score)
  })
}

shinyApp(ui = ui, server = server)
