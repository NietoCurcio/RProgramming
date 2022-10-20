library(tidyverse)

data_superzip <- read.csv("superzip.csv")
data_zipcode <- read.csv("zip_codes_states.csv")

allzips <- data_superzip %>% left_join(data_zipcode, by = c("zipcode" = "zip_code"))

# allzips$college <- sapply(allzips$college, function(x) parse_number(x))
# vectorized code, much faster:
allzips$college <- parse_number(allzips$college)


# in the dataset there are zipcodes that point to the exact latitude and longitude
# jitter adds a noise so that different zipcodes that before pointed to the same coordinate
# will not point to the exact same location, but close to it
allzips$latitude <- jitter(allzips$latitude)
allzips$longitude <- jitter(allzips$longitude)

# add padding left to zipcode (0 at left with 5 digits)
allzips$zipcode <- formatC(allzips$zipcode, width = 5, format = "d", flag = "0")

rownames(allzips) <- allzips$zipcode

allzips <- allzips %>% drop_na(c(latitude, longitude))

# sample 8000 zip codes
allzips <- allzips[sample.int(nrow(allzips), 8000), ]

cleantable <- allzips %>%
  select(
    Zipcode = zipcode,
    Score = centile,
    Superzip = superzip,
    Rank = rank,
    City = city.x,
    State = state.x,
    Population = adultpop,
    College = college,
    Income = income,
    Lat = latitude,
    Long = longitude
  )
