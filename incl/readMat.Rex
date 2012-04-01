path <- system.file("mat-files", package="R.matlab")
pathname <- file.path(path, "ABC.mat")
data <- readMat(pathname)
print(data)
