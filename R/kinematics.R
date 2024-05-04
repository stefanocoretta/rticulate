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



#' Get gestural landmarks
#'
#' @param signal The displacement signal.
#' @param time The time of the signal.
#' @param threshold The velocity threshold (default is \code{0.2}, corresponding to 20 percent velocity.)
#'
#' @return A tibble with one row and a column for each gestural landmark.
#' @export
get_landmarks <- function(signal, time, threshold = 0.2) {
  signal_abs_vel <- abs(get_velocity(signal))
  peaks <- pracma::findpeaks(signal_abs_vel, minpeakheight = 0.1)

  if (!is.null(peaks)) {
    if (nrow(peaks) == 2) {
    min_1_pos <- peaks[1,3] - 1
    peak_1_pos <- peaks[1,2]
    max_disp_pos <- peaks[1,4] - 1
    peak_2_pos <- peaks[2,2]
    min_3_pos <- peaks[2,4] - 1

    min_1_time <- time[min_1_pos]
    min_1 <- signal[min_1_pos]
    peak_1_time <- time[peak_1_pos]
    peak_1 <- signal[peak_1_pos]
    max_disp_time <- time[max_disp_pos]
    max_disp <- signal[max_disp_pos]
    peak_2_time <- time[peak_2_pos]
    peak_2 <- signal[peak_2_pos]
    min_3_time <- time[min_3_pos]
    min_3 <- signal[min_3_pos]

    # Get gesture onset
    # Formula: threshold * (abs_vel at peak_1 = peak_1_pos - abs_vel at min_1 = min_1_pos)
    min1_peak1_thresh <- threshold * (signal_abs_vel[peak_1_pos] - signal_abs_vel[min_1_pos])
    GEST_ons <- stats::approx(
      signal_abs_vel[time >= min_1_time & time <= peak_1_time],
      time[time >= min_1_time & time <= peak_1_time],
      signal_abs_vel[min_1_pos] + min1_peak1_thresh
    )$y

    # Get plateau onset
    # Formula: 1 - threshold * (abs_vel at max_disp - abs_vel at peak_1)
    peak1_max_thresh <- (1 - threshold) * (signal_abs_vel[max_disp_pos] - signal_abs_vel[peak_1_pos])
    PLAT_ons <- stats::approx(
      signal_abs_vel[time >= peak_1_time & time <= max_disp_time],
      time[time >= peak_1_time & time <= max_disp_time],
      signal_abs_vel[peak_1_pos] + peak1_max_thresh
    )$y

    # Get plateau offset
    # Formula: 1 - threshold * (abs_vel at max - abs_vel at peak_2)
    max_peak2_thresh <- threshold * (signal_abs_vel[max_disp_pos] - signal_abs_vel[peak_2_pos])
    PLAT_off <- stats::approx(
      signal_abs_vel[time >= max_disp_time & time <= peak_2_time],
      time[time >= max_disp_time & time <= peak_2_time],
      signal_abs_vel[max_disp_pos] - max_peak2_thresh
    )$y

    # Get gesture offset
    # Formula: threshold * (abs_vel at peak_2 = peak_2_pos - abs_vel at min_3 = min_3_pos)
    peak2_min3_thresh <- threshold * (signal_abs_vel[peak_2_pos] - signal_abs_vel[min_3_pos])
    GEST_off <- stats::approx(
      signal_abs_vel[time >= peak_2_time],
      time[time >= peak_2_time],
      signal_abs_vel[min_3_pos] +
        peak2_min3_thresh
    )$y

      tibble::tibble(
        min_1, peak_1, max_disp, peak_2, min_3,
        min_1_time, peak_1_time, max_disp_time, peak_2_time, min_3_time,
        GEST_ons, PLAT_ons, PLAT_off, GEST_off
      )
    } else {
      tibble::tibble(
        min_1 = NA, peak_1 = NA, max_disp = NA, peak_2 = NA, min_3 = NA,
        min_1_time = NA, peak_1_time = NA, max_disp_time = NA, peak_2_time = NA, min_3_time = NA,
        GEST_ons = NA, PLAT_ons = NA, PLAT_off = NA, GEST_off = NA
      )
    }
  } else {
    tibble::tibble(
      min_1 = NA, peak_1 = NA, max_disp = NA, peak_2 = NA, min_3 = NA,
      min_1_time = NA, peak_1_time = NA, max_disp_time = NA, peak_2_time = NA, min_3_time = NA,
      GEST_ons = NA, PLAT_ons = NA, PLAT_off = NA, GEST_off = NA
    )
  }
}
