#---------- Coordinates

# 1.limits
# 2. zoom

m <- ggplot(data=movies, aes(
  x=CriticRating, y=AudienceRating, size=BudgetMillions, colour=Genre
))
m + geom_point()
m + geom_point() + xlim(50, 100) + ylim(50, 100)

# won't work well always
n <- ggplot(data=movies, aes(
  x=BudgetMillions
))
n + geom_histogram(binwidth = 10, aes(fill=Genre), colour="Black") + ylim(0, 50)

# instead, zoom
n + geom_histogram(binwidth = 10, aes(fill=Genre), colour="Black") +
  coord_cartesian(ylim=c(0, 50))

# improve >>> 1
w + geom_point(aes(size=BudgetMillions)) +
  geom_smooth() +
  facet_grid(Genre~Year) +
  coord_cartesian(ylim=c(0,100))
