.onUnload <- function(libpath) {
  # Force finalize() on Matlab objects
  gc()
}

.onLoad <- function(libname, pkgname) {
  ns <- getNamespace(pkgname)
  pkg <- Package(pkgname)
  assign(pkgname, pkg, envir = ns)
}

.onAttach <- function(libname, pkgname) {
  pkg <- get(pkgname, envir = getNamespace(pkgname))
  startupMessage(pkg)
}
