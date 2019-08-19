library(dplyr)
library(readr)
print('sourcing globals')

keep_pos <- c('Noun', 'Verb', 'Adjective', '#N/A', 'Adverb')
conc <-
  read_tsv('../data/concreteness.txt')  %>% filter(Bigram == 0, Dom_Pos %in% keep_pos, Conc.M < 4.5)

keep_pos <- c('Noun', 'Verb','Adverb', 'Adjective','#N/A')
#sw <- c('is','be','are','have','was','will','may','had','has', 'having','being','were','would','could','been','shall','may','do')
sw <- c()

col_table <- c('DeepSkyBlue', 'Blue', 'LightGreen', 'LightCoral', 'Orange')
names(col_table) <- c('Noun', '#N/A', 'Adjective', 'Verb', 'Adverb')

shape_table <- c("circle", "circle", "square", "rectangle","rectangle")
names(shape_table) <- c('Noun', '#N/A', 'Adjective', 'Verb', 'Adverb')

get_score <- function(type = c('log-dpf'), obs, exp) {
  this_score <- NA
  print(type)
  if (type == 'pmi') {
    this_score <- log(obs / exp)
  } else if (type == 'n-pmi') {
    this_score <- log(obs / exp) / log(1 / exp)
  } else if (type == 't-score') {
    this_score <- (obs - exp) / sqrt(obs)
  }
  else if (type == 'pmi-sig') {
    this_score <- sqrt(min(obs, exp)) * log(obs / exp)
  }
  else if (type == 'pmi-s') {
    this_score <- sqrt(max(obs, exp)) * log(obs / exp)
  }
  else if (type == 'log-dpf') {
    this_score <- log(obs / (exp ^ 0.78))
  }
  else if (type == 'dpf') {
    this_score <- obs / (exp ^ 0.78)
  }
  return(this_score)
}
