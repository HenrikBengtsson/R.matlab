path <- system.file("mat-files", package="R.matlab")
data <- R.matlab::readMat(file.path(path, "unsignedByte.mat"))
if (!identical(as.vector(data$A), as.double(126:255)))
  stop("Error reading unsigned bytes saved by MATLAB.")

# Also, assert that...
cons0 <- getAllConnections()

# Compressed data blocks - display raw bytes
data <- R.matlab::readMat(file.path(path, "NestedMiMATRIX,problem4,v5,compressed.mat"), verbose=-120)

# ...no connections are left open
stopifnot(identical(getAllConnections(), cons0))

