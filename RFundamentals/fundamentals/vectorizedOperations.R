# Vectors in R are pretty much numpy arrays in python
a <- c(1,2,3)
b <- c(4,5,6)
a + b

a <- c(1,2)
b <- c(4,5,6,7)
a+b

a <- c(1,2,3)
b <- c(4,5,6,7)
a+b

a <- c(1,2,3,4,5,6,7,8)
a[a > 2]


# Operations

x <- rnorm(5)

for(i in x) {
  print(i)
}

for (i in 1:length(x)) {
  print(x[i])
}

N <- 1000000
a <- rnorm(N)
b <- rnorm(N)

# Vectorized operation approach

start <- Sys.time()

c <- a * b

end <- Sys.time()
print(end - start)

# De-vectorized operation approach

start <- Sys.time()

d <- rep(NA, N)
for (i in 1:N) {
  d[i] <- a[i] * b[i]
}

end <- Sys.time()
print(end - start)

# Vectorized is faster, R is high-level programming language, the vectorized 
# operations and function calls is delegating those things to programming languages
# like C in the background (pretty much like Python functions)

# Vectors contain only data of the same type