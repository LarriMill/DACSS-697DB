# Larri Miller
# DACSS 697DB - Prof. Wayne Xu
# Assignment 1
# Due 9/25/2020

library(rtweet)
mytoken <- create_token(
  app = "R_Workshop_DB",
  consumer_key = "4EL1tCE2DG4OdtLrynOGnWsHi",
  consumer_secret = "57Urg78Zkpoqj4M6ZPL8TOXp7X4o0IM4Thh2FzmUGrm0TmgviD",
  access_token = "17917334-QzAR7yu42izruhOLsQEzVbHOVwXYHj0BrhMkqhJne",
  access_secret = "fvNA7z3Sb1nVfmqCIEJvDxkIWyvGlkbe6xXgscnXFlvzj")

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
