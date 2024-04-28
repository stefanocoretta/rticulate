#' Filter a signal
#'
#' @param signal Signal to filter.
#' @param filter Type of filter (default is \code{"sgolay"}, or \code{"butter"}).
#' @param order Order of the filter.
#' @param window_length Window length of the Savitzky-Golay filter.
#' @param cutoff_freq Cut-off frequency of the Butterworth filter.
#' @param sampling_freq Sampling frequency of the signal.
#' @param type Butterworth band type (default is \code{"low"}).
#' @param apply Apply the filter N times (default is \code{1}).
#'
#' @return The filtered signal.
#' @export
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


#' Resample (up or down) a signal
#'
#' @param signal The signal to resample.
#' @param time The time vector of the signal to resample.
#' @param by The factor by which to resample the signal (default is \code{2}).
#' @param to The frequency to resample to.
#' @param from The original sampling frequency.
#' @param method Resampling method (default is \code{interpolate} which uses \code{approx}).
#'
#' @return A list with the resampled signal and time if \code{methdo = "interpolate"}.
#' @export
#'
resample_signal <- function(
    signal,
    time,
    by = 2,
    to,
    from,
    method = "interpolation"
) {
  if (method == "interpolation") {
    interp_time <- seq(min(time), max(time), length.out = length(time) * by)
    interp_sig <- stats::approx(time, signal, xout = interp_time)

    return(tibble::tibble(time_int = interp_sig$x, signal_int = interp_sig$y))
  } else if (method == "resample") {
    resampled_signal <- gsignal::resample(signal, p = to, q = from)
    phase_shift <- round(to / from) - 1
    resampled_signal <- resampled_signal[1:(length(resampled_signal) - phase_shift)]
    return(resampled_signal)
  }
}
