library("R.matlab")

fullTest <- (Sys.getenv("_R_CHECK_FULL_") != "")
fullTest <- fullTest && nzchar(Sys.which("matlab"))
if (fullTest) {

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
print(system.file("externals", package="R.matlab"))

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
# setVerbose(matlab, -2)

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
evaluate(matlab, "A=1+2;", "B=ones(2,20);")

# Ask MATLAB to display a value (without transferring it to R)
evaluate(matlab, "A")

# Get MATLAB variables
data <- getVariable(matlab, c("A", "B"))
cat("Received variables:\n")
str(data)

# Set variables in MATLAB
ABCD <- matrix(rnorm(10000), ncol=100)
str(ABCD)
setVariable(matlab, ABCD=ABCD)

# Retrieve what we just set
data <- getVariable(matlab, "ABCD")
cat("Received variables:\n")
str(data)

# Create a function (M-file) on the MATLAB server
setFunction(matlab, "          \
  function [win,aver]=dice(B)  \
  %Play the dice game B times  \
  gains=[-1,2,-3,4,-5,6];      \
  plays=unidrnd(6,B,1);        \
  win=sum(gains(plays));       \
  aver=win/B;                  \
");

# Use the MATLAB function just created
evaluate(matlab, "[w,a]=dice(1000);")
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

} # if (fullTest)
