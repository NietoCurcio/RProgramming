MyFirstVector <- c(3, 45, 84, 76) # c like concatenate, combine

is.array(MyFirstVector)
is.atomic(MyFirstVector)
is.vector(MyFirstVector)
is.numeric(MyFirstVector)
is.integer(MyFirstVector)
is.double(MyFirstVector)
is.array(array(MyFirstVector))

# Matrices
array(MyFirstVector, dim=c(4,4,1))
array(c(1:3, MyFirstVector), dim=c(4,4,1))
array(c(1:3, MyFirstVector), dim=c(3,3,1))


is.integer(as.integer(2))
is.integer(as.double(2))
is.integer(as.numeric(2))

V2 <- c(3L, 4L, 5L, 6L)
is.numeric(V2)
is.integer(V2)
is.double(V2)

V3 <- c("A", 3, "Hello")
is.character(V3)

seq() # sequence like ':'
rep() # replicate

seq(1,15)
1:15
seq(1,15,2)
a <- 1:15
b <- a
c <- rep(a)
a[1] <- 99
b
c

rep(3, 50)
d <- rep(2,5)
rep("a", 5)

x <- c(60,80)
rep(x, 10)
length(rep(x, 10))

