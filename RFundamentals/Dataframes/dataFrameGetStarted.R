

library(data.frames)

?read.csv

# ------------------------- Method 1 Select file manually
stats <- read.csv(file.choose())
head(stats)

# ------------------------- Method 2 Set WD and Read data
getwd()
setwd("C:\\Users\\Felipe\\Documents\\Felipe\\Projects\\FiocruzEstagio\\RStudio")
# for mac: /Users/Name/Desktop...
rm(stats)
stats <- read.csv("./Dataframes/P2-Demographic-Data.csv")
# stats <- read.csv("./Dataframes/P2-Demographic-Data.csv", stringsAsFactors=T)
head(stats)

# ------------------------- Exploring data
nrow(stats)
ncol(stats)
length(stats)
head(stats)
tail(stats)
str(stats) # structure

stats$Country.Code <- factor(stats$Country.Code) # categorcal features
stats$Country.Name <- factor(stats$Country.Name)
stats$Income.Group <- factor(stats$Income.Group)
str(stats)
summary(stats)

# ------------------------- $ sign

head(stats)
stats[3, 3]
stats[3, "Birth.rate"]
stats$Internet.users
stats$Internet.users[2]
# same results
stats[,"Internet.users"]
levels(stats$Income.Group)

# ------------------------- basic operations with DF
stats[1:10,]
stats[3:9,]
stats[c(4,100),]
is.data.frame(stats[1,]) # no need for drop=F
is.data.frame(stats[,1])
stats[,1,drop=F]
# multiply columns
head(stats)
stats$Birth.rate * stats$Internet.users
stats$Birth.rate + stats$Internet.users
# add column
stats$MyCalc <- stats$Birth.rate * stats$Internet.users
head(stats)
stats$xyz <- 1:5 # vector recycled
stats$xyz <- 1:4 # error 195 is not multiple of 4
head(stats)

# remove column
head(stats)
stats$MyCalc <- NULL
stats$xyz <- NULL

# ------------------------- Filtering DF
filter <- stats$Internet.users < 2
stats[filter,]

stats[stats$Birth.rate > 40 & stats$Internet.users < 2,]
stats[stats$Income.Group == "High income",]
levels(stats$Income.Group)
stats[stats$Income.Group == 1,]

# find all about Malta
stats[stats$Country.Name == "Malta",]

# ------------------------- qplot intro
library(ggplot2)

?qplot
qplot(data=stats, x=Internet.users)
qplot(data=stats, x=Income.Group, y=Birth.rate)
qplot(data=stats, x=Income.Group, y=Birth.rate, size=I(3))
# to assign color or size using qplot use I
qplot(data=stats, x=Income.Group, y=Birth.rate, size=I(3), color=I("blue"))

qplot(data=stats, x=Income.Group, y=Birth.rate, geom="boxplot")
?I

# ------------------------- visualizing what we need

qplot(data=stats, x=Internet.users, y=Birth.rate, size=I(4), color=I("red"))

qplot(data=stats, x=Internet.users, y=Birth.rate, size=I(4), color=Income.Group)

# ------------------------- creating data frames

df <- data.frame(Countries_2012_Dataset, Codes_2012_Dataset, Regions_2012_Dataset)
#colnames(df) <- c("Country", "Code", "Region")
#head(df)
rm(df)
df <- data.frame(
  Country=Countries_2012_Dataset,
  Code=Codes_2012_Dataset,
  Region=Regions_2012_Dataset
)
# also works for rbind and cbind
head(df)
summary(df)

# ------------------------- merging data frames
head(stats)
head(df)
merged <- merge(stats, df, by.x = "Country.Code", by.y = "Code")
merged$Country <- NULL
head(merged)
str(merged)
summary(merged)

# ------------------------- Visualizing with new split
#qplot(data=stats, x=Internet.users, y=Birth.rate, size=I(4), color=Regions_2012_Dataset)
qplot(data=merged, x=Internet.users, y=Birth.rate, size=I(4), color=Region)

# shapes
qplot(data=merged, x=Internet.users, y=Birth.rate, size=I(4), color=Region, shape=I(17))
# transparency
qplot(data=merged, x=Internet.users, y=Birth.rate, size=I(4), color=Region, shape=I(19), alpha=I(0.6))
# title
qplot(data=merged, x=Internet.users, y=Birth.rate, size=I(4), color=Region, shape=I(19), alpha=I(0.6), main="Birth Rate vs Internet users")

# with dataframes we can have different data types
