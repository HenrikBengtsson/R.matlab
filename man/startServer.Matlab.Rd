%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not modify this file since it was automatically generated from:
% 
%  Matlab.R
% 
% by the Rdoc compiler part of the R.oo package.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{Matlab$startServer}
\alias{Matlab$startServer}
\alias{startServer.Matlab}
\alias{Matlab.startServer}
\alias{startServer,Matlab-method}

\title{Static method which starts a Matlab server}

\description{
 Static method which starts a Matlab server on the local machine. Note
 that Matlab v6 or later is required, since the Matlab server relies on
 Java.
}

\usage{
## Static method (use this):
## Matlab$startServer(matlab=getOption("matlab"), port=9999, minimize=TRUE, options=c("nodesktop", "nodisplay", "nosplash"), ...)

## Don't use the below:
\method{startServer}{Matlab}(this, matlab=getOption("matlab"), port=9999, minimize=TRUE, options=c("nodesktop", "nodisplay", "nosplash"), ...)
}

\arguments{
 \item{matlab}{An optional \code{\link[base]{character}} string specifying the name of
   the matlab command, if different from \code{"matlab"}. An absolute
   path are possible.}
 \item{port}{An optional \code{\link[base]{integer}} in [1023,65535].
   If given, the environment variable \code{MATLABSERVER_PORT} is
   set specifying which port the Matlab server should listen to for
   clients trying to connect.  The default port is 9999.}
 \item{minimize}{When starting Matlab on Windows, it is always opened
   in a new window (see \code{\link{1. The Matlab server running in Matlab}}).
   If this argument is \code{\link[base:logical]{TRUE}}, the new window is minimized, otherwise not.
   This argument is ignored on non-Windows systems.}
 \item{options}{A \code{\link[base]{character}} \code{\link[base]{vector}} of options used to call the
   Matlab application.}
 \item{...}{Not used.}
}

\value{
  Returns nothing.
}

\details{
  This method is currently supported on Windows and Unix systems. Other
  systems are untested, but might work anyway.

  Note that this method will return immediately upon calling
  \code{system()} internally, i.e. you will not receive a return value
  telling wether Matlab was successfully started or not.

  To specify the full path to the matlab software set the \code{matlab}
  option, e.g. \code{options(matlab="/opt/bin/matlab6.1")}. If no such
  option exists, the value \code{"matlab"} will be used.

  The Matlab server relies on two files: 1) MatlabServer.m and
  2) InputStreamByteWrapper.class (from InputStreamByteWrapper.java).
  These files exists in the externals/ directory of this package. However,
  if they do not exist in the current directory, which is the directory
  where Matlab is started, copies of them will automatically be made.
}

\author{Henrik Bengtsson}

\seealso{
  For more information see \code{\link{Matlab}}.
}
\keyword{internal}
\keyword{methods}
