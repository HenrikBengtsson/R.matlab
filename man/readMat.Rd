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
 default [3], which can be read (not written) if the \pkg{Rcompression}
 package is installed.  See \code{\link{R.matlab}} for more details on that
 package.

 If \pkg{Rcompression} is not available, use \code{save -V6} in Matlab
 to write a MAT file compatible with Matlab v6, that is, to write a
 non-compressed MAT version 5 file.

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
  \item{fixNames}{If \code{\link[base:logical]{TRUE}}, names of Matlab variables and fields are
    renamed such that they are valid variables names in R.}
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

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Reading all example files
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
for (version in 4:5) {
  cat("Loading all MAT v", version, " example files in ",
                                                path, "...\n", sep="")

  pattern <- sprintf("-v\%d[.]mat$", version)
  pathnames <- list.files(pattern=pattern, path=path, full.names=TRUE)

  for (pathname in pathnames) {
    cat("Reading MAT file: ", basename(pathname), "\n", sep="")
    mat <- readMat(pathname)
    if (interactive()) {
      cat("Press ENTER to view data:")
      readline()
    }
    print(mat)
  }
}

# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Assert that signed and unsigned integers are read correctly
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
bs <- readMat(file.path(path, "unsignedByte.mat"))
if (!identical(as.vector(bs$A), as.double(126:255)))
  stop("Error reading unsigned bytes saved by Matlab.")

is <- readMat(file.path(path, "unsignedInt.mat"))
if (!identical(as.vector(is$B), as.double(127:256)))
  stop("Error reading unsigned ints saved by Matlab.")


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Assert that sparse matrices are read identically in MAT v4 and v5
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
mat4 <- readMat(file.path(path, "SparseMatrix3-v4.mat"))
mat5 <- readMat(file.path(path, "SparseMatrix3-v5.mat"))
diff <- sum(abs(mat4$sparseM - mat5$sparseM))
if (diff > .Machine$double.eps)
  stop("Failed to read identical MAT v4 and MAT v5 sparse matrices.")


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Assert that sparse matrices can be read as 'Matrix' and 'SparseM'
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
pathname <- file.path(path, "SparseMatrix3-v4.mat")
mat4a <- readMat(pathname, sparseMatrixClass="matrix")

if (require("Matrix")) {
  mat4b <- readMat(pathname, sparseMatrixClass="Matrix")
  diff <- sum(abs(as.matrix(mat4b$sparseM) - mat4a$sparseM))
  if (diff > .Machine$double.eps)
    stop("Failed to read MAT v4 sparse matrix by class 'Matrix'.")
}

if (require("SparseM")) {
  mat4c <- readMat(pathname, sparseMatrixClass="SparseM");
  diff <- sum(abs(as.matrix(mat4c$sparseM) - mat4a$sparseM))
  if (diff > .Machine$double.eps)
    stop("Failed to read MAT v4 sparse matrix by class 'SparseM'.")
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Assert that compressed files can be read
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
if (require("Rcompression")) {
  # A particular compressed file
  pathname <- file.path(path, "StructWithSparseMatrix-v4,compressed.mat")
  mat4 <- readMat(pathname, sparseMatrixClass="matrix")

  # All compressed files
  pattern <- ",compressed[.]mat$"
  pathnames <- list.files(pattern=pattern, path=path, full.names=TRUE)
  for (pathname in pathnames) {
    cat("Reading MAT file: ", basename(pathname), "\n", sep="")
    mat <- readMat(pathname)
    if (interactive()) {
      cat("Press ENTER to view data:")
      readline()
    }
    print(mat)
  }
}


# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# Example of a Matlab struct
# - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
# File was created by
# s = struct('type',{'big','little'},  'color','red',  'x',{3,4})
#  1x2 struct array with fields:
#      type
#      color
#      x
# save structLooped.mat s -v6
mat <- readMat(file.path(path, "structLooped.mat"))

# Extract the structure
s <- mat$s

# Field names are always in the first dimension
fields <- dimnames(s)[[1]]
cat("Field names: ", paste(fields, collapse=", "), "\n", sep="");

print(s)

# Get field 'type'
print(s["type",,])

# Get substructure s(:,2)
print(s[,,2])
}

\author{
  Henrik Bengtsson, Mathematical Statistics, Lund University.
  The internal MAT v4 reader was written by
  Andy Jacobson at Program in Atmospheric and Oceanic Sciences,
  Princeton University.
  Support for read compressed files, sparse matrices and UTF-encoded
  strings was added by Jason Riedy, UC Berkeley.
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
