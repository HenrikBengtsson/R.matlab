# Allows conflicts. For more information, see library() and
# conflicts() in [R] base.
.conflicts.OK <- TRUE


## .First.lib <- function(libname, pkgname) {
.onAttach <- function(libname, pkgname) {
  pkg <- Package(pkgname);
  assign(pkgname, pkg, pos=getPosition(pkg));

  # Patch for Sys.setenv() and Sys.putenv()
  # Sys.setenv() replaces Sys.putenv() from R v2.5.0. Code for migration.
  if (!exists("Sys.setenv", mode="function", envir=baseenv())) {
    env <- as.environment("package:R.matlab");
    assign("Sys.setenv", Sys.putenv, envir=env);
  }

  packageStartupMessage(getName(pkg), " v", getVersion(pkg), " (", 
    getDate(pkg), ") successfully loaded. See ?", pkgname, " for help.");
}


############################################################################
# HISTORY:
# 2011-09-24
# o Now using packageStartupMessage() instead of cat().
# 2011-07-24
# o Added a namespace to the package.
############################################################################
