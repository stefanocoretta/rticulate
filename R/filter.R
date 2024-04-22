filter_signal <- function(
  signal,
  filter = "sgolay",
  order = 2,
  window_length = NULL
) {
  if (filter == "sgolay") {
    signal_sm <- gsignal::sgolayfilt(signal, p = order, n = window_length)
  }

  return(signal_sm)
}
