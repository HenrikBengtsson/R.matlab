library("R.matlab")

message("writeMat() ...")

message("writeMat() - basic objects ...")

A <- matrix(1:27, nrow = 9, ncol = 3)
B <- as.matrix(1:10)
C <- matrix(c(TRUE, FALSE, FALSE, TRUE), nrow = 2, ncol = 2)
D <- array(1:18, dim = c(2, 3, 3))

Cint <- local({ mode(C) <- "integer"; C })
truth <- list(A = A, B = B, C = Cint, D = D)


filename <- paste(tempfile(), ".mat", sep = "")

writeMat(filename, A = A, B = B, C = C, D = D, verbose = -120)
data <- readMat(filename)
str(data)
stopifnot(all.equal(truth, data[names(truth)]))

unlink(filename)


filename <- paste(tempfile(), ".mat", sep = "")

## Files are overwritten without notice
writeMat(filename, A = A, B = B, C = C, D = D)
data <- readMat(filename)
str(data)
stopifnot(all.equal(truth, data[names(truth)]))

unlink(filename)


message("writeMat() - to connection ...")

filename <- paste(tempfile(), ".mat", sep = "")
con <- file(filename)

## Files are overwritten without notice
writeMat(con, A = A, B = B, C = C, D = D, verbose = TRUE)

con <- file(filename)
data <- readMat(con)
str(data)
stopifnot(all.equal(truth, data[names(truth)]))

raw <- readBin(filename, what = "raw", n = 1e6)
data <- readMat(raw)
str(data)
stopifnot(all.equal(truth, data[names(truth)]))

unlink(filename)

message("writeMat() - to connection ... DONE")


message("writeMat() - basic objects ... DONE")


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Complex objects
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
message("writeMat() - complex objects ...")

F <- matrix(1i^ (-6:5), nrow = 4)

filename <- paste(tempfile(), ".mat", sep = "")
writeMat(filename, F = F, verbose = -120)
data <- readMat(filename)
str(data)
stopifnot(all.equal(data$F, F))
unlink(filename)

message("writeMat() - complex objects ... DONE")


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Character objects
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
message("writeMat() - character objects ...")

e <- paste("letter:", letters)
E <- matrix(c(e, letters), nrow = 13, ncol = 4)

filename <- paste(tempfile(), ".mat", sep = "")

writeMat(filename, e = e, verbose = -120)
data <- readMat(filename)
str(data)
stopifnot(length(data$e) == length(e))

unlink(filename)


filename <- paste(tempfile(), ".mat", sep = "")

writeMat(filename, E = E, verbose = -120)
data <- readMat(filename)
str(data)
stopifnot(length(data$E) == length(E))

unlink(filename)

message("writeMat() - character objects ... DONE")


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Multi-dimensional arrays
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
message("writeMat() - multidimensional arrays ...")

filename <- paste(tempfile(), ".mat", sep = "")
X <- array(1:24, dim = c(2, 3, 4))
writeMat(filename, X = X)
data <- readMat(filename)
str(data)
stopifnot(all.equal(data$X, X))
unlink(filename)

filename <- paste(tempfile(), ".mat", sep = "")
A <- 1:4
X <- array(1:24, dim = c(2, 3, 4))
data <- list(A = A, X = X)
writeMat(filename, data = data)
data2 <- readMat(filename)$data
str(data2)
## FIXME: https://github.com/HenrikBengtsson/R.matlab/issues/30
## stopifnot(all.equal(data2$A, data$A), all.equal(data2$X, data$X),
##           all.equal(data2, data))
unlink(filename)

message("writeMat() - multidimensional arrays ... DONE")


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# All objects written must be named uniquely
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
message("writeMat() - onWrite ...")

g <- 0L
onWrite <- function(...) {
  args <- list(...)
  str(args)
  g <<- g + 1L
}

filename <- paste(tempfile(), ".mat", sep = "")
writeMat(filename, x = 1, onWrite = onWrite)
unlink(filename)
print(g)
stopifnot(g == 1L)

message("writeMat() - onWrite ... DONE")

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Renaming variable and field names
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
message("writeMat() - fixNames ...")

truth <- list(a.b = 1, c_d = 2, e_f.g = 3, x = 4)
str(truth)
names <- names(truth)
names. <- gsub("_", ".", names(truth), fixed = TRUE)
names_ <- gsub(".", "_", names(truth), fixed = TRUE)

message("writeMat() - fixNames and variable names ...")

