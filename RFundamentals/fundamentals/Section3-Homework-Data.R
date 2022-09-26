#Data
revenue <- c(14574.49, 7606.46, 8611.41, 9175.41, 8058.65, 8105.44, 11496.28, 9766.09, 10305.32, 14379.96, 10713.97, 15433.50)
expenses <- c(12051.82, 5695.07, 12319.20, 12089.72, 8658.57, 840.20, 3285.73, 5821.12, 6976.93, 16618.61, 10054.37, 3803.96)

profit <- revenue - expenses
profitAfterTax <- round(profit * 0.7, digits=2)
profitMargin <- round(profitAfterTax / revenue, digits=2) * 100

meanProfitAfterTax <- mean(profitAfterTax)

goodMonths <- profitAfterTax > meanProfitAfterTax
badMonths2 <- !goodMonths

bestMonth <- max(profitAfterTax)
worstMonth <- min(profitAfterTax)

months <- c("Jan", "Fev", "Mar",
            "April", "May", "Jun",
            "July", "Aug", "Sep",
            "Oct", "Nov", "Dec")

revenue.1000 <- round(revenue / 1000, 0)
expenses.1000 <- round(expenses / 1000, 0)
profit.1000 <- round(profit / 1000, 0)
profit.after.tax.1000 <- round(profitAfterTax / 1000, 0)

for (i in 1:12) {
  print(months[i])
  print(sprintf("Profit %.0f", profit.1000[i]))
  print(sprintf("Profit after tax %.0f", profit.after.tax.1000[i]))
  print(sprintf("Profit margin %.0f%%", profitMargin[i]))
}

print("Good months:")
print(months[goodMonths])

print("Bad months:")
print(months[badMonths2])

print("Best month:")
print(months[which(profitAfterTax == bestMonth)])
print(months[profitAfterTax == bestMonth])

print("Worst month:")
print(months[which(profitAfterTax == worstMonth)])

M <- rbind(
  revenue.1000,
  expenses.1000,
  profit.1000,
  profit.after.tax.1000,
  profitMargin,
  goodMonths,
  badMonths2,
  bestMonth=profitAfterTax == bestMonth,
  wM=profitAfterTax == worstMonth
)

M

library(ggplot2)

data <- data.frame(Month=months, Profit=profit.1000, Revenue=revenue.1000, Expenses=expenses.1000)
data$Month <- factor(data$Month, order=T,)
str(data)
levels(data$Month) <- months
levels(data$Month)

plt <- ggplot(data=data, aes(x=Month, y=Profit, colour=Profit > 0))
plt + geom_point(size=5)
