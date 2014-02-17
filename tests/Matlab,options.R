library("R.matlab")

matlab <- Matlab()
print(matlab)

# Sanity check
stopifnot(!isOpen(matlab))

# Get options
value <- getOption(matlab, "readResult/interval")
print(value)
value <- getOption(matlab, "readResult/maxTries")
print(value)

# Set options
ovalue <- setOption(matlab, "readResult/interval", 0.2)
print(ovalue)
value <- getOption(matlab, "readResult/interval")
print(value)

ovalue <- setOption(matlab, "readResult/maxTries", 30)
print(ovalue)
value <- getOption(matlab, "readResult/maxTries")
print(value)

# Cleanup
rm(list="matlab")
