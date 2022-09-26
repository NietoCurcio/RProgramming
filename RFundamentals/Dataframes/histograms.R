#---------- Histograms and Density Charts

s <- ggplot(data=movies, aes(x=BudgetMillions))
s + geom_histogram(binwidth = 5)
s + geom_histogram(binwidth = 10)
# R aggregates budgetMillions to count = statistcs

# add color
s + geom_histogram(binwidth = 5, aes(fill=Genre))
# add border
# >>> 3
s + geom_histogram(binwidth = 5, aes(fill=Genre), colour="Black")

s + geom_density(aes(fill=Genre))
s + geom_density(aes(fill=Genre), position="stack")
