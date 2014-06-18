library("R.matlab")

A <- matrix(1:27, ncol=3)
B <- as.matrix(1:10)
C <- array(1:18, dim=c(2,3,3))

filename <- paste(tempfile(), ".mat", sep="")

writeMat(filename, A=A, B=B, C=C)
data <- readMat(filename)
str(data)

X <- list(A=A, B=B, C=C)
stopifnot(all.equal(X, data[names(X)]))

unlink(filename)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# All objects written must be named uniquely
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
tryCatch({
  # Named
  writeMat(filename, A=A)
  # Not named
  writeMat(filename, A)
}, error = function(ex) {
  cat("ERROR:", ex$message, "\n")
})


tryCatch({
  # Uniquely named
  writeMat(filename, A=A, B=B, C=C)
  # Not uniquely named
  writeMat(filename, A=A, B=B, A=C)
}, error = function(ex) {
  cat("ERROR:", ex$message, "\n")
})


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Octave compatibility
# [1] GNU Octave, bug #42562: 3.8.1 can't load mat file
#     (>maltab r2010b), 2014-06-15
#     https://savannah.gnu.org/bugs/?42562
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
value <- double(0L)
filename <- "octave-bug42562-empty.mat"
writeMat(filename, value=value)
data <- readMat(filename, verbose=-100)
value2 <- data$value
str(value2)
stopifnot(length(value2) == length(value))
stopifnot(all(value2 == value))

value <- 0
filename <- "octave-bug42562-scalar.mat"
writeMat(filename, value=value)
data <- readMat(filename, verbose=-100)
value2 <- data$value
str(value2)
stopifnot(length(value2) == length(value))
stopifnot(all(value2 == value))

value <- 1:5
filename <- "octave-bug42562-vector.mat"
writeMat(filename, value=value)
data <- readMat(filename, verbose=-100)
value2 <- data$value
str(value2)
stopifnot(length(value2) == length(value))
stopifnot(all(value2 == value))

