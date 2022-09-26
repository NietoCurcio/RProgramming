s <- ggplot(data=movies, aes(BudgetMillions))
s + geom_histogram(binwidth=10)

s + geom_histogram(binwidth=10, aes(fill=Genre))
s + geom_histogram(binwidth=10, aes(fill=Genre), colour="Black")

s + geom_density(aes(fill=Genre))
s + geom_density(aes(fill=Genre), position="stack")
