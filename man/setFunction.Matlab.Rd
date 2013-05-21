%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not modify this file since it was automatically generated from:
% 
%  Matlab.R
% 
% by the Rdoc compiler part of the R.oo package.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{setFunction.Matlab}
\alias{setFunction.Matlab}
\alias{Matlab.setFunction}
\alias{setFunction,Matlab-method}

\title{Defines a Matlab function}

\description{
  Creates an M-file on the Matlab server machine (in the working directory)
  containing the specified Matlab function definition.
}

\usage{
\method{setFunction}{Matlab}(this, code, name=NULL, collapse="\n", ...)
}

\arguments{
 \item{code}{The Matlab function definition.}
 \item{name}{Optional name of the function, which will defined the
    name of the M-file where the function is stored. If \code{\link[base]{NULL}},
    the name is extracted from the code.}
 \item{collapse}{The string that the code lines, if there are more than
    one, is going to be concattenated with.}
 \item{...}{Not used.}
}

\value{
  Returns nothing.
}

\examples{\dontrun{code <- c(
  "function [win,aver]=dice(B)",
  "\%Play the dice game B times",
  "gains=[-1,2,-3,4,-5,6];",
  "plays=unidrnd(6,B,1);",
  "win=sum(gains(plays));",
  "aver=win;"
)

setFunction(matlab, code)
evaluate(matlab, "[w,a]=dice(1000);")
res <- getVariable(matlab, c("w", "a"))
print(res)

}}

\author{Henrik Bengtsson}

\seealso{
  For more information see \code{\link{Matlab}}.
}
\keyword{internal}
\keyword{methods}
