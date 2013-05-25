# Allows conflicts. For more information, see library() and
# conflicts() in [R] base.
.conflicts.OK <- TRUE


## .First.lib <- function(libname, pkgname) {
.onAttach <- function(libname, pkgname) {
  pkg <- Package(pkgname);
  pos <- getPosition(pkg);
  assign(pkgname, pkg, pos=pos);

  # Patch for Sys.setenv() and Sys.putenv()
  # Sys.setenv() replaces Sys.putenv() from R v2.5.0. Code for migration.
  if (!exists("Sys.setenv", mode="function", envir=baseenv())) {
    # To please R CMD check on R (>= 2.15.0)
    Sys.putenv <- NULL; rm(list="Sys.putenv");
    assign("Sys.setenv", Sys.putenv, pos=pos);
  }

  startupMessage(pkg);
}


############################################################################
# HISTORY:
# 2013-04-15
# o Now utilizing startupMessage() of Package in R.oo.
# 2010-11-02
# o Added a workaround for an R (>= 2.15.0) CMD check NOTE.
# 2011-09-24
# o Now using packageStartupMessage() instead of cat().
# 2011-07-24
# o Added a namespace to the package.
############################################################################
