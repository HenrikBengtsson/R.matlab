path <- system.file("mat-files", package="R.matlab")
bs <- R.matlab::readMat(file.path(path, "unsignedByte.mat"))
if (!identical(as.vector(bs$A), as.double(126:255)))
  stop("Error reading unsigned bytes saved by MATLAB.")
