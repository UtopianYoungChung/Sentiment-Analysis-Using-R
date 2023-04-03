library(tidyverse)
library(tidytext)
library(SnowballC)
library(tidyr)
library(dplyr)
library(tokenizers)
library(hcandersenr)
library(janeaustenr)
library(jiebaR)
library(stopwords)

sentiments <- read.csv("inputs/data/DS_ML_AI_comments.csv")

get_dfm <- function(frac) {
  sentiments %>%
    sample_frac(frac) %>%
    unnest_tokens(word, comment) %>%
    anti_join(get_stopwords(), by = "word") %>%
    mutate(stem = wordStem(word)) %>%
    count(post_id, stem) %>%
    cast_dfm(post_id, stem, n)
}

set.seed(123)
tibble(frac = 2 ^ seq(-16, -6, 2)) %>%
  mutate(dfm = map(frac, get_dfm),
         words = map_dbl(dfm, quanteda::nfeat),
         sparsity = map_dbl(dfm, quanteda::sparsity),
         `RAM (in bytes)` = map_dbl(dfm, lobstr::obj_size)) %>%
  pivot_longer(sparsity:`RAM (in bytes)`, names_to = "measure") %>%
  ggplot(aes(words, value, color = measure)) +
  geom_line(size = 1.5, alpha = 0.5) +
  geom_point(size = 2) +
  facet_wrap(~measure, scales = "free_y") +
  scale_x_log10(labels = scales::label_comma()) +
  scale_y_continuous(labels = scales::label_comma()) +
  theme(legend.position = "none") +
  labs(x = "Number of unique words in corpus (log scale)",
       y = NULL)

# Unique words
tidy_sentiments <- sentiments %>%
  select(post_id, comment) %>%
  unnest_tokens(word, comment) %>%
  add_count(word) %>%
  filter(n >= 50) %>%
  select(-n)

nested_words <- tidy_sentiments %>%
  nest(words = c(word))

nested_words

###Sliding windows
slide_windows <- function(tbl, window_size) {
  skipgrams <- slider::slide(
    tbl, 
    ~.x, 
    .after = window_size - 1, 
    .step = 1, 
    .complete = TRUE
  )
  
  safe_mutate <- safely(mutate)
  
  out <- map2(skipgrams,
              1:length(skipgrams),
              ~ safe_mutate(.x, window_id = .y))
  
  out %>%
    transpose() %>%
    pluck("result") %>%
    compact() %>%
    bind_rows()
}

### Let's count
library(widyr)
library(furrr)


plan(multisession)  ## for parallel processing

tidy_pmi <- nested_words %>%
  mutate(words = future_map(words, slide_windows, 4L)) %>%
  unnest(words) %>%
  unite(window_id, post_id, window_id) %>%
  pairwise_pmi(word, window_id)

tidy_pmi