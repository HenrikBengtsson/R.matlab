
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# This example will try to start the Matlab server on the local machine,
# and then setup a Matlab object in R for communicating data between R
# and Matlab and for sending commands from R to Matlab.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# 1.  Load R.matlab
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
library(R.matlab)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# 2.  Start Matlab
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# 2.1.  Start Matlab from R?
# Start Matlab server on the local machine (if this fails, 
# see help(Matlab) for alternatives).
Matlab$startServer()

# 2.2.  OR start Matlab externally,
#       THEN add 'externals' subdirectory to the Matlab path

#  (Where is the 'externals' subdirectory?)
print(system.file("externals", package="R.matlab"))

#       THEN from within Matlab,
#            issue Matlab command "MatlabServer"
# Note: If issued from a Matlab command line, this last command
#       prevents further Matlab 'command line' input
#       until something like close(matlab) at the end of this script

# 2.3.  If both these options fail, see help(Matlab) for alternatives.


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# 3. Create a Matlab client object used to communicate with Matlab
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
matlab <- Matlab()

# 3.1 Check status of Matlab connection (not yet connected)
print(matlab)

# 3.2 If you experience any problems, ask for detailed outputs
#     by uncommenting the next line
# setVerbose(matlab, -2)

# 3.3 Connect to the Matlab server.
isOpen <- open(matlab)

# 3.4 Confirm that the Matlab server is open, and running
if (!isOpen)
  throw("Matlab server is not running: waited 30 seconds.")

# 3.5 Check status of Matlab connection (now connected)
print(matlab)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# 4.  Sample uses of the Matlab server
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# 4.1 Run Matlab expressions on the Matlab server
evaluate(matlab, "A=1+2;", "B=ones(2,20);")

# 4.2 Ask Matlab to display a value (without transferring it to R)
evaluate(matlab, "A")

# 4.3 Get Matlab variables
data <- getVariable(matlab, c("A", "B"))
cat("Received variables:\n")
str(data)

# 4.4 Set variables in Matlab
ABCD <- matrix(rnorm(10000), ncol=100)
str(ABCD)
setVariable(matlab, ABCD=ABCD)

# 4.5 Retrieve what we just set
data <- getVariable(matlab, "ABCD")
cat("Received variables:\n")
str(data)

# 4.6 Create a function (M-file) on the Matlab server
setFunction(matlab, "          \
  function [win,aver]=dice(B)  \
  %Play the dice game B times  \
  gains=[-1,2,-3,4,-5,6];      \
  plays=unidrnd(6,B,1);        \
  win=sum(gains(plays));       \
  aver=win/B;                  \
");

# 4.7 Use the Matlab function just created
evaluate(matlab, "[w,a]=dice(1000);")
res <- getVariable(matlab, c("w", "a"))
print(res)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# 5.  Done:  close the Matlab client
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
# When done, close the Matlab client, which will also shutdown
# the Matlab server and the connection to it.
close(matlab)

# 3.5 Check status of Matlab connection (now disconnected)
print(matlab)
