# calling the C++ functions
Rcpp::sourceCpp("Rcpp_Code.cpp")

# function to calculate required time to sort a particular input array using a user defined cutoff
single_hybrid_runtime <-
  function(array_to_be_sorted, cutoff_to_be_used)
  {
    system.time(sorting_R(array_to_be_sorted, 1, cutoff_to_be_used))["user.self"]
  }

# function to calculate the time required for sorting arrays of some particular size using different choices of cutoff
comparative_hybrid_runtime <- function(array_size, cutoff)
{
  simulated_array <- rnorm(array_size)
  sapply(cutoff, single_hybrid_runtime, array_to_be_sorted = simulated_array)
}

# function to calculate average runtime for user defined array size for different choices of cutoff,
# average being taken over different replications (optionally user defined)
average_hybrid_runtime <-
  function(array_size, cutoff, replication = 50)
  {
    times <-
      rowMeans(replicate(
        replication,
        comparative_hybrid_runtime(array_size, cutoff)
      ))
    names(times) <- cutoff
    return(times)
  }

# choices of cut-off used for simulation study
keys <- seq(1, 1000, 1)

# simulated average run-times
times_1_e_5 <-
  average_hybrid_runtime(array_size = 1e+5, cutoff = keys)
times_2_e_5 <-
  average_hybrid_runtime(array_size = 2e+5, cutoff = keys)
times_3_e_5 <-
  average_hybrid_runtime(array_size = 3e+5, cutoff = keys)
times_4_e_5 <-
  average_hybrid_runtime(array_size = 4e+5, cutoff = keys)
times_5_e_5 <-
  average_hybrid_runtime(array_size = 5e+5, cutoff = keys)
times_6_e_5 <-
  average_hybrid_runtime(array_size = 6e+5, cutoff = keys)
times_7_e_5 <-
  average_hybrid_runtime(array_size = 7e+5, cutoff = keys)
times_8_e_5 <-
  average_hybrid_runtime(array_size = 8e+5, cutoff = keys)
times_9_e_5 <-
  average_hybrid_runtime(array_size = 9e+5, cutoff = keys)
times_1_e_6 <-
  average_hybrid_runtime(array_size = 1e+6, cutoff = keys)
times <-
  cbind(
    times_1_e_5,
    times_2_e_5,
    times_3_e_5,
    times_4_e_5,
    times_5_e_5,
    times_6_e_5,
    times_7_e_5,
    times_8_e_5,
    times_9_e_5,
    times_1_e_6
  )
write.csv(cbind(keys, times), "results.csv", row.names = FALSE)

# performing lowess to suggest the optimum
optimum_cutoff_1_e_5 <-
  with(lowess(keys, times_1_e_5, f = 1 / 3), x[which.min(y)])
optimum_cutoff_2_e_5 <-
  with(lowess(keys, times_2_e_5, f = 1 / 3), x[which.min(y)])
optimum_cutoff_3_e_5 <-
  with(lowess(keys, times_3_e_5, f = 1 / 3), x[which.min(y)])
optimum_cutoff_4_e_5 <-
  with(lowess(keys, times_4_e_5, f = 1 / 3), x[which.min(y)])
optimum_cutoff_5_e_5 <-
  with(lowess(keys, times_5_e_5, f = 1 / 3), x[which.min(y)])
optimum_cutoff_6_e_5 <-
  with(lowess(keys, times_6_e_5, f = 1 / 3), x[which.min(y)])
optimum_cutoff_7_e_5 <-
  with(lowess(keys, times_7_e_5, f = 1 / 3), x[which.min(y)])
optimum_cutoff_8_e_5 <-
  with(lowess(keys, times_8_e_5, f = 1 / 3), x[which.min(y)])
optimum_cutoff_9_e_5 <-
  with(lowess(keys, times_9_e_5, f = 1 / 3), x[which.min(y)])
optimum_cutoff_1_e_6 <-
  with(lowess(keys, times_1_e_6, f = 1 / 3), x[which.min(y)])
optimum_cutoffs <-
  c(
    optimum_cutoff_1_e_5,
    optimum_cutoff_2_e_5,
    optimum_cutoff_3_e_5,
    optimum_cutoff_4_e_5,
    optimum_cutoff_5_e_5,
    optimum_cutoff_6_e_5,
    optimum_cutoff_7_e_5,
    optimum_cutoff_8_e_5,
    optimum_cutoff_9_e_5,
    optimum_cutoff_1_e_6
  )
