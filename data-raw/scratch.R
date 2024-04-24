# resample example ----

# Generate a sample signal (sine wave)
frequency <- 5  # Frequency of the sine wave (in Hz)
sampling_rate <- 65  # Sampling rate (in Hz)
duration <- 1  # Duration of the signal (in seconds)
time <- seq(0, duration, 1/sampling_rate)  # Time vector
signal <- sin(2 * pi * frequency * time)  # Sine wave signal
# noise <- rnorm(length(signal), mean = 0, sd = 0.2)
# noisy_signal <- signal + noise

# Resample the signal using a polyphase algorithm
resampled_signal <- gsignal::resample(signal, p = 390, q = 65)
resampled_time <- seq(0, 1, length.out = length(resampled_signal) - 5)
upsampled_signal <- gsignal::upsample(signal, 4)
upsampled_time <- seq(0, 1, length.out = length(upsampled_signal) - 5)

resampled <- resample_signal(signal, 390, 65)


plot(time, signal, type = "p")
lines(resampled$time, resampled$signal, col = "red", type = "p", pch = 3)
# lines(upsampled_time, upsampled_signal[1:(length(upsampled_signal) - 4)], col = "green", type = "p", pch = 20)

# new_fs <- 200
# interp_time <- seq(0, 1, length.out = new_fs)
# interp_signal <- approx(time, signal, xout = interp_time)

# order <- 4  # Filter order
# cutoff_freq <- 20  # Cutoff frequency in Hz
# sampling_freq <- 65  # Sampling frequency in Hz

# Calculate normalized cutoff frequency
# nyquist_freq <- sampling_freq / 2
# normalized_cutoff <- cutoff_freq / nyquist_freq

# Design the Butterworth filter
# butterworth_filter <- gsignal::butter(order, normalized_cutoff, type = "low")

# padded_signal <- gsignal::upfirdn(signal, butterworth_filter$b, p = 3)

# Plot the original and resampled signals

# lines(interp_time, interp_signal$y, col = "green", type = "l")
# lines(seq(0, 1, length.out = length(padded_signal)), padded_signal, col = "green", type = "p", pch = 20)














lx <- 600
tx <- seq(0, 1360, length.out = lx)
x <- sin(2 * pi * tx / 120)

# upsample
p <- 3; q <- 2
ty <- seq(0, 1360, length.out = lx * p / q)
y <- resample(x, p, q)

# downsample
p <- 2; q <- 3
tz <- seq(0, 1360, length.out = lx * p / q)
z <- resample(x, p, q)

# plot
plot(tx, x, type = "b", col = 1, pch = 1,
     xlab = "", ylab = "")
points(ty, y, col = 2, pch = 2)
points(tz, z, col = 3, pch = 3)
legend("bottomleft", legend = c("original", "upsampled", "downsampled"),
       lty = 1, pch = 1:3, col = 1:3)













# Generate a noisy sinusoidal signal
set.seed(123) # Set seed for reproducibility

# Parameters
n <- 1000 # Number of data points
freq <- 1 # Frequency of the sinusoidal signal
amplitude <- 1 # Amplitude of the sinusoidal signal
noise_sd <- 0.2 # Standard deviation of the noise

# Generate time vector
time <- seq(0, 10, length.out = n)

# Generate sinusoidal signal
sinusoidal_signal <- amplitude * sin(2 * pi * freq * time)

# Add noise
noise <- rnorm(n, mean = 0, sd = noise_sd)
noisy_signal <- sinusoidal_signal + noise

filtered <- filter_signal(noisy_signal, order = 2, window_length = 41)
filtered_2 <- filter_signal(filtered, order = 2, window_length = 41)

# Plot the noisy sinusoidal signal
plot(time, sinusoidal_signal, type = "l", col = "blue", main = "Noisy Sinusoidal Signal", xlab = "Time", ylab = "Amplitude")
# lines(time, sinusoidal_signal, col = "green", lty = "dashed", lwd = 2)
lines(time, filtered, col = "green", lwd = 3)
lines(time, filtered_2, col = "red", lwd = 3)

plot(time[-1], diff(sinusoidal_signal), type = "l", col = "blue", main = "Noisy Sinusoidal Signal", xlab = "Time", ylab = "Amplitude")
# lines(time, sinusoidal_signal, col = "green", lty = "dashed", lwd = 2)
lines(time[-1], diff(filtered_2), col = "red", lwd = 3)

