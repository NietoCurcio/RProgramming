#---------- Theme
o <- ggplot(data=movies, aes(x=BudgetMillions))
h <- o + geom_histogram(binwidth = 10, aes(fill=Genre), colour="Black")
h

# axis labels
h + xlab("Money Axis") + ylab("Number of movies")

# label formatting
h + xlab("Money Axis") + ylab("Number of movies") +
  theme(axis.title.x = element_text(colour="DarkGreen", size=30),
        axis.title.y = element_text(colour="Red", size=30))

# tick mark formatting
h + xlab("Money Axis") + 
  ylab("Number of movies") +
  theme(axis.title.x = element_text(colour="DarkGreen", size=30),
        axis.title.y = element_text(colour="Red", size=30),
        axis.text.x = element_text(size=20),
        axis.text.y = element_text(size=20))

# legend formatting
h + xlab("Money Axis") + 
  ylab("Number of movies") +
  theme(axis.title.x = element_text(colour="DarkGreen", size=30),
        axis.title.y = element_text(colour="Red", size=30),
        axis.text.x = element_text(size=20),
        axis.text.y = element_text(size=20),
        legend.title = element_text(size=30),
        legend.text = element_text(size=20),
        legend.position = c(1, 1),
        legend.justification = c(1,1))
# 01 11
# 00 10

# title
h + xlab("Money Axis") + 
  ylab("Number of movies") +
  ggtitle("Movie Budget Distribution") +
  theme(axis.title.x = element_text(colour="DarkGreen", size=30),
        axis.title.y = element_text(colour="Red", size=30),
        axis.text.x = element_text(size=20),
        axis.text.y = element_text(size=20),
        legend.title = element_text(size=30),
        legend.text = element_text(size=20),
        legend.position = c(1, 1),
        legend.justification = c(1,1),
        plot.title = element_text(colour="DarkBlue", family="Courier", size=20))
