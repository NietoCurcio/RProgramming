#---------- Overriding Aesthetics

q <- ggplot(data=movies, aes(
  x=CriticRating,
  y=AudienceRating,
  color=Genre,
  size=BudgetMillions)
)


q + geom_point(aes(size=CriticRating))

q + geom_point(aes(color=BudgetMillions))
# q remains the same
q + geom_point()

# >>> 2
q + geom_point(aes(x=BudgetMillions)) + xlab("BudgetMillions $")

p + geom_line() + geom_point()
p + geom_line(size=1) + geom_point() # setting size = 1

# Mapping vs Setting
# mapping = aes(size=CriticRating)
# setting = size=1 
