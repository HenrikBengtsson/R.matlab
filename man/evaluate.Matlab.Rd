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

 If an error occured in MATLAB an exception will be thrown. This expection
 can be caught by \code{\link[base:conditions]{tryCatch}()}.

 If you receieve error message \emph{Excepted an 'answer' from MATLAB,
 but kept receiving nothing}, see "Troubleshooting" under ?R.matlab.
}

\usage{
\method{evaluate}{Matlab}(this, ..., collapse=";")
}

\arguments{
  \item{...}{One or several string with MATLAB expressions. If several
    strings are given they will be concatenated with the separator
    \code{collapse}.}
  \item{collapse}{Separator to be used to concatenate expressions.}
}

\value{
  Returns (invisibly) \code{\link[base]{NULL}} if expressions were evaluated successfully.
  An exception might also be thrown.
}

\author{Henrik Bengtsson}

\seealso{
  For more information see \code{\link{Matlab}}.
}
\keyword{internal}
\keyword{methods}
