###############################################################################
# Advanced R — Chapter: Performance
# EXERCISES
#
# Source material (adapted):
#   - https://jettes.github.io/a297advancedr/performance.html
#   - https://privefl.github.io/advr38book/performance.html
#
# Instructions for participants:
#   For each exercise, a naive/working implementation is given together with
#   its approximate timing (as reported in the reference material). Your task
#   is to write a faster implementation, and to verify that it returns the
#   same result as the naive version (e.g. with all.equal()) before comparing
#   timings with system.time()
# 
###############################################################################

# you should use microbench
# install.packages("microbenchmark")
library(microbenchmark)

###############################################################################
## Exercise 1 — Vectorization: Monte Carlo integration
###############################################################################
# Estimate the integral of x^2 on [0, 1] using a Monte Carlo method: draw
# (x, y) uniformly on [0, 1]^2 and compute the proportion of draws for which
# y < x^2.

monte_carlo <- function(N) {

  hits <- 0

  for (i in seq_len(N)) {
    x <- runif(1)
    y <- runif(1)
    if (y < x^2) {
      hits <- hits + 1
    }
  }

  hits / N
}

N <- 10e6
system.time(res <- monte_carlo(N))
res

# TASK: write a vectorized version, monte_carlo_vec(), that avoids the
# explicit loop. Verify that its result is comparable to monte_carlo()

monte_carlo_vec <- function(N) {
  # TODO: replace the loop with vectorized operations
  x <- runif(N)
  y <- runif(N)
  sum(y < x^2) / N
}

system.time(res2 <- monte_carlo_vec(N))
res2


###############################################################################
## Exercise 2 — Linear algebra: Euclidean distances between two sets of points
###############################################################################

set.seed(1)
X <- matrix(rnorm(5000), ncol = 5)
Y <- matrix(rnorm(2000), ncol = 5)

# Naive implementation (double loop):
system.time({
  dist_naive <- matrix(NA_real_, nrow(X), nrow(Y))
  for (i in seq_len(nrow(X))) {
    for (j in seq_len(nrow(Y))) {
      dist_naive[i, j] <- sqrt(sum((Y[j, ] - X[i, ])^2))
    }
  }
})

# TASK (step 1): remove one of the two loops using sweep(). Which loop
# should you remove, and why? 

# TODO: dist_sweep <- function { ... }

# There is still one explicit loop. Hence, TASK (step 2):
# implement a fully vectorized solution using the identity
#   dist(X_i, Y_j)^2 = X_i^T X_i + Y_j^T Y_j - 2 X_i^T Y_j
# and the functions outer() and tcrossprod().

# TODO: dist_vec <- function { ... }

# Verify all three approaches agree, e.g.:
# all.equal(dist_naive, dist_sweep)
# all.equal(dist_naive, dist_vec)


###############################################################################
## Exercise 3 — Random walk: proportion of negative values
###############################################################################
# Generate N steps of the process X(0) = 0, X(t+1) = X(t) + Y(t), where
# Y(t) ~ N(0, 1) i.i.d. Compute the proportion of X(t) that are negative.
# You do not need to store all values of X.

set.seed(1)
system.time({
  N <- 1e5
  x <- 0
  count <- 0
  for (i in seq_len(N)) {
    y <- rnorm(1)
    x <- x + y
    if (x < 0) count <- count + 1
  }
  p <- count / N
})
p

# TASK: write X(0), X(1), X(2), X(3) explicitly in terms of Y(0), Y(1), Y(2)
# to identify the vectorized form, then implement a vectorized version.

random_walk_neg_prop_vec <- function(N) {
  # TODO
}

set.seed(1)
system.time(p2 <- random_walk_neg_prop_vec(1e5))
p2


###############################################################################
## Exercise 4 — Vectorizing a nested loop over a matrix
###############################################################################
mat <- as.matrix(mtcars)
ind <- seq_len(nrow(mat))
mat_big <- mat[rep(ind, 1000), ]  # 1000 times bigger dataset
last_row <- mat_big[nrow(mat_big), ]

system.time({
  for (j in 1:ncol(mat_big)) {
    for (i in 1:nrow(mat_big)) {
      mat_big[i, j] <- 10 * mat_big[i, j] * last_row[j]
    }
  }
})

# TASK: vectorize this double loop.

# TODO


###############################################################################
## Exercise 5 — colSums(): partial vs. full matrix (conceptual)
###############################################################################
m0 <- matrix(rnorm(1e6), 1e3, 1e3)
microbenchmark::microbenchmark(
  colSums(m0[, 1:500]),
  colSums(m0)
)

# TASK: colSums() on the whole matrix is faster than on half of it, even
# though it does twice the work. Explain why (consider what m0[, 1:500]
# requires before colSums() can even be called).
# (you dont need to code anything, just think about it!)




###############################################################################
## Exercise 6 — Prime numbers up to N
###############################################################################
# TASK: write a fast function AllPrimesUpTo(N) that returns all prime
# numbers up to N (e.g. using the Sieve of Eratosthenes).
# https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes
# Compare your implementation against microbenchmark for increasing N.
# Hint: Modulo operator (also called remainer operator) '%%' is very useful here!

AllPrimesUpTo <- function(N) {
  # TODO
}

N <- 1e6
system.time(primes <- AllPrimesUpTo(N))


#
install.packages("devtools",
"usethis", 
"roxygen2", 
"testthat", 
"spelling2")
