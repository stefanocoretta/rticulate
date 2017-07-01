# Change Log

## Unreleased
### Added
- argument in `read_aaa` to choose coordinate system
- `read_aaa_data` for internal use

### Changed
- updates to `NEWS.md`
- clarified documentation
- `read_aaa` can now accept a list of files
- column `fan` now properly named `fan.line`

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

[1.0.1]: https://github.com/stefanocoretta/rticulate/compare/v1.0.0...v1.0.1
