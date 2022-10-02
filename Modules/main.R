library(modules)
library(shiny)

# https://cran.r-project.org/web/packages/modules/vignettes/modulesAsFiles.html
# https://cran.r-project.org/web/packages/modules/vignettes/modulesAsObjects.html
# https://cran.r-project.org/web/packages/modules/vignettes/modulesInR.html

# the difference between source function and the use of modules with import and export
# is that source functions loads data in the global environment. Modules are isolated
# from the global environment, it only know about its local scope inside {}

getwd()
setwd(file.path(getwd(), "Modularized"))

libs <- modules::use("R") # we can load a single file
data <- read.csv("./data/example.csv")

libs$helpers$getDivison(5, 2) # calling private function
libs$helpers$divideNums(5, 2)
libs$helpers2$m$fun()
libs$helpers2$m$privateFun() # calling private function

libs$graphics$histPlot(
  dataframe = data.frame(v = rnorm(1000)),
  binWidth = 0.1,
  x_axis = "v"
)

libs$graphics$barPLot(
  dataframe = data,
  x_axis = "class"
)

# Modules ----------------------------------------------------------------------------

m <- module({
  import("ggplot2")

  divideNums <- function(a, b) {
    c(a / b, a %% b)
  }
  sumNums <- function(a, b) {
    a + b
  }

  histPlot <- function(dataframe, binWidth, x_axis) {
    ggplot(data = dataframe, aes_string(x = x_axis)) + geom_histogram(binwidth = binWidth)
  }
})

m$histPlot(
  dataframe = data.frame(v = rnorm(1000)),
  binWidth = 0.1,
  x_axis = "v"
)

m2 <- function(x) {
  amodule({
    fun <- function() {
      paste("hello", x)
    }
  })
}

m2("felipe")$fun()

# Dependency injection - DIP
a <- module({
  hello <- function() "hello"
})

B <- function(a) {
  amodule({
    helloName <- function(name) {
      paste(a$hello(), name)
    }
  })
}
b <- B(a)
b$helloName("Felipe")

# Mutable Module, objects in other languages

mutableModule <- module({
  .num <- NULL
  getNum <- function() .num
  setNum <- function(val) .num <<- val
})
mutableModule$get()
mutableModule$set(2)

complectModule <- module({
  # suppressMessages(use(mutableModule, attach = TRUE, reInit = FALSE))
  # use(mutableModule, attach = TRUE, reInit = FALSE)
  use(mutableModule, attach = TRUE)
  getNum2 <- function() {
    getNum()
  }
  setNum(3)
})
mutableModule$getNum() # if reInit = False, mutableModule$getNum() returns 3
complectModule$getNum2()

# "Inheritance" on modules

A <- function() {
  amodule({
    aValue <- "aValue"
    foo <- function() "foo"
    setAValue <- function(val) aValue <<- val
    getAValue <- function() aValue
  })
}

eae2 <- 3
B <- function(a) {
  amodule({
    # eae <- eae2, since modules are isolated from global env, this would trigger not found err
    .eae <- 3 #.named makes it a private prop
    expose(a)
    bar <- function() "bar"
    foo <- function() paste("foo2", .privateFun()) # override
    getEae <- function() .eae
    setEae <- function(val) .eae <<- val
    .privateFun <- function() "privateFun"
  })
}

obj1 <- B(A())
obj1$foo()
obj1$bar()
obj1$getEae()
obj1$setEae(4)
obj1$getEae()
obj1$.eae

# inherited property
obj1$aValue
obj1$setAValue("aValue2")
obj1$aValue
obj1$getAValue()
obj1$privateFun

obj2 <- B(A())
obj2$getEae()
obj2$setEae(obj2$getEae() + 2)
obj2$getEae()
obj2$.eae

B(A())$getEae()
getSearchPathContent(obj2)

# "extend" - real use case for testing:

a <- module({
  foo <- function() "foo"
})

extend(a, {
  stopifnot(foo() == "foo")
})

# Conclusions

# We can make modularized programming with modules package
# It's possible to make OOP programming with R6 package.

# For data analysis, it is not always worthy applyings OOP and modularization.