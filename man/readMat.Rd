%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Do not modify this file since it was automatically generated from:
% 
%  readMat.R
% 
% by the Rdoc compiler part of the R.oo package.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

\name{readMat}
\alias{readMat.default}
\alias{readMat}

\title{Reads a MAT file structure from a connection or a file}

\description{
 Reads a MAT file structure from an input stream, either until End of File
 is detected or until \code{maxLength} bytes has been read.
 Using \code{maxLength} it is possible to read MAT file structure over
 socket connections and other non-terminating input streams. In such cases
 the \code{maxLength} has to be communicated before sending the actual
 MAT file structure.

 Both the MAT version 4 and MAT version 5 file formats are
 supported. The implementation is based on [1].

 From Matlab v7, \emph{compressed} MAT version 5 files are used by
 default [3].  This function supports reading such files,
 if running R v2.10.0 or newer.
 For older versions of R, the \pkg{Rcompression} package is used.
 To install that package, please see instructions at
 \url{http://www.omegahat.org/cranRepository.html}.
 As a last resort, use \code{save -V6} in Matlab to write MAT files
 that are compatible with Matlab v6, that is, to write
 non-compressed MAT version 5 files.

 Note: Do not mix up version numbers for the Matlab software and
 the Matlab file formats.

 Recent versions of Matlab store some strings using Unicode
 encodings.  If the R installation supports \code{\link{iconv}},
 these strings will be read correctly.  Otherwise non-ASCII codes
 are converted to NA.  Saving to an earlier file format version
 may avoid this problem as well.
}

\usage{\method{readMat}{default}(con, maxLength=NULL, fixNames=TRUE, verbose=FALSE, sparseMatrixClass=c("Matrix", "SparseM", "matrix"), ...)}

\arguments{
  \item{con}{Binary \code{\link[base:connections]{connection}} to which the MAT file structure should be
    written to. A string is interpreted as filename, which then will be
    opened (and closed afterwards).}
  \item{maxLength}{The maximum number of bytes to be read from the input
    stream, which should be equal to the length of the MAT file structure.
    If \code{NULL}, data will be read until End Of File has been reached.}
  \item{fixNames}{If \code{\link[base:logical]{TRUE}}, underscores within names of Matlab variables
    and fields are converted to periods.}
  \item{verbose}{Either a \code{\link[base]{logical}}, a \code{\link[base]{numeric}}, or a \code{\link[R.utils]{Verbose}}
    object specifying how much verbose/debug information is written to
    standard output. If a Verbose object, how detailed the information is
    is specified by the threshold level of the object. If a numeric, the
    value is used to set the threshold of a new Verbose object. If \code{\link[base:logical]{TRUE}},
    the threshold is set to -1 (minimal). If \code{\link[base:logical]{FALSE}}, no output is written
    (and neither is the \link[R.utils:R.utils-package]{R.utils} package required).
  }
  \item{sparseMatrixClass}{If \code{"matrix"}, a sparse matrix is expanded to
    a regular \code{\link[base]{matrix}}.  If either \code{"Matrix"} (default) or \code{"SparseM"},
    the sparse matrix representation by the package of the same name will be used.
    These packages are only loaded if the a sparse matrix is read.}
  \item{...}{Not used.}
}

\value{
  Returns a named \code{\link[base]{list}} structure containing all variables in the
  MAT file structure.
}

\details{
  For the MAT v5 format, \emph{cell} structures are read into
  \R as a \code{\link[base]{list}} structure.
}

\examples{
path <- system.file("mat-files", package="R.matlab")
pathname <- file.path(path, "ABC.mat")
data <- readMat(pathname)
print(data)
}

\author{
  Henrik Bengtsson, Mathematical Statistics, Lund University.
  The internal MAT v4 reader was written by
  Andy Jacobson at Program in Atmospheric and Oceanic Sciences,
  Princeton University.
  Support for reading compressed files via \pkg{Rcompression},
  sparse matrices and UTF-encoded strings was added by
  Jason Riedy, UC Berkeley.
}

\seealso{
  \code{\link{writeMat}}().
}

\references{
  [1] The MathWorks Inc., \emph{Matlab - MAT-File Format, version 5}, June 1999.\cr
  [2] The MathWorks Inc., \emph{Matlab - Application Program Interface Guide, version 5}, 1998.\cr
  [3] The MathWorks Inc., \emph{Matlab - MAT-File Format, version 7}, September 2009, \url{http://www.mathworks.com/access/helpdesk/help/pdf_doc/matlab/matfile_format.pdf}\cr
}



\keyword{file}
\keyword{IO}
