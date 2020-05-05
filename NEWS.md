# Change Log

## Unreleased
### Changed
- expand documentation of `transform_coordinates()` and `get_origin()`
- better handling of fit errors in `get_origin()`

### Deprecated
- `geom_polar_ci()`, see vignette "polar-gam" for a working alternative

## [1.5.0] - 2019-04-22
### Added
- examples for `predict_polar_gam()` and plotting

### Changed
- extend `polar-gam.Rmd`

### Deprecated
- ⚠️ `time_series` is now deprecated and replaced with `series`. `time_series` will be removed in future releases.

## [1.4.0] - 2019-01-31
### Added
- examples in docs
- section in `polar-gams.Rmd` about multiple predictors
- function `predict_polar_gam()`
- geom `geom_polar_ci()`

## [1.3.5] - 2018-12-05
### Changed
- README now uses new `install_github` argument for building vignettes

## [1.3.4] - 2018-10-22
### Added
- support for NULL comparison argument in `plot_polar_smooths()`

### Fixed
- error after `rlang` update

## [1.3.3] - 2018-10-22
### Added
- `split` argument for splitting factor interactions into separate factors

## [1.3.2] - 2018-08-02
### Added
- argument in `read_aaa()` for choosing format (wide or long)

### Changed
- removed `tidymv` version from README

### Fixed
- polar GAMs vignette title
- error in Polar GAMs vignette
- error when using `AR.start`

## [1.3.1] - 2018-02-26
### Fixed
- fix several bugs
- fix issue #1

## [1.3.0] - 2018-02-26
### Added
- functions for transforming coordinates
- vignette about coordinates transformation
- polar gams

### Changed
- dropped levels in `tongue` data set
- use underscores in names everywhere

## [1.2.0] - 2017-09-29
### Added
- argument in `read_aaa` to choose coordinate system
- `read_aaa_data` for internal use
- `it02` data
- example in vignette for multiple import
- added `point` and `path` options to `plot_tongue`

### Changed
- updates to `NEWS.md`
- clarified documentation
- `read_aaa` can now accept a list of files
- column `fan` now properly named `fan.line`
- data names
- renamed `plot_splines` to `plot_tongue`

### Fixed
- name of package in documentation
- name of vignette
- title in README

## [1.0.1] - 2017-06-10
### Added
- depends and imports in DESCRIPTION
- globalVariables for data frame variables in functions
- NEWS.md

### Fixed
- data documentation (wrong variable names)
- missing parameter in `plot_splines`
- missing `stats::` in `read_aaa`
- `aes` call which caused notes on R CMD check using `aes_`

[1.5.0]: https://github.com/stefanocoretta/rticulate/compare/v1.4.0...v1.5.0
[1.4.0]: https://github.com/stefanocoretta/rticulate/compare/v1.3.5...v1.4.0
[1.3.5]: https://github.com/stefanocoretta/rticulate/compare/v1.3.4...v1.3.5
[1.3.4]: https://github.com/stefanocoretta/rticulate/compare/v1.3.3...v1.3.4
[1.3.3]: https://github.com/stefanocoretta/rticulate/compare/v1.3.2...v1.3.3
[1.3.2]: https://github.com/stefanocoretta/rticulate/compare/v1.3.1...v1.3.2
[1.3.1]: https://github.com/stefanocoretta/rticulate/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/stefanocoretta/rticulate/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/stefanocoretta/rticulate/compare/v1.0.1...v1.2.0
[1.0.1]: https://github.com/stefanocoretta/rticulate/compare/v1.0.0...v1.0.1
