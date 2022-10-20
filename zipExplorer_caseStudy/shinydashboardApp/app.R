library(tidyverse)
library(shinydashboard)
library(leaflet)
library(shiny)
# library(scales)
# library(lattice)

# Using app.R we have to call source("global.R")
# Using the modularized version with ui.R, and server.R, global.R is sourced automatically
source("global.R")
# I've had to repeat the global.R code inside the app folder as well as the .csv data files
# to deploy in shinyapps.io

# There's a way to build modularized code with namespaces using the NS function,
# but unfortunately it adds more complexity to our app
# https://shiny.rstudio.com/articles/modules.html

set.seed(100)
zipdata <- allzips
zipdata <- zipdata[order(zipdata$centile), ]

showZipcodePopup <- function(zip_code, lat, lng) {
  selectedZip <- allzips %>% filter(zipcode == zip_code)

  content <- str_glue(
    "
    <h4>Score: {round(selectedZip$centile)}</h4>
    <strong>{selectedZip$city.x}, {selectedZip$state.x} {selectedZip$zipcode}</strong>
    <br>
    <span>Median household income: {scales::dollar(selectedZip$income * 1000)}</span>
    <br>
    <span>Percent of adults with BA: {round(selectedZip$college)}%</span>
    <br>
    <span>Adult population: {selectedZip$adultpop}</span>
    "
    ) %>% HTML

  leafletProxy("map") %>% addPopups(lng = lng, lat = lat, popup = content, layerId = zip_code)
}

header <- dashboardHeader(title = "Zip explorer - Study")

sidebar <- dashboardSidebar(
  sidebarMenu(
      menuItem("Interactive map", tabName = "interactiveMap"),
      menuItem("Data explorer", tabName = "dataExplorer")
    )
)

selectOptions <- c(
  "Is SuperZIP?" = "superzip",
  "Centile score" = "centile",
  "College education" = "college",
  "Median income" = "income",
  "Population" = "adultpop"
)

body <- dashboardBody(
  tags$header(
    includeCSS("www/styles.css"),
    includeScript("www/gomap.js"),
    tags$link(
      rel = "stylesheet",
      href = "https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.2.0/css/all.min.css",
      integrity = "sha512-xh6O/CkQoPOWDdYTDqeRdPCVd1SpvCA9XXcUnZS2FmJNp1coAFzvtCN9BmamE+4aHK8yyUHUSCcJHgXloTyT2A==",
      crossorigin = "anonymous",
      referrerpolicy = "no-referrer"
    )
  ),
  tabItems(
    tabItem(
      tabName = "interactiveMap",
      tags$main(
        class = "map-content",
        leafletOutput("map", width = "100%", height = "100%"),
        absolutePanel(
          id = "controls",
          class = "panel panel-default",
          fixed = TRUE,
          draggable = TRUE,
          top = 60,
          right = 20,
          width = 330,
          h2("ZIP explorer"),
          selectInput("color", "Color", selectOptions),
          selectInput("size", "Size", selectOptions, selected = "adultpop"),
          conditionalPanel(
            "input.color == 'superzip' || input.size == 'superzip'",
            numericInput("threshold", "SuperZIP threshold (top n percentile)", 5)
          ),
          plotOutput("histCentile", height = 200),
          plotOutput("scatterCollegeIncome", height = 250)
        ),
        p(
          class = "cite",
          "Data compiled for ",
          em("Coming Apart: The State of White America, 1960–2010"),
          "by Charles Murray (Crown Forum, 2012)."
        )
      )
    ),
    tabItem(
      tabName = "dataExplorer",
      div(
        style = "padding: 2rem;",
        fluidRow(
          column(3,
            selectInput(
              inputId = "states",
              label = "States",
              choices = c(
                "All states" = "",
                structure(state.abb, names = state.name),
                "Washington, DC" = "DC"
              ),
              multiple = TRUE
            )
          ),
          column(3,
            conditionalPanel(
              "input.states",
              selectInput(
                inputId = "cities",
                label = "Cities",
                choices = c("All cities" = ""),
                multiple = TRUE)
            )
          ),
          column(3,
            conditionalPanel(
              "input.states",
              selectInput(
                inputId = "zipcodes",
                label = "Zipcodes",
                choices = c("All zipcodes" = ""),
                multiple = TRUE)
            )
          )
        ),
        fluidRow(
          column(1,
            numericInput(
              inputId = "minScore",
              label = "Min score",
              min = 0,
              max = 100,
              value = 0
            )
          ),
          column(1,
            numericInput(
              inputId = "maxScore",
              label = "Max score",
              min = 0,
              max = 100,
              value = 100
            )
          )
        ),
        hr(),
        DT::dataTableOutput("ziptable")
      )
    )
  )
)


ui <- dashboardPage(header, sidebar, body)

