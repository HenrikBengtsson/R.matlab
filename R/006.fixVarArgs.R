# Added '...' to some base functions. These will later be
# turned into default functions by setMethodS3().

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Methods in 'base'
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
isOpen <- function(...) UseMethod("isOpen")
setMethodS3("isOpen", "default", function(...) {
  base::isOpen(...)
})
