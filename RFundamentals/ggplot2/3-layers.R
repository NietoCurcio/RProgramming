#---------- Plotting with layers

# in ggplot every time you want to add a layer
# you have to literally add with plus sign +
# so for adding geometry layer is + geom_point()

# there are 7 layers:
# Data, Aesthetics, Geometry, Statistics, Facets, Coordinates, Theme
p <- ggplot(data=movies, aes(
  x=CriticRating,
  y=AudienceRating,
  color=Genre,
  size=BudgetMillions)
)
# p is a object

# points
p + geom_point()

# lines
p + geom_line()

# multiple layers
p + geom_point() + geom_line()
p + geom_line() + geom_point()
p + geom_boxplot() + geom_point()
p + geom_point() + geom_boxplot(alpha=0.5)
p + geom_col() + geom_point()
p + geom_density_2d() + geom_point()
p + geom_path()
