#### Preamble ####
# Purpose: Load the data from the data section of Reddit API 
# Author: Joseph Chung
# Data: 07 April 2023
# Contact: yj.chung@mail.utoronto.ca
# License: MIT
# Pre-requisites: 
# - Need to have installed the tidyverse, haven and tidyr packages. 



#### Workspace setup ####

library(haven)
library(tidyverse)

# Reading in the data
posts = read_csv(here::here("inputs/data/DS_ML_AI_posts.csv"))
comments = read_csv(here::here("inputs/data/DS_ML_AI_comments.csv"))

# Create datasets from csv files
write_csv(x = posts, file = here::here("inputs/data/posts.csv"))