#' Title
#'
#' @param signal
#' @param filter
#' @param order
#' @param window_length
#' @param cutoff_freq
#' @param sampling_freq
#' @param type
#'
#' @return
#' @export
#'
#' @examples
#'
#'
filter_signal <- function(
  signal,
  filter = "sgolay",
  order = 2,
  window_length = NULL,
  cutoff_freq = NULL,
  sampling_freq = NULL,
  type = "low",
  apply = 1
) {

  signal_sm <- signal

  for (iter in 1:apply) {
    if (filter == "sgolay") {
      signal_sm <- gsignal::sgolayfilt(signal_sm, p = order, n = window_length)
    } else if (filter == "butter") {
      nyquist_freq <- sampling_freq / 2
      normalized_cutoff <- cutoff_freq / nyquist_freq
      butter_filt <- gsignal::butter(order, normalized_cutoff, type = type)

      signal_sm <- gsignal::filtfilt(butter_filt, signal_sm)
    }

  }

  return(signal_sm)
}
