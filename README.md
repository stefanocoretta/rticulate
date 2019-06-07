# `rticulate`: Ultrasound Tongue Imaging in R

<!-- badges: start -->
[![Travis build status](https://travis-ci.org/stefanocoretta/rticulate.svg?branch=master)](https://travis-ci.org/stefanocoretta/rticulate)
<!-- badges: end -->

This is the repository of the R package `rticulate`. This package provides two functions for importing UTI data from Articulate Assistant Advanced and plotting UTI data from any source.

# Installation

**IMPORTANT**: The package `tidymv` needs to be [installed](https://github.com/stefanocoretta/tidymv) first.

To install the package, run `devtools::install_github("stefanocoretta/rticulate@v1.5.0", build_opts = c("--no-resave-data", "--no-manual"))`.
To learn the basic use of the package, run `vignette("tongue-imaging", package = "rticulate")` after the installation.

If you want to try the development version, run `devtools::install_github("stefanocoretta/rticulate", build_opts = c("--no-resave-data", "--no-manual"))` instead.
