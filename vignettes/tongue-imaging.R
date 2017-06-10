## ----setup, echo=FALSE, include=FALSE------------------------------------
knitr::opts_chunk$set(out.width = "600px", fig.align = "center", dpi = 300)
library(tidyverse)
theme_set(theme_bw())
library(stringr)
library(rticulate)

## ----load, eval=FALSE----------------------------------------------------
#  library(rticulate)

## ----columns-------------------------------------------------------------
columns <- c(
    "speaker",
    "seconds",
    "rec.date",
    "prompt",
    "label",
    "TT.displacement.sm",
    "TT.velocity",
    "TT.velocity.abs",
    "TD.displacement.sm",
    "TD.velocity",
    "TD.velocity.abs"
)

## ----read-aaa------------------------------------------------------------
# system.file() is needed here because the example files reside in the package.
# You can just include the file path directly in read_aaa, like 
# read_aaa("~/Desktop/splines.tsv", columns)
file.path <- system.file("extdata", "sc01-aaa.tsv", package = "rticulate")

tongue <- read_aaa(file.path, columns)

## ----tibble--------------------------------------------------------------
tongue

## ----join----------------------------------------------------------------
nonce <- read_csv(system.file("extdata", "nonce.csv", package = "rticulate"))

tongue <- mutate(tongue, word = stringr::word(prompt, 2)) %>%
    left_join(y = nonce) %>%
    mutate_if(is.character, as.factor)

## ----tibble-2------------------------------------------------------------
tongue

## ----plot-splines--------------------------------------------------------
plot_splines(tongue)

## ----filter-plot---------------------------------------------------------
filter(tongue, label == "max_TD") %>%
    plot_splines()

## ----plot-options--------------------------------------------------------
plot_splines(tongue, alpha = 0.5) +
    aes(group = rec.date, colour = c2place) +
    theme(legend.position="bottom")

## ----plot-palate---------------------------------------------------------
palate <- read_aaa(system.file("extdata", "sc01-palate.tsv", package = "rticulate"), columns)

filter(tongue, label == "max_TD") %>%
    plot_splines(palate = palate, alpha = 0.5) + aes(group = rec.date)

