# Larri Miller
# DACSS 697DB - Prof. Wayne Xu
# Assignment 1
# Due 9/25/2020

library(rtweet)
mytoken <- create_token(
  app = "",
  consumer_key = "",
  consumer_secret = "",
  access_token = "",
  access_secret = "")

# Task 1
recenttweets <- get_timeline("DrIbram", n = 500, token = mytoken)
save_as_csv(recenttweets, "recenttweets.csv")

# Task 2
originaltweets <- recenttweets[recenttweets$is_retweet == FALSE,]
save_as_csv(originaltweets, "originaltweets.csv")

# Task 3
keywordtweets1 <- search_tweets("#BlackLivesMatter", n = 300, retryonratelimit = TRUE, token = mytoken)
twitter_mentions <- keywordtweets1[keywordtweets1$is_retweet == "FALSE" & !is.na(keywordtweets1$mentions_screen_name),]
save_as_csv(twitter_mentions, "mentions.csv")
