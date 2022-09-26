setwd("C:\\Users\\Felipe\\Documents\\Felipe\\Anotacoes\\FioCruzEstagio\\Projects\\RStudio")
getwd()

movies <- read.csv('./ggplot2/P2-Movie-Ratings.csv')
head(movies)
colnames(movies) <- c("Film", "Genre", "CriticRating", "AudienceRating", "BudgetMillions", "Year")
head(movies)
tail(movies)
str(movies)

library(ggplot2)
