## Look for existing generic functions also in imported namespaces.
## This will affect whether setGenericS3() creates a generic function
## or not.
options("R.methodsS3:checkImports:setGenericS3"=TRUE)
