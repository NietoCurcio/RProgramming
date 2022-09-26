# we can activate and deactivate a package in the
# current R session in the Packages tab, browser to package page,
# remove a package

install.packages("ggplot2")

library("ggplot2")

?qplot
?ggplot
?diamonds

typeof(diamonds)

qplot(data=diamonds, carat, price, colour=clarity, facets=.~clarity)
