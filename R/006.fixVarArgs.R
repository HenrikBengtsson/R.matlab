# Added '...' to some base functions. These will later be
# turned into default functions by setMethodS3().

isOpen <- appendVarArgs(isOpen)
getOption <- appendVarArgs(getOption)

############################################################################
# HISTORY:
# 2005-02-15
# o Created to please R CMD check.
############################################################################
