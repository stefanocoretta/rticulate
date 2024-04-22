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




library(gsignal)

# Define filter parameters
order <- 3  # Filter order
cutoff_freq <- 20  # Cutoff frequency in Hz
sampling_freq <- 100  # Sampling frequency in Hz

# Calculate normalized cutoff frequency
nyquist_freq <- sampling_freq / 2
normalized_cutoff <- cutoff_freq / nyquist_freq

# Design the Butterworth filter
butterworth_filter <- butter(order, normalized_cutoff, type = "low")

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
