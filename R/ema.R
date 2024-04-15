read_ema_pos<- function(path, channels = 12, ch_values = 7, bytes = 4) {
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

  data_tbl <- tibble::as_tibble(
    data_matrix
  ) |>
    dplyr::mutate(
      chn = rep(1:channels, length.out = n_values / ch_values),
      sample = rep(1:n_samples, each = channels),
      file = path
    ) |>
    relocate(file, chn, sample, everything())

  return(data_tbl)
}
