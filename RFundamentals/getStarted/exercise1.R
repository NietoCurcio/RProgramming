N <- 100000
betweenMinusOneandOne <- 0
#betweenMinusOneandOneVector <- c()
betweenMinusOneandOneVector <- rep(0, N)
#for (i in 1:N) {
#  x <- rnorm(1)
#  betweenMinusOneandOneVector[i] <- x
  
#  if (x > -1 & x < 1) betweenMinusOneandOne <- betweenMinusOneandOne + 1
#}


numbers = rnorm(N)
for (i in 1:length(numbers)) {
  betweenMinusOneandOneVector[i] <- numbers[i]
   
  if (numbers[i] > -1 & numbers[i] < 1) betweenMinusOneandOne <- betweenMinusOneandOne + 1 
}


target = 0.682
predicted <- betweenMinusOneandOne / N

betweenMinusOneandOneVector <- betweenMinusOneandOneVector[
  betweenMinusOneandOneVector > -1 & betweenMinusOneandOneVector < 1
]
predicted2 <- length(betweenMinusOneandOneVector) / N

# or just
between <- numbers[numbers > -1 & numbers < 1]
predicted3 <- length(between) / N

error <- target - predicted2

library(ggplot2)

df_numbers = data.frame(numbers)

plt <- ggplot(data=df_numbers, aes(x=numbers))
plt + geom_histogram(binwidth = 0.1)
plt +
  geom_density(aes(fill=numbers), position="stack") +
  xlim(-3,3)



