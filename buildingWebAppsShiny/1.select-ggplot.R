library(shiny)
library(ggplot2)
library(tidyverse)
library(plotly)

load(file.path(getwd(), "buildingWebAppsShiny", "movies.RData"))

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "x",
        label = "X-axis:",
        choices = c(
          "IMDB rating" = "imdb_rating",
          "IMDB number of votes" = "imdb_num_votes",
          "Critics score"        = "critics_score",
          "Audience score"       = "audience_score",
          "Runtime"              = "runtime"
        ),
        selected = "audience_score"
      ),
      selectInput(
        inputId = "y",
        label = "Y-axis:",
        choices = c(
          "IMDB rating" = "imdb_rating",
          "IMDB number of votes" = "imdb_num_votes",
          "Critics score" = "critics_score",
          "Audience score" = "audience_score",
          "Runtime" = "runtime"
        ),
        selected = "critics_score"
      ),
      selectInput(
        inputId = "z",
        label = "Color by:",
        choices = c(
          "Title type" = "title_type",
          "Genre" = "genre",
          "MPAA rating" = "mpaa_rating",
          "Critics rating" = "critics_rating",
          "Audience rating" = "audience_rating"
        ),
        selected = "mpaa_rating"
      ),
      sliderInput(
        inputId = "alpha",
        label = "Alpha:",
        min = 0, max = 1,
        value = 0.5
      )
    ),
    mainPanel(
      plotly::plotlyOutput(outputId = "scatterplot"),
      plotOutput(outputId = "densityplot", height = 200),
      htmlOutput(outputId = "avg_x"),
      textOutput(outputId = "avg_y"),
      verbatimTextOutput(outputId = "lmoutput")
    )
  )
)

server <- function(input, output, session) {
  output$scatterplot <- plotly::renderPlotly({
    ggplot(
      data = movies,
      aes_string(x = input$x, y = input$y, color = input$z)
    ) + geom_point(alpha = input$alpha)
  })

  output$densityplot <- renderPlot({
    ggplot(data = movies, aes_string(x = input$x)) +
      geom_density()
  })

  output$avg_x <- renderUI({
    avg_x <- movies %>% pull(input$x) %>% mean() %>% round(2)
    str_x <- paste("Average", input$x, "=", avg_x)
    HTML(paste0("<strong>", str_x, "</strong>"))
  })

  output$avg_y <- renderText({
    avg_y <- movies %>% pull(input$y) %>% mean() %>% round(2)
    str_y <- paste("Average", input$y, "=", avg_y)
    paste("Avg y:", str_y)
  })

  output$lmoutput <- renderPrint({
    x <- movies %>% pull(input$x)
    y <- movies %>% pull(input$y)
    print(summary(lm(y ~ x, data = movies)), digits = 3, signif.stars = FALSE)
  })
}

shinyApp(ui = ui, server = server)
