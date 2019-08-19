library(dplyr)
library(feather)
library(igraph)
library(readr)
library(xtable)

## Despotism tests

r1 <- read_feather('../data/ecco_90_dist_100_cut_10_2.feather')
r2<- read_feather('../data/ecco_90_dist_10_cut_10_2.feather')


rels <- read_feather('../data/times_coocs_unigrams_cutoff_d1.feather')
rels <- group_by(rels, focal) %>% arrange(desc(score)) %>%
    mutate(rank = order(score, decreasing = TRUE))%>% ungroup

tmp <- filter(rels, focal=='democracy' | bound=='democracy', rank < 10)

t9 <- read_feather('../data/ecco_90_dist_100_cut_10_2.feather')

t80_100 <- bind_rows(t0,t9) %>% group_by(focal, bound) %>% summarise(focal_e=sum(focal_e),
                                                                     bound_e=sum(bound_e),
                                                                     Freq = sum(Freq)
                                                                     )
t80_100 <- g



tmp <- read_feather('../data/times_coocs_unigrams_cutoff_d1.feather') %>% filter(dpf > 1)
tmp$log_dpf <- log(tmp$dpf)
tmp$score <- tmp$log_dpf
t2 <- read_feather('../data/ecco_100_dist_100_cut_10_2.feather')
write_feather(tmp, '../data/times_coocs_unigrams_cutoff_d1.feather')
prox <- read_feather('../data/ecco_50_dist_10_cut_10_2.feather')
dist <- read_feather('../data/ecco_50_dist_100_cut_10_2.feather')

conc <-
    read_tsv('../data/concreteness.txt')  %>% filter(Bigram == 0, Conc.M < 4.5)


relations <- data.frame(from=prox$focal, to=prox$bound, weight=prox$score) 
relations <- filter(relations, from %in% conc$Word, to %in% conc$Word)

gprox <- graph_from_data_frame(relations, directed = FALSE) %>% simplify

relations <- data.frame(from=dist$focal, to=dist$bound, weight=dist$score) 
relations <- filter(relations, from %in% conc$Word, to %in% conc$Word)
gdist <- graph_from_data_frame(relations, directed = FALSE) %>% simplify


bc <- estimate_betweenness(gdist, cutoff=4)
dist_bcdf <- data.frame(bc, names(bc)) %>% filter(bc > 200)

bc <- estimate_betweenness(gprox, cutoff=4)
prox_bcdf <- data.frame(bc, names(bc)) %>% filter(bc > 200)

tmp <- inner_join(prox_bcdf,dist_bcdf, by=('names.bc.'))
tmp$ratio <- tmp$bc.x/tmp$bc.y

tmp <- rename(tmp, prox_centrality = bc.x, dist_centrality = bc.y) %>% arrange(ratio)
top <- arrange(tmp, ratio) %>% head(50)
bottom <- arrange(tmp, desc(ratio)) %>% head(50)
ob <- xtable(top, caption = '1800_abs')
print(ob, 'html', '1750_abs_top.html')

ob <- xtable(bottom, caption = '1800_abs')
print(ob, 'html', '1750_abs_bottom.html')
