library("R.matlab")

full_test <- (Sys.getenv("_R_CHECK_FULL_") != "")
full_test <- full_test && nzchar(Sys.which("matlab"))


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Test Matlab class regardless of MATLAB installed or not
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
message("Matlab class ...")

readResult <- R.matlab:::readResult
writeCommand <- R.matlab:::writeCommand

workdir <- tempdir()
res <- Matlab$startServer(workdir = workdir)
print(res)

for (remote in c(FALSE, TRUE)) {
  message(sprintf("- Matlab(remote = %s) ...", remote))

  matlab <- Matlab(remote = remote)
  print(matlab)

  setVerbose(matlab, TRUE)
  setVerbose(matlab, FALSE)
  setVerbose(matlab, 0)
  setVerbose(matlab, -1)
  setVerbose(matlab, -100)

  res <- tryCatch({
    open(matlab, trials = 2L, interval = 0.1, timeout = 0.5)
  }, error = identity)
  print(res)
  
  res <- tryCatch({
    writeCommand(matlab, "echo")
  }, error = identity)
  print(res)
  
  res <- tryCatch({
    writeCommand(matlab, "<unknown>")
  }, error = identity)
  print(res)
  
  res <- tryCatch({
    evaluate(matlab, "x = 1;")
  }, error = identity)
  print(res)
  
  res <- tryCatch({
    setVariable(matlab, x = 2)
  }, error = identity)
  print(res)
  
  res <- tryCatch({
    getVariable(matlab, "x")
  }, error = identity)
  print(res)
  
  res <- tryCatch({
    setFunction(matlab, "   \
      function [y] = foo(x) \
        y = x;              \
    ")
  }, error = identity)
  print(res)

  ## Not a proper MATLAB function
  res <- tryCatch({
    setFunction(matlab, "function [y] = foo")
  }, error = identity)
  print(res)

  ## Not a MATLAB function
  res <- tryCatch({
    setFunction(matlab, "foo bar")
  }, error = identity)
  print(res)

  options("readResult/maxTries" = 2L)
  options("readResult/interval" = 0.1)
  res <- tryCatch({
    readResult(matlab)
  }, error = identity)
  print(res)
  
  res <- tryCatch({
    close(matlab)
  }, error = identity)
  print(res)
  
  rm(list = "matlab")
  gc()

  message(sprintf("- Matlab(remote = %s) ... DONE", remote))  
}

message("Matlab class ... DONE")


if (full_test) {
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# This example will try to start the MATLAB server on the local machine,
# and then setup a Matlab object in R for communicating data between R
# and MATLAB and for sending commands from R to MATLAB.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Start MATLAB
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Start MATLAB from R?
# Start MATLAB server on the local machine (if this fails,
# see help(Matlab) for alternatives).
Matlab$startServer()

# OR start MATLAB externally,
# THEN add 'externals' subdirectory to the MATLAB path

#  (Where is the 'externals' subdirectory?)
print(system.file("externals", package = "R.matlab"))

# THEN from within MATLAB,
#      issue MATLAB command "MatlabServer"
# Note: If issued from a MATLAB command line, this last command
#       prevents further MATLAB 'command line' input
#       until something like close(matlab) at the end of this script

# If both these options fail, see help(Matlab) for alternatives.


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Create a MATLAB client object used to communicate with MATLAB
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
matlab <- Matlab()

# Check status of MATLAB connection (not yet connected)
print(matlab)

# If you experience any problems, ask for detailed outputs
# by uncommenting the next line
setVerbose(matlab, -2)

# Connect to the MATLAB server.
isOpen <- open(matlab)

# Confirm that the MATLAB server is open, and running
if (!isOpen)
  throw("MATLAB server is not running: waited 30 seconds.")

# Check status of MATLAB connection (now connected)
print(matlab)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Sample uses of the MATLAB server
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Run MATLAB expressions on the MATLAB server
evaluate(matlab, "A = 1+2;", "B = ones(2, 20);")

# Ask MATLAB to display a value (without transferring it to R)
evaluate(matlab, "A")

# Get MATLAB variables
data <- getVariable(matlab, c("A", "B"))
cat("Received variables:\n")
str(data)

# Set variables in MATLAB
ABCD <- matrix(rnorm(10000), ncol = 100)
str(ABCD)
setVariable(matlab, ABCD = ABCD)

# Retrieve what we just set
data <- getVariable(matlab, "ABCD")
cat("Received variables:\n")
str(data)

# Create a function (M-file) on the MATLAB server
setFunction(matlab, "            \
  function [win, aver] = dice(B) \
  %Play the dice game B times    \
  gains = [-1, 2, -3, 4, -5, 6]; \
  plays = unidrnd(6, B, 1);      \
  win = sum(gains(plays));       \
  aver = win/B;                  \
")

# Use the MATLAB function just created
evaluate(matlab, "[w, a] = dice(1000);")
res <- getVariable(matlab, c("w", "a"))
print(res)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Done:  close the MATLAB client
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# When done, close the MATLAB client, which will also shutdown
# the MATLAB server and the connection to it.
close(matlab)

# Check status of MATLAB connection (now disconnected)
print(matlab)

} # if (full_test)
