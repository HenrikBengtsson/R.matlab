%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not modify this file since it was automatically generated from:
% 
%  writeMat.R
% 
% by the Rdoc compiler part of the R.oo package.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{writeMat}
\alias{writeMat.default}
\alias{writeMat}

\title{Writes a MAT file structure}

\description{
 This function takes the given variables (\code{...}) and places them in a
 MAT file structure, which is then written to a binary connection.
}

\usage{
\method{writeMat}{default}(con, ..., fixNames=TRUE, matVersion="5", onWrite=NULL, verbose=FALSE)
}

\arguments{
  \item{con}{Binary \code{\link[base:connections]{connection}} to which the MAT file structure should be
    written to. A string is interpreted as filename, which then will be
    opened (and closed afterwards).}
  \item{...}{\emph{Named} variables to be written where the names
    must be unique.}
  \item{fixNames}{If \code{\link[base:logical]{TRUE}}, periods within names of R variables
    and fields are converted to underscores.}
  \item{matVersion}{A \code{\link[base]{character}} string specifying what MAT file format
    version to be written to the connection. If \code{"5"}, a MAT v5 file
    structure is written. No other formats are currently supported.}
  \item{onWrite}{Function to be called just before starting to write to
    connection. Since the MAT file structure does not contain information
    about the total size of the structure this argument makes it possible
    to first write the structure size (in bytes) to the connection.}
  \item{verbose}{Either a \code{\link[base]{logical}}, a \code{\link[base]{numeric}}, or a \code{\link[R.utils]{Verbose}}
    object specifying how much verbose/debug information is written to
    standard output. If a Verbose object, how detailed the information is
    is specified by the threshold level of the object. If a numeric, the
    value is used to set the threshold of a new Verbose object. If \code{\link[base:logical]{TRUE}},
    the threshold is set to -1 (minimal). If \code{\link[base:logical]{FALSE}}, no output is written
    (and neither is the \link[R.utils:R.utils-package]{R.utils} package required).
  }

  Note that \code{...} must \emph{not} contain variables with names equal
  to the arguments \code{matVersion} and \code{onWrite}, which were chosen
  because we believe they are quite unique to this write method.
}

\value{
  Returns (invisibly) the number of bytes written. Any bytes written by
  any onWrite function are \emph{not} included in this count.
}

\section{Limitations}{
 Currently only the uncompressed MAT version 5 file format [6] is
 supported, that is, compressed MAT files cannot be written (only read).

 Moreover, the maximum variable size supported by the MAT version 5
 file format is 2^31 bytes [6].  In R, this limitation translates to
 2^31-1 bytes, which corresponds to for instance an integer object
 with 536870912 elements or double object with 268435456 elements.
}

\section{Details on onWrite()}{
  If specified, the \code{onWrite()} function is called before the
  data is written to the connection.  This function must take a \code{\link[base]{list}}
  argument as the first argument.  This will hold the element \code{con}
  which is the opened \code{\link[base:connections]{connection}} to be written to.
  It will also hold the element \code{length}, which specified the
  number of bytes to be written.  See example for an illustration.

  \emph{Note}, in order to provide the number of bytes before actually
  writing the data, a two-pass procedure has to be taken, where the
  first pass is imitating a complete writing without writing anything
  to the connection but only counting the total number of bytes. Then
  in the second pass, after calling \code{onWrite()}, the data is written.
}

\examples{A <- matrix(1:27, ncol = 3)
B <- as.matrix(1:10)
C <- array(1:18, dim = c(2, 3, 3))

filename <- paste(tempfile(), ".mat", sep = "")

writeMat(filename, A = A, B = B, C = C)
data <- readMat(filename)
str(data)

X <- list(A = A, B = B, C = C)
stopifnot(all.equal(X, data[names(X)]))

unlink(filename)


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# All objects written must be named uniquely
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
tryCatch({
  # Named
  writeMat(filename, A = A)
  # Not named
  writeMat(filename, A)
}, error = function(ex) {
  cat("ERROR:", ex$message, "\n")
})


tryCatch({
  # Uniquely named
  writeMat(filename, A = A, B = B, C = C)
  # Not uniquely named
  writeMat(filename, A = A, B = B, A = C)
}, error = function(ex) {
  cat("ERROR:", ex$message, "\n")
})


\dontrun{
# When writing to a stream connection the receiver needs to know on
# beforehand how many bytes are available. This can be done by using
# the 'onWrite' argument.
onWrite <- function(x)
  writeBin(x$length, con = x$con, size = 4, endian = "little")
  writeMat(con, A = A, B = B, onWrite = onWrite)
}
}

\author{Henrik Bengtsson}

\references{
  [1] The MathWorks Inc., \emph{MATLAB - MAT-File Format, version 5}, June 1999.\cr
  [2] The MathWorks Inc., \emph{MATLAB - Application Program Interface Guide, version 5}, 1998.\cr
  [3] The MathWorks Inc., \emph{MATLAB - MAT-File Format, version 7}, September 2009.\cr
  [4] The MathWorks Inc., \emph{MATLAB - MAT-File Format, version R2012a}, September 2012.\cr
  [5] The MathWorks Inc., \emph{MATLAB - MAT-File Format, version R2015b}, September 2015.\cr
  [6] The MathWorks Inc., \emph{MATLAB - MAT-File Versions}, December 2015.
      \url{http://www.mathworks.com/help/matlab/import_export/mat-file-versions.html}\cr
}

\seealso{
  \code{\link{readMat}}().
}



\keyword{file}
\keyword{IO}
