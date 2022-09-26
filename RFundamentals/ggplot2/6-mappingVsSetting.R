#---------- Mapping vs Setting

r <- ggplot(data=movies, aes(
  x=CriticRating, y=AudienceRating
))
r + geom_point()

# 1. Mapping (what we've done, mapping a color to a variable):
r + geom_point(aes(color=Genre))
# 2. Setting (not map, just set a color):
r + geom_point(color="DarkGreen")
# Errors:
# r + geom_point(aes(color="DarkGreen"))
# r + geom_point(color=Genre)

# 1. Mapping
r + geom_point(aes(size=BudgetMillions))
# 2. Setting
r + geom_point(size=10)
# Errors:
# r + geom_point(aes(size=10))
# r + geom_point(size=BudgetMillions)