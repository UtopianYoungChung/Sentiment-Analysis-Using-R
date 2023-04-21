#### Preamble ####
# Purpose: Load the data from the data section of Reddit API 
# Author: Joseph Chung
# Data: 07 April 2023
# Contact: yj.chung@mail.utoronto.ca
# License: MIT

#Read in the data
reddit_orig <- read.csv("inputs/data/DS_ML_AI_posts.csv", stringsAsFactors = FALSE)

#Select only what we want
reddit <- reddit_orig %>%
  select(post_id, subreddit, category = link_flair_text, score, created_year, comment)