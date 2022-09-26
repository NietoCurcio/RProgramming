# factor is a categorical variable
levels(movies$Genre)

movies$Genre <- factor(movies$Genre)
levels(movies$Genre)

str(movies)
summary(movies)

movies$Year <- factor(movies$Year)
summary(movies)
