library(shiny)
library(shinydashboard)
library(leaflet)
library(tidyverse)

task_data <- data.frame(text = c("A text"), value = c(10))
load(file = "nasa_fireball.rda")

sapply(nasa_fireball, anyNA)
nasa_fireball <- nasa_fireball %>% drop_na(c(lat, lon))

n_us <- sum(
  ifelse(
    nasa_fireball$lat < 64.9 & nasa_fireball$lat > 19.5
    & nasa_fireball$lon < -68.0 & nasa_fireball$lon > -161.8,
    1, 0),
  na.rm = TRUE)

body <- dashboardBody(
  fluidRow(
    box(
      width = 12,
      title = "Regular Box, Row 1",
      "Star Wars, nothing but Star Wars",
      status = "danger"
    )
  ),
  fluidRow(
    column(
      width = 4,
      infoBox(
        width = NULL,
        title = "Regular Box, Row 2, Column 1",
        subtitle = "Gimme those Star Wars",
        icon = icon("star")
      )
    ),
    column(
      width = 4,
      infoBox(
        width = NULL,
        title = "Regular Box, Row 2, Column 2",
        subtitle = "Don't let them end",
        color = "yellow"
      )
    ),
    valueBoxOutput("us_box")
  ),
  valueBoxOutput("click_box"),
  tableOutput("table"),
  tabItems(
    tabItem("dashboard", "Dashboard tab"),
    tabItem("inputs", "Inputs tab")
  ),
  leafletOutput("plot")
)

ui <- dashboardPage(
  skin = "purple",
  header = dashboardHeader(
    dropdownMenuOutput("task_menu")
  ),
  sidebar = dashboardSidebar(
    sliderInput(inputId = "threshold", label = "Color Threshold", min = 0, max = 100, value = 10),
    actionButton("click", "Update click box"),
    sidebarMenu(
      menuItem("Dashboard", tabName = "dashboard"),
      menuItem("Inputs", tabName = "inputs")
    )
  ),
  body = body
)

server <- function(input, output, session) {
    # reactive boxes
    output$us_box <- renderValueBox({
      valueBox(
        width = 4,
        value = n_us,
        subtitle = "Number of Fireballs in the US",
        icon = icon("globe"),
        color = ifelse(n_us < input$threshold, "blue", "fuchsia")
      )
    })

    output$click_box <- renderValueBox({
      valueBox(
        value = input$click,
        subtitle = "Click Box"
      )
    })

    # reactive dropdownMenu
    output$task_menu <- renderMenu({
      tasks <- apply(task_data, 1, function(row) {
        taskItem(text = row[["text"]], value = row[["value"]])
      })
      dropdownMenu(type = "tasks", .list = tasks)
      # type = "tasks, messages, notifications",
      # taskItem messageItem and notificationItem
    })

    # real-time data
    reactive_starwars_data <- reactiveFileReader(
      intervalMillis = 1000,
      session = session,
      filePath = "starwars.csv",
      readFunc = function(filePath) {
          read.csv(filePath)
        }
    )

    output$table <- renderTable({
      reactive_starwars_data()
    })

    output$plot <- renderLeaflet({
      leaflet() %>%
        addTiles() %>%
        addCircleMarkers(
          lng = nasa_fireball$lon,
          lat = nasa_fireball$lat,
          radius = log(nasa_fireball$impact_e),
          label = nasa_fireball$date,
          weight = 2
        )
  })
}

shinyApp(ui, server)