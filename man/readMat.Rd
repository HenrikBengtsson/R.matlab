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
 Reads a MAT file structure from a connection or a file.
 Both the MAT version 4 and MAT version 5 file formats are
 supported. The implementation is based on [1-4].
 Note: Do not mix up version numbers for the MATLAB software and
 the MATLAB file formats.
}

\usage{
\method{readMat}{default}(con, maxLength=NULL, fixNames=TRUE, verbose=FALSE,
  sparseMatrixClass=c("Matrix", "SparseM", "matrix"), ...)
}

\arguments{
  \item{con}{Binary \code{\link[base:connections]{connection}} from which the MAT file structure
    should be read.
    If a \code{\link[base]{character}} string, it is interpreted as filename, which then
    will be opened (and closed afterwards).
    If a \code{\link[base]{raw}} \code{\link[base]{vector}}, it will be read via as a raw binary \code{\link[base:connections]{connection}}.
  }
  \item{maxLength}{The maximum number of bytes to be read from the input
    stream, which should be equal to the length of the MAT file structure.
    If \code{NULL}, data will be read until End Of File has been reached.}
  \item{fixNames}{If \code{\link[base:logical]{TRUE}}, underscores within names of MATLAB variables
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

\section{Speed performance}{
  This function uses a MAT file parser implemented completely using
  pure R. For MAT files containing large vectorized objects, for instance
  long vectors and large matrices, the R implementation is indeed fast
  enough because it can read and parse each such objects in one go.

  On the other hand, for MAT files containing a large number of small
  objects, e.g. a large number of cell structures, there will be a
  signifant slowdown, because each of the small objects has to be
  parsed individually.
  In such cases, if possible, try to (re)save the data in MATLAB
  using larger ("more vectorized") objects.
}

\section{MAT cell structures}{
  For the MAT v5 format, \emph{cell} structures are read into
  \R as a \code{\link[base]{list}} structure.
}

\section{Unicode strings}{
 Recent versions of MATLAB store some strings using Unicode
 encodings.  If the R installation supports \code{\link{iconv}},
 these strings will be read correctly.  Otherwise non-ASCII codes
 are converted to NA.  Saving to an earlier file format version
 may avoid this problem as well.
}

\section{Reading compressed MAT files}{
 From MATLAB v7, \emph{compressed} MAT version 5 files are used by
 default [3,4].  This function supports reading such files,
 if running R v2.10.0 or newer.
 For older versions of R, the \pkg{Rcompression} package is used.
 To install that package, please see instructions at
 \url{http://www.omegahat.org/cranRepository.html}.

 As a last resort, use \code{save -V6} in MATLAB to write MAT files
 that are compatible with MATLAB v6, that is, to write
 non-compressed MAT version 5 files.
}

\section{About MAT files saved in MATLAB using '-v7.3'}{
 This function does not support MAT files saved in MATLAB as
 \code{save('foo.mat', '-v7.3')}.
 Such MAT files are of a completely different file format [5,6]
 compared to those saved with, say, \code{'-v7'}.
}

\section{Reading MAT file structures input streams}{
 Reads a MAT file structure from an input stream, either until End of File
 is detected or until \code{maxLength} bytes has been read.
 Using \code{maxLength} it is possible to read MAT file structure over
 socket connections and other non-terminating input streams. In such cases
 the \code{maxLength} has to be communicated before sending the actual
 MAT file structure.
}

\examples{
path <- system.file("mat-files", package="R.matlab")
pathname <- file.path(path, "ABC.mat")
data <- readMat(pathname)
print(data)
}

\author{
  Henrik Bengtsson.
  The internal MAT v4 reader was written by
  Andy Jacobson (Princeton University).
  Support for reading compressed files via \pkg{Rcompression},
  sparse matrices and UTF-encoded strings was added by
  Jason Riedy (UC Berkeley).
}

\seealso{
  \code{\link{writeMat}}().
}

\references{
  [1] The MathWorks Inc., \emph{MATLAB - MAT-File Format, version 5}, June 1999.\cr
  [2] The MathWorks Inc., \emph{MATLAB - Application Program Interface Guide, version 5}, 1998.\cr
  [3] The MathWorks Inc., \emph{MATLAB - MAT-File Format, version 7}, September 2009, \url{http://www.mathworks.com/access/helpdesk/help/pdf_doc/matlab/matfile_format.pdf}\cr
  [4] The MathWorks Inc., \emph{MATLAB - MAT-File Format, version R2012a}, September 2012, \url{http://www.mathworks.com/help/pdf_doc/matlab/matfile_format.pdf}\cr
  [5] The MathWorks Inc., \emph{MATLAB - MAT-File Versions}, July 2013, \url{http://www.mathworks.com/help/matlab/import_export/mat-file-versions.html}\cr
  [6] Undocumented Matlab, \emph{Improving save performance}, May 2013, \url{http://undocumentedmatlab.com/blog/improving-save-performance/}\cr
}



\keyword{file}
\keyword{IO}
