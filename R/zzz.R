## covr: skip=all

.onUnload <- function(libpath) {
  # Force finalize() on Matlab objects
  gc();
} # .onUnload()

.onLoad <- function(libname, pkgname) {
  ns <- getNamespace(pkgname);
  pkg <- Package(pkgname);
  assign(pkgname, pkg, envir=ns);
}

.onAttach <- function(libname, pkgname) {
  pkg <- get(pkgname, envir=getNamespace(pkgname))
  startupMessage(pkg)
}


############################################################################
# HISTORY:
# 2014-02-21
# o Added .onUnload() which calls the garbage collector.
# 2013-04-15
# o Now utilizing startupMessage() of Package in R.oo.
# 2010-11-02
# o Added a workaround for an R (>= 2.15.0) CMD check NOTE.
# 2011-09-24
# o Now using packageStartupMessage() instead of cat().
# 2011-07-24
# o Added a namespace to the package.
############################################################################
