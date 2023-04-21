# Load required libraries
library(dplyr) #data manipulation
library(ggplot2) #visualizations
library(gridExtra) #viewing multiple plots together
library(tidytext) #text mining
library(wordcloud2) #creative visualizations

#Read in the data
reddit_orig <- read.csv("inputs/data/DS_ML_AI_posts.csv", stringsAsFactors = FALSE)

#Select only what we want
reddit <- reddit_orig %>%
  select(post_id, subreddit, category = link_flair_text, score, created_year, comment)

#Data Conditioning
## Basic cleaning

### function to expand contractions in an English-language source
fix.contractions <- function(doc) {
  # "won't" is a special case as it does not expand to "wo not"
  doc <- gsub("won't", "will not", doc)
  doc <- gsub("can't", "can not", doc)
  doc <- gsub("n't", " not", doc)
  doc <- gsub("'ll", " will", doc)
  doc <- gsub("'re", " are", doc)
  doc <- gsub("'ve", " have", doc)
  doc <- gsub("'m", " am", doc)
  doc <- gsub("'d", " would", doc)
  # 's could be 'is' or could be possessive: it has no expansion
  doc <- gsub("'s", "", doc)

  return(doc)
}

### Create the semi_annual column
reddit <- reddit %>%
  mutate(years = 
           ifelse(reddit$created_year %in% 2013:2015, "13-15",
                  ifelse(reddit$created_year %in% 2016:2018, "16-18",
                         ifelse(reddit$created_year %in% 2019:2021, "19-21",
                                ifelse(reddit$created_year %in% 2022:2023, "22-23",
                  "NA")))))

### fix (expand) contractions
reddit$comment <- sapply(reddit$comment, fix.contractions)

# function to remove special characters
removeSpecialChars <- function(x) gsub("[^a-zA-Z0-9 ]", " ", x)
### remove special characters
reddit$comment <- sapply(reddit$comment, removeSpecialChars)

### convert everything to lower case
reddit$comment <- sapply(reddit$comment, tolower)


#### Save the data in our inputs folder
write.csv(x = reddit,
          file = here::here("inputs/data/reddit.csv"))