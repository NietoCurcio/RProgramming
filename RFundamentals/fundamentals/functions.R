#? operator

?rnorm
rnorm(n=5, mean=10, sd=8)
rnorm(n=5, sd=8, mean=10)

?c
seq(from=10, to=20, by=3)
seq(from=10, to=20, length.out=10)
x <- c("a", "b", "c")
A <- seq(from=10, to=20, along.with=x)
rep(x, times=5)
rep(x, each=5)

NULL
NA

#ggplot
#geom_point

print
paste

is.numeric
as.numeric
typeof

sqrt(A)

help("install.packages")
help(seq)
?seq

sum_numbers <- function(a, b) {
  result <- a + b
  return(result)
}

c <- sum_numbers(10,20)
c
