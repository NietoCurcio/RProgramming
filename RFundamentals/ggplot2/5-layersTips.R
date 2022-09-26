#---------- Starting Layers Tips

t <- ggplot(data=movies, aes(x=AudienceRating))
t + geom_histogram(binwidth = 10, fill="White", colour="Blue")

normalDist_df <- data.frame(rnorm(1000))
colnames(normalDist_df) <- c("rnorm100")
colnames(normalDist_df)

mtx <- rbind(rnorm(10))
is.matrix(normalDist_df)
is.data.frame(normalDist_df)
as.data.frame(mtx)
mtx
as.data.frame(as.vector(mtx))

plt <- ggplot(data=normalDist_df, aes(x=rnorm100))
plt + geom_histogram(binwidth = 0.5, fill="White", colour="Blue")

# normal distribution
# >>> 4
t <- ggplot(data=movies)
t + geom_histogram(
  binwidth = 10,
  aes(x=AudienceRating),
  fill="White",
  colour="Blue"
)

# uniform distribution
t + geom_histogram(
  binwidth = 10,
  aes(x=CriticRating),
  fill="White",
  colour="Blue"
)

# >>> 5
t <- ggplot()
t + geom_histogram(
  data=movies,
  binwidth = 10,
  aes(x=CriticRating),
  fill="White",
  colour="Blue"
)