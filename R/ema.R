#' Read EMA data from AG500 pos files
#'
#' @param path Path to the .pos file.
#' @param channels Number of channels (default \code{12}).
#' @param ch_values Number of values per channel (default \code{7}).
#' @param bytes Number of bytes per value (default \code{4}).
#' @param fs Sampling frequency (default \code{200} Hz).
#'
#' @return A tibble.
#' @export
read_ag500_pos <- function(path, channels = 12, ch_values = 7, bytes = 4, fs = 200) {
  con <- file(path, "rb")

  # File size in bytes
  file_size <- file.info(path)$size
  # Number of values in file (each value is `bytes` bytes, default to 4 bytes)
  n_values <- file_size / bytes
  # Number of samples (each sample as `channels * ch_values` values)
  n_samples <- n_values / channels / ch_values

  data_bin <- readBin(con, what = "numeric", n = n_values, size = bytes)
  close(con)

  data_matrix <- matrix(data_bin, ncol = ch_values, byrow = TRUE)
  colnames(data_matrix) <- c("x", "y", "z", "phi", "theta", "rms", "extra")

  time <- seq(0, (n_samples - 1) / fs, by = 1 / fs)

  data_tbl <- tibble::as_tibble(
    data_matrix
  ) |>
    dplyr::mutate(
      file = path,
      chn = rep(1:channels, length.out = n_values / ch_values),
      sample = rep(1:n_samples, each = channels),
      time = rep(time, each = channels)
    ) |>
    dplyr::relocate(file, chn, sample, time, tidyselect::everything())

  return(data_tbl)
}
