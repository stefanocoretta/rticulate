
<!-- README.md is generated from README.Rmd. Please edit that file -->

# rticulate: Ultrasound Tongue Imaging in R <img src='man/figures/logo.png' align="right" height="120" />

<!-- badges: start -->

[![](https://www.r-pkg.org/badges/version/rticulate?color=blue)](https://cran.r-project.org/package=rticulate)
[![CRAN
checks](https://cranchecks.info/badges/summary/rticulate)](https://cran.r-project.org/web/checks/check_results_rticulate.html)
[![R build
status](https://github.com/stefanocoretta/rticulate/workflows/R-CMD-check/badge.svg)](https://github.com/stefanocoretta/rticulate/actions)
[![](https://img.shields.io/badge/devel%20version-1.7.2.9000-orange.svg)](https://github.com/stefanocoretta/rticulate)
[![](https://img.shields.io/badge/doi-10.5281/zenodo.1469038-blue.svg)](https://doi.org/10.5281/zenodo.1469038)
<!-- badges: end -->

This is the repository of the R package `rticulate`. This package
provides two functions for importing UTI data from Articulate Assistant
Advanced and plotting UTI data from any source.

## Installation

The package is on CRAN, so you can install it from there with
`install.packages("rticulate")`.

If you like living on edge, install a polished pre-release with:

``` r
remotes::install_github(
  "stefanocoretta/rticulate",
  build_vignettes = TRUE
)
```

Or the development version with:

``` r
remotes::install_github(
  "stefanocoretta/rticulate@devel",
  build_vignettes = TRUE
)
```

## Usage

To learn the basic use of the package, run
`vignette("tongue-imaging", package = "rticulate")` after the
installation.
