#' Get velocity of displacement
#'
#' @param signal The signal to get the velocity of.
#'
#' @return A vector with the first derivative of the signal.
#' @export
get_velocity <- function(signal) {
  return(c(NA, diff(signal)))
}
