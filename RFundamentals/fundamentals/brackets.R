x <- c(1,534, 254, 12) # combine
y <- seq(200, 300, 11) # sequence
z <- rep("hi", 3) # replicate

w <- c("a", "b", "c", "d", "e")
w

w[1]
w[5]
w[-1]
w[-3]
w[w != "a"]
w[1:3]
w[c(1,3,5)]
w[c(-2, -4)]
w[-3:-5]

w[7]
w[0]
w[-7]

# In javascript everything is an object

# in R everything is a vector, hence we won't be accessing
# one, two or isolated elements in a vector, since it is a vectorized language
# very attached to linear algebra