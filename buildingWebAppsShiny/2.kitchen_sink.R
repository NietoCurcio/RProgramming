library(shiny)
library(ggplot2)
library(dplyr)
library(DT)
options("shiny.sanitize.errors" = FALSE) # Turn off error sanitization

load(file.path(getwd(), "buildingWebAppsShiny", "movies.RData"))
all_studios <- sort(unique(movies$studio))
n_total <- nrow(movies)

ui <- fluidPage(
  sidebarLayout(
    sidebarPanel(
      selectInput(
        inputId = "studio",
        label = "Select studio:",
        choices = all_studios,
        selected = "20th Century Fox",
        multiple = TRUE
      ),
      numericInput(
        inputId = "table_entry",
        label = "Sample ID:",
        value = 1,
        min = 1, max = n_total,
        step = 1
      ),
      tableOutput("table"),
      radioButtons(
        inputId = "filetype",
        label = "Select filetype:",
        choices = c("csv", "tsv"),
        selected = "csv"
      ),
      checkboxGroupInput(
        inputId = "selected_var",
        label = "Select variables:",
        choices = names(movies),
        selected = c("title")
      ),
      verbatimTextOutput("total"),
      downloadButton("download_data", "Download data"),
      br(),
      actionButton(
        inputId = "increment_counter",
        label = "Increment"
      ),
      actionButton(
        inputId = "decrement_counter",
        label = "Decrement"
      ),
      textInput(inputId = "counter", label = "Counter:", value = 1)
    ),
    mainPanel(
      dataTableOutput(outputId = "moviestable")
    )
  )
)

server <- function(input, output, session) {

  movies_from_selected_studios <- reactive({
    movies %>%
      filter(studio %in% input$studio)
  })

  movies_from_selected_columns <- reactive({
    movies_from_selected_studios() %>% select(input$selected_var)
  })

  output$moviestable <- renderDataTable({
    DT::datatable(
      data = movies_from_selected_columns(),
      options = list(pageLength = 10),
      rownames = FALSE
    )
  })

  output$total <- renderPrint({
    print("Total movies from selected studios:")
    print(nrow(movies_from_selected_studios()))
  })

  output$table <- renderTable({
    movies[input$table_entry, ] %>% select(title:genre)
  })

  output$download_data <- downloadHandler(
    filename = function() {
      paste0("movies.", input$filetype)
    },
    content = function(file) {
      if (input$filetype == "csv") {
        write_csv(movies_from_selected_columns(), file)
      }
      if (input$filetype == "tsv") {
        write_tsv(movies_from_selected_columns(), file)
      }
    }
  )

  counter <- eventReactive(
    eventExpr = input$increment_counter & input$decrement_counter,
    valueExpr = {
      as.integer(input$counter)
    }
  )

  observeEvent(input$increment_counter, {
    updateTextInput(inputId = "counter", value = counter() + 1)
  })

  observeEvent(input$decrement_counter, {
    updateTextInput(inputId = "counter", value = counter() - 1)
  })
}

shinyApp(ui = ui, server = server)
