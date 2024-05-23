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
#' @param signal_vel The velocity of the displacement signal.
#' @param time The time of the signal.
#' @param start Start time of interval in which to search for maximum displacement.
#' @param end End time of interval in which to search for maximum displacement.
#' @param threshold The velocity threshold (default is \code{0.2}, corresponding to 20 percent velocity.)
#'
#' @return A tibble with one row and a column for each gestural landmark.
#' @export
get_landmarks <- function(signal_vel, time, start, end, threshold = 0.2) {

  max_disp <- get_zerocross(signal_vel, time, start = start, end = end)
  peaks <- get_peakvel(signal_vel, time, max_disp$min_time)

  if (is.null(peaks$peak_1_vel) | is.null(peaks$peak_2_vel)) {
    cli::cli_alert_warning("Peak not found!")
    return(NA)
  }

  min_1 <- get_zerocross(signal_vel, time, end = peaks$peak_1_time)
  min_3 <- get_zerocross(signal_vel, time, start = peaks$peak_2_time)

  signal_abs_vel <- abs(signal_vel)

  # Get gesture onset
  min1_peak1_thresh <- threshold * (peaks$peak_1_vel - min_1$min_vel)
  GEST_ons <- stats::approx(
    signal_abs_vel[time >= min_1$min_time & time <= peaks$peak_1_time],
    time[time >= min_1$min_time & time <= peaks$peak_1_time],
    min_1$min_vel + min1_peak1_thresh
  )$y

  # Get plateau onset
  peak1_max_thresh <- (1 - threshold) * (max_disp$min_vel - peaks$peak_1_vel)
  PLAT_ons <- stats::approx(
    signal_abs_vel[time >= peaks$peak_1_time & time <= max_disp$min_time],
    time[time >= peaks$peak_1_time & time <= max_disp$min_time],
    peaks$peak_1_vel + peak1_max_thresh
  )$y

  # Get plateau offset
  max_peak2_thresh <- threshold * (max_disp$min_vel - peaks$peak_2_vel)
  PLAT_off <- stats::approx(
    signal_abs_vel[time >= max_disp$min_time & time <= peaks$peak_2_time],
    time[time >= max_disp$min_time & time <= peaks$peak_2_time],
    max_disp$min_vel - max_peak2_thresh
  )$y

  # Get gesture offset
  peak2_min3_thresh <- threshold * (peaks$peak_2_vel - min_3$min_vel)
  GEST_off <- stats::approx(
    signal_abs_vel[time >= peaks$peak_2_time & time <= min_3$min_time],
    time[time >= peaks$peak_2_time & time <= min_3$min_time],
    min_3$min_vel + peak2_min3_thresh
  )$y

  tibble::tibble(
    min_1_vel = min_1$min_vel, peak_1_vel = peaks$peak_1_vel,
    max_disp_vel = max_disp$min_vel,
    peak_2_vel = peaks$peak_2_vel, min_3_vel = min_3$min_vel,
    min_1_time = min_1$min_time, peaks_1_time = peaks$peak_1_time,
    max_disp_time = max_disp$min_time,
    peak_2_time = peaks$peak_2_time, min_3_time = min_3$min_time,
    GEST_ons, PLAT_ons, PLAT_off, GEST_off
  )
}


## Internals ----

# Get the time when the velocity crosses 0.
get_zerocross <- function(signal_vel, time, start = NULL, end = NULL) {
  if (is.null(start)) {
    start <- time[1]
  }

  if (is.null(end)) {
    end <- time[length(time)]
  }

  time_win_ids <- time >= start & time <= end

  min_vel <- 0
  min_time <- stats::approx(
    signal_vel[time_win_ids],
    time[time_win_ids],
    0
  )$y

  if (is.na(min_time)) {
    min_vel <- min(abs(signal_vel[time_win_ids]), na.rm = TRUE)
    min_time <- time[which(abs(signal_vel) == min_vel)]
  }

  return(
    list(
      min_vel = min_vel,
      min_time = min_time
    )
  )
}

# Get the first peak velocity before and after maximum displacement
get_peakvel <- function(signal_vel, time, maxd_time) {
  signal_abs_vel <- abs(signal_vel)

  peak_1 <- pracma::findpeaks(rev(signal_abs_vel[time < maxd_time]), minpeakheight = 0.1, npeaks = 1)
  peak_2 <- pracma::findpeaks(signal_abs_vel[time > maxd_time], minpeakheight = 0.1, npeaks = 1)

  peak_1_time <- rev(time[time < maxd_time])[peak_1[1,2]]
  peak_2_time <- time[time > maxd_time][peak_2[1,2]]

  return(
    list(
      peak_1_vel = peak_1[1,1],
      peak_1_time = peak_1_time,
      peak_2_vel = peak_2[1,1],
      peak_2_time = peak_2_time
    )
  )

}
