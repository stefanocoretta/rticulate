#' Tongue contours dataset.
#'
#' A dataset containing tongue contour coordinates of a single speaker.
#'
#' @format A data frame with 4578 rows and 25 variables.
#' \describe{
#'     \item{speaker}{speaker ID}
#'     \item{seconds}{time of coordinate, in seconds}
#'     \item{rec.date}{date and time of recording}
#'     \item{prompt}{prompt string}
#'     \item{label}{label of annotation}
#'     \item{TT.displacement}{smoothed displacement of tongue tip}
#'     \item{TT.velocity}{velocity of tongue tip displacement}
#'     \item{TT.velocity.abs}{absolute velocity of tongue tip displacement}
#'     \item{TD.displacement}{smoothed displacement of tongue dorsum}
#'     \item{TD.velocity}{velocity of tongue dorsum displacement}
#'     \item{TD.velocity.abs}{absolute velocity of tongue dorsum displacement}
#'     \item{fan}{fan number}
#'     \item{X}{horizontal coordinate at time \code{seconds}}
#'     \item{Y}{vertical coordinate at time \code{seconds}}
#' }
"tongue"

#' Palate profile dataset.
#'
#' A dataset containing the palate profile of a single speaker.
#'
#' @format A data frame with 42 rows and 14 variables
#' \describe{
#'     \item{speaker}{speaker ID}
#'     \item{seconds}{time of coordinate, in seconds}
#'     \item{rec.date}{date and time of recording}
#'     \item{prompt}{prompt string}
#'     \item{label}{label of annotation}
#'     \item{TT.displacement}{smoothed displacement of tongue tip}
#'     \item{TT.velocity}{velocity of tongue tip displacement}
#'     \item{TT.velocity.abs}{absolute velocity of tongue tip displacement}
#'     \item{TD.displacement}{smoothed displacement of tongue dorsum}
#'     \item{TD.velocity}{velocity of tongue dorsum displacement}
#'     \item{TD.velocity.abs}{absolute velocity of tongue dorsum displacement}
#'     \item{fan}{fan number}
#'     \item{X}{horizontal coordinate at time \code{seconds}}
#'     \item{Y}{vertical coordinate at time \code{seconds}}
#' }
"palate"