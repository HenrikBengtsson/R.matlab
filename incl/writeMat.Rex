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
