# Change Log

## Unreleased
## Changed
- removed `tidymv` version from README

## Fixed
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

[1.3.0]: https://github.com/stefanocoretta/rticulate/compare/v1.3.0...v1.3.1
[1.3.0]: https://github.com/stefanocoretta/rticulate/compare/v1.2.0...v1.3.0
[1.2.0]: https://github.com/stefanocoretta/rticulate/compare/v1.0.1...v1.2.0
[1.0.1]: https://github.com/stefanocoretta/rticulate/compare/v1.0.0...v1.0.1
