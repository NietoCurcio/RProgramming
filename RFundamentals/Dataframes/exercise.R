getwd()

df <- read.csv("./Dataframes/P2-Section5-Homework-Data.csv")
head(df)
tail(df)
df$Year <- factor(df$Year)
str(df)
summary(df)

filter <- df$Year == 1960
df_1960 <- df[filter,]
df_2013 <- df[!filter,]

str(df_1960)
str(df_2013)

df_le_1960 <- data.frame(Country_Code, LifeExp=Life_Expectancy_At_Birth_1960)
summary(df_le_1960)

df_le_2013 <- data.frame(Country_Code, LifeExp=Life_Expectancy_At_Birth_2013)
summary(df_le_2013)

# rbind(df_le_1960, df_le_2013)

merged_1960 <- merge(df_1960, df_le_1960, by.x = "Country.Code", by.y = "Country_Code")
merged_2013 <- merge(df_2013, df_le_2013, by.x = "Country.Code", by.y = "Country_Code")
merged_1960$Year <- NULL
merged_2013$Year <- NULL
summary(merged_1960)
summary(merged_2013)

# y=life expectancy, x=fertility rate, categorized by country regions, each for 1960 and 2013
library(ggplot2)
qplot(data=merged_1960, x=Fertility.Rate, y=Life_Expectancy_1960, size=I(3), color=Region, main="Life expectancy vs fertility rate at 1960", alpha=I(0.6))
qplot(data=merged_2013, x=Fertility.Rate, y=Life_Expectancy_2013, size=I(3), color=Region, main="Life expectancy vs fertility rate at 2013", alpha=I(0.6))

# give insights off the two different years
# 1960
# Europe very high LE, very low FR
# Africa very low LE, very high FR
# Asia as the fertility rate increases, LE decreases, same for Oceania,
# middle east and the Americas

# 2013
# Europe very high LE, very low FR
# Africa as the fertility rate increases, LE decreases, same for Asia
# Oceania has decreased FR and increased LE, same for middle east and Americas