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


\title{MATLAB client for remote or local MATLAB access}

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

\usage{
Matlab(host="localhost", port=9999, remote=!(host \%in\% c("localhost", "127.0.0.1")))
}

\arguments{
  \item{host}{Name of host to connect to.}
  \item{port}{Port number on host to connect to.}
  \item{remote}{If \code{\link[base:logical]{TRUE}}, all data to and from the MATLAB server will
     be transferred through the socket \code{\link[base:connections]{connection}}, otherwise the data will
     be transferred via a temporary file.}
}

\section{Fields and Methods}{
 \bold{Methods:}\cr
\tabular{rll}{
 \tab \code{\link[R.matlab:as.character.Matlab]{as.character}} \tab Gets a string describing the current MATLAB connection.\cr
 \tab \code{\link[R.matlab:close.Matlab]{close}} \tab Closes connection to MATLAB server.\cr
 \tab \code{\link[R.matlab:evaluate.Matlab]{evaluate}} \tab Evaluates a MATLAB expression.\cr
 \tab \code{\link[R.matlab:finalize.Matlab]{finalize}} \tab Finalizes the object if deleted.\cr
 \tab \code{\link[R.matlab:getOption.Matlab]{getOption}} \tab Gets the value of an option.\cr
 \tab \code{\link[R.matlab:getVariable.Matlab]{getVariable}} \tab Gets one or several MATLAB variables.\cr
 \tab \code{\link[R.matlab:isOpen.Matlab]{isOpen}} \tab Checks if connection to the MATLAB server is open.\cr
 \tab \code{\link[R.matlab:open.Matlab]{open}} \tab Tries to open a connection to the MATLAB server.\cr
 \tab \code{\link[R.matlab:readResult.Matlab]{readResult}} \tab Reads results from the MATLAB server.\cr
 \tab \code{\link[R.matlab:setFunction.Matlab]{setFunction}} \tab Defines a MATLAB function.\cr
 \tab \code{\link[R.matlab:setOption.Matlab]{setOption}} \tab Sets the value of an option.\cr
 \tab \code{\link[R.matlab:setVariable.Matlab]{setVariable}} \tab Sets one or several MATLAB variables.\cr
 \tab \code{\link[R.matlab:setVerbose.Matlab]{setVerbose}} \tab Sets the verbose level to get more details about the MATLAB access.\cr
 \tab \code{\link[R.matlab:startServer.Matlab]{startServer}} \tab Static method which starts a MATLAB server.\cr
 \tab \code{\link[R.matlab:writeCommand.Matlab]{writeCommand}} \tab Writes (sends) a command to the MATLAB server.\cr
}


 \bold{Methods inherited from Object}:\cr
$, $<-, [[, [[<-, as.character, attach, attachLocally, clearCache, clearLookupCache, clone, detach, equals, extend, finalize, getEnvironment, getFieldModifier, getFieldModifiers, getFields, getInstantiationTime, getStaticInstance, hasField, hashCode, ll, load, objectSize, print, save


}

\section{Requirements}{
  In order for \R to communicate with MATLAB, MATLAB v6 or higher is
  needed. It will \emph{not} work with previous versions, because they
  do not support Java!\cr

  We use the term \emph{server} to say that MATLAB acts like a server
  with regard to \R. Note that it a standard MATLAB session that runs.\cr

  Also, the starting of the MatlabServer is simplier from MATLAB v7,
  although it is pretty straightforward for MATLAB v6 too.
  It is easier in MATLAB v7 and above, because the Java class required
  for remote-data-transfer can be automatically/dynamically added to
  the MATLAB Java classpath, whereas for MATLAB v6 it has to be
  added manually (see below).
}

\section{Remote and non-remote connections}{
  When a remote connection (argument \code{remote=TRUE}) is used,
  data is send to and from MATLAB via a data stream. This is needed
  when \R is running on a host with a seperated file system than
  the one MATLAB is running on.

  If not connection "remotely" (\code{remote=FALSE}), data is
  communicated via the file system, that is, by saving and reading
  it to temporary MAT files. \cr

  Troubleshooting: If "remote" transfers are used, the
  InputStreamByteWrapper Java class must be found by MATLAB,
  otherwise an error will occur in MATLAB as soon as data is
  send from \R to MATLAB. In all other cases, the above Java class
  is \emph{not} needed.
}

\section{Starting the MATLAB server from within \R}{
  The MATLAB server may be started from within \R by
  calling \code{Matlab$startServer()}. By default 'matlab' is called;
  if named differently set \code{options(matlab="matlab6.5")}, say.
  \emph{The method is experimental and may not work on your system.}
  By default the MATLAB server listens for connections on port 9999.
  For other ports, set argument \code{port}, e.g.
  \code{Matlab$startServer(port=9998)}.

  Note that the code will \emph{not} halt and wait for MATLAB to get
  started. Thus, you have to make sure you will wait long enough for
  the server to get up and running before the \R client try to
  connect. By default, the client will try once a second for 30 seconds
  before giving up.
  Moreover, on non-Windows systems, the above command will start MATLAB
  in the background making all MATLAB messages be sent to the \R output
  screen.
  In addition, the method will copy the MatlabServer and
  InputStreamByteWrapper files to the current directory and start
  MATLAB from there.
}

\section{Starting the MATLAB server without \R}{
  If the above does not work, the MATLAB server may be started manually
  from MATLAB itself.  Please follow the below instructions carefully.

  \bold{To be done once:}\cr
  In MATLAB, add the path to the directory where MatlabServer.m sits.
  See \code{help pathtool} in MATLAB on how to do this.
  In R you can type \code{system.file("externals", package="R.matlab")}
  to find out the path to MatlabServer.m.

  \bold{For MATLAB v6 only:} Contrary to MATLAB v7 and above, MATLAB v6
  cannot find the InputStreamByteWrapper class automatically. Instead,
  the so called Java classpath has to be set manually. In MATLAB, type
  \code{which('classpath.txt')} to find where the default
  MATLAB classpath.txt file is located. Copy this file to the
  \emph{current directory}, and append the \emph{path} (the directory)
  of InputStreamByteWrapper.class to the end of classpath.txt.
  The path of InputStreamByteWrapper.class should be the same as
  the path of the MatlabServer.m that you identified above.\cr

  \bold{Lazy alternative:} Instead of setting path and classpaths,
  you may try to copy the MatlabServer.m and InputStreamByteWrapper.class
  to the current directory from which MATLAB is then started.

  \bold{To start the server:}\cr
  In order to start the MATLAB server, type\cr

  \code{matlab -nodesktop -nosplash -r MatlabServer}\cr

  If using MATLAB v6, make sure your \code{classpath.txt} is the
  current directory!

  This will start MATLAB and immediately call the MatlabServer(.m)
  script. Here is how it should look like when the server starts:
  \preformatted{
  
                            < M A T L A B (R) >
                  Copyright 1984-2012 The MathWorks, Inc.
                    R2012a (7.14.0.739) 64-bit (glnxa64)
                              February 9, 2012


To get started, type one of these: helpwin, helpdesk, or demo.
For product information, visit www.mathworks.com.

Running MatlabServer v2.2.0
MATLAB v7.x or higher detected.
Saving with option -V6.
Added InputStreamByteWrapper to dynamic Java CLASSPATH.
----------------------
MATLAB server started!
----------------------
Trying to open server socket (port 9999)...done.

  }
  Alternatively you can start MATLAB and type \code{MatlabServer}
  at the prompt.

  By default the MATLAB server listens for connections on port 9999.
  For other ports, set environment variable \code{MATLABSERVER_PORT}.
}

\section{Confirmed MATLAB versions}{
  This package has been confirmed to work \emph{successfully} out of
  the box together with the following MATLAB versions:
  MATLAB v6.1.0.450 (R12.1) [Jun 2001],
  MATLAB v6.5.0.180913a (R13) [Jul 2002],
  MATLAB v7.0.0.19901 (R14) [Jun 2004],
  MATLAB v7.0.1.24704 (R14SP1) [Oct 2004],
  MATLAB v7.0.4.365 (R14SP2) [Mar 2005],
  MATLAB v7.2.0.232 (R2006a) [Mar 2006],
  MATLAB v7.4.0 (R2007a) [Mar 2007]],
  MATLAB v7.7.0.471 (R2008b) [Oct 2008],
  MATLAB v7.10.0.499 (R2010a) [Mar 2010],
  MATLAB v7.11.0.584 (R2010b) [Sep 2010],
  MATLAB v7.14.0.739 (R2012a) [Mar 2012], and
  MATLAB v8.2.0.701 (R2013b) [Sep 2013].
  If you successfully use a different/higher MATLAB version,
  please tell us, so we can share it here.

  It does \emph{not} work with MATLAB v5 or before.
}

\section{Security}{
  There is \emph{no} security in the communication with the MATLAB
  server. This means that if you start the MATLAB server, it will
  wait for requests via the connection at the specified port. As
  long as your \R session has not connected to this port, others
  may be able to steal the connection and send malicious commands
  (if they know the R.matlab protocol). The MATLAB server only
  allows one connection. In other words, if you are connected it
  is not possible for others to connect to the MATLAB server.
}

\section{Firewalls}{
  If the MATLAB server is running on a machine behind a firewall,
  one may have to connect via a proxy.  If on Windows, see
  \code{setInternet2()} in the \pkg{utils} package on how to do this.
}

\section{MATLAB server is timing out}{
  It might be that an \code{\link[R.matlab:evaluate.Matlab]{*evaluate}()} call to the MATLAB server
  takes a long time for the server to finish resulting in a time-out
  exception.  By default this happens after 30 seconds, but it can
  be changed by modifying options, cf. \code{\link{setOption}}().
}

\examples{\dontrun{
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# This example will try to start the MATLAB server on the local machine,
# and then setup a Matlab object in R for communicating data between R
# and MATLAB and for sending commands from R to MATLAB.
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 1.  Load R.matlab
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
library(R.matlab)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 2.  Start MATLAB
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 2.1.  Start MATLAB from R?
# Start MATLAB server on the local machine (if this fails,
# see help(Matlab) for alternatives).
Matlab$startServer()

# 2.2.  OR start MATLAB externally,
#       THEN add 'externals' subdirectory to the MATLAB path

#  (Where is the 'externals' subdirectory?)
print(system.file("externals", package="R.matlab"))

#       THEN from within MATLAB,
#            issue MATLAB command "MatlabServer"
# Note: If issued from a MATLAB command line, this last command
#       prevents further MATLAB 'command line' input
#       until something like close(matlab) at the end of this script

# 2.3.  If both these options fail, see help(Matlab) for alternatives.


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 3. Create a MATLAB client object used to communicate with MATLAB
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
matlab <- Matlab()

# 3.1 Check status of MATLAB connection (not yet connected)
print(matlab)

# 3.2 If you experience any problems, ask for detailed outputs
#     by uncommenting the next line
# setVerbose(matlab, -2)

# 3.3 Connect to the MATLAB server.
isOpen <- open(matlab)

# 3.4 Confirm that the MATLAB server is open, and running
if (!isOpen)
  throw("MATLAB server is not running: waited 30 seconds.")

# 3.5 Check status of MATLAB connection (now connected)
print(matlab)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 4.  Sample uses of the MATLAB server
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 4.1 Run MATLAB expressions on the MATLAB server
evaluate(matlab, "A=1+2;", "B=ones(2,20);")

# 4.2 Ask MATLAB to display a value (without transferring it to R)
evaluate(matlab, "A")

# 4.3 Get MATLAB variables
data <- getVariable(matlab, c("A", "B"))
cat("Received variables:\n")
str(data)

# 4.4 Set variables in MATLAB
ABCD <- matrix(rnorm(10000), ncol=100)
str(ABCD)
setVariable(matlab, ABCD=ABCD)

# 4.5 Retrieve what we just set
data <- getVariable(matlab, "ABCD")
cat("Received variables:\n")
str(data)

# 4.6 Create a function (M-file) on the MATLAB server
setFunction(matlab, "          \
  function [win,aver]=dice(B)  \
  \%Play the dice game B times  \
  gains=[-1,2,-3,4,-5,6];      \
  plays=unidrnd(6,B,1);        \
  win=sum(gains(plays));       \
  aver=win/B;                  \
");

# 4.7 Use the MATLAB function just created
evaluate(matlab, "[w,a]=dice(1000);")
res <- getVariable(matlab, c("w", "a"))
print(res)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# 5.  Done:  close the MATLAB client
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# When done, close the MATLAB client, which will also shutdown
# the MATLAB server and the connection to it.
close(matlab)

# 3.5 Check status of MATLAB connection (now disconnected)
print(matlab)
}}

\author{Henrik Bengtsson}

\seealso{
  Stand-alone methods \code{\link{readMat}}() and \code{\link{writeMat}}()
  for reading and writing MAT file structures.
}


\keyword{classes}
