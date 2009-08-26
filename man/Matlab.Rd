%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not modify this file since it was automatically generated from:
% 
%  Matlab.R
% 
% by the Rdoc compiler part of the R.oo package.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

 \name{Matlab}
\docType{class}
\alias{Matlab}


 \title{Matlab client for remote or local Matlab access}

 \description{
  Package:  R.matlab \cr
\bold{Class Matlab}\cr

\code{\link[R.oo]{Object}}\cr
\code{~~|}\cr
\code{~~+--}\code{Matlab}\cr

\bold{Directly known subclasses:}\cr
\cr

public static class \bold{Matlab}\cr
extends \link[R.oo]{Object}\cr


 }

 \usage{Matlab(host="localhost", port=9999, remote=!(host \%in\% c("localhost", "127.0.0.1")))}

 \arguments{
   \item{host}{Name of host to connect to.}
   \item{port}{Port number on host to connect to.}
   \item{remote}{If \code{\link[base:logical]{TRUE}}, all data to and from the Matlab server will
      be transferred through the socket \code{\link[base:connections]{connection}}, otherwise the data will
      be transferred via a temporary file.}
 }

 \section{Fields and Methods}{
  \bold{Methods:}\cr
\tabular{rll}{
 \tab \code{\link[R.matlab:as.character.Matlab]{as.character}} \tab Gets a string describing the current Matlab connection.\cr
 \tab \code{\link[R.matlab:close.Matlab]{close}} \tab Closes connection to Matlab server.\cr
 \tab \code{\link[R.matlab:evaluate.Matlab]{evaluate}} \tab Evaluates a Matlab expression.\cr
 \tab \code{\link[R.matlab:finalize.Matlab]{finalize}} \tab Finalizes the object if deleted.\cr
 \tab \code{\link[R.matlab:getOption.Matlab]{getOption}} \tab Gets the value of an option.\cr
 \tab \code{\link[R.matlab:getVariable.Matlab]{getVariable}} \tab Gets one or several Matlab variables.\cr
 \tab \code{\link[R.matlab:isOpen.Matlab]{isOpen}} \tab Checks if connection to the Matlab server is open.\cr
 \tab \code{\link[R.matlab:open.Matlab]{open}} \tab Tries to open a connection to the Matlab server.\cr
 \tab \code{\link[R.matlab:readResult.Matlab]{readResult}} \tab Reads results from the Matlab server.\cr
 \tab \code{\link[R.matlab:setFunction.Matlab]{setFunction}} \tab Defines a Matlab function.\cr
 \tab \code{\link[R.matlab:setOption.Matlab]{setOption}} \tab Sets the value of an option.\cr
 \tab \code{\link[R.matlab:setVariable.Matlab]{setVariable}} \tab Sets one or several Matlab variables.\cr
 \tab \code{\link[R.matlab:setVerbose.Matlab]{setVerbose}} \tab Sets the verbose level to get more details about the Matlab access.\cr
 \tab \code{\link[R.matlab:startServer.Matlab]{startServer}} \tab Static method which starts a Matlab server.\cr
 \tab \code{\link[R.matlab:writeCommand.Matlab]{writeCommand}} \tab Writes (sends) a command to the Matlab server.\cr
}


 \bold{Methods inherited from Object}:\cr
$, $<-, [[, [[<-, as.character, attach, attachLocally, clearCache, clone, detach, equals, extend, finalize, gc, getEnvironment, getFields, getInstantiationTime, getStaticInstance, hasField, hashCode, ll, load, objectSize, print, registerFinalizer, save

 }

 \section{Requirements}{
   In order for \R to communicate with Matlab, Matlab v6 or higher is
   needed. It will \emph{not} work with previous versions, because they
   do not support Java!\cr

   We use the term \emph{server} to say that Matlab acts like a server
   with regard to \R. Note that it a standard Matlab session that runs.\cr

   Also, the starting of the MatlabServer is simplier from Matlab v7,
   although it is pretty straightforward for Matlab v6 too
   (this has to do with the fact that in Matlab v7, the for
   remote-data-transfer required Java class can be dynamically
   added to the Matlab Java classpath).
 }

 \section{Remote and non-remote connections}{
   When a remote connection (argument \code{remote=TRUE}) is used,
   data is send to and from Matlab via a data stream. This is needed
   when \R is running on a host with a seperated file system than
   the one Matlab is running on.

   If not connection "remotely" (\code{remote=FALSE}), data is
   communicated via the file system, that is, by saving and reading
   it to temporary MAT files. \cr

   Troubleshooting: If "remote" transfers are used, the
   InputStreamByteWrapper Java class must be found by Matlab,
   otherwise an error will occur in Matlab as soon as data is
   send from \R to Matlab. In all other cases, the above Java class
   is \emph{not} needed.
 }

 \section{Starting the Matlab server from within \R}{
   The Matlab server may be started from within \R by
   calling \code{Matlab$startServer()}. By default 'matlab' is called;
   if named differently set \code{options(matlab="matlab6.5")}, say.
   \emph{The method is experimental and may not work on your system.}
   By default the Matlab server listens for connections on port 9999.
   For other ports, set argument \code{port}, e.g.
   \code{Matlab$startServer(port=9998)}.

   Note that the code will \emph{not} halt and wait for Matlab to get
   started. Thus, you have to make sure you will wait long enough for
   the server to get up and running before the \R client try to
   connect. By default, the client will try once a second for 30 seconds
   before giving up.
   Moreover, on non-Windows systems, the above command will start Matlab
   in the background making all Matlab messages be sent to the \R output
   screen.
   In addition, the method will copy the MatlabServer and
   InputStreamByteWrapper files to the current directory and start
   Matlab from there.
 }

 \section{Starting the Matlab server without \R}{
   If the above does not work, the Matlab server may be started manually
   from Matlab itself.  Please follow the below instructions carefully.

   \bold{To be done once:}\cr
   In Matlab, add the path to the directory where MatlabServer.m sits.
   See \code{help pathtool} in Matlab on how to do this.
   In R you can type \code{system.file("externals", package="R.matlab")}
   to find out the path to MatlabServer.m.
 
   \bold{For Matlab v6 only:} Contrary to Matlab v6, Matlab v6 cannot
   find the InputStreamByteWrapper class automatically. Instead, the
   so called Java classpath has to be set. In Matlab, type
   \code{which('classpath.txt')} to find where the default
   Matlab classpath.txt file is located. Copy this file to the
   \emph{current directory} and append the \emph{path} (the directory)
   to InputStreamByteWrapper.class file, which is the same as the path
   of the MatlabServer.m you identified above.\cr

   \bold{Lazy alternative:} Instead of setting path and classpaths,
   you may try to copy the MatlabServer.m and InputStreamByteWrapper.class
   to the current directory from which Matlab is then started.

   \bold{To start the server:}\cr
   In order to start the Matlab server, type\cr

   \code{matlab -nodesktop -nosplash -r MatlabServer}\cr

   If using Matlab v6, make sure your \code{classpath.txt} is the
   current directory!

   This will start Matlab and immediately call the MatlabServer(.m)
   script. Here is how it should look like when the server starts:
   \preformatted{
   
                              < M A T L A B >
                  Copyright 1984-2004 The MathWorks, Inc.
                  Version 7.0.1.24704 (R14) Service Pack 1
                             September 13, 2004


  To get started, type one of these: helpwin, helpdesk, or demo.
  For product information, visit www.mathworks.com.

Matlab v7.x or higher detected.
Saving with option -V6.
Added InputStreamByteWrapper to dynamic Java CLASSPATH.
----------------------
Matlab server started!
----------------------
Trying to open server socket (port 9999)...done.

   }
   Alternatively you can start Matlab and type \code{MatlabServer}
   at the prompt.

   By default the Matlab server listens for connections on port 9999.
   For other ports, set environment variable \code{MATLABSERVER_PORT}.
 }

 \section{Confirmed Matlab versions}{
   This package has been confirmed to work \emph{successfully} out of
   the box together with Matlab v6.1.0.450 (R12.1),
   Matlab v6.5.0.180913a (R13), Matlab v7.0.0.19901 (R14),
   Matlab v7.0.1.24704 (R14SP1), Matlab v7.0.4.365 (R14SP2),
   and Matlab v7.2.0.232 (R2006a).
   [If you successfully use a higher Matlab version, please tell us, so
    we can share it here.]

   It does \emph{not} work with Matlab v5 or before!
 }

 \section{Security}{
   There is \emph{no} security in the communication with the Matlab
   server. This means that if you start the Matlab server, it will
   wait for requests via the connection at the specified port. As
   long as your \R session has not connected to this port, others
   may be able to steal the connection and send malicious commands
   (if they know the R.matlab protocol). The Matlab server only
   allows one connection. In other words, if you are connected it
   is not possible for others to connect to the Matlab server.
 }

 \section{Matlab server is timing out}{
   It might be that an \code{\link[R.matlab:evaluate.Matlab]{*evaluate}()} call to the Matlab server
   takes a long time for the server to finish resulting in a time-out
   exception.  By default this happens after 30 seconds, but it can
   be changed by modifying options, cf. \code{\link{setOption}}().
 }

 \examples{\dontrun{# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
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

# 3.1 If you experience any problems, ask for detailed outputs
#     by uncommenting the next line
# setVerbose(matlab, -2)

# 3.2   Connect to the Matlab server.
isOpen <- open(matlab)

# 3.3.  Confirm that the Matlab server is open, and running
if (!isOpen)
  throw("Matlab server is not running: waited 30 seconds.")


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 4.  Sample uses of the Matlab server
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 4.1 Run Matlab expressions on the Matlab server
evaluate(matlab, "A=1+2;", "B=ones(2,20);")

# 4.2 Get Matlab variables
data <- getVariable(matlab, c("A", "B"))
cat("Received variables:\n")
str(data)

# 4.3 Set variables in Matlab
ABCD <- matrix(rnorm(10000), ncol=100)
str(ABCD)
setVariable(matlab, ABCD=ABCD)

# 4.4 Retrieve what we just set
data <- getVariable(matlab, "ABCD")
cat("Received variables:\n")
str(data)

# 4.5 Create a function (M-file) on the Matlab server
setFunction(matlab, "          \
  function [win,aver]=dice(B)  \
  \%Play the dice game B times  \
  gains=[-1,2,-3,4,-5,6];      \
  plays=unidrnd(6,B,1);        \
  win=sum(gains(plays));       \
  aver=win/B;                  \
");

# 4.6 Use the Matlab function just created
evaluate(matlab, "[w,a]=dice(1000);")
res <- getVariable(matlab, c("w", "a"))
print(res)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 5.  Done:  close the Matlab client
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# When done, close the Matlab client, which will also shutdown
# the Matlab server and the connection to it.
close(matlab)

}}

 \author{Henrik Bengtsson (\url{http://www.braju.com/R/})}

 \seealso{
   Stand-alone methods \code{\link{readMat}}() and \code{\link{writeMat}}()
   for reading and writing MAT file structures.
 }


\keyword{classes}
