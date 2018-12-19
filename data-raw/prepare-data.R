library(tidyverse)
library(rticulate)

stimuli <- read_csv("./data-raw/dataset/stimuli.csv")

columns <- c(
  "speaker",
  "seconds",
  "rec_date",
  "prompt",
  "label",
  "TT_displacement",
  "TT_velocity",
  "TT_abs_velocity",
  "TD_displacement",
  "TD_velocity",
  "TD_abs_velocity",
  "TR_displacement",
  "TR_velocity",
  "TR_abs_velocity"
)

tongue <- list.files(
  path = "./data-raw/dataset/",
  pattern = "*-tongue-cart.tsv",
  full.names = TRUE
) %>%
  read_aaa(., columns) %>%
  mutate(word = word(prompt, 2)) %>%
  left_join(y = stimuli) %>%
  filter(
    c1_phonation == "voiceless",
    label %in% c("max_TT", "max_TD"),
    c2_phonation == "voiceless"
  ) %>%
  mutate_if(is.character, as.factor)

save(tongue, file = "./data/tongue.rda")
