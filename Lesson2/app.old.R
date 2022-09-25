library(shiny)

ui <- fluidPage(
  navbarPage(
    "nav bar app title",
    tabPanel("Plot"),
    tabPanel("Summary")
  ),
  titlePanel("title panel"),
  sidebarLayout(
    # position = "right"
    sidebarPanel(
      h1(
        a("Heading 1 sidebarPanel", href = "https://www.google.com")
      ),
      h2("Second level title", align = "center")
    ),
    # mainPanel(
    #   div(
    #     p("main panel image"),
    #     img(
    #       src = "https://static.wikia.nocookie.net/ptstarwars/images/c/cc/Star-wars-logo-new-tall.jpg",
    #       alt = "Shiny image",
    #       width = "200px"
    #     )
    #   )
    # ), using HTML:
    mainPanel(
      HTML(
        "
        <div>
          <p>main panel image</p>
          <img
            src='https://static.wikia.nocookie.net/ptstarwars/images/c/cc/Star-wars-logo-new-tall.jpg'
            alt = 'Shiny image'
            width = '200px'
          />
        </div>  
        "
      )
    )
  ),
  fluidRow(
    column(4, "column 1"),
    column(4, "column 2"),
    column(2, "column 3"),
    column(2, "column 4"),
  )
)

server <- function(input, output) {
  
}

shinyApp(ui = ui, server = server)