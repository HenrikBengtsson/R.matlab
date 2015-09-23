library("R.matlab")
library("methods")

path <- system.file("mat-files", package="R.matlab")


equals <- function(target, current, ..., check.attributes=FALSE, assert=TRUE) {
  ## AD HOC: 'SparseM' matrices gives an error on
  ##         as.matrix() if covr::package_coverage().
  if ("covr" %in% loadedNamespaces()) {
    for (obj in list(target, current))
      if (inherits(obj, c("matrix.coo", "matrix.csc"))) return(TRUE)
  }
  target <- as.matrix(target)
  current <- as.matrix(current)
  eq <- all.equal(target=target, current=current, check.attributes=check.attributes, ...)
  if (!isTRUE(eq)) {
    print(eq)
    str(list(target, current))
    if (assert) {
      stop("Detected differences between matrices.")
    }
  }
  eq
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Reading all example files
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
for (version in 4:5) {
  cat("Loading all MAT v", version, " example files in ",
                                                path, "...\n", sep="")

  pattern <- sprintf("-v%d[.]mat$", version)
  pathnames <- list.files(pattern=pattern, path=path, full.names=TRUE)

  for (pathname in pathnames) {
    cat("Reading MAT file: ", basename(pathname), "\n", sep="")
    tryCatch({
    mat <- readMat(pathname)
    print(mat)
}, error = function(ex) {
    print(ex)
    message(pathname)
})
  }
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Assert that signed and unsigned integers are read correctly
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
bs <- readMat(file.path(path, "unsignedByte.mat"), verbose=-120)
if (!identical(as.vector(bs$A), as.double(126:255)))
  stop("Error reading unsigned bytes saved by MATLAB.")

is <- readMat(file.path(path, "unsignedInt.mat"), verbose=-120)
if (!identical(as.vector(is$B), as.double(127:256)))
  stop("Error reading unsigned ints saved by MATLAB.")


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Assert that sparse matrices are read identically in MAT v4 and v5
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
mat4 <- readMat(file.path(path, "SparseMatrix3-v4.mat"))
mat5 <- readMat(file.path(path, "SparseMatrix3-v5.mat"))
diff <- sum(abs(mat4$sparseM - mat5$sparseM))
if (diff > .Machine$double.eps)
  stop("Failed to read identical MAT v4 and MAT v5 sparse matrices.")


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Assert that sparse matrices can be read as 'Matrix' and 'SparseM'
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
pathname <- file.path(path, "SparseMatrix3-v4.mat")
mat4a <- readMat(pathname, sparseMatrixClass="matrix", verbose=-120)

if (requireNamespace("Matrix")) {
  mat4b <- readMat(pathname, sparseMatrixClass="Matrix", verbose=-120)
  eq <- equals(mat4b$sparseM, mat4a$sparseM)
  if (!isTRUE(eq)) {
    stop("Failed to read MAT v4 sparse matrix by class 'Matrix'.")
  }
}

if (requireNamespace("SparseM")) {
  mat4c <- readMat(pathname, sparseMatrixClass="SparseM", verbose=-120)
  eq <- equals(mat4c$sparseM, mat4a$sparseM)
  if (!isTRUE(eq)) {
    stop("Failed to read MAT v4 sparse matrix by class 'SparseM'.")
  }
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Assert that sparse logical matrices can be read
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
pathname <- file.path(path, "SparseLogicalDouble-v5.mat")
mat4c <- readMat(pathname, sparseMatrixClass="matrix", verbose=-120)
stopifnot(all(mat4c$L == mat4c$D))

if (requireNamespace("Matrix")) {
  mat4d <- readMat(pathname, sparseMatrixClass="Matrix", verbose=-120)
  equals(1.0*mat4d$L, mat4d$D, assert=TRUE)
}

if (requireNamespace("SparseM")) {
  mat4e <- readMat(pathname, sparseMatrixClass="SparseM", verbose=-120)
  equals(mat4e$L, mat4e$D, assert=TRUE)
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Assert that sparse matrices with all zeros can be read
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
pathname <- file.path(path, "SparseMatrix,all_zeros.mat")
mat0 <- readMat(pathname, sparseMatrixClass="matrix")
stopifnot(all(mat0$X == 0))

if (requireNamespace("Matrix")) {
  mat2 <- readMat(pathname, sparseMatrixClass="Matrix")
  equals(mat2$X, mat0$X, assert=TRUE)
  equals(mat2$Y, mat0$Y, assert=TRUE)
}

if (requireNamespace("SparseM")) {
  mat3 <- readMat(pathname, sparseMatrixClass="SparseM")
  equals(mat3$X, mat0$X, assert=TRUE)
  equals(mat3$Y, mat0$Y, assert=TRUE)
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Assert that empty sparse matrices can be read
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
pathname <- file.path(path, "SparseMatrix,empty.mat")
mat0 <- readMat(pathname, sparseMatrixClass="matrix")
stopifnot(all(mat0$cyclicalEdges == 0))

if (requireNamespace("Matrix")) {
  mat2 <- readMat(pathname, sparseMatrixClass="Matrix")
  equals(mat2$cyclicalEdges, mat0$cyclicalEdges, assert=TRUE)
}

if (requireNamespace("SparseM")) {
  mat3 <- readMat(pathname, sparseMatrixClass="SparseM")
  equals(mat3$cyclicalEdges, mat0$cyclicalEdges, assert=TRUE)
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Assert that compressed files can be read
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if (getRversion() >= "2.10.0") {
  # A particular compressed file
  pathname <- file.path(path, "StructWithSparseMatrix-v4,compressed.mat")
  mat4 <- readMat(pathname, sparseMatrixClass="matrix", verbose=-120)

  # All compressed files
  pattern <- ",compressed[.]mat$"
  pathnames <- list.files(pattern=pattern, path=path, full.names=TRUE)
  for (pathname in pathnames) {
    cat("Reading MAT file: ", basename(pathname), "\n", sep="")
    mat <- readMat(pathname)
    print(mat)
  }
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Example of a MATLAB struct
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# File was created by
# s = struct('type',{'big','little'},  'color','red',  'x',{3,4})
#  1x2 struct array with fields:
#      type
#      color
#      x
# save structLooped.mat s -v6
mat <- readMat(file.path(path, "structLooped.mat"), verbose=-120)

# Extract the structure
s <- mat$s

# Field names are always in the first dimension
fields <- dimnames(s)[[1]]
cat("Field names: ", paste(fields, collapse=", "), "\n", sep="")

print(s)

# Get field 'type'
print(s["type",,])

# Get substructure s(:,2)
print(s[,,2])


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Example of verbose output
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
bs <- readMat(file.path(path, "unsignedByte.mat"), verbose=TRUE)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Assert that newlines are preserved in text strings
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
mat <- readMat(file.path(path, "TextWithNewlines.mat"))
mystr <- mat$mystr[1,1]
print(mystr)
stopifnot(mystr == "hello\nworld\n\nEOM")
