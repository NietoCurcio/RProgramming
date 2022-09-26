data <- read.csv('./ggplot2/Section6-Homework-Data.csv')
data$Studio <- factor(data$Studio)
data$Genre <- factor(data$Genre)
data$Day.of.Week <- factor(data$Day.of.Week)
str(data)
#nrow

filter_studio <- (data$Studio == "Buena Vista Studios") | (data$Studio == "Universal") | (data$Studio == "Fox") | (data$Studio == "Paramount Pictures") | (data$Studio == "Sony") | (data$Studio == "WB")
filter_genre <- data$Genre %in% c("action", "adventure", "animation", "comedy", "drama")
head(data)

data2 <- data[filter_studio & filter_genre,]
str(data2)

library(ggplot2)

ggplot(data=data, aes(x=Day.of.Week)) + geom_bar()
# for categorical variables is geom_bar for counting
# for continues variables is geom_histogram for counting
# counting with geom_histogram or geom_bar only needs aes(x=Feature)

plt <- ggplot(data=data2, aes(
  x=Genre,
  y=Gross...US,
))
plt <- plt + geom_jitter(aes(colour=Studio, size=Budget...mill.))
plt <- plt + geom_boxplot(alpha=0.5, outlier.colour = NA)
plt

# Theme
plt <- plt + xlab("Genre") + ylab("Gross % US")
plt <- plt + ggtitle("Domestic Gross % by Genre")
plt <- plt + theme(
  axis.title.x = element_text(colour="DarkGreen", size=20),
  axis.title.y = element_text(colour="Red", size=20),
  axis.text.x = element_text(size=15),
  axis.text.y = element_text(size=15),
  plot.title = element_text(size=20),
  legend.title = element_text(size=15),
  legend.text = element_text(size=12),
  
  #text = element_text(family="Comic Sans MS")
)
plt$labels$size <- "Budget $M"
plt
