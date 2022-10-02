m <- module({
  .moduleData <- "module data, string property"
  fun <- function() {
    ## A function for illustrating documentation
    ## () empty args (ad-hoc docs)
    privateFun()
  }
  privateFun <- function() paste("fun helper", .moduleData)

  export("fun")
})