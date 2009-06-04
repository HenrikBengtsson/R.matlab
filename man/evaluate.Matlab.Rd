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
\alias{evaluate.Matlab}
\alias{evaluate,Matlab-method}


\title{Evaluates a Matlab expression}

\description{
 Evaluates one or several Matlab expressions on the Matlab server. This
 method will not return until the Matlab server is done.

 If an error occured in Matlab an exception will be thrown. This expection
 can be caught by \code{\link[base:conditions]{tryCatch}()}.

 If you receieve error message \emph{Excepted an 'answer' from Matlab,
 but kept receiving nothing}, see "Troubleshooting" under ?R.matlab.
}

\usage{\method{evaluate}{Matlab}(this, ..., collapse=";")}

\arguments{
  \item{...}{One or several string with Matlab expressions. If several
    strings are given they will be concatenated with the separator
    \code{collapse}.}
  \item{collapse}{Separator to be used to concatenate expressions.}
}

\value{
  Returns (invisibly) \code{\link[base]{NULL}} if expressions were evaluated successfully.
  An exception might also be thrown.
}

\author{Henrik Bengtsson (\url{http://www.braju.com/R/})}

\seealso{
  For more information see \code{\link{Matlab}}.
}
\keyword{internal}
\keyword{methods}
