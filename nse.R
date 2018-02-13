#https://www.kaggle.com/minatverma/nse-stocks-data
#
# install.packages(pkgs="plyr")
# install.packages(pkgs="dplyr")
# install.packages(pkgs="stringr")
# install.packages(pkgs="tidyr")

#library(plyr)
#library(dplyr)
#library(stringr)
#library(tidyr)
#Clear the Environment - To avoid any testing issues.
rm(list = ls())

# Set working directory - physical location to read and write files from
setwd("C:/pgdds/Kaggle")

# Check if working directory is set
getwd()


final <-
  read.csv(file = "FINAL_FROM_DF.csv",
           stringsAsFactors = FALSE,
           quote = "")

str(final)

#Symbols with maximum gain/loss between Jan 1 2016 vs. Dec 29 2017

#create 2 new df's with just the entries for the 2 dates - Jan 1 2016 and Dec 29 2017

data_2jan16 <- filter(final,TIMESTAMP==min(TIMESTAMP))

data_29dec17 <- filter(final,TIMESTAMP == max(TIMESTAMP))

#merge the 2 df's created above so the price can be compared between Jan 1 2016 and Dec 29 2017

data_jan_vs_dec <- merge(data_2jan16,data_29dec17[,c("SYMBOL","SERIES","CLOSE")], by=c("SYMBOL","SERIES"),all = TRUE)[,c("SYMBOL","SERIES","CLOSE.x","CLOSE.y")]

#keeping only SYMBOLS that existed on both those dates (2jan16 and 29dec17), idea is to compare the 
#best growth and worst loss stocks over the entire 2-year period
data_jan_vs_dec <- filter(data_jan_vs_dec,!is.na(CLOSE.x) & !is.na(CLOSE.y))

#Add a 4th column - % change over the 2 years for each symbol

data_jan_vs_dec$per_change <- ((data_jan_vs_dec$CLOSE.y-data_jan_vs_dec$CLOSE.x)/data_jan_vs_dec$CLOSE.x)*100

data_jan_vs_dec <- arrange(data_jan_vs_dec,desc(per_change))

#Best performing 3 stocks
head(data_jan_vs_dec,3)

#Worst performing 3 stocks
tail(data_jan_vs_dec,3)

#Price change graph over 2 years for the best & worst performing stocks
library(ggplot2)
#Format data
top3_all_values <- inner_join(final, head(data_jan_vs_dec,3) %>% select(SYMBOL))[, c(1,11,6)]
bottom3_all_values <- inner_join(final, tail(data_jan_vs_dec,3) %>% select(SYMBOL))[, c(1,11,6)]
top3_all_values$TIMESTAMP <- as.Date(top3_all_values$TIMESTAMP)
bottom3_all_values$TIMESTAMP <- as.Date(bottom3_all_values$TIMESTAMP)

#Plot top 3
ggplot( top3_all_values, aes( TIMESTAMP, CLOSE,colour=SYMBOL )) + geom_line() +xlab(label='dates')+ylab(label='Close_price')

#Plot bottom 3
ggplot( bottom3_all_values, aes( TIMESTAMP, CLOSE,colour=SYMBOL)) + geom_line() +xlab(label='dates')+ylab(label='Close_price')
