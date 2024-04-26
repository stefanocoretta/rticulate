#' Get velocity of displacement
#'
#' @param signal The signal to get the velocity of.
#'
#' @return A vector with the first derivative of the signal.
#' @export
get_velocity <- function(signal) {
  return(c(NA, diff(signal)))
}

#' Get acceleration of displacement
#'
#' @param signal The signal to get the acceleration of.
#'
#' @return A vector with the second derivative of the signal.
#' @export
get_acceleration <- function(signal) {
  return(c(NA, NA, diff(signal, differences = 2)))
}
