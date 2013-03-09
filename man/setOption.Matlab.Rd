%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not modify this file since it was automatically generated from:
% 
%  Matlab.R
% 
% by the Rdoc compiler part of the R.oo package.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{setOption.Matlab}
\alias{setOption.Matlab}
\alias{Matlab.setOption}
\alias{setOption,Matlab-method}

\title{Sets the value of an option}

\description{
  Sets the value of an option where the option is specified like a file pathname, e.g.
  "readResult/maxTries". See the \link[R.utils]{Options} class for details.
}

\usage{
\method{setOption}{Matlab}(this, ...)
}

\arguments{
 \item{...}{Arguments passed to
   \code{\link[R.utils:getOption.Options]{setOption()}}
   of the Options class.}
}

\value{
  Returns the previous value of the option.
}

\section{Available options}{
 \itemize{
  \item{readResult/maxTries}{The maximum number of times the connection
     is check for an answer from the Matlab server before giving up.
     Default values is 30 times.}
  \item{readResult/interval}{The interval in seconds between each poll
     for an answer.  Default interval is 1 (second).}
 }

 With default values of the above options, the \R Matlab client waits
 30 seconds for a reply from the Matlab server before giving up.
}

\author{Henrik Bengtsson, Jason Riedy}

\seealso{
  \code{\link[R.matlab:getOption.Matlab]{*getOption}()}.
  For more information see \code{\link{Matlab}}.
}
\keyword{internal}
\keyword{methods}
