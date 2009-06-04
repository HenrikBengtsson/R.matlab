###########################################################################/**
# @RdocClass Verbose
#
# @title "Class for detailed verbose output with various details"
#
# \description{
#  @classhierarchy
# }
#
# @synopsis
#
# \arguments{
#   \item{threshold}{A threshold that the \code{level} argument
#     of any write method has to be equal to or larger than in order to the 
#     message being written.
#     Thus, the lower the threshold is the more and more details will be
#     outputted.}
# }
#
# \details{
#  @get "title".
# }
#
# @author
# 
# @keyword programming
# @keyword internal
#*/###########################################################################
setConstructorS3("Verbose", function(threshold=0) {
  if (!is.numeric(threshold) || length(threshold) != 1)
    throw("Argument 'threshold' must be a scalar.");
  extend(Object(), "Verbose",
    threshold = threshold
  )
}, private=TRUE)



###########################################################################/**
# @RdocMethod "as.character"
#
# @title "Returns a character string version of this object"
#
# \description{
#   @get "title".
# }
# 
# @synopsis
#
# \arguments{
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns a @character string.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#
# @keyword programming
#*/###########################################################################
setMethodS3("as.character", "Verbose", function(this, ...) {
  s <- paste(class(this)[1], ": threshold=", this$threshold, sep="");
  s;
})


###########################################################################/**
# @RdocMethod setThreshold
#
# @title "Sets verbose threshold"
#
# \description{
#   @get "title". Output requests below this threshold will be ignored.
# }
#
# @synopsis
#
# \arguments{
#  \item{threshold}{A @numeric threshold.}
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns old threshold.
# }
#
# @author
#
# \seealso{
#   @seemethod "getThreshold" and @seemethod "isVisible".
#   @seeclass
# }
#
# @keyword programming
#*/###########################################################################
setMethodS3("setThreshold", "Verbose", function(this, threshold, ...) {
  if (!is.numeric(threshold) || length(threshold) != 1)
    throw("Argument 'threshold' must be a scalar.");
  old <- this$threshold;
  this$threshold <- threshold;
  invisible(old);
})


###########################################################################/**
# @RdocMethod getThreshold
#
# @title "Gets current verbose threshold"
#
# \description{
#   @get "title".
# }
#
# @synopsis
#
# \arguments{
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns a @numeric value.
# }
#
# @author
#
# \seealso{
#   @seemethod "setThreshold" and @seemethod "isVisible".
#   @seeclass
# }
#
# @keyword programming
#*/###########################################################################
setMethodS3("getThreshold", "Verbose", function(this, ...) {
  this$threshold;
})


###########################################################################/**
# @RdocMethod isVisible
#
# @title "Checks if a certain verbose level will be shown or not"
#
# \description{
#   @get "title".
# }
# 
# @synopsis
#
# \arguments{
#  \item{level}{A @numeric value to be compared to the threshold.}
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns @FALSE, if given level is below current threshold, otherwise
#   @FALSE.
# }
#
# @author
#
# \seealso{
#   @seemethod "getThreshold" and @seemethod "setThreshold".
#   @seeclass
# }
#
# @keyword programming
#*/###########################################################################
setMethodS3("isVisible", "Verbose", function(this, level, ...) {
  (level >= this$threshold);
})



###########################################################################/**
# @RdocMethod cat
#
# @title "Concatenates and prints objects if above threshold"
#
# \description{
#   @get "title".
# }
# 
# @synopsis
#
# \arguments{
#  \item{...}{Objects to be passed to @see "base::cat".}
#  \item{level}{A @numeric value to be compared to the threshold.}
# }
#
# \value{
#   Returns nothing.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#
# @keyword programming
#*/###########################################################################
setMethodS3("cat", "Verbose", function(this, ..., level=0) {
  if (is.null(level) || isVisible(this, level)) {
    cat(...);
  }
})


###########################################################################/**
# @RdocMethod print
#
# @title "Prints objects if above threshold"
#
# \description{
#   @get "title".
# }
# 
# @synopsis
#
# \arguments{
#  \item{...}{Objects to be passed to @see "base::print".}
#  \item{level}{A @numeric value to be compared to the threshold.}
# }
#
# \value{
#   Returns nothing.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#
# @keyword programming
#*/###########################################################################
setMethodS3("print", "Verbose", function(x, ..., level=0) {
  # print() is already a generic function in 'base'.
  this <- x;

  if (is.null(level) || isVisible(this, level)) {
    print(...);
  }
})


