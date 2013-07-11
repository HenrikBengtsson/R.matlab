%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not modify this file since it was automatically generated from:
% 
%  Matlab.R
% 
% by the Rdoc compiler part of the R.oo package.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{setVerbose.Matlab}
\alias{setVerbose.Matlab}
\alias{Matlab.setVerbose}
\alias{setVerbose,Matlab-method}

\title{Sets the verbose level to get more details about the MATLAB access}

\description{
  Sets the verbose level to get more details about the MATLAB access.
}

\usage{
\method{setVerbose}{Matlab}(this, threshold=0, ...)
}

\arguments{
 \item{threshold}{A threshold that the \code{level} argument
    of any write method has to be equal to or larger than in order to the
    message being written.
    Thus, the lower the threshold is the more and more details will be
    outputted. If a large \code{\link[base]{numeric}} or \code{\link[base:logical]{FALSE}}, no verbose output will be
    given.}
 \item{...}{Not used.}
}

\value{
  Returns the previous threshold value (an \code{\link[base]{integer}}) used.
}

\details{
  If the threshold is set to zero (default) general comments about the
  MATLAB access is given, such as the MATLAB server is started etc.
  If the threshold is \code{-1}, details about the communication with the
  MATLAB server is given.
  If the threshold is \code{-2}, low-level details about the communication
  with the MATLAB server is given, such as what commands are sent etc.
}

\author{Henrik Bengtsson}

\seealso{
  For more information see \code{\link{Matlab}}.
}
\keyword{internal}
\keyword{methods}
