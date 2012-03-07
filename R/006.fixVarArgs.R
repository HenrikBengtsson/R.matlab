# Added '...' to some base functions. These will later be
# turned into default functions by setMethodS3().

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Methods in 'base'
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
getOption <- appendVarArgs(getOption);

# USED TO DO: isOpen <- appendVarArgs(isOpen)
isOpen <- function(...) UseMethod("isOpen");
setMethodS3("isOpen", "default", function(...) {
  base::isOpen(...);
})


############################################################################
# HISTORY:
# 2012-03-06
# o Replaced some appendVarArgs() with explicit default functions
#   in order to avoid copying functions with .Internal() calls. 
# 2005-02-15
# o Created to please R CMD check.
############################################################################
