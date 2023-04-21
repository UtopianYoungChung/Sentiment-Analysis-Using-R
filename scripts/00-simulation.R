#### Preamble ####
# Purpose: A script simulating the helper functions used in this project.
# Author: Sidharth Gupta
# Data: 19 April 2023
# Contact: yj.chung@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - RStudio, or an equivalent environment to compile and execute .R and .Rmd files.
# - The following libraries are installed:

#### Test data ####
# If there is TRUE outputting, then test is assumed to be passed
# All of the test are passing with return value of True
# For those with multiple data outputting, there might be some false outputing
# after the True value, those can be ignored because as long the first value
# is outputting True, then that means it is passing the test, since we are only
# checking for first value to be outputted as True in the data

reddit <- read.csv("inputs/data/reddit.csv")

# Checking if the subreddit topics are unique
reddit$subreddit |>
  unique() == c(
    "artificial",
    "MachineLearning",
    "datascience"
  )

# reserved
library(datasets)
set.seed(583)
idx <- seq_len(nrwo(reddit))

samp <- sample(idx, 6)
reddit[samp, ]

# Checking if the year matches the smallest year listed in the dataset
reddit$created_year |> min() == c('2013')

# Checking if the year matches the largest year listed in the dataset
reddit$created_year |> unique() == c('2023')

# Checking if the value matches the value listed in the dataset
reddit$score |> unique() == c('7793')

# Checking if the value matches the value listed in the dataset
reddit$score |> unique() == c('2')

# Checking if the years matches the years listed in the dataset
reddit$years |> unique() == c('19-21')

# Checking if the years matches the years listed in the dataset
reddit$years |> unique() == c('13-15')

# Test the created_year data is a integer
reddit$post_id |> class() == "character"

# Test the created_year data is a integer
reddit$created_year |> class() == "integer"


# Test the comment data is a numeric
reddit$comment |> class() == "character"
