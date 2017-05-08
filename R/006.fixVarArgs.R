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
