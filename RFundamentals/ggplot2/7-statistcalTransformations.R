#---------- Statistical Transformations

# geom_smooth
?geom_smooth
# helps seeing trends, dependencies, patterns, interrelations

u <- ggplot(data=movies, aes(
  x=CriticRating,
  y=AudienceRating,
  colour=Genre
))
u + geom_point() + geom_smooth(fill=NA)

u <- ggplot(data=movies, aes(
  x=Genre,
  y=AudienceRating,
  colour=Genre
))
u + geom_boxplot()
u + geom_boxplot(size=1.2)
u + geom_boxplot(size=1.2) + geom_point()
# tip / hack
u + geom_boxplot(size=1.2) + geom_jitter()
u + geom_jitter() + geom_boxplot(size=1.2, alpha=0.5)

# >>> 6
u <- ggplot(data=movies, aes(
  x=Genre,
  y=CriticRating,
  colour=Genre
))
u + geom_jitter() + geom_boxplot(size=1.2, alpha=0.5)
