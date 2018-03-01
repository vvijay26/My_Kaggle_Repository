library("dplyr")
getwd()
setwd("C:/pgdds/Kaggle")
crypto <- read.delim("crypto-markets.csv", sep = ",")
str(crypto)
length(unique(crypto$name))

#Store the highest and lowest for each currency type in a new df crypto_high_low

agg_high <-
  setNames(aggregate(crypto$high, by = list(crypto$name), FUN = max),
           c("name", "Max"))
agg_low <-
  setNames(aggregate(crypto$high, by = list(crypto$name), FUN = min),
           c("name", "Min"))

crypto_high_low <-
  merge(agg_high,
        agg_low,
        by.x = "name",
        by.y = "name")

#Add growth % (between life max and min values) as a 4th column in crypto_high_low df
# (Truncated to 1 decimal)
# The calculated value is growth %, for example, if a currency doubles, then growth is 100%, not 200%

crypto_high_low$Growth <- round(((crypto_high_low$Max/crypto_high_low$Min) * 100)-100,digits=2)

#Sort the list by descending growth percentage
crypto_high_low <-  arrange(crypto_high_low, desc(Growth))

#Top growth cryptos
top3 <- head(crypto_high_low,3)
#Format data
top3_cryptos <- inner_join(crypto, top3 %>% select(name))[, c(3,4,6,7)]
#Change date from factor to date
top3_cryptos$date <- as.Date(top3_cryptos$date)

#Plot top 3 currencies with highest price fluctuation % (Min to Max)
ggplot( top3_cryptos, aes( x=date, y=high,colour=name )) + geom_line() 

write.table(top3_cryptos, "merge.csv", sep=",", row.names = FALSE)