###########################################################################/**
# @RdocMethod str
#
# @title "Prints the structure of an object if above threshold"
#
# \description{
#   @get "title".
# }
# 
# @synopsis
#
# \arguments{
#  \item{...}{Objects to be passed to @see "base::str".}
#  \item{level}{A @numeric value to be compared to the threshold.}
# }
#
# \value{
#   Returns nothing.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#
# @keyword programming
#*/###########################################################################
setMethodS3("str", "Verbose", function(object, ..., level=0) {
  # print() is already a generic function in 'base'.
  this <- object;

  if (is.null(level) || isVisible(this, level)) {
    str(...);
  }
})


###########################################################################/**
# @RdocMethod summary
#
# @title "Generates a summary of an object if above threshold"
#
# \description{
#   @get "title".
# }
# 
# @synopsis
#
# \arguments{
#  \item{...}{Objects to be passed to @see "base::summary".}
#  \item{level}{A @numeric value to be compared to the threshold.}
# }
#
# \value{
#   Returns nothing.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#
# @keyword programming
#*/###########################################################################
setMethodS3("summary", "Verbose", function(object, ..., level=0) {
  # print() is already a generic function in 'base'.
  this <- object;

  if (is.null(level) || isVisible(this, level)) {
    print(summary(...));
  }
})

###########################################################################/**
# @RdocMethod printf
#
# @title "Formats and prints object if above threshold"
#
# \description{
#   @get "title".
# }
# 
# @synopsis
#
# \arguments{
#  \item{...}{Objects to be passed to @see "base::sprintf".}
#  \item{level}{A @numeric value to be compared to the threshold.}
# }
#
# \value{
#   Returns nothing.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("printf", "Verbose", function(this, fmtstr, ..., level=0) {
  if (is.null(level) || isVisible(this, level)) {
    cat(sprintf(fmtstr, ...));
  }
})

###########################################################################/**
# @RdocMethod newline
#
# @title "Prints a newline if above threshold"
#
# \description{
#   @get "title".
# }
# 
# @synopsis
#
# \arguments{
#  \item{level}{A @numeric value to be compared to the threshold.}
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns nothing.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("newline", "Verbose", function(this, level=0, ...) {
  cat(this, "\n", level=level);
})


###########################################################################/**
# @RdocMethod ruler
#
# @title "Prints a ruler if above threshold"
#
# \description{
#   @get "title".
# }
# 
# @synopsis
#
# \arguments{
#  \item{chars}{A @character string concatenated to a ruler.}
#  \item{width}{An @numeric specifying the width (in characters) of 
#    the ruler.}
#  \item{level}{A @numeric value to be compared to the threshold.}
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns nothing.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("ruler", "Verbose", function(this, chars="- ", width=getOption("width")-1, level=0, ...) {
  if (is.null(level) || isVisible(this, level)) {
    chars <- strsplit(chars, "")[[1]];
    ruler <- rep(chars, length.out=width);
    ruler <- paste(ruler, collapse="");
    cat(ruler, "\n", sep="");
  }
})


###########################################################################/**
# @RdocMethod evaluate
#
# @title "Evaluates a function and prints its results if above threshold"
#
# \description{
#   @get "title".
# }
# 
# @synopsis
#
# \arguments{
#  \item{fun}{A @function to be evaluated (only if above threshold).}
#  \item{...}{Additional arguments passed to the function.}
#  \item{level}{A @numeric value to be compared to the threshold.}
# }
#
# \value{
#   Returns nothing.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("evaluate", "Verbose", function(this, fun, ..., level=0) {
  if (is.null(level) || isVisible(this, level)) {
    cat(fun(...));
  }
})



############################################################################
# HISTORY:
# 2005-05-26
# o BUG FIX: Used 'threshold' instead of 'this$threshold' in as.character().
# 2005-02-15
# o Added arguments '...' in order to match any generic functions. 
# 2005-02-10
# o Added Rdoc comments to all of Verbose methods.
# 2004-02-24
# o Removed the requirement that the threshold must be non-negative.
# o The default verbose level is now 'level=0'.
# o Moved this class into the R.matlab package. Still a trial class that
#   may not exists later.
# 2003-12-07
# o Created.
############################################################################
