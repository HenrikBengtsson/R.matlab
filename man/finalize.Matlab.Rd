%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not modify this file since it was automatically generated from:
% 
%  Matlab.R
% 
% by the Rdoc compiler part of the R.oo package.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{finalize.Matlab}
\alias{finalize.Matlab}
\alias{Matlab.finalize}
\alias{finalize,Matlab-method}

\title{Finalizes the object if deleted}

\description{
  Finalizes the object if deleted. If a Matlab connection is opened, it is closed.

  Note that you should never have to call this method explicitly. It is
  called automatically whenever the object is removed from memory
  (by the garbage collector).
}

\usage{
\method{finalize}{Matlab}(this, ...)
}

\arguments{
 \item{...}{Not used.}
}

\value{
  Returns nothing.
}

\author{Henrik Bengtsson}

\seealso{
  For more information see \code{\link{Matlab}}.
}
\keyword{internal}
\keyword{methods}