write.table(
  t(optimum_cutoffs),
  "results.csv",
  append = TRUE,
  col.names = FALSE,
  row.names = "Optimum",
  sep = ","
)
lowess_results <- cbind((1:10) * 1e+5, optimum_cutoffs)
colnames(a) <- c("Array Sizes", "Optimum Cut-offs")

# plot of simulated average run-times
png("Plot 1.png")
plot(
  keys,
  times_1_e_5,
  type = "o",
  main = "For array size 1e+05",
  xlab = "Cutoff Used",
  ylab = "Time Taken"
)
lines(lowess(keys, times_1_e_5, f = 1 / 3),
      col = "red",
      lwd = 2)
dev.off()
png("Plot 2.png")
plot(
  keys,
  times_2_e_5,
  type = "o",
  main = "For array size 2e+05",
  xlab = "Cutoff Used",
  ylab = "Time Taken"
)
lines(lowess(keys, times_2_e_5, f = 1 / 3),
      col = "red",
      lwd = 2)
dev.off()
png("Plot 3.png")
plot(
  keys,
  times_3_e_5,
  type = "o",
  main = "For array size 3e+05",
  xlab = "Cutoff Used",
  ylab = "Time Taken"
)
lines(lowess(keys, times_3_e_5, f = 1 / 3),
      col = "red",
      lwd = 2)
dev.off()
png("Plot 4.png")
plot(
  keys,
  times_4_e_5,
  type = "o",
  main = "For array size 4e+05",
  xlab = "Cutoff Used",
  ylab = "Time Taken"
)
lines(lowess(keys, times_4_e_5, f = 1 / 3),
      col = "red",
      lwd = 2)
dev.off()
png("Plot 5.png")
plot(
  keys,
  times_5_e_5,
  type = "o",
  main = "For array size 5e+05",
  xlab = "Cutoff Used",
  ylab = "Time Taken"
)
lines(lowess(keys, times_5_e_5, f = 1 / 3),
      col = "red",
      lwd = 2)
dev.off()
png("Plot 6.png")
plot(
  keys,
  times_6_e_5,
  type = "o",
  main = "For array size 6e+05",
  xlab = "Cutoff Used",
  ylab = "Time Taken"
)
lines(lowess(keys, times_6_e_5, f = 1 / 3),
      col = "red",
      lwd = 2)
dev.off()
png("Plot 7.png")
plot(
  keys,
  times_7_e_5,
  type = "o",
  main = "For array size 7e+05",
  xlab = "Cutoff Used",
  ylab = "Time Taken"
)
lines(lowess(keys, times_7_e_5, f = 1 / 3),
      col = "red",
      lwd = 2)
dev.off()
png("Plot 8.png")
plot(
  keys,
  times_8_e_5,
  type = "o",
  main = "For array size 8e+05",
  xlab = "Cutoff Used",
  ylab = "Time Taken"
)
lines(lowess(keys, times_8_e_5, f = 1 / 3),
      col = "red",
      lwd = 2)
dev.off()
png("Plot 9.png")
plot(
  keys,
  times_9_e_5,
  type = "o",
  main = "For array size 9e+05",
  xlab = "Cutoff Used",
  ylab = "Time Taken"
)
lines(lowess(keys, times_9_e_5, f = 1 / 3),
      col = "red",
      lwd = 2)
dev.off()
png("Plot 10.png")
plot(
  keys,
  times_1_e_6,
  type = "o",
  main = "For array size 1e+06",
  xlab = "Cutoff Used",
  ylab = "Time Taken"
)
lines(lowess(keys, times_1_e_6, f = 1 / 3),
      col = "red",
      lwd = 2)
dev.off()

# function to compute improvement in runtime for a single replication for a user defined input size
single_improvement <- function(array_size)
{
  x <- rnorm(array_size)
  hybrid_time <- system.time(sorting_R(x, 1))["user.self"]
  quick_time <- system.time(sorting_R(x, 4))["user.self"]
  (quick_time - hybrid_time) * 100 / quick_time
}

# function to compute average improvement over multiple replications
average_improvement <- function(length_of_array, replication = 50)
{
  mean(replicate(replication, single_improvement(length_of_array)))
}

# simulated sizes used for improvement calculation
sizes <- seq(1e+5, 1e+7, 1e+5)

# simulated percentage improvement data
improvement <- sapply(sizes, average_improvement)

# plot of simulated percentage improvement data
png("Plot 11.png")
plot(
  sizes,
  improvement,
  type = "o",
  xlab = "Array Size",
  ylab = "Percentage Improvement",
  main = "Improvement in Hybrid algorithm over Quick"
)
dev.off()
