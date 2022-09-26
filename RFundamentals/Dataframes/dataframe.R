a <- c(1,2,3)
b <- c(4,5,6)
c <- c(7,8,9)

data <- rbind(a,b,c)

data <- data.frame(data)
data

data[data$X2 == 2 | data$X2 == 5,]

filter <- data$X2 %in% c(2,5)
data[filter,]