filtered <- filter_signal(noisy_signal, filter = "butter", order = 3, sampling_freq = 100, cutoff_freq = 2.5)

# Plot the noisy sinusoidal signal
plot(time, sinusoidal_signal, type = "l", col = "blue", main = "Noisy Sinusoidal Signal", xlab = "Time", ylab = "Amplitude")
# lines(time, sinusoidal_signal, col = "green", lty = "dashed", lwd = 2)
lines(time, filtered, col = "green", lwd = 3)



library(gsignal)

# Define filter parameters
order <- 3  # Filter order
cutoff_freq <- 20  # Cutoff frequency in Hz
sampling_freq <- 100  # Sampling frequency in Hz

# Calculate normalized cutoff frequency
nyquist_freq <- sampling_freq / 2
normalized_cutoff <- cutoff_freq / nyquist_freq

# Design the Butterworth filter
butterworth_filter <- gsignal::butter(order, normalized_cutoff, type = "low")

# Generate example signal (e.g., sinusoidal)
time <- seq(0, 10, length.out = 1000)
signal <- sin(2 * pi * 1 * time)  # Example sinusoidal signal with frequency of 10 Hz
noise <- rnorm(n, mean = 0, sd = noise_sd)
noisy_signal <- sinusoidal_signal + noise

# Apply the filter to the signal
filtered_signal <- filter(butterworth_filter, noisy_signal)

# Plot original and filtered signals
plot(time, signal, type = "l", col = "blue", xlab = "Time", ylab = "Amplitude", main = "Original and Filtered Signals")
lines(time, filtered_signal, col = "red")
legend("topright", legend = c("Original", "Filtered"), col = c("blue", "red"), lty = 1)






## Modified sync kernel

# Function to smooth the data using a modified sinc kernel
# Similar to Savitzky-Golay filters, with degree determining
# the sharpness of the cutoff in the frequency domain.
# Handles boundary values by weighted linear extrapolation before convolution.
smoothMS <- function(data, deg, m) {
  if (length(data) < 2) {
    stop("Less than two data points")
  }

  kernel <- kernelMS(deg, m)
  fitWeights <- edgeWeights(deg, m)
  extData <- extendData(data, m, fitWeights)
  smoothedExtData <- convolve(extData, kernel, type = "filter", sides = 2*m)
  smoothedData <- smoothedExtData[(m+1):(length(data)+m)]
  return(smoothedData)
}

# Function to smooth using a shorter MS1 kernel
smoothMS1 <- function(data, deg, m) {
  if (length(data) < 2) {
    stop("Less than two data points")
  }

  kernel <- kernelMS1(deg, m)
  fitWeights <- edgeWeights1(deg, m)
  extData <- extendData(data, m, fitWeights)
  smoothedExtData <- convolve(extData, kernel, type = "filter", sides = 2*m)
  smoothedData <- smoothedExtData[(m+1):(length(data)+m)]
  return(smoothedData)
}

# Correction coefficients for a flat passband of the MS kernel
corrCoeffsMS <- function(deg) {
  switch(deg,
         2, {coeffs <- NULL},
         4, {coeffs <- NULL},
         6, {coeffs <- matrix(c(0.001717576, 0.02437382, 1.64375), ncol = 3)},
         8, {coeffs <- matrix(c(0.0043993373, 0.088211164, 2.359375,
                                0.006146815, 0.024715371, 3.6359375), ncol = 3)},
         10, {coeffs <- matrix(c(0.0011840032, 0.04219344, 2.746875,
                                 0.0036718843, 0.12780383, 2.7703125), ncol = 3)},
         stop("Invalid degree")
  )
  return(coeffs)
}

# Correction coefficients for a flat passband of the MS1 kernel
corrCoeffsMS1 <- function(deg) {
  switch(deg,
         2, {coeffs <- NULL},
         4, {coeffs <- matrix(c(0.021944195, 0.050284006, 0.765625), ncol = 3)},
         6, {coeffs <- matrix(c(0.001897730, 0.00847681, 1.2625,
                                0.023064667, 0.13047926, 1.2265625), ncol = 3)},
         8, {coeffs <- matrix(c(0.006590300, 0.05792946, 1.915625,
                                0.002323448, 0.01029885, 2.2726562,
                                0.021046653, 0.16646601, 1.98125), ncol = 3)},
         10, {coeffs <- matrix(c(9.749618E-4, 0.00207429, 3.74375,
                                 0.008975366, 0.09902466, 2.707812,
                                 0.002419541, 0.01006486, 3.296875,
                                 0.019185117, 0.18953617, 2.784961), ncol = 3)},
         stop("Invalid degree")
  )
  return(coeffs)
}