filename <- paste(tempfile(), ".mat", sep = "")
do.call(writeMat, args = c(list(filename), truth, fixNames = FALSE))
data <- readMat(filename, fixNames = FALSE)
str(data)
stopifnot(length(data) == length(truth), all(names(data) == names))
data <- readMat(filename, fixNames = TRUE)
str(data)
stopifnot(length(data) == length(truth), all(names(data) == names.))
unlink(filename)

filename <- paste(tempfile(), ".mat", sep = "")
do.call(writeMat, args = c(list(filename), truth, fixNames = TRUE))
data <- readMat(filename, fixNames = FALSE)
str(data)
stopifnot(length(data) == length(truth), all(names(data) == names_))
data <- readMat(filename, fixNames = TRUE)
str(data)
stopifnot(length(data) == length(truth), all(names(data) == names.))
unlink(filename)

message("writeMat() - fixNames and variable names ... DONE")

message("writeMat() - fixNames and field names ...")

filename <- paste(tempfile(), ".mat", sep = "")
writeMat(filename, x = truth, fixNames = FALSE)
data <- readMat(filename, fixNames = FALSE)
str(data)
stopifnot(nrow(data) == length(truth), all(rownames(data$x) == names))
data <- readMat(filename, fixNames = TRUE)
str(data)
stopifnot(nrow(data) == length(truth), all(rownames(data$x) == names.))
unlink(filename)

filename <- paste(tempfile(), ".mat", sep = "")
writeMat(filename, x = truth, fixNames = TRUE)
data <- readMat(filename, fixNames = FALSE)
str(data)
stopifnot(nrow(data) == length(truth), all(rownames(data$x) == names_))
data <- readMat(filename, fixNames = TRUE)
str(data)
stopifnot(nrow(data) == length(truth), all(rownames(data$x) == names.))
unlink(filename)

message("writeMat() - fixNames and field names ... DONE")

message("writeMat() - fixNames ... DONE")

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# All objects written must be named uniquely
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
message("writeMat() - exceptions ...")

filename <- paste(tempfile(), ".mat", sep = "")
tryCatch({
  # Named
  writeMat(filename, A = A, verbose = -120)
  # Not named
  writeMat(filename, A, verbose = -120)
}, error = function(ex) {
  cat("ERROR:", ex$message, "\n")
})
unlink(filename)


filename <- paste(tempfile(), ".mat", sep = "")
tryCatch({
  # Uniquely named
  writeMat(filename, A = A, B = B, C = C, verbose = -120)
  # Not uniquely named
  writeMat(filename, A = A, B = B, A = C, verbose = -120)
}, error = function(ex) {
  cat("ERROR:", ex$message, "\n")
})
unlink(filename)

filename <- paste(tempfile(), ".mat", sep = "")
res <- tryCatch({
  writeMat(filename, expr = substitute(x <- 2))
}, error = identity)
print(res)
unlink(filename)

filename <- paste(tempfile(), ".mat", sep = "")
res <- tryCatch({
  writeMat(filename, formula = y ~ x)
}, error = identity)
print(res)
unlink(filename)


filename <- paste(tempfile(), ".mat", sep = "")
res <- tryCatch({
  writeMat(filename, x = 1, matVersion = "99")
}, error = identity)
print(res)
unlink(filename)

message("writeMat() - exceptions ... DONE")


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Octave compatibility
# [1] GNU Octave, bug #42562: 3.8.1 can't load mat file
#     (>maltab r2010b), 2014-06-15
#     https://savannah.gnu.org/bugs/?42562
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
message("writeMat() - Octave compatibility ...")

value <- double(0L)
filename <- file.path(tempdir(), "octave-bug42562-empty.mat")
writeMat(filename, value = value, verbose = -120)
data <- readMat(filename, verbose = -100)
value2 <- data$value
str(value2)
stopifnot(length(value2) == length(value))
stopifnot(all(value2 == value))

value <- 0
filename <- file.path(tempdir(), "octave-bug42562-scalar.mat")
writeMat(filename, value = value, verbose = -120)
data <- readMat(filename, verbose = -100)
value2 <- data$value
str(value2)
stopifnot(length(value2) == length(value))
stopifnot(all(value2 == value))

value <- 1:5
filename <- file.path(tempdir(), "octave-bug42562-vector.mat")
writeMat(filename, value = value, verbose = -120)
data <- readMat(filename, verbose = -100)
value2 <- data$value
str(value2)
stopifnot(length(value2) == length(value))
stopifnot(all(value2 == value))

message("writeMat() - Octave compatibility ... DONE")

message("writeMat() ... DONE")
