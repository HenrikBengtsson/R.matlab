%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not modify this file since it was automatically generated from:
% 
%  Matlab.R
% 
% by the Rdoc compiler part of the R.oo package.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{getOption.Matlab}
\alias{getOption.Matlab}
\alias{Matlab.getOption}
\alias{getOption,Matlab-method}

\title{Gets the value of an option}

\description{
  Gets the value of an option where the option is specified like a file pathname, e.g.
  "readResult/maxTries".  See \code{\link[R.matlab:setOption.Matlab]{*setOption}()} for what options
  are available.
  See the \link[R.utils]{Options} class for details.
}

\usage{
\method{getOption}{Matlab}(this, ...)
}

\arguments{
 \item{...}{Arguments passed to
   \code{\link[R.utils:getOption.Options]{getOption}}()
   of the Options class.}
}

\value{
  Returns the value of the option.
}

\author{Henrik Bengtsson, Jason Riedy}

\seealso{
  \code{\link[R.matlab:setOption.Matlab]{*setOption}()}.
  For more information see \code{\link{Matlab}}.
}
\keyword{internal}
\keyword{methods}
