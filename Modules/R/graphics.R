import("ggplot2")

histPlot <- function(dataframe, binWidth, x_axis) {
  ggplot(data = dataframe, aes_string(x = x_axis)) + geom_histogram(binwidth = binWidth)
}

barPLot <- function(dataframe, x_axis) {
  ggplot(data = dataframe, aes_string(x = x_axis)) + geom_bar()
}

export("histPlot", "barPLot")