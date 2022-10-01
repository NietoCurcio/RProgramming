library(shiny)
library(rsconnect)

runApp("./HelloShiny", display.mode = "showcase")
runApp("./Lesson2", display.mode = "showcase")
runApp("./Lesson4", display.mode = "showcase")
runApp("./Lesson5", display.mode = "showcase")
runApp("./Lesson6", display.mode = "showcase")

rsconnect::deployApp(file.path(getwd(), "leaflet", "shinyApps", "choropleth"))

runExample("01_hello")      # a histogram
runExample("02_text")       # tables and data frames
runExample("03_reactivity") # a reactive expression
runExample("04_mpg")        # global variables
runExample("05_sliders")    # slider bars
runExample("06_tabsets")    # tabbed panels
runExample("07_widgets")    # help text and submit buttons
runExample("08_html")       # Shiny app built from HTML
runExample("09_upload")     # file upload wizard
runExample("10_download")   # file download wizard
runExample("11_timer")      # an automated timer