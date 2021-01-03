
<!-- README.md is generated from README.Rmd. Please edit that file -->

# `rticulate`: Ultrasound Tongue Imaging in R

<!-- badges: start -->
<!-- badges: end -->

This is the repository of the R package `rticulate`. This package
provides two functions for importing UTI data from Articulate Assistant
Advanced and plotting UTI data from any source.

## Installation

To install the package, run the following (you need the package
[remotes](https://remotes.r-lib.org)).

``` r
remotes::install_github(
  "stefanocoretta/rticulate",
  ref = remotes::github_release(), # this pulls the latest release
  build_vignettes = TRUE
)
```

If you want to install the development version, run this instead.

``` r
remotes::install_github(
  "stefanocoretta/rticulate",
  build_vignettes = TRUE
)
```

## Usage

To learn the basic use of the package, run
`vignette("tongue-imaging", package = "rticulate")` after the
installation.
