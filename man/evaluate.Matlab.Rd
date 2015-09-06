%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not modify this file since it was automatically generated from:
% 
%  Matlab.R
% 
% by the Rdoc compiler part of the R.oo package.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{evaluate.Matlab}
\alias{evaluate.Matlab}
\alias{Matlab.evaluate}
\alias{evaluate,Matlab-method}

\title{Evaluates a MATLAB expression}

\description{
 Evaluates one or several MATLAB expressions on the MATLAB server. This
 method will not return until the MATLAB server is done.

 If an error occurred in MATLAB an exception will be thrown. This
 exception can be caught by \code{\link[base:conditions]{tryCatch}()}.

 If you receive error message \emph{Expected an 'answer' from MATLAB,
 but kept receiving nothing}, see "Troubleshooting" under ?R.matlab.
}

\usage{
\method{evaluate}{Matlab}(this, ..., collapse=";", capture=FALSE)
}

\arguments{
  \item{...}{One or several string with MATLAB expressions. If several
    strings are given they will be concatenated with the separator
    \code{collapse}.}
  \item{collapse}{Separator to be used to concatenate expressions.}
  \item{capture}{If \code{\link[base:logical]{TRUE}}, MATLAB output is captured into a string,
    otherwise not.}
}

\value{
  If \code{caputure} is \code{\link[base:logical]{TRUE}}, then a \code{\link[base]{character}} string of MATLAB output
  is returned, where the MATLAB status code is returned as
  attribute \code{status}.
  If \code{caputure} is \code{\link[base:logical]{FALSE}}, then the MATLAB status code as is.
}

\author{Henrik Bengtsson}

\seealso{
  For more information see \code{\link{Matlab}}.
}
\keyword{internal}
\keyword{methods}
