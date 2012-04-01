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
  cat("ERROR:", getMessage(ex), "\n")
})


tryCatch({
  # Uniquely named
  writeMat(filename, A=A, B=B, C=C)
  # Not uniquely named
  writeMat(filename, A=A, B=B, A=C)
}, error = function(ex) {
  cat("ERROR:", getMessage(ex), "\n")
})
