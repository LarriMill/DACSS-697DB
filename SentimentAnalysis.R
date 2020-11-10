# Larri Miller
# DACSS 697DB - Prof. Wayne Xu
# Assignment 2
# Due 10/16/2020

# required packages
library(rtweet)
library(readr)
library(ggplot2)
library(lubridate)
library(reshape2)
library(dplyr)
library(stringr)
library(syuzhet) 
library(quanteda)

# creating token
mytoken <- create_token(
  app = "",
  consumer_key = "",
  consumer_secret = "",
  access_token = "",
  access_secret = "")

# task 1
tweets1 <- get_timeline("JoeBiden", n = 500, token = mytoken) 
tweets2 <- get_timeline("realDonaldTrump", n = 500, token = mytoken) 

tweets <- rbind(tweets1, tweets2) 

# task 2
tweets$created_at <- ymd_hms(tweets$created_at)
tweets$created_at <- with_tz(tweets$created_at, "America/New_York")
tweets$created_date <- as.Date(tweets$created_at)

tweets$date_label <- as.factor(tweets$created_date)


daily_count <- tweets %>%
  group_by(date_label, screen_name) %>%
  summarise(avg_rt = mean(retweet_count),
  avg_fav = mean(favorite_count),
  num_retweeted = length(is_retweet[is_retweet == TRUE]),
  tweet_count = length(unique(status_id))) %>% melt

daily_count$dat_label <- as.Date(daily_count$date_label)

# note: I rotated the x axis date labels because they were impossible to read horizontally
# I also expanded the title to explain that this is the last 500 tweets each, otherwise it seems misleading
ggplot(data = daily_count[daily_count$variable=="tweet_count",], aes(x = date_label, y = value, group = screen_name)) +
    geom_line(size = 2.9, alpha = 1.7, aes(color = screen_name)) +
    geom_point(size = 1) +
    ylim(0, NA) +
    theme(legend.title = element_blank(), axis.title.x = element_blank(), axis.text.x = element_text(angle = 90, vjust = 0.5, hjust = 1)) +
    ylab("Tweet volume") +
    ggtitle("@realDonaldTrump and @JoeBiden Twitter Volume, Last 500 Tweets") 

# Task 3
tweets$clean_text <- str_replace_all(tweets$text, "@\\w+", "")
Sentiment <- get_nrc_sentiment(tweets$clean_text)
alltweets_senti <- cbind(tweets, Sentiment)

senti_aggregated <- alltweets_senti %>% 
  group_by(date_label,screen_name) %>%
  summarise(anger = mean(anger), 
            anticipation = mean(anticipation), 
            disgust = mean(disgust), 
            fear = mean(fear), 
            joy = mean(joy), 
            sadness = mean(sadness), 
            surprise = mean(surprise), 
            trust = mean(trust)) %>% melt

senti_aggregated$day <- as.Date(senti_aggregated$date_label)

ggplot(data = senti_aggregated[senti_aggregated$variable=="joy",], aes(x = day, y = value, group = screen_name)) +
  geom_line(size = 0.5, alpha = 0.6, aes(color = screen_name)) +
  geom_point(size = 0) +
  ylim(0, NA) +
  theme(legend.title=element_blank(), axis.title.x = element_blank()) +
  ylab("Average joy score") + 
  ggtitle("Joy Scores by @realDonaldTrump and @JoeBiden")


# Task 4
tweets_agg <- aggregate(text~screen_name, data = tweets, paste0, collapse=". ")
tweets_corpus <- corpus(tweets_agg,docid_field = "screen_name",text_field = "text")
tweets_corpus

# Task 5
ggplot(data = senti_aggregated[senti_aggregated$screen_name=="realDonaldTrump",], aes(x = day, y = value, group = variable)) +
  geom_line(size = 0.5, alpha = 0.6, aes(color = variable)) +
  geom_point(size = 0) +
  ylim(0, NA) +
  theme(legend.title=element_blank(), axis.title.x = element_blank()) +
  ylab("Average sentiment score") + 
  ggtitle("@realDonaldTrump Sentiments Over Last 500 Tweets")

