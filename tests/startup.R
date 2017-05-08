library("R.matlab")

.onAttach <- R.matlab:::.onAttach
.onLoad <- R.matlab:::.onLoad
.onUnload <- R.matlab:::.onUnload

message("Startup and shutdown code ...")

pkgname <- "R.matlab"
libname <- pkgname
libpath <- dirname(system.file(package = pkgname))

res <- tryCatch({
  .onUnload(libpath)
}, error = identity)
print(res)

res <- tryCatch({
  .onLoad(libname, pkgname)
}, error = identity)
print(res)

res <- tryCatch({
  .onAttach(libname, pkgname)
}, error = identity)
print(res)

message("Startup and shutdown code ... DONE")
