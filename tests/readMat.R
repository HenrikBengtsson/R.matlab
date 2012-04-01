library("R.matlab")

path <- system.file("mat-files", package="R.matlab")

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
    mat <- readMat(pathname)
    if (interactive()) {
      cat("Press ENTER to view data:")
      readline()
    }
    print(mat)
  }
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Assert that signed and unsigned integers are read correctly
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
bs <- readMat(file.path(path, "unsignedByte.mat"))
if (!identical(as.vector(bs$A), as.double(126:255)))
  stop("Error reading unsigned bytes saved by Matlab.")

is <- readMat(file.path(path, "unsignedInt.mat"))
if (!identical(as.vector(is$B), as.double(127:256)))
  stop("Error reading unsigned ints saved by Matlab.")


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
mat4a <- readMat(pathname, sparseMatrixClass="matrix")

if (require("Matrix")) {
  mat4b <- readMat(pathname, sparseMatrixClass="Matrix")
  diff <- sum(abs(as.matrix(mat4b$sparseM) - mat4a$sparseM))
  if (diff > .Machine$double.eps)
    stop("Failed to read MAT v4 sparse matrix by class 'Matrix'.")
}

if (require("SparseM")) {
  mat4c <- readMat(pathname, sparseMatrixClass="SparseM");
  diff <- sum(abs(as.matrix(mat4c$sparseM) - mat4a$sparseM))
  if (diff > .Machine$double.eps)
    stop("Failed to read MAT v4 sparse matrix by class 'SparseM'.")
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Assert that compressed files can be read
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
hasMemDecompress <- (getRversion() >= "2.10.0" && exists("memDecompress", mode="function"));
if (hasMemDecompress || require("Rcompression")) {
  # A particular compressed file
  pathname <- file.path(path, "StructWithSparseMatrix-v4,compressed.mat")
  mat4 <- readMat(pathname, sparseMatrixClass="matrix")

  # All compressed files
  pattern <- ",compressed[.]mat$"
  pathnames <- list.files(pattern=pattern, path=path, full.names=TRUE)
  for (pathname in pathnames) {
    cat("Reading MAT file: ", basename(pathname), "\n", sep="")
    mat <- readMat(pathname)
    if (interactive()) {
      cat("Press ENTER to view data:")
      readline()
    }
    print(mat)
  }
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Example of a Matlab struct
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# File was created by
# s = struct('type',{'big','little'},  'color','red',  'x',{3,4})
#  1x2 struct array with fields:
#      type
#      color
#      x
# save structLooped.mat s -v6
mat <- readMat(file.path(path, "structLooped.mat"))

# Extract the structure
s <- mat$s

# Field names are always in the first dimension
fields <- dimnames(s)[[1]]
cat("Field names: ", paste(fields, collapse=", "), "\n", sep="");

print(s)

# Get field 'type'
print(s["type",,])

# Get substructure s(:,2)
print(s[,,2])


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# Example of verbose output
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
bs <- readMat(file.path(path, "unsignedByte.mat"), verbose=TRUE)

