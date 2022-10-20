library(shiny)

runApp("./zipExplorer_caseStudy/shinyApp")
runApp("./zipExplorer_caseStudy/shinydashboardApp")

rsconnect::deployApp(file.path(getwd(), "zipExplorer_caseStudy", "shinydashboardApp"))