server <- function(input, output, session) {
  output$map <- renderLeaflet({
    leaflet() %>%
      addTiles() %>%
      setView(lng = -93.85, lat = 37.45, zoom = 4)
  })

  zipsInBounds <- reactive({
    # likewise "input$map_shape_click"
    if (is.null(input$map_bounds)) return(zipdata[FALSE, ])

    bounds <- input$map_bounds

    # range to get minimun value in index [1] and max in [2]
    latRng <- range(bounds$north, bounds$south)
    lngRng <- range(bounds$east, bounds$west)

    zipdata %>% filter(
      latitude >= latRng[1] & latitude <= latRng[2],
      longitude >= lngRng[1] & longitude <= lngRng[2]
    )
  })

  output$histCentile <- renderPlot({
    if (nrow(zipsInBounds()) == 0) return(NULL)

    ggplot(zipsInBounds(), aes(x = centile)) +
      geom_histogram(bins = 20, fill = "#00DD00", color = "white") +
      ggtitle("SuperZIP score (visible zips)") +
      xlab("Percentile") +
      ylab("Frequency") +
      xlim(range(allzips$centile)) +
      theme(
        axis.title.x = element_text(size = 13),
        axis.title.y = element_text(size = 13),
        axis.text.x = element_text(size = 12),
        axis.text.y = element_text(size = 12),
        plot.title = element_text(size = 14, face = "bold")
      )
  })

  output$scatterCollegeIncome <- renderPlot({
    if (nrow(zipsInBounds()) == 0) return(NULL)

    ggplot(data = zipsInBounds(), aes(x = college, y = income)) +
      geom_point(colour = "blue", shape = 21) +
      xlim(range(allzips$college)) +
      ylim(range(allzips$income)) +
      theme(
        axis.title.x = element_text(size = 12),
        axis.title.y = element_text(size = 12),
        axis.text.x = element_text(size = 11),
        axis.text.y = element_text(size = 11),
      )
  })

  observe({
    colorBy <- input$color
    sizeBy <- input$size

    if (colorBy == "superzip") {
      colorData <- ifelse(zipdata$centile >= (100 - input$threshold), "yes", "no")
      pal <- colorFactor("viridis", colorData)
    } else {
      colorData <- zipdata[[colorBy]]
      pal <- colorBin("viridis", colorData, 7, pretty = FALSE)
    }

    if (sizeBy == "superzip")
      radius <- ifelse(zipdata$centile >= (100 - input$threshold), 30000, 3000)
    else
      radius <- zipdata[[sizeBy]] / max(zipdata[[sizeBy]]) * 30000

    leafletProxy("map", data = zipdata) %>%
      # clearMarkers() %>%
      clearShapes() %>% # clearShapes makes a blink effect
      addCircles(
        lng = ~longitude,
        lat = ~latitude,
        radius = radius,
        stroke = FALSE,
        fillOpacity = 0.4,
        fillColor=pal(colorData),
        layerId = ~zipcode
      ) %>% addLegend(
        position = "bottomleft",
        pal = pal,
        values = colorData,
        title = colorBy,
        layerId = "colorLegend"
      )
  })

  observe({
    event <- input$map_shape_click

    leafletProxy("map") %>% clearPopups()

    if (is.null(event)) return()

    isolate({
      showZipcodePopup(event$id, event$lat, event$lng)
    })
  })


  # Data Explorer -------------------------------

  observe({
    states <- input$states

    cities <- if (is.null(states)) {
      character(0)
    } else {
      cleantable %>% filter(State %in% states) %>% pull(City) %>% unique() %>% sort()
    }

    stillSelected <- isolate(input$cities[input$cities %in% cities])

    updateSelectizeInput(
      session = session,
      inputId = "cities",
      choices = cities,
      selected = stillSelected,
      server = TRUE
    )
  })

  observe({
    states <- input$states

    zipcodes <- if (is.null(states)) {
      character(0)
    } else {
      cleantable %>% filter(
        State %in% states,
        is.null(input$cities) | City %in% input$cities
      ) %>% pull(Zipcode) %>% unique() %>% sort()
    }

    stillSelected <- isolate(input$zipcodes[input$zipcodes %in% zipcodes])

    # "zipcodes" vector ir large
    # it uses server-side selectize to improve performance
    updateSelectizeInput(
      session = session,
      inputId = "zipcodes",
      choices = zipcodes,
      selected = stillSelected,
      server = TRUE
    )
  })

  output$ziptable <- DT::renderDataTable({
    df <- cleantable %>%
      filter(
        Score >= input$minScore,
        Score <= input$maxScore,
        is.null(input$states) | State %in% input$states,
        is.null(input$cities) | City %in% input$cities,
        is.null(input$zipcodes) | Zipcode %in% input$zipcodes
      ) %>%
      mutate(
        Action = str_glue(
          "
          <a
            class='go-map'
            href=''
            data-lat={Lat}
            data-long={Long}
            data-zip={Zipcode}
          >
            <i class='fas fa-crosshairs'></i>
          </a>
          "
        )
      )

    action <- DT::dataTableAjax(session, df, outputId = "ziptable")

    DT::datatable(df, options = list(ajax = list(url = action)), escape = FALSE)
  })

  observe({
    if (is.null(input$gotozipcode)) return()

    isolate({
      event <- input$gotozipcode

      map <- leafletProxy("map")
      map %>% clearPopups()
      dist <- 0.5
      zip <- event$zip
      lat <- event$lat
      lng <- event$lng
      showZipcodePopup(zip, lat, lng)
      map %>% fitBounds(
        lng1 = lng - dist,
        lat1 = lat - dist,
        lng2 = lng + dist,
        lat2 = lat + dist
      )
    })
  })
}

shinyApp(ui, server)