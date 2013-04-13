%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not modify this file since it was automatically generated from:
% 
%  Matlab.R
% 
% by the Rdoc compiler part of the R.oo package.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{setVariable.Matlab}
\alias{setVariable.Matlab}
\alias{Matlab.setVariable}
\alias{setVariable,Matlab-method}

\title{Sets one or several Matlab variables}

\description{
  Sets one or several \R variables on the Matlab server.
  The transfer of the data can be done locally via a temporary file
  (\code{remote=FALSE}) or through the socket \code{\link[base:connections]{connection}} (\code{remote=TRUE}),
  which is always available.
}

\usage{
\method{setVariable}{Matlab}(this, ..., remote=this$remote)
}

\arguments{
  \item{...}{Named \R variables to be set in Matlab.}
  \item{remote}{If \code{\link[base:logical]{TRUE}} the variables are transferred on the
    socket \code{\link[base:connections]{connection}}, otherwise they are transferred via a temporary file.}
}

\value{
  Returns nothing. If the Matlab server did not received the variables
  successfully an exception is thrown.
}

\author{Henrik Bengtsson}

\seealso{
  For more information see \code{\link{Matlab}}.
}
\keyword{internal}
\keyword{methods}