# Function to calculate the MS convolution kernel
kernelMS <- function(deg, m) {
  coeffs <- corrCoeffsMS(deg)
  kappa <- sapply(coeffs, function(abcd) {
    abcd[1] + abcd[2] / (abcd[3] - m)^3
  })

  if (deg %% 2 == 0) {
    nuMinus2 <- 0
  } else {
    nuMinus2 <- -1
  }

  kernel <- numeric(2*m + 1)
  kernel[m + 1] <- windowMS(0, 4)

  for (i in 1:m) {
    x <- i / (m + 1)
    w <- windowMS(x, 4)
    a <- sin((0.5 * deg + 2) * pi * x) / ((0.5 * deg + 2) * pi * x)

    for (j in 1:length(kappa)) {
      a <- a + kappa[j] * x * sin((2 * j + nuMinus2) * pi * x)
    }

    a <- a * w
    kernel[m + 1 - i] <- a
    kernel[m + 1 + i] <- a
  }

  norm <- sum(kernel)
  kernel <- kernel / norm

  return(kernel)
}

# Function to calculate the MS1 convolution kernel
kernelMS1 <- function(deg, m) {
  coeffs <- corrCoeffsMS1(deg)
  kappa <- sapply(coeffs, function(abcd) {
    abcd[1] + abcd[2] / (abcd[3] - m)^3
  })

  kernel <- numeric(2*m + 1)
  kernel[m + 1] <- windowMS(0, 2)

  for (i in 1:m) {
    x <- i / (m + 1)
    w <- windowMS(x, 2)
    a <- sin((0.5 * deg + 1) * pi * x) / ((0.5 * deg + 1) * pi * x)

    for (j in 1:length(kappa)) {
      a <- a + kappa[j] * x * sin(j * pi * x)
    }

    a <- a * w
    kernel[m + 1 - i] <- a
    kernel[m + 1 + i] <- a
  }

  norm <- sum(kernel)
  kernel <- kernel / norm

  return(kernel)
}

# Gaussian-like window function for the MS and MS1 kernels
windowMS <- function(x, alpha) {
  exp(-alpha * x^2) + exp(-alpha * (x + 2)^2) + exp(-alpha * (x - 2)^2) - (2 * exp(-alpha) + exp(-9 * alpha))
}

# Hann-square weights for linear fit at the edges, for MS smoothing
edgeWeights <- function(deg, m) {
  beta <- 0.70 + 0.14 * exp(-0.6 * (deg - 4))
  fitLengthD <- ((m + 1) * beta) / (1.5 + 0.5 * deg)
  fitLength <- floor(fitLengthD)

  w <- numeric(fitLength + 1)

  for (i in 1:(fitLength + 1)) {
    cosine <- cos(pi/2 * (i - 1) / fitLengthD)
    w[i] <- cosine^2
  }

  return(w)
}

# Hann-square weights for linear fit at the edges, for MS1 smoothing
edgeWeights1 <- function(deg, m) {
  beta <- 0.65 + 0.35 * exp(-0.55 * (deg - 4))
  fitLengthD <- ((m + 1) * beta) / (1 + 0.5 * deg)
  fitLength <- floor(fitLengthD)

  w <- numeric(fitLength + 1)

  for (i in 1:(fitLength + 1)) {
    cosine <- cos(pi/2 * (i - 1) / fitLengthD)
    w[i] <- cosine^2
  }

  return(w)
}

# Extends the data by weighted linear extrapolation, for smoothing to the ends
extendData <- function(data, m, fitWeights) {
  datLength <- length(data)
  fitLength <- length(fitWeights)
  fitX <- 1:fitLength
  fitY <- data[1:fitLength]

  lm_fit <- lm(fitY ~ fitX, weights = fitWeights)
  offset <- coef(lm_fit)[1]
  slope <- coef(lm_fit)[2]

  extData <- c(offset + (-m + 1:0) * slope, data, offset + (0:-1:-m + 1) * slope)

  return(extData)
}

# Test data
deg <- 6
m <- 7
data <- c(0, 1, -2, 3, -4, 5, -6, 7, -8, 9, 10, 6, 3, 1, 0)

# Testing smoothMS function
out <- smoothMS(data, deg, m)
print("smoothMS of test data:")
print(out)
