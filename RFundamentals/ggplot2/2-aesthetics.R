#---------- Aesthetics

# aesthetics = how your data maps to what you wanna see 
# (what is going to be the colors, the fills, the x,
#  and y axis, the size. It is what we can see)
ggplot(data=movies, aes(x=CriticRating, y=AudienceRating))

# add geometry = how we want the data, as squares, circles,
# lines, dots, bars and so on
ggplot(data=movies, aes(x=CriticRating, y=AudienceRating)) +
  geom_point()

# add color and size

# >>> 1
ggplot(data=movies, aes(
  x=CriticRating, y=AudienceRating, color=Genre, size=BudgetMillions)
) + geom_point()
