library(shiny)

getwd()
setwd(file.path(getwd(), "Lesson2"))
addResourcePath("public", "./public")

ui <- fluidPage(
  titlePanel(h1("My Shiny App")),
  sidebarLayout(
    sidebarPanel(
      h1("Installation"),
      p("Shiny is available on CRAN, so you can install it in the usual way from your R console:"),
      code('install.packages("shiny")', style = "color:red; margin: 10px;"),
      br(),
      br(),
      img(src = "public/my_image.jpg", style = "width: 25rem;"),
      img(src = "https://static.wikia.nocookie.net/marvel_dc/images/4/4b/Batman_Vol_3_86_Textless.jpg", style = "width: 5rem;"),
      p("Shiny is a product of",
        a("RStudio", href = "https://www.rstudio.com/")),
      style = "width: 300px;"
    ),
    mainPanel(
     div(
       h1("Introduction to Shiny"),
       p("Shiny is a new package from RStudio that makes it", em("incredibly easy"), "to build interactive web applications with R."),
       br(),
       p("For an introduction and live examples, visit the", a("Shiny homepage", href = "https://shiny.rstudio.com/"))
     ),
     div(
       HTML(
         "<h1 style='color: blue; background: #ff0000;'>Features</h1>
          <li>
            Build userful web applications - no Javascript required.
          </li>
          <li>
          Shiny applications 'live' <strong>spreadsheets</strong> Outputs change instantly with browser.
          </li>
         "
       ))
     )
  )
)
server <- function(input, output) {
  
}
getwd()

shinyApp(ui = ui, server = server)
