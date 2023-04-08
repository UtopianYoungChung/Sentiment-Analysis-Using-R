# Load required libraries
library(dplyr) #data manipulation
library(ggplot2) #visualizations
library(gridExtra) #viewing multiple plots together
library(tidytext) #text mining
library(wordcloud2) #creative visualizations

#Read in the data
comments_orig <- read.csv("inputs/data/DS_ML_AI_posts.csv", stringsAsFactors = FALSE)

names(comments_orig)

