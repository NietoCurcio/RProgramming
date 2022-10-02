# if export function it's not called, then all functions are exported

export("sumNums")
sumNums <- function(a, b) {
  a + b
}

export("divideNums")
divideNums <- function(a, b) {
    ## A function for illustrating documentation
    ## args: a (numeric), b (numeric)
    ## this functions divides a by b
  c(getDivison(a, b), getRestDivision(a, b))
}
#> divideNums:
#> function(a, b)
#> ## A function for illustrating documentation
#> ## args: a (numeric), b (numeric)
#> ## this functions divides a by b

getDivison <- function(a, b) {
  a / b
}

getRestDivision <- function(a, b) {
  a %% b
}