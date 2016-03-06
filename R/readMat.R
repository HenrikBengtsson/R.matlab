##########################################################################/**
# @RdocDefault readMat
#
# @title "Reads a MAT file structure from a connection or a file"
#
# \description{
#  @get "title".
#  Both the MAT version 4 and MAT version 5 file formats are
#  supported. The implementation is based on [1-5].
#  Note: Do not mix up version numbers for the MATLAB software and
#  the MATLAB file formats.
# }
#
# @synopsis
#
# \arguments{
#   \item{con}{Binary @connection from which the MAT file structure
#     should be read.
#     If a @character string, it is interpreted as filename, which then
#     will be opened (and closed afterwards).
#     If a @raw @vector, it will be read via as a raw binary @connection.
#   }
#   \item{maxLength}{The maximum number of bytes to be read from the input
#     stream, which should be equal to the length of the MAT file structure.
#     If \code{NULL}, data will be read until End Of File has been reached.}
#   \item{fixNames}{If @TRUE, underscores within names of MATLAB variables
#     and fields are converted to periods.}
#   \item{drop}{A @character @vector specifying cases when one or more dimensions
#     of elements should be dropped in order to decrease the amount of "nestedness"
#     of the returned data structure.  This only applies to the MAT v5 file format.}
#   \item{sparseMatrixClass}{If \code{"matrix"}, a sparse matrix is expanded to
#     a regular @matrix.  If either \code{"Matrix"} (default) or \code{"SparseM"},
#     the sparse matrix representation by the package of the same name will be used.
#     These packages are only loaded if the a sparse matrix is read.}
#   \item{verbose}{Either a @logical, a @numeric, or a @see "R.utils::Verbose"
#     object specifying how much verbose/debug information is written to
#     standard output. If a Verbose object, how detailed the information is
#     is specified by the threshold level of the object. If a numeric, the
#     value is used to set the threshold of a new Verbose object. If @TRUE,
#     the threshold is set to -1 (minimal). If @FALSE, no output is written.
#   }
#   \item{...}{Not used.}
# }
#
# \value{
#   Returns a named @list structure containing all variables in the
#   MAT file structure.
# }
#
# \section{Speed performance}{
#   This function uses a MAT file parser implemented completely using
#   pure R. For MAT files containing large vectorized objects, for instance
#   long vectors and large matrices, the R implementation is indeed fast
#   enough because it can read and parse each such objects in one go.
#
#   On the other hand, for MAT files containing a large number of small
#   objects, e.g. a large number of cell structures, there will be a
#   significant slowdown, because each of the small objects has to be
#   parsed individually.
#   In such cases, if possible, try to (re)save the data in MATLAB
#   using larger ("more vectorized") objects.
# }
#
# \section{MAT cell structures}{
#   For the MAT v5 format, \emph{cell} structures are read into
#   \R as a @list structure.
# }
#
# \section{Unicode strings}{
#  Recent versions of MATLAB store some strings using Unicode
#  encodings.  If the R installation supports \code{\link{iconv}},
#  these strings will be read correctly.  Otherwise non-ASCII codes
#  are converted to NA.  Saving to an earlier file format version
#  may avoid this problem as well.
# }
#
# \section{Reading compressed MAT files}{
#  From MATLAB v7, \emph{compressed} MAT version 5 files are used by
#  default [3-5], which is supported by this function.
#
#  If for some reason it fails, use \code{save -V6} in MATLAB to write
#  non-compressed MAT v5 files (sic!).
# }
#
# \section{About MAT files saved in MATLAB using '-v7.3'}{
#  MAT v7.3 files, saved using for instance \code{save('foo.mat', '-v7.3')},
#  stores the data in the Hierarchical Data Format (HDF5) [6,7], which
#  is a format not supported by this function/package.
#  However, there exist other R packages that can parse HDF5, e.g.
#  CRAN package \pkg{h5} and Bioconductor package \pkg{rhdf5}.
# }
#
# \section{Reading MAT file structures input streams}{
#  Reads a MAT file structure from an input stream, either until End of File
#  is detected or until \code{maxLength} bytes has been read.
#  Using \code{maxLength} it is possible to read MAT file structure over
#  socket connections and other non-terminating input streams. In such cases
#  the \code{maxLength} has to be communicated before sending the actual
#  MAT file structure.
# }
#
# @examples "../incl/readMat.Rex"
#
# \author{
#   Henrik Bengtsson.
#   The internal MAT v4 reader was written by
#   Andy Jacobson (Princeton University).
#   Support for reading sparse matrices, UTF-encoded strings and
#   compressed files, was contributed by Jason Riedy (UC Berkeley).
# }
#
# \seealso{
#   @see "writeMat".
# }
#
# \references{
#   [1] The MathWorks Inc., \emph{MATLAB - MAT-File Format, version 5}, June 1999.\cr
#   [2] The MathWorks Inc., \emph{MATLAB - Application Program Interface Guide, version 5}, 1998.\cr
#   [3] The MathWorks Inc., \emph{MATLAB - MAT-File Format, version 7}, September 2009.\cr
#   [4] The MathWorks Inc., \emph{MATLAB - MAT-File Format, version R2012a}, September 2012.\cr
#   [5] The MathWorks Inc., \emph{MATLAB - MAT-File Format, version R2015b}, September 2015.\cr
#   [6] The MathWorks Inc., \emph{MATLAB - MAT-File Versions}, December 2015.
#       \url{http://www.mathworks.com/help/matlab/import_export/mat-file-versions.html}\cr
#   [7] Undocumented Matlab, \emph{Improving save performance}, May 2013.
#       \url{http://undocumentedmatlab.com/blog/improving-save-performance/}\cr
#   [8] J. Gilbert et al., {Sparse Matrices in MATLAB: Design and Implementation}, SIAM J. Matrix Anal. Appl., 1992.
#       \url{https://www.mathworks.com/help/pdf_doc/otherdocs/simax.pdf}\cr
#   [9] J. Burkardt, \emph{HB Files: Harwell Boeing Sparse Matrix File Format}, Apr 2010.
#       \url{http://people.sc.fsu.edu/~jburkardt/data/hb/hb.html}
# }
#
# @keyword file
# @keyword IO
#*/###########################################################################
setMethodS3("readMat", "default", function(con, maxLength=NULL, fixNames=TRUE, drop=c("singletonLists"), sparseMatrixClass=c("Matrix", "SparseM", "matrix"), verbose=FALSE, ...) {
  # To please R CMD check
  .require <- require;

  # The object 'this' is actually never used, but we might put 'con' or
  # similar in the structure some day, so we keep it for now. /HB 2007-06-10
  this <- list();


  #===========================================================================
  # General functions to read both MAT v4 and MAT v5 files.              BEGIN
  #===========================================================================
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Emulate support for argument 'keep.source' in older versions of R
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (getRversion() < "3.0.0") {  ## covr: skip=8
    # Look up base::parse() once; '::' is very expensive
    base_parse <- base::parse;
    parse <- function(..., keep.source=getOption("keep.source")) {
      oopts <- options(keep.source=keep.source);
      on.exit(options(oopts));
      base_parse(...);
    } # parse()
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # willRead(), hasHead() and isDone() operators keep count on the number of
  # bytes actually read and compares it with 'maxLength'.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  nbrOfBytesRead <- 0L;

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # readBinMat() need to know what endian the numerics in the stream are
  # written with. From the beginning we assume Little Endian, but that might
  # be updated when we have read the MAT-file header.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  detectedEndian <- "little";

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # ASCII is the 8-bit ASCII table with ASCII characters from 0-255.
  #
  # Extracted from the R.oo package.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ASCII <- c(
    "",    "\001","\002","\003","\004","\005","\006","\007", # 000-007
    "\010","\011","\012","\013","\014","\015","\016","\017", # 010-017
    "\020","\021","\022","\023","\024","\025","\026","\027", # 020-027
    "\030","\031","\032","\033","\034","\035","\036","\037", # 030-037
    "\040","\041","\042","\043","\044","\045","\046","\047", # 040-047
    "\050","\051","\052","\053","\054","\055","\056","\057", # 050-057
    "\060","\061","\062","\063","\064","\065","\066","\067", # 060-067
    "\070","\071","\072","\073","\074","\075","\076","\077", # 070-077
    "\100","\101","\102","\103","\104","\105","\106","\107", # 100-107
    "\110","\111","\112","\113","\114","\115","\116","\117", # 110-117
    "\120","\121","\122","\123","\124","\125","\126","\127", # 120-127
    "\130","\131","\132","\133","\134","\135","\136","\137", # 130-137
    "\140","\141","\142","\143","\144","\145","\146","\147", # 140-147
    "\150","\151","\152","\153","\154","\155","\156","\157", # 150-157
    "\160","\161","\162","\163","\164","\165","\166","\167", # 160-167
    "\170","\171","\172","\173","\174","\175","\176","\177", # 170-177
    "\200","\201","\202","\203","\204","\205","\206","\207", # 200-207
    "\210","\211","\212","\213","\214","\215","\216","\217", # 210-217
    "\220","\221","\222","\223","\224","\225","\226","\227", # 220-227
    "\230","\231","\232","\233","\234","\235","\236","\237", # 230-237
    "\240","\241","\242","\243","\244","\245","\246","\247", # 240-247
    "\250","\251","\252","\253","\254","\255","\256","\257", # 250-257
    "\260","\261","\262","\263","\264","\265","\266","\267", # 260-267
    "\270","\271","\272","\273","\274","\275","\276","\277", # 270-277
    "\300","\301","\302","\303","\304","\305","\306","\307", # 300-307
    "\310","\311","\312","\313","\314","\315","\316","\317", # 310-317
    "\320","\321","\322","\323","\324","\325","\326","\327", # 320-327
    "\330","\331","\332","\333","\334","\335","\336","\337", # 330-337
    "\340","\341","\342","\343","\344","\345","\346","\347", # 340-347
    "\350","\351","\352","\353","\354","\355","\356","\357", # 350-357
    "\360","\361","\362","\363","\364","\365","\366","\367", # 360-367
    "\370","\371","\372","\373","\374","\375","\376","\377"  # 370-377
  );

  # We removed ASCII 0x00, because it represents an empty string in
  # R v2.7.0 (and maybe some earlier version) and in R v2.8.0 we will get
  # a warning.  However, for backward compatibility we will still use it
  # for version prior to R v2.7.0.  See also email from Brian Ripley
  # on 2008-04-23 on this problem.
  if (getRversion() < "2.7.0") {  ## covr: skip=2
    ASCII[1L] <- eval(parse(text="\"\\000\""));
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Function to convert a vector of integers into a vector of ASCII chars.
  #
  # Extracted from the R.oo package.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  intToChar <- function(i) {
    ASCII[i %% 256 + 1L];
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Gets a vector of bits for an integer
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##   getBits <- function(i, nbits) {
##     ready <- FALSE;
##     bits <- integer(nbits);
##     while (!ready) {
##       bit <- i %% 2;
##       bits <- c(bits, bit);
##       i <- i %/% 2;
##       ready <- (i == 0L);
##     }
##     bits <- as.integer(bits);
##     bits;
##   } # getBits()


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Function to assert that it is possible to read a certain number of bytes.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  willRead <- function(nbrOfBytes) {
      return()
    if (is.null(maxLength))
      return();
    if (nbrOfBytesRead + nbrOfBytes <= maxLength)
      return();
    stop("Trying to read more bytes than expected from connection. Have read ", nbrOfBytesRead, " byte(s) and trying to read another ", nbrOfBytes, " byte(s), but expected ", maxLength, " byte(s).");
  } # willRead()

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Function to tell now many bytes we actually have read.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  hasRead <- function(nbrOfBytes) {
      return()
    nbrOfBytesRead <<- nbrOfBytesRead + nbrOfBytes;
    if (is.null(maxLength))
      return(TRUE);
    return(nbrOfBytesRead <= maxLength);
  } # hasRead()

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Function to check is there are more bytes to read.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  isDone <- function() {
    if (is.null(maxLength))
      return(FALSE);
    return(nbrOfBytesRead >= maxLength);
  } # isDone()


  rawBuffer <- NULL;
  rawBufferSize <- getOption("R.matlab::readMat/rawBufferSize", 10e6);
  rawBufferMethod <- getOption("R.matlab::readMat/rawBufferMethod", "1.8.0");

  if (rawBufferMethod == "1.7.1") {
    fillRawBuffer <- function(need) {
      nTotal <- length(rawBuffer);
      nMissing <- (need - nTotal);
      if (nMissing < 0L) {
        verbose && cat(verbose, level=-500, "Not filling, have enough data.")
        return(NULL);
      }
      nRead <- max(nMissing, rawBufferSize);
      raw <- readBin(con=con, what=raw(), n=nRead);
      if (length(raw) > 0L) {
        rawBuffer <<- c(rawBuffer, raw);
      }
      NULL;
    }

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Function to push back a raw vector to the main input stream
    # This is used to push back a decompressed stream of data.
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    pushBackRawMat <- function(con, raw) {
      if (length(raw) > 0L) {
        rawBuffer <<- c(raw, rawBuffer);
      }
      NULL;
    } # pushBackRawMat()

    readRawBuffer <- function(nbrOfBytes) {
      nTotal <- length(rawBuffer);
      # Nothing to read? [nTotal == 0 is a special case for reaching EoF]
      if (nbrOfBytes == 0L || nTotal == 0L) {
        return(raw(0L));
      }
      # Sanity check
      ### stopifnot(nbrOfBytes <= nTotal);
      rawBuffer[1:nbrOfBytes];
    }

    eatRawBuffer <- function(eaten) {
      nTotal <- length(rawBuffer);
      if (eaten < nTotal) {
        rawBuffer <<- rawBuffer[(eaten+1L):nTotal];
      } else {
        rawBuffer <<- raw(0L);
      }
      NULL;
    }
  } else if (rawBufferMethod == "1.8.0") {
    rawBufferOffset <- 0L;

    shortenRawBuffer <- function() {
      # Shorten existing raw buffer?
      nTotal <- length(rawBuffer);
      if (rawBufferOffset > 0L && nTotal > 0L) {
        idxs <- (rawBufferOffset+1L):nTotal;
        rawBuffer <<- rawBuffer[idxs];
        rawBufferOffset <<- 0L;
      }
      ### stopifnot(rawBufferOffset == 0L);
      NULL;
    } # shortenRawBuffer()

    fillRawBuffer <- function(need) {
      nTotal <- length(rawBuffer);
      nAvail <- nTotal - rawBufferOffset;
      nMissing <- (need - nAvail);
      if (nMissing <= 0L) {
        verbose && cat(verbose, level=-500, "Not filling, have enough data.")
        return(NULL);
      }

      # Read and append, if more data exists
      nRead <- max(nMissing, rawBufferSize);
      raw <- readBin(con=con, what=raw(), n=nRead);
      if (length(raw) > 0L) {
        shortenRawBuffer();
        rawBuffer <<- c(rawBuffer, raw);
      }

      NULL;
    }

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Function to push back a raw vector to the main input stream
    # This is used to push back a decompressed stream of data.
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    pushBackRawMat <- function(con, raw) {
      if (length(raw) > 0L) {
        shortenRawBuffer();
        # Insert pushback 'raw' data
        rawBuffer <<- c(raw, rawBuffer);
        rawBufferOffset <<- 0L;
      }
      NULL;
    } # pushBackRawMat()

    readRawBuffer <- function(nbrOfBytes) {
      nTotal <- length(rawBuffer);
      # Nothing to read?
      if (nTotal == 0L) {
        return(raw(0L));
      }
      # Sanity check
      ### stopifnot(nbrOfBytes <= nTotal);
      idxs <- seq.int(from=rawBufferOffset+1L, to=rawBufferOffset+nbrOfBytes, by=1L);
      ### stopifnot(length(idxs) == nbrOfBytes);
      rawBuffer[idxs];
    }

    eatRawBuffer <- function(eaten) {
      nTotal <- length(rawBuffer);
      nAvail <- nTotal - rawBufferOffset;
      if (eaten < nAvail) {
        rawBufferOffset <<- rawBufferOffset + eaten;
        # Sanity check
        ### stopifnot(rawBufferOffset <= nTotal);
      } else if (eaten == nAvail) {
        rawBuffer <<- raw(0L);
        rawBufferOffset <<- 0L;
      } else {
        stop("INTERNAL ERROR: More bytes was read from the raw buffer than existed: ", eaten, " > ", nAvail);
      }
      NULL;
    }
  } else {
    throw("Unkown value of option' R.matlab::readMat/rawBufferMethod': ", rawBufferMethod);
  } # if (rawBufferMethod ...)


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Function to read 'n' binary values of a data type of type 'what'
  # and size 'size', cf. readBin().
  # This function will also keep track of the actual number of bytes read.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  readBinMat <- function(con, what, size=1L, n, signed=TRUE, endian=detectedEndian) {
    # Nothing to do?
    if (n == 0L || isDone()) {
      return(c());
    }

    if (is.na(signed)) {
      signed <- TRUE;
    } else if (!signed && size > 2L && typeof(what) == "integer") {
      # Avoid warnings
      signed <- TRUE;
    }

    nbrOfBytes <- size*n;
    willRead(nbrOfBytes);
    fillRawBuffer(nbrOfBytes);

    # Extract the subset to read
    rawBufferT <- readRawBuffer(nbrOfBytes);
    bfr <- readBin(con=rawBufferT, what=what, size=size, n=n, signed=signed, endian=endian);
    nbfr <- length(bfr);
    if (nbfr > 0L) {
      ### stopifnot(nbfr == n && nbfr*size == nbrOfBytes);
      eatRawBuffer(nbfr*size);
      hasRead(nbfr*size);
    }

    bfr;
  } # readBinMat()

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Function to read 'nchars' characters from the input connection.
  # This function will also keep track of the actual number of bytes read.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  readCharMat <- function(con, nchars) {
    # Check maxLength to see if we are done.
    if (nchars == 0L || isDone()) {
      return(character(0L));
    }

    willRead(nchars);
    fillRawBuffer(nchars);

    # Extract the subset to read
    bfr <- readRawBuffer(nchars);

    ### stopifnot(length(bfr) == nchars);

    # Coerce to a string
    bfr <- rawToChar(bfr);
    ## Was:
    ## bfr <- as.integer(bfr);
    ## bfr <- intToChar(bfr);
    ## bfr <- paste(bfr, collapse="");

    eatRawBuffer(nchars);
    hasRead(nchars);

    bfr;
  } # readCharMat()


  ## convert* are internal helper functions.  They handle type dispatch
  ## and defaults for charset conversions.
  convertUTF8 <- function(ary) {
    if (length(ary) > 0L) {
      ary <- as.raw(ary);
      ary <- rawToChar(ary);
    } else {
      ary <- "";
    }
    Encoding(ary) <- "UTF-8";
    ary;
  }
##   Was:
##   convertUTF8 <- function(ary) {
##     if (length(ary) > 0L) {
##       ary <- as.integer(ary);
##       ary <- intToChar(ary);
##       ary <- paste(ary, collapse="");
##     } else {
##       ary <- "";
##     }
##     Encoding(ary) <- "UTF-8";
##     ary;
##   }

  convertASCII <- function(ary) {
    ## WAS: The below would also drop newlines etc. /HB 2014-04-29
    ## Set entires outside the ASCII range to NA except for NUL.
    # ary[ary > 127L | (ary != 0L & ary < 32L)] <- NA_integer_;

    ## (a) From http://www.wikipedia.org/wiki/UTF-8:
    ## "The first 128 characters of Unicode, which correspond
    ##  one-to-one with ASCII, are encoded using a single octet
    ##  with the same binary value as ASCII, making valid ASCII
    ##  text valid UTF-8-encoded Unicode as well.".
    ## (b) From [4]:
    ## "Note that the elements of a text matrix are stored as
    ##  floating-point numbers between 0 and 255 representing
    ##  ASCII-encoded characters."
    ## From (a) + (b), we infer that we can keep characters in
    ## Matlab text that is non-UTF encoded (when this function
    ## is used/called) as 8-bit ASCII characters (0-255).  So,
    ## if we for some odd reason get symbols outside this range,
    ## we drop them, because they cannot be interpreted as ASCII
    ## and our ASCII-to-UTF8 converted does not know how to
    ## interpret/translate such symbols). /HB 2014-04-29
    ary[ary > 255L] <- NA_integer_;

    # Can't we use base::intToUtf8(ary) here? /HB 2014-04-29
    convertUTF8(ary);
  } # convertASCII()

  ## By default, just pick out the ASCII range, ...
  convertUTF16 <- convertUTF32 <- convertASCII;

  ## However, if there's support for more on the current system,
  ## use that instead.
  if (capabilities("iconv")) {
    utfs <- grep("UTF", iconvlist(), value=TRUE);
    ## The convertUTF{16,32} routines below work in big-endian, so
    ## look for UTF-16BE or UTF16BE, etc..
    utf16 <- head(grep("UTF-?16BE", utfs, value=TRUE), n=1L);
    if (length(utf16) > 0L) {
      convertUTF16 <- function(ary) {
        ary16 <- paste(intToChar(c(sapply(ary, FUN=function(x) {
          c(x%/%256, x%%256);
        }))), collapse="");
        iconv(ary16, from=utf16, to="UTF-8");
      }
    }
    utf32 <- head(grep("UTF-?32BE", utfs, value=TRUE), n=1L);
    if (length(utf32) > 0L) {
      convertUTF32 <- function(ary) {
        ary32 <- paste(intToChar(c(sapply(ary, FUN=function(x) {
          c((x%/%16777216)%%256, (x%/%65536)%%256, (x%/%256)%%256, x%%256);
        }))), collapse="");
        iconv(ary32, from=utf32, to="UTF-8");
      }
    }
  } # if (capabilities("iconv"))

  charConverter <- function(type) {
    switch(type,
           miUTF8 = convertUTF8,
           miUTF16 = convertUTF16,
           miUTF32 = convertUTF32,
           convertASCII);
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Function to convert an array of numbers to a UTF-8 string.  If the
  # type is miUTF16 or miUTF32, iconv-supporting implementations will
  # convert the charset correctly.  Otherwise non-ASCII characters are
  # replaced by NA.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  matToString <- function(ary, type) {
    do.call(charConverter(type), list(ary));
  } # matToString

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Function to convert an array of numbers to an array of UTF-8
  # characters.  If the type is miUTF16 or miUTF32, iconv-supporting
  # implementations will convert the charset correctly.  Otherwise
  # non-ASCII characters are replaced by NA.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # sapply(X, ...) function that treats length(X) == 0 specially
  sapply0 <- function(X, FUN, ...) {
    if (length(X) == 0L) {
      FUN(X, ...);
    } else {
      sapply(X, FUN=FUN, ...);
    }
  } # sapply0()

  matToCharArray <- function(ary, type) {
    # AD HOC/special/illegal case?  /HB 2013-09-11
    if (length(ary) == 0L) {
      return(matrix(character(0L), nrow=0L, ncol=0L));
    }
    fn <- charConverter(type);
    sapply0(ary, FUN=fn);
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Function to make a variable name into a safe R variable name.
  # For instance, underscores ('_') are replaced by periods ('.').
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  asSafeRName <- function(name) {
    if (fixNames) {
      name <- gsub("_", ".", name, fixed=TRUE);
    }
    name;
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # \description{
  #  Function to uncompress zlib compressed data.
  #  We'll utilize base::memDecompress() which was introduced in R 2.10.0.
  # }
  #
  # \arguments{
  #  \item{zraw}{A @raw @vector to be uncompressed.}
  #  \item{asText}{If @TRUE, a @character string is returned,
  #    otherwise a @raw @vector.}
  #  \item{...}{Not used.}
  # }
  #
  # \value{
  #   Returns a @raw @vector (or a @character string if 'asText' is TRUE).
  # }
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  typeOfCompression <- function(zraw, ...) {
    # Guess type of compression by inspecting the header bytes;
    # Source: http://www.groupsrv.com/science/about474488.html
    known <- list(
      compress = matrix(c(c(0x1f, 0x9d)), nrow=2L),
      gzip     = matrix(c(c(0x1f, 0x8b)), nrow=2L),
      zip      = matrix(c(c(0x50, 0x4b)), nrow=2L),
      bzip2    = matrix(c(c(0x42, 0x5a)), nrow=2L),
      pack     = matrix(c(c(0x1f, 0x1e)), nrow=2L),
      LZH      = matrix(c(c(0x1f, 0x50)), nrow=2L),
      zlib     = matrix(c(
        # zlib ("common")
        c(0x78, 0x01), c(0x78, 0x5e), c(0x78, 0x9c), c(0x78, 0xda),
        # zlib ("rare"),
        c(0x08, 0x1d), c(0x08, 0x5b), c(0x08, 0x99), c(0x08, 0xd7), c(0x18, 0x19), c(0x18, 0x57), c(0x18, 0x95), c(0x18, 0xd3), c(0x28, 0x15), c(0x28, 0x53), c(0x28, 0x91), c(0x28, 0xcf), c(0x38, 0x11), c(0x38, 0x4f), c(0x38, 0x8d), c(0x38, 0xcb), c(0x48, 0x0d), c(0x48, 0x4b), c(0x48, 0x89), c(0x48, 0xc7), c(0x58, 0x09), c(0x58, 0x47), c(0x58, 0x85), c(0x58, 0xc3), c(0x68, 0x05), c(0x68, 0x43), c(0x68, 0x81), c(0x68, 0xde),
        # zlib ("very rare")
        c(0x08, 0x3c), c(0x08, 0x7a), c(0x08, 0xb8), c(0x08, 0xf6), c(0x18, 0x38), c(0x18, 0x76), c(0x18, 0xb4), c(0x18, 0xf2), c(0x28, 0x34), c(0x28, 0x72), c(0x28, 0xb0), c(0x28, 0xee), c(0x38, 0x30), c(0x38, 0x6e), c(0x38, 0xac), c(0x38, 0xea), c(0x48, 0x2c), c(0x48, 0x6a), c(0x48, 0xa8), c(0x48, 0xe6), c(0x58, 0x28), c(0x58, 0x66), c(0x58, 0xa4), c(0x58, 0xe2), c(0x68, 0x24), c(0x68, 0x62), c(0x68, 0xbf), c(0x68, 0xfd), c(0x78, 0x3f), c(0x78, 0x7d), c(0x78, 0xbb), c(0x78, 0xf9)
      ), nrow=2L) # zlib
    );

    byte1 <- zraw[1L];
    byte2 <- zraw[2L];
    for (type in names(known)) {
      bytes <- known[[type]];
      a <- (byte1 == bytes[1L,])
      b <- (byte2 == bytes[2L,])
      if (any((byte1 == bytes[1L,] & byte2 == bytes[2L,])))
        return(type);
    } # for (type ...)

    # Nothing found
    NA_character_;
  } # typeOfCompression()

  uncompressZlib <- function(zraw, ..., addGzip=TRUE, BFR.SIZE=1e7) {
    # From a few runs, it looks like memDecompress(..., type="gzip") can be
    # emulated by the follow.  The idea of adding a GZIP header comes from
    # http://unix.stackexchange.com/questions/22834/how-to-uncompress-zlib-data-in-unix
    # /HB 2014-04-06
    if (addGzip) {
      crc <- function(x) {
        tail <- tail(x, n=4L)
        truth <- rev(tail)
        crcTruth <- paste(truth, collapse="")

        n <- length(x)
        x2 <- x[1:(n-4)]

###        message(sprintf("CRC in: (tail=%s, calc=%s)", crcTruth, digest::digest(x2, algo="crc32")))

        # FIXME: If we can figure out how to calculate the checksum
        # then returning it here and replacing the 4-byte tail below
        # is the correct way to update the checksum. /HB 2014-05-06
        ## Ex: rawCRC <- rev(as.raw(c(0xf3, 0x53, 0x5e, 0x68)))

        # For now, we don't return anything
        rawCRC <- raw(0L);

        rawCRC;
      } # crc()

      rawCRC <- crc(zraw) # reqs digest()
      rawH <- as.raw(c(0x1F, 0x8B, 0x08, 0x00, 0x00, 0x00, 0x00, 0x00));
      zraw <- c(rawH, zraw);

      rawCRC <- crc(zraw) # reqs digest()

      # Update checksum
      if (length(rawCRC) == 4L) zraw[length(zraw)-c(3:0)] <- rawCRC;

      # NOTE: It won't fix the problem to just drop the checksum
      ## zraw <- zraw[1:(length(zraw)-4)]
    } # if (addGzip)

    con <- gzcon(rawConnection(zraw, open="rb"));
    on.exit(close(con));

    res <- raw(0L);
    repeat {
      # Call readBin() while capturing standard error, because gzcon()
      # in uncompressZlip() will output "crc error nnnnnn mmmmmm" until
      # we figure out how to regenerate the crc32 checksum. /HB 2014-05-06
      bfr <- local({
        conT <- rawConnection(raw(0L), open="wb");
        sink(conT, type="message");
        on.exit({
          sink(type="message");
          close(conT);
          conT <- NULL;
        });
        readBin(con, what="raw", n=BFR.SIZE);
      })

      n <- length(bfr);
      res <- c(res, bfr);
      bfr <- NULL;  # Not needed anymore

      # Done?
      if (n < BFR.SIZE) break;

      # ...and just in case (should not happen)
      if (n == 0L) break;
    } # repeat()

###    message(sprintf("CRC out: (calc=%s)", digest::digest(res, algo="crc32")))

    res;
  } # uncompressZlib()


  uncompressMemDecompress <- function(zraw, type="gzip", asText=TRUE, method=c("internal", "emulated"), ...) {
    # Argument 'type':
    if (is.na(type)) type <- "gzip";

    # Argument 'method':
    method <- match.arg(method);

    if (type == "zlib") {
      unzraw <- uncompressZlib(zraw, addGzip=TRUE);
      if (asText) unzraw <- rawToChar(unzraw);
    } else if (type == "gzip") {
      if (method == "internal") {
        # To please R CMD check for R versions before R v2.10.0
        memDecompress <- NULL; rm(list="memDecompress");
        unzraw <- memDecompress(zraw, type=type, asChar=asText, ...);
      } else if (method == "emulated") {
        unzraw <- uncompressZlib(zraw, addGzip=TRUE);
        if (asText) unzraw <- rawToChar(unzraw);
      }
    } else {
      # To please R CMD check for R versions before R v2.10.0
      memDecompress <- NULL; rm(list="memDecompress");
      unzraw <- memDecompress(zraw, type=type, asChar=asText, ...);
    }

    unzraw;
  } # uncompressMemDecompress()


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Decompression method
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  uncompress <- uncompressMemDecompress
  attr(uncompress, "label") <- "memDecompress"


##  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##  # Debug functions
##  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
##  debugIndent <- 0L;
##  debug <- function(..., sep="") {
##    if (debugIndent > 0L)
##      cat(paste(rep(" ", times=debugIndent), collapse=""));
##    cat(..., sep=sep);
##    cat("\n");
##  }
##
##  debugPrint <- function(...) {
##    print(...);
##  }
##
##  debugStr <- function(...) {
##    str(...);
##  }
##
##  debugEnter <- function(..., indent=+1L) {
##    debug(..., "...");
##    debugIndent <<- debugIndent + indent;
##  }
##
##  debugExit <- function(..., indent=-1L) {
##    debugIndent <<- debugIndent + indent;
##    debug(..., "...done\n");
##  }

  #===========================================================================
  # General functions to read both MAT v4 and MAT v5 files.                END
  #===========================================================================


  #===========================================================================
  # MAT v4 specific                                                      BEGIN
  #===========================================================================

  # "Programming Note When creating a MAT-file, you must write data in the
  #  first four bytes of this header. MATLAB uses these bytes to determine
  #  if a MAT-file uses a Version 5 format or a Version 4 format. If any of
  #  these bytes contain a zero, MATLAB will incorrectly assume the file is
  #  a Version 4 MAT-file."
  isMat4 <- function(MOPT) {
    any(MOPT == 0L);
  }


  # Debug function to generate more informative error messages.
  moptToString <- function(MOPT) {
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # MOPT[1] "indicates the numeric format of binary numbers on the machine
    #          that wrote the file.
    #          0 IEEE Little Endian (PC, 386, 486, DEC Risc)
    #          1 IEEE Big Endian (Macintosh, SPARC, Apollo,SGI, HP 9000/300,
    #            other Motorola)
    #          2 VAX D-float  [don't know how to read these]
    #          3 VAX G-float  [don't know how to read these]
    #          4 Cray         [don't know how to read these]"
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    MOPT1 <- MOPT[1L];
    if (MOPT1 == 0L)
      mStr <- "IEEE Little Endian (PC, 386, 486, DEC Risc)"
    else if (MOPT1 == 1L)
      mStr <- "IEEE Big Endian (Macintosh, SPARC, Apollo,SGI, HP 9000/300, other Motorola)"
    else if (MOPT1 == 2L)
      mStr <- "VAX D-float"
    else if (MOPT1 == 3L)
      mStr <- "VAX G-float"
    else if (MOPT1 == 4L)
      mStr <- "Cray"
    else
      mStr <- sprintf("<Unknown value of MOPT[1]. Not in range [0,4]: %d.>", as.integer(MOPT1));

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # MOPT[2] "is always 0 (zero) and is reserved for future use."
    #
    # I've only seen a non-default value for ocode used once, by a
    # matfile library external to the MathWorks.  I believe it stands
    # for "order" code...whether a matrix is written in row-major or
    # column-major format.  Its value here will be ignored. /Andy November 2003
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    if (MOPT[2L] == 0L)
      oStr <- "Reserved for future use"
    else
      oStr <- sprintf("<Unknown value of MOPT[2]. Should be 0: %d.>", as.integer(MOPT[2L]));

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # MOPT[3] "indicates which format the data is stored in according to the
    #          following table:
    #          0 double-precision (64-bit) floating point numbers
    #          1 single-precision (32-bit) floating point numbers
    #          2 32-bit signed integers
    #          3 16-bit signed integers
    #          4 16-bit unsigned integers
    #          5 8-bit unsigned integers
    #          The precision used by the save command depends on the size and
    #          type of each matrix. Matrices with any noninteger entries and
    #          matrices with 10,000 or fewer elements are saved in floating
    #          point formats requiring 8 bytes per real element. Matrices
    #          with all integer entries and more than 10,000 elements are
    #          saved in the following formats, requiring fewer bytes per element."
    #
    # precision defines the number of type of data written and thus the number of
    # bytes per datum.
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    MOPT3 <- MOPT[3L];
    if (MOPT3 == 0L)
      pStr <- "64-bit double"
    else if (MOPT3 == 1L)
      pStr <- "32-bit single"
    else if (MOPT3 == 2L)
      pStr <- "32-bit signed integer"
    else if (MOPT3 == 3L)
      pStr <- "16-bit signed integer"
    else if (MOPT3 == 4L)
      pStr <- "16-bit unsigned integer"
    else if (MOPT3 == 5L)
      pStr <- "8-bit unsigned integer"
    else
      pStr <- sprintf("<Unknown value of MOPT[3]. Not in range [0,5]: %d.>", as.integer(MOPT3));

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # MOPT[4]  "indicates the matrix type according to the following table:
    #          0 Numeric (Full) matrix
    #          1 Text matrix
    #          2 Sparse matrix
    #          Note that the elements of a text matrix are stored as floating
    #          point numbers between 0 and 255 representing ASCII-encoded
    #          characters."
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    MOPT4 <- MOPT[4L];
    if (MOPT4 == 0L)
      tStr <- "Numeric (Full) matrix"
    else if (MOPT4 == 1L)
      tStr <- "Text matrix"
    else if (MOPT4 == 2L)
      tStr <- "Sparse matrix"
    else
      tStr <- sprintf("<Unknown value of MOPT[4]. Not in range [0,2]: %d.>", as.integer(MOPT4));


    moptStr <- paste("MOPT[1]: ", mStr, ". MOPT[2]: ", oStr, ". MOPT[3]: ", pStr, ". MOPT[4]: ", tStr, ".", sep="");
    moptStr;
  } # moptToString()


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Function to convert four signed or unsigned integers in big or little
  # endian order into a (MOPT) vector c(M,O,P,T) of unsigned integers.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  getMOPT <- function(fourBytes) {
    if (length(fourBytes) != 4L)
      stop("Argument 'fourBytes' must a vector of 4 bytes: ", length(fourBytes));

    # Make sure the four bytes are non-signed integers
    fourBytes <- as.integer(fourBytes);
    neg <- (fourBytes < 0L);
    if (any(neg))
      fourBytes[neg] <- fourBytes[neg] + 256L;

    base <- 256^(0:3);
    MOPT <- integer(4L);
    for (endian in c("little", "big")) {
      mopt <- sum(base*fourBytes);
      for (kk in 4:1) {
        MOPT[kk] <- mopt %% 10;
        mopt <- mopt %/% 10;
      }

      isMOPT <- (MOPT[1L] %in% 0:4 && MOPT[2L] == 0L && MOPT[3L] %in% 0:5 && MOPT[4L] %in% 0:2);
      if (isMOPT)
        break;

      base <- rev(base);
    } # for (endian ...)

    if (!isMOPT) {
      stop("File format error: Not a valid MAT v4. The first four bytes (MOPT) were: ", paste(MOPT, collapse=", "));
    }

    verbose && cat(verbose, level=-50, "Read MOPT bytes: ", moptToString(MOPT));

    MOPT;
  } # getMOPT()



  readMat4 <- function(con, maxLength=NULL, firstFourBytes=NULL) {
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Function to read a MAT v4 Matrix Header Format
    #
    # Fix length: 20 bytes
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    readMat4Header <- function(con, firstFourBytes=NULL) {
      header <- list();

      # "A MAT-file may contain one or more matrices. The matrices are written
      #  sequentially on disk, with the bytes forming a continuous stream. Each matrix
      #  starts with a fixed-length 20-byte header that contains information describing
      #  certain attributes of the Matrix. The 20-byte header consists of five long
      #  (4-byte) integers."


      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # The 'type' field, a.k.a. MOPT
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      if (is.null(firstFourBytes)) {
        firstFourBytes <- readBinMat(con, what=integer(), size=1L, n=4L);
      }

      # If no bytes are read, we have reached the End Of Stream.
      if (length(firstFourBytes) == 0L)
        return(NULL);

      # Assert that it really is a MAT v4 file we are reading and get MOPT bytes
      MOPT <- getMOPT(firstFourBytes);

      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # MOPT[1] "indicates the numeric format of binary numbers on the machine
      #          that wrote the file.
      #          0 IEEE Little Endian (PC, 386, 486, DEC Risc)
      #          1 IEEE Big Endian (Macintosh, SPARC, Apollo,SGI, HP 9000/300,
      #            other Motorola)
      #          2 VAX D-float  [don't know how to read these]
      #          3 VAX G-float  [don't know how to read these]
      #          4 Cray         [don't know how to read these]"
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      MOPT1 <- MOPT[1L];
      if (MOPT1 == 0L) {
        detectedEndian <<- "little";
      } else if (MOPT1 == 1L) {
        detectedEndian <<- "big";
      } else if (MOPT1 %in% 2:4) {
        stop("Looks like a MAT v4 file, but the storage format of numerics (VAX D-float, VAX G-float or Cray) is not supported. Currently only IEEE numeric formats in big or little endian are supported.");
      } else {
        stop("Unknown first byte in MOPT header (not in [0,4]): ", paste(MOPT, collapse=", "));
      }

      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # MOPT[2] "is always 0 (zero) and is reserved for future use."
      #
      # I've only seen a non-default value for ocode used once, by a
      # matfile library external to the MathWorks.  I believe it stands
      # for "order" code...whether a matrix is written in row-major or
      # column-major format.  Its value here will be ignored. /Andy November 2003
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      header$ocode <- MOPT[2L];

      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # MOPT[3] "indicates which format the data is stored in according to the
      #          following table:
      #          0 double-precision (64-bit) floating point numbers
      #          1 single-precision (32-bit) floating point numbers
      #          2 32-bit signed integers
      #          3 16-bit signed integers
      #          4 16-bit unsigned integers
      #          5 8-bit unsigned integers
      #          The precision used by the save command depends on the size and
      #          type of each matrix. Matrices with any noninteger entries and
      #          matrices with 10,000 or fewer elements are saved in floating
      #          point formats requiring 8 bytes per real element. Matrices
      #          with all integer entries and more than 10,000 elements are
      #          saved in the following formats, requiring fewer bytes per element."
      #
      # precision defines the number of type of data written and thus the number of
      # bytes per datum.
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      MOPT3 <- MOPT[3L];
      if (MOPT3 == 0L) {
        # "64-bit double";
        header$what <- double();
        header$size <- 8L;
        header$signed <- NA;
      } else if (MOPT3 == 1L) {
        # "32-bit single";
        header$what <- double();
        header$size <- 4L;
        header$signed <- NA;
      } else if (MOPT3 == 2L) {
        # "32-bit signed integer";
        header$what <- integer();
        header$size <- 4L;
        header$signed <- TRUE;  # Ignored by readBin() because 32-bit ints are always signed!
      } else if (MOPT3 == 3L) {
        # "16-bit signed integer";
        header$what <- integer();
        header$size <- 2L;
        header$signed <- TRUE;
      } else if (MOPT3 == 4L) {
        # "16-bit unsigned integer";
        header$what <- integer();
        header$size <- 2L;
        header$signed <- FALSE;
      } else if (MOPT3 == 5L) {
        # "8-bit unsigned integer";
        header$what <- integer();
        header$size <- 1L;
        header$signed <- FALSE;
      } else {
        stop("Unknown third byte in MOPT header (not in [0,5]): ", paste(MOPT, collapse=", "));
      }

      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # MOPT[4]  "indicates the matrix type according to the following table:
      #          0 Numeric (Full) matrix
      #          1 Text matrix
      #          2 Sparse matrix
      #          Note that the elements of a text matrix are stored as floating
      #          point numbers between 0 and 255 representing ASCII-encoded
      #          characters."
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      MOPT4 <- MOPT[4L];
      header$matrixType <- "numeric";
      if (MOPT4 == 0L) {
        header$matrixType <- "numeric";
      } else if (MOPT4 == 1L) {
        header$matrixType <- "text";
      } else if (MOPT4 == 2L) {
        header$matrixType <- "sparse";
      } else {
###        stop("Unknown fourth byte in MOPT header (not in [0,2]): ", paste(MOPT, collapse=", "));
      }

      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # The 'mrows' and 'ncols' fields
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # "The row dimension contains an integer with the number of rows in the matrix."
      header$mrows  <- readBinMat(con, what=integer(), size=4L, n=1L)

      # "The column dimension contains an integer with the number of columns in the matrix."
      header$ncols  <- readBinMat(con, what=integer(), size=4L, n=1L)

      verbose && cat(verbose, level=-50, "Matrix dimension: ", header$mrows, "x", header$ncols);

      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # The 'imagf' fields
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # "The imaginary flag is an integer whose value is either 0 or 1. If 1,
      #  then the matrix has an imaginary part. If 0, there is only real data."
      header$imagf  <- readBinMat(con, what=integer(), size=4L, n=1L)

      verbose && cat(verbose, level=-60, "Matrix contains imaginary values: ", as.logical(header$imagf));

      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # The 'namelen' fields
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # "The name length contains an integer with 1 plus the length of the matrix name."
      header$namlen <- readBinMat(con, what=integer(), size=4L, n=1L)

      verbose && cat(verbose, level=-100, "Matrix name length: ", header$namlen-1);

      header;
    }


    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Function to read a MAT v4 Matrix Data Format
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    textMatrixCollapse <- getOption("R.matlab::readMat/v4/textMatrixCollapse", "byrow");
    textMatrixCollapse <- match.arg(textMatrixCollapse, choices=c("byrow", "bycolumn", "none"));
    if (textMatrixCollapse == "byrow") {
      mat4TextMatrixToString <- function(data) {
        apply(data, MARGIN=1L, FUN=paste, collapse="", sep="");
      }
    } else if (textMatrixCollapse == "bycolumn") {
      mat4TextMatrixToString <- function(data) {
        apply(data, MARGIN=2L, FUN=paste, collapse="", sep="");
      }
    } else {
      mat4TextMatrixToString <- function(data) data;
    }

    readMat4Data <- function(con, header) {
      # "Immediately following the fixed length header is the data whose length
      #  is dependent on the variables in the fixed length header:"

      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # The 'name' field
      #
      # "The matrix name consists of 'namlen' ASCII bytes, the last one of which
      #  must be a null character ('\0')."
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      name <- readCharMat(con, header$namlen);

      verbose && cat(verbose, level=-50, "Matrix name: '", name, "'");

      name <- asSafeRName(name);

      verbose && cat(verbose, level=-51, "Matrix safe name: '", name, "'");

      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # The 'real' field
      #
      # "Real part of the matrix consists of mrows * ncols numbers in the format
      #  specified by the MOPT[3] element of the type flag. The data is stored
      #  column-wise such that the second column follows the first column, etc."
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      n <- header$mrows * header$ncols;
      if (header$matrixType == "text") {
        data <- readBinMat(con, what=header$what, size=header$size,
                                                     signed=header$signed, n=n);
        data <- intToChar(data);

        # Make into a matrix
        dim(data) <- c(header$mrows, header$ncols);

        # Turn text matrix intro strings (if at all)
        data <- mat4TextMatrixToString(data);
      } else if (header$matrixType %in% c("numeric", "sparse")) {
        real <- readBinMat(con, what=header$what, size=header$size, signed=header$signed, n=n);
        if (header$imagf != 0L) {
          verbose && cat(verbose, level=-2, "Reading imaginary part of complex data set.")
          imag <- readBinMat(con, what=header$what, size=header$size, signed=header$signed, n=n);
          data <- complex(real=real, imaginary=imag);
        } else {
          data <- real;
          real <- NULL; # Not needed anymore
        }

        # Make into a matrix or an array
        dim(data) <- c(header$mrows, header$ncols);

        if (header$matrixType == "sparse") {
          # From help sparse in MATLAB:
          # "S = SPARSE(i,j,s,m,n,nzmax) uses the rows of [i,j,s] to generate an
          #  m-by-n sparse matrix with space allocated for nzmax nonzeros.  The
          #  two integer index vectors, i and j, and the real or complex entries
          #  vector, s, all have the same length, nnz, which is the number of
          #  nonzeros in the resulting sparse matrix S .  Any elements of s
          #  which have duplicate values of i and j are added together."

          # The last entry in 'data' is (only) used to specify the size of the
          # matrix, i.e. to infer (m,n).
          i <- as.integer(data[,1L]);
          j <- as.integer(data[,2L]);
          s <- data[,3L];
          data <- NULL; # Not needed anymore

          if (verbose) {
            str(verbose, level=-102, header);
            str(verbose, level=-102, i);
            str(verbose, level=-102, j);
            str(verbose, level=-102, s);
          }

          # When saving a sparse matrix, MATLAB is making sure that one can infer
          # the size of the m-by-n sparse matrix for the index matrix [i,j]. If
          # there are no non-zero elements in the last row or last column, MATLAB
          # saves a zero elements in such case.
          n <- max(i);
          m <- max(j);

          # Note that it can be the case that MATLAB save the above extra element
          # just in case, meaning it might actually contain an repeated element.
          # If so, remove it. /HB 2008-02-12
          last <- length(i);
          if (last > 1L && i[last] == i[last-1L] && j[last] == j[last-1L]) {
            i <- i[-last];
            j <- j[-last];
            s <- s[-last];
          }

          if (sparseMatrixClass == "Matrix" && .require("Matrix", quietly=TRUE)) {
            i <- i-1L;
            j <- j-1L;
            dim <- as.integer(c(n, m));
            data <- new("dgTMatrix", i=i, j=j, x=s, Dim=dim);
            data <- as(data, "dgCMatrix");
          } else if (sparseMatrixClass == "SparseM" && .require("SparseM", quietly=TRUE)) {
            dim <- as.integer(c(n, m));
            data <- new("matrix.coo", ra=s, ia=i, ja=j, dimension=dim);
          } else {
            # Instead of applying row-by-row, we calculate the position of each
            # sparse element in an hardcoded fashion.
            pos <- (j-1L)*n + i;
            i <- j <- NULL; # Not needed anymore

            data <- matrix(0, nrow=n, ncol=m);
            data[pos] <- s;
            pos <- s <- NULL; # Not needed anymore
          }
        }
      } else {
        stop("MAT v4 file format error: Unknown 'type' in header: ", header$matrixType);
      }

      if (verbose) {
        cat(verbose, level=-60, "Matrix elements:\n");
        str(verbose, level=-60, data);
        if (header$matrixType == "text") {
          cat(verbose, level=-60, "Distribution of string lengths:");
          t <- table(nchar(data));
          names(t) <- paste("n=", names(t), sep="")
          print(verbose, level=-60, t)
        }
    }

      data <- list(data);
      names(data) <- name;

      data;
    } # readMat4Data()

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # "Main program"
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Since readMat4() is wrapped inside the readMat() function, we can assume
    # that 'con' really is a connection.

    result <- list();

    repeat {
      header <- readMat4Header(con, firstFourBytes=firstFourBytes);
      verbose && str(verbose, level=-102, header);
      if (is.null(header))
        break;

      data <- readMat4Data(con, header);
      verbose && str(verbose, level=-102, data);

      result <- append(result, data);
      data <- NULL; # Not needed anymore

      firstFourBytes <- NULL;
    } # repeat

    header <- list(version="4", endian=detectedEndian);
    attr(result, "header") <- header;
    result;
  } # readMat4()
  #===========================================================================
  # MAT v4 specific                                                        END
  #===========================================================================


  #===========================================================================
  # MAT v5 specific                                                      BEGIN
  #===========================================================================
  readMat5 <- function(con, maxLength=NULL, firstFourBytes=NULL) {
    # Used to test if a matrix read contains an imaginary part too.
    left <- NA_integer_;

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Function to read the MAT-file header, which contains information of what
    # version of the MAT file we are reading, if it used little or big endian
    # etc.
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    readMat5Header <- function(this, firstFourBytes=NULL) {
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # "MATLAB uses the first four bytes to determine if a MAT-file uses a
      #  Version 5 format or a Version 4 format. If any of these bytes
      #  contain a zero, MATLAB will assume the file is a Version 4 MAT-file."
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      if (is.null(firstFourBytes))
        firstFourBytes <- readBinMat(con, what=integer(), size=1L, n=4L);

      MOPT <- firstFourBytes;

      if (MOPT[1L] %in% 0:4 && MOPT[2L] == 0L && MOPT[3L] %in% 0:5 && MOPT[4L] %in% 0:2) {
        stop("Detected MAT file format v4. Do not use readMat5() explicitly, but use readMat().");
      }

      # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      #  Text [124 bytes] (we already have read four of them)
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # Paste the 'MOPT' above to the rest.
      description <- c(MOPT, readBinMat(con, what=integer(), size=1L, n=120L));
      description <- paste(intToChar(description), collapse="");

      # - - - - - - - - - -
      #  Version
      # - - - - - - - - - -
      # At this point we can not know which the endian is and we just have to
      # make a guess and adjust later.
      version <- readBinMat(con, what=integer(), size=2L, n=1L, endian="little");

      # - - - - - - - - - -
      #  Endian Indicator
      # - - - - - - - - - -
      endian <- readCharMat(con, nchars=2L);
      if (endian == "MI") {
        detectedEndian <<- "big";
      } else if (endian == "IM") {
        detectedEndian <<- "little";
      } else {
        warning("Unknown endian: ", endian, ". Will assume Bigendian.");
        detectedEndian <<- "big";
      }

      if (detectedEndian == "big") {
         hi <- version %/% 256;
         low <- version %% 256;
         version <- 256*low + hi;
      }

      if (version == 256) {         # version == 0x0100
        version = "5";
      } else {
        warning("Unknown MAT version tag: ", version, ". Will assume version 5.");
        version = as.character(version);
      }

      list(description=description, version=version, endian=detectedEndian);
    } # readMat5Header()

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # MAT5 CONSTANTS
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Data sizes and types according to [5]
    KNOWN_TYPES <- c(
                                  # Value  Symbol        MAT-File Data Type
      "miMATRIX"=0L,              # ----------------------------------------------------------
      "miINT8"=8L,                #     1  miINT8        8 bit, signed
      "miUINT8"=8L,               #     2  miUINT8       8 bit, unsigned
      "miINT16"=16L,              #     3  miINT16       16-bit, signed
      "miUINT16"=16L,             #     4  miUINT16      16-bit, unsigned
      "miINT32"=32L,              #     5  miINT32       32-bit, signed
      "miUINT32"=32L,             #     6  miUINT32      32-bit, unsigned
      "miSINGLE"=32L,             #     7  miSINGLE      IEEE 754 single format
      "--"=NA_integer_,           #     8  --            Reserved
      "miDOUBLE"=64L,             #     9  miDOUBLE      IEEE 754 double format
      "--"=NA_integer_,           #    10  --            Reserved
      "--"=NA_integer_,           #    11  --            Reserved
      "miINT64"=64L,              #    12  miINT64       64-bit, signed
      "miUINT64"=64L,             #    13  miUINT64      64-bit, unsigned
      "miMATRIX"=NA_integer_,     #    14  miMATRIX      MATLAB array
      "miCOMPRESSED"=NA_integer_, #    15  miCOMPRESSED  Compressed Data
      "miUTF8"=8L,                #    16  miUTF8        Unicode UTF-8 Encoded Character Data
      "miUTF16"=16L,              #    17  miUTF16       Unicode UTF-16 Encoded Character Data
      "miUTF32"=32L               #    18  miUTF32       Unicode UTF-32 Encoded Character Data
    );
    NAMES_OF_KNOWN_TYPES <- names(KNOWN_TYPES);
    NBR_OF_KNOWN_TYPES <- length(KNOWN_TYPES);

    SIGNED_KNOWN_TYPES <- rep(NA, times=NBR_OF_KNOWN_TYPES);
    names(SIGNED_KNOWN_TYPES) <- NAMES_OF_KNOWN_TYPES;
    SIGNED_KNOWN_TYPES[grep("miINT", NAMES_OF_KNOWN_TYPES)] <- TRUE;
    SIGNED_KNOWN_TYPES[grep("miUINT", NAMES_OF_KNOWN_TYPES)] <- FALSE;

    KNOWN_WHATS <- list(
      "miMATRIX"=double(),
      "miINT8"=integer(),
      "miUINT8"=integer(),
      "miINT16"=integer(),
      "miUINT16"=integer(),
      "miINT32"=integer(),
      "miUINT32"=integer(),
      "miSINGLE"=double(),
      "--"=NA,
      "miDOUBLE"=double(),
      "--"=NA,
      "--"=NA,
      "miINT64"=integer(),
      "miUINT64"=integer(),
      "miMATRIX"=NA,
      "miCOMPRESSED"=NA,
      "miUTF8"=integer(),
      "miUTF16"=integer(),
      "miUTF32"=integer()
    );
    stopifnot(length(KNOWN_WHATS) == NBR_OF_KNOWN_TYPES);

    # Known array types [5] and the number of bytes they occupy.
    # NOTE: The index corresponds to its encoded value.
    KNOWN_ARRAY_FLAGS <- c(           # MATLAB Array Type (Class)  Value
                                      # ---------------------------------
      "mxCELL_CLASS"=NA_integer_,     # Cell array                 1
      "mxSTRUCT_CLASS"=NA_integer_,   # Structure                  2
      "mxOBJECT_CLASS"=NA_integer_,   # Object                     3
      "mxCHAR_CLASS"=8L,              # Character array            4
      "mxSPARSE_CLASS"=NA_integer_,   # Sparse array               5
      "mxDOUBLE_CLASS"=NA_integer_,   # Double precision array     6
      "mxSINGLE_CLASS"=NA_integer_,   # Single precision array     7
      "mxINT8_CLASS"=8L,              # 8-bit, signed integer      8
      "mxUINT8_CLASS"=8L,             # 8-bit, unsigned integer    9
      "mxINT16_CLASS"=16L,            # 16-bit, signed integer     10
      "mxUINT16_CLASS"=16L,           # 16-bit, unsigned integer   11
      "mxINT32_CLASS"=32L,            # 32-bit, signed integer     12
      "mxUINT32_CLASS"=32L,           # 32-bit, unsigned integer   13
      "mxINT64_CLASS"=64L,            # 64-bit, signed integer     14
      "mxUINT64_CLASS"=64L,           # 64-bit, unsigned integer   15
      "mxFUNCTION_CLASS"=8L,          # Function                   16 ## Undocumented!
      "mxOPAQUE_CLASS"=NA_integer_    # Function handle, ...?      17 ## Undocumented!
    );
    NAMES_OF_KNOWN_ARRAY_FLAGS <- names(KNOWN_ARRAY_FLAGS);
    NBR_OF_KNOWN_ARRAY_FLAGS <- length(KNOWN_ARRAY_FLAGS);
    SIGNED_KNOWN_ARRAY_FLAGS <- rep(NA, times=NBR_OF_KNOWN_ARRAY_FLAGS);
    names(SIGNED_KNOWN_ARRAY_FLAGS) <- NAMES_OF_KNOWN_ARRAY_FLAGS;
    SIGNED_KNOWN_ARRAY_FLAGS[grep("mxINT", NAMES_OF_KNOWN_ARRAY_FLAGS)] <- TRUE;
    SIGNED_KNOWN_ARRAY_FLAGS[grep("mxUINT", NAMES_OF_KNOWN_ARRAY_FLAGS)] <- FALSE;


    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Utility functions for readMat5DataElement()
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      # "Each data element begins with an 8-byte tag followed immediately
      #  by the data in the element."
      #
      # From [1, page 6]:
      #
      #      1    2    3    4    5    6    7    8
      #   +----+----+----+----+----+----+----+----+
      #   |    Data type      |  Number of Bytes  |  Tag
      #   +---------------------------------------+
      #   :                                       :
      #
      # but also [1, page 9]:
      #
      #      1    2    3    4   ...
      #   +----+----+----+----+----+----+----+----+
      #   | Nbr of. | Data t. | ...               |  Tag
      #   +---------------------------------------+
      #   :                                       :
      #
      mat5ReadTag <- function(this) {
        if (verbose) {
          enter(verbose, level=-80, "Reading Tag");
          on.exit(exit(verbose));
        }

        type <- readBinMat(con, what=integer(), size=4L, n=1L);

        # Did we read EOF?
        if (length(type) == 0L)
          return(NULL);

        left <<- left - 4L;

        nbrOfBytes <- NULL;

        # From [1, page 9]:
        # "Programming Note - When reading a MAT-file, you can tell if you
        #  are processing a compressed data element by comparing the value
        #  of the first two bytes of the tag with the value zero (0). If
        #  these two bytes are not zero, the tag uses the compressed format."
        tmp <- type;
        bytes <- rep(NA_integer_, times=4L);
        for (kk in 1:4) {
          bytes[kk] <- (tmp %% 256);
          tmp <- tmp %/% 256;
        }
        compressed <- any(bytes[3:4] != 0L);

        verbose && cat(verbose, level=-100, "Compressed tag: ", compressed);

        if (compressed) {
          # NOTE: Do not swap for different endians here. /HB 020827
          nbrOfBytes <- type %/% 65536;
          type <- type %% 65536;
          if (detectedEndian == "big") {
            tmp <- type;
          }
          if (type+1L < 1L || type+1L > NBR_OF_KNOWN_TYPES)
            stop("Unknown data type. Not in range [1,", NBR_OF_KNOWN_TYPES, "]: ", type);

          # Treat unsigned values too.
          padding <- 4L - ((nbrOfBytes-1L) %% 4L + 1L);
        } else {
          nbrOfBytes <- readBinMat(con, what=integer(), size=4L, n=1L);
          left <<- left - 4L;
          padding <- 8L - ((nbrOfBytes-1L) %% 8L + 1L);
        }

        type <- type+1L;
        sizeOf <- KNOWN_TYPES[type];
        what <- KNOWN_WHATS[[type]];
        signed <- SIGNED_KNOWN_TYPES[type];
        type <- NAMES_OF_KNOWN_TYPES[type];
#       str(list(type=type, sizeOf=sizeOf, what=what, signed=signed));

        tag <- list(type=type, signed=signed, sizeOf=sizeOf, what=what, nbrOfBytes=nbrOfBytes, padding=padding, compressed=compressed);

        verbose && print(verbose, level=-100, unlist(tag));

        if (tag$type == "miCOMPRESSED") {
          n <- tag$nbrOfBytes;
          zraw <- readBinMat(con=con, what=raw(), n=n);

          # Guess type of compression by inspecting the header bytes;
          # Source: http://www.groupsrv.com/science/about474488.html
          type <- typeOfCompression(zraw);

          if (verbose) {
            cat(verbose, level=-110, "Decompressing ", n, " bytes");
            printf(verbose, level=-110, "zraw [%d bytes; compression type: %s]: %s\n", length(zraw), type, hpaste(zraw, maxHead=8, maxTail=8));
          }
          # Sanity check
          stopifnot(identical(length(zraw), n));
          tryCatch({
            unzraw <- uncompress(zraw, type=type, asText=FALSE);

            verbose && printf(verbose, level=-110,
                    "Inflated %.3f times from %d bytes to %d bytes.\n",
                    length(unzraw)/length(zraw), length(zraw), length(unzraw));

            pushBackRawMat(con, unzraw);
            unzraw <- NULL; # Not needed anymore
          }, error = function(ex) {
            msg <- ex$message;
            env <- globalenv(); # To please 'R CMD check'
            assign("R.matlab.debug.zraw", zraw, envir=env);

            # Guess type of compression by inspecting the header bytes;
            # Source: http://www.groupsrv.com/science/about474488.html
            if (is.na(type)) type <- "<unknown>";

            # Translate the integer error code in error messages such as
            # "internal error -3 in memDecompress(2)".
            pattern <- "(.*internal error )([-0-9]*)( in memDecompress[(])([0-9])([)].*)";
            if (regexpr(pattern, msg) != -1L) {
              zCode <- gsub(pattern, "\\2", msg);
              tCode <- gsub(pattern, "\\4", msg);

              zCodes <- c(Z_OK=0, Z_STREAM_END=1, Z_NEED_DICT=2,
                          Z_ERRNO=-1, Z_STREAM_ERROR=-2, Z_DATA_ERROR=-3,
                          Z_MEM_ERROR=-4, Z_BUF_ERROR=-5, Z_VERSION_ERROR=-6);
              zLabel <- names(zCodes)[match(zCode, zCodes)];

              tCodes <- c(none=1, gzip=2, bzip2=3, xz=4, unknown=5)
              tLabel <- names(tCodes)[match(tCode, tCodes)];

              msgT <- gsub(pattern, sprintf("\\1%s\\3%s\\5", zLabel, tLabel), msg)
              msg <- sprintf("'%s' (translated from '%s')", msgT, msg);
            }

            msg <- sprintf("INTERNAL ERROR: Failed to decompress data (%s [%d bytes; first two bytes => '%s']) using '%s'. Please report to the R.matlab (v%s) package maintainer (%s). The reason was: %s", hpaste(zraw, maxHead=8, maxTail=8), length(zraw), type, attr(uncompress, "label"), getVersion(R.matlab), getMaintainer(R.matlab), msg);
            onError <- getOption("R.matlab::readMat/onDecompressError", "error");
            if (identical(onError, "warning")) {
              warning(msg);
              if (verbose) {
                enter(verbose, "Skipping");
                cat(verbose, msg);
                exit(verbose);
              }
            } else {
              throw(msg);
            }
          }) # tryCatch()
          zraw <- NULL; # Not needed anymore

          tag <- mat5ReadTag(this);
        } # if (tag$type == "miCOMPRESSED")

        tag;
      } # mat5ReadTag()


    # Subelement     Data Type  Number of Bytes
    # ---------------------------------------------------------------------
    # Array Flags    miUINT32   2*sizeOf(miUINT32) (8 bytes)
    mat5ReadArrayFlags <- function(this) {
      if (verbose) {
        enter(verbose, level=-70, "Reading Array Flags");
        on.exit(exit(verbose));
      }

      # Read the first miUINT32 integer
      arrayFlags <- readBinMat(con, what=integer(), size=4L, n=1L);
      left <<- left - 4L;

      # Byte 4 - Class
      # "Class. This field contains a value that identifies the MATLAB
      # array type (class) represented by the data element."
      #
      class <- arrayFlags %% 256;
      if (class < 1L || class > NBR_OF_KNOWN_ARRAY_FLAGS) {
        stop("Unknown array type (class). Not in [1,", NBR_OF_KNOWN_ARRAY_FLAGS, "]: ", class);
      }

      symbol <- NAMES_OF_KNOWN_ARRAY_FLAGS[class];
      classSize <- KNOWN_ARRAY_FLAGS[class];


      arrayFlags <- arrayFlags %/% 256;

      # Byte 3 - Flags
      # "Flags. This field contains three, single-bit flags that indicate
      #  whether the numeric data is complex, global, or logical. If the
      #  complex bit is set, the data element includes an imaginary part
      #  (pi). If the global bit is set, MATLAB loads the data element as
      #  a global variable in the base workspace. If the logical bit is
      #  set, it indicates the array is used for logical indexing."
      flags <- arrayFlags %% 256;

      # Was:
      ## bits <- as.logical(getBits(flags + 256L, nbits=9L)[-9L]);
      ## logical <- bits[2L];
      ## global  <- bits[3L];
      ## complex <- bits[4L];

      f1 <- flags %% 2;
      f2 <- (flags - f1) %% 4;
      f3 <- (flags - f1 - f2) %% 8;
      f4 <- (flags - f1 - f2 - f3) %% 16;
      logical <- as.logical(f2);
      global  <- as.logical(f3);
      complex <- as.logical(f4);


      # Bytes 1 & 2 - The two hi-bytes are "undefined".


      # Used for Sparse Arrays, otherwise undefined
      # Read the second miUINT32 integer
      nzmax <- readBinMat(con, what=integer(), size=4L, n=1L);
      left <<- left - 4L;

      flags <- list(logical=logical, global=global, complex=complex, class=symbol, classSize=classSize, nzmax=nzmax);

      if (verbose) {
        cat(verbose, level=-100, "Flags:");
        print(verbose, level=-100, unlist(flags[-1L]));
      }

      flags;
    } # mat5ReadArrayFlags()


    mat5ReadDimensionsArray <- function(this) {
      if (verbose) {
        enter(verbose, level=-70, "Reading Dimensions Array");
        on.exit(exit(verbose));
      }

      tag <- mat5ReadTag(this);
      if (!tag$type %in% c("miINT8", "miINT32")) {
        if (verbose) {
          cat(verbose, "Tag:");
          str(verbose, tag);
        }
        throw("Tag type not supported: ", tag$type);
      }

      sizeOf <- tag$sizeOf %/% 8;
      len <- tag$nbrOfBytes %/% sizeOf;
      verbose && cat(verbose, level=-100, "Reading ", len, " integers each of size ", sizeOf, " bytes.");
      dim <- readBinMat(con, what=integer(), size=sizeOf, n=len);
      left <<- left - sizeOf*len;

      verbose && cat(verbose, level=-101, "Reading ", tag$padding, " padding bytes.");
      padding <- readBinMat(con, what=integer(), size=1L, n=tag$padding);
      left <<- left - tag$padding;

      dimArray <- list(tag=tag, dim=dim);

      verbose && print(verbose, level=-100, list(dim=dim));

      dimArray;
    } # mat5ReadDimensionsArray()


    mat5ReadName <- function(this) {
      if (verbose) {
        enter(verbose, level=-70, "Reading Array Name");
        on.exit(exit(verbose));
      }

      tag <- mat5ReadTag(this);

      sizeOf <- tag$sizeOf %/% 8;
      nchars <- tag$nbrOfBytes %/% sizeOf;
      verbose && cat(verbose, level=-100, "Reading ", nchars, " characters.");
      name <- readBinMat(con, what=tag$what, size=sizeOf, n=nchars);
      ## Be generous in what types are accepted for names; MATLAB(tm) has
      ## a habit of sprouting new file features.
      name <- matToString(name, tag$type);
      name <- asSafeRName(name);
      left <<- left - nchars;

      verbose && cat(verbose, level=-101, "Reading ", tag$padding, " padding bytes.");
      padding <- readBinMat(con, what=integer(), size=1L, n=tag$padding);
      left <<- left - tag$padding;

      verbose && cat(verbose, level=-50, "Name: '", name, "'");

      list(tag=tag, name=name);
    } # mat5ReadName()


    mat5ReadFieldNameLength <- function(this) {
      if (verbose) {
        enter(verbose, level=-70, "Reading Field Name Length");
        on.exit(exit(verbose));
      }

      tag <- mat5ReadTag(this);
      if (tag$type != "miINT32") {
        throw("Tag type not supported: ", tag$type);
      }

      sizeOf <- tag$sizeOf %/% 8;
      len <- tag$nbrOfBytes %/% sizeOf;
      maxLength <- readBinMat(con, what=integer(), size=sizeOf, n=len);

      left <<- left - len;

      padding <- readBinMat(con, what=integer(), size=1L, n=tag$padding);
      left <<- left - tag$padding;

     verbose && cat(verbose, level=-100, "Field name length+1: ", maxLength);

      list(tag=tag, maxLength=maxLength);
    } # mat5ReadFieldNameLength()


    mat5ReadFieldNames <- function(this, maxLength) {
      if (verbose) {
        enter(verbose, level=-70, "Reading Field Names");
        on.exit(exit(verbose));
      }

      tag <- mat5ReadTag(this);
      ## Be generous in what types are accepted for names; MATLAB(tm) has
      ## a habit of sprouting new file features.

      sizeOf <- tag$sizeOf %/% 8;
      nbrOfNames <- tag$nbrOfBytes %/% maxLength;
      names <- character(length=nbrOfNames);
      for (kk in seq_len(nbrOfNames)) {
        name <- readBinMat(con, what=tag$what, size=sizeOf, n=maxLength);
        left <<- left - maxLength;
        name <- matToString(name, tag$type);
        name <- asSafeRName(name);
        names[kk] <- name;
      }

      verbose && cat(verbose, level=-101, "Reading ", tag$padding, " padding bytes.");
      padding <- readBinMat(con, what=integer(), size=1L, n=tag$padding);
      left <<- left - tag$padding;

      verbose && cat(verbose, level=-50, "Field names: ", paste(paste("'", names, "'", sep=""), collapse=", "));

      list(tag=tag, names=names);
    } # mat5ReadFieldNames()


    # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
    # From [1, page 26]:
    # "Fields Subelement - This subelement contains the value stored in a
    #  field. These values are MATLAB arrays, represented using the
    #  miMATRIX format specific to the array type: numeric array, sparse
    #  array, cell, object or other structure. See the appropriate section
    #  of this document for details about the MAT-file format of each of
    #  these array type. MATLAB reads and writes these fields in
    #  column-major order."
    mat5ReadFields <- function(this, names) {
      if (verbose) {
        enter(verbose, level=-70, "Reading Fields");
        on.exit(exit(verbose));
      }

      # Precalculations
      dropSingletonLists <- is.element("singletonLists", drop);

      fields <- vector("list", length=length(names));
      for (kk in seq_along(names)) {
        verbose && enter(verbose, level=-3, "Reading field: ", sQuote(names[kk]));
        field <- readMat5DataElement(this);
        # If read element is a list with a single element, then return that
        # latter element by itself to decrease the amount of nestedness.
        if (dropSingletonLists) {
          if (is.list(field) && length(field) <= 1L &&
              (is.null(names(field)) || identical(names(field), ""))) {
            field <- field[[1L]];
          }
        }
        if (!is.null(field)) {
          fields[[kk]] <- field;
        }
        verbose && exit(verbose);
      }
      names(fields) <- names;

      fields;
    } # mat5ReadFields()


    mat5ReadValues <- function(this, logical=FALSE) {
      if (verbose) {
        enter(verbose, level=-70, "Reading Values");
        on.exit(exit(verbose));
      }

      tag <- mat5ReadTag(this);

      # "If the 'logical' bit is set, it indicates the array is used for
      # logical indexing." [4].  This is a rather vague explanation, but
      # by comparing the byte content of sparse matrices containing
      # doubles to those containing logical, it appears as if the latter
      # are stored as single 0/1 bytes, regardless of what the "tag"
      # is indicating.
      if (logical) {
        # Override tag parameters.
        sizeOf <- 1L;
        what <- logical(0L);
      } else {
        sizeOf <- tag$sizeOf %/% 8;
        what <- tag$what;
      }

      len <- tag$nbrOfBytes %/% sizeOf;

      verbose && cat(verbose, level=-100, "Reading ", len, " values each of ", sizeOf, " bytes. In total ", tag$nbrOfBytes, " bytes.");

      ## stopifnot(is.finite(tag$nbrOfBytes), is.finite(tag$sizeOf))

      value <- readBinMat(con, what=what, size=sizeOf, n=len, signed=tag$signed);
      verbose && str(verbose, level=-102, value);
      verbose && str(verbose, level=-102, intToChar(value));

      left <<- left - sizeOf*len;

      verbose && cat(verbose, level=-101, "Reading ", tag$padding, " padding bytes.");

      padding <- readBinMat(con, what=integer(), size=1L, n=tag$padding);

      left <<- left - tag$padding;

      list(tag=tag, value=value);
    } # mat5ReadValues()


    mat5ReadMiMATRIX <- function(this, tag) {
      if (verbose) {
        enter(verbose, level=-70, "Reading miMATRIX");
        on.exit(exit(verbose));
        cat(verbose, level=-60, "Argument 'tag':");
        str(verbose, level=-60, tag);
      }

      # Sanity check
      if (tag$nbrOfBytes == 0L) {
        throw("INTERNAL ERROR: Zero bytes to read in miMATRIX.")
      }

      tag <- mat5ReadTag(this);

      if (is.null(tag)) {
        verbose && cat(verbose, "Nothing more to read. Returning NULL.");
        return(NULL);
      }

      if (tag$type == "miMATRIX") {
        verbose && enter(verbose, level=-70, "Reading a nested miMATRIX");
        node <- mat5ReadMiMATRIX(this, tag);
        verbose && exit(verbose);
        return(node);
      }


      if (tag$type != "miUINT32") {
        throw("Tag type not supported: ", tag$type);
      }

      arrayFlags <- mat5ReadArrayFlags(this);
      if (verbose) {
        cat(verbose, level=-100, "Array flags:");
        str(verbose, level=-70, arrayFlags);
      }

      # Update the array flag tag.  "Why?" /HB 2013-05-23
      arrayFlags$tag <- tag;
      arrayFlags$signed <- tag$signed;

      dimensionsArray <- mat5ReadDimensionsArray(this);
      arrayName <- mat5ReadName(this);
      verbose && cat(verbose, "Array name: ", sQuote(arrayName$name));

      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      # (a) mxCELL_CLASS
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      if (arrayFlags$class == "mxCELL_CLASS") {
        nbrOfCells <- prod(dimensionsArray$dim);
        verbose && enter(verbose, level=-4, "Reading mxCELL_CLASS with ", nbrOfCells, " cells.");
        matrix <- vector("list", length=nbrOfCells);
        for (kk in seq_len(nbrOfCells)) {
          tag <- mat5ReadTag(this);
          if (tag$nbrOfBytes > 0L) {
            matrix[[kk]] <- mat5ReadMiMATRIX(this, tag);
          }
        }

        matrix <- list(matrix);
        names(matrix) <- arrayName$name;
        verbose && exit(verbose);
      } # (a) mxCELL_CLASS
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      # (b) mxSTRUCT_CLASS
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      else if (arrayFlags$class == "mxSTRUCT_CLASS") {
        nbrOfCells <- prod(dimensionsArray$dim);
        verbose && enter(verbose, level=-4, "Reading mxSTRUCT_CLASS with ", nbrOfCells, " cells in structure.");
        maxLength <- mat5ReadFieldNameLength(this);
        names <- mat5ReadFieldNames(this, maxLength=maxLength$maxLength);
        verbose && cat(verbose, level=-100, "Field names: ", paste(names$names, collapse=", "));
        nbrOfFields <- length(names$names);
        matrix <- list();
        for (kk in seq_len(nbrOfCells)) {
          fields <- mat5ReadFields(this, names=names$names);
          matrix <- c(matrix, fields);
        }
        names(matrix) <- NULL;

        # Set the dimension of the structure
        ## FIXME: Is this really correct?, cf. Issue #30. /HB 2015-12-29
        dim <- c(nbrOfFields, dimensionsArray$dim);
        if (prod(dim) > 0) {
          matrix <- structure(matrix, dim=dim);
          dimnames <- rep(list(NULL), times=length(dim(matrix)));
          dimnames[[1L]] <- names$names;
          dimnames(matrix) <- dimnames;
        }

        # Finally, put the structure in a named list.
        matrix <- list(matrix);
        names(matrix) <- arrayName$name;

        if (verbose) {
          cat(verbose, level=-60, "Read a 'struct':");
          str(verbose, level=-60, matrix);
        }
        verbose && exit(verbose);
      } # (b) mxSTRUCT_CLASS
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      # (c) mxOBJECT_CLASS
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      else if (arrayFlags$class == "mxOBJECT_CLASS") {
        className <- mat5ReadName(this)$name;
        maxLength <- mat5ReadFieldNameLength(this);
        verbose && enter(verbose, level=-4, "Reading mxOBJECT_CLASS of class '", className, "' with ", maxLength, " fields.");
        names <- mat5ReadFieldNames(this, maxLength=maxLength$maxLength);
        fields <- mat5ReadFields(this, names=names$names);
        class(fields) <- className;
        matrix <- list(fields);
        names(matrix) <- arrayName$name;
      } else if (arrayFlags$complex) {
        verbose && enter(verbose, level=-4, "Reading complex matrix")
        pr <- mat5ReadValues(this, logical=arrayFlags$logical);
        if (left > 0L) {
          pi <- mat5ReadValues(this, logical=arrayFlags$logical);
        } else {
          pi <- NULL;
        }
        matrix <- complex(real=pr$value, imaginary=pi$value);

        # Set dimension of complex matrix
        dim(matrix) <- dimensionsArray$dim;
        verbose && str(verbose, level=-10, matrix);

        # Put into a named list
        matrix <- list(matrix);
        names(matrix) <- arrayName$name;
        verbose && exit(verbose, suffix=paste("...done: '", names(matrix), "' [",
                 mode(matrix), ": ", paste(dim(matrix), collapse="x"),
                                               " elements]", sep=""));
        verbose && exit(verbose);
      } # (c) mxOBJECT_CLASS
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      # (d) mxSPARSE_CLASS
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      else if (arrayFlags$class == "mxSPARSE_CLASS") {
        # Dimensions of the sparse matrix
        nrow <- dimensionsArray$dim[1L];
        ncol <- dimensionsArray$dim[2L];

        verbose && enter(verbose, level=-4, "Reading mxSPARSE_CLASS ", nrow, "x", ncol, " matrix.");

        # From [2, page5-6]
        # "Sparse Matrices
        #  Sparse matrices have a different storage convention in MATLAB. The
        #  parameters pr and pi are still arrays of double-precision numbers,
        #  but there are three additional parameters, nzmax, ir, and jc:
        #  * nzmax - is an integer that contains the length of ir, pr, and,
        #    if it exists, pi. It is the maximum possible number of nonzero
        #    elements in the sparse matrix.
        #  * ir - points to an integer array of length nzmax containing the
        #    row indices of the corresponding elements in pr and pi.
        #  * jc - points to an integer array of length N+1 that contains
        #    column index information. For j, in the range 0 <= j <= N-1,
        #    jc[j] is the index in ir and pr (and pi if it exists) of the
        #    first nonzero entry in the jth column and jc[j+1] - 1 index of
        #    the last nonzero entry. As a result, jc[N] is also equal to nnz,
        #    the number of nonzero entries in the matrix. If nnz is less
        #    than nzmax, then more nonzero entries can be inserted in the
        #    array without allocating additional storage."

        # From mxGetIr in [2]:
        # "The nzmax field holds an integer value that signifies the number
        #  of elements in the ir, pr, and, if it exists, the pi arrays. The
        #  value of nzmax is always greater than or equal to the number of
        #  nonzero elements in a sparse mxArray. In addition, the value of
        #  nzmax is always less than or equal to the number of rows times
        #  the number of columns."
        nzmax <- arrayFlags$nzmax;
        ir <- c();
        jc <- c();
        pr <- c();
        if (nzmax > 0L) {
          # Read the row indices for non-zero values (index start at zero!)
          #
          # From mxGetIr in [2]:
          # "Each value in an ir array indicates a row (offset by 1) at which
          #  a nonzero element can be found. (The jc array is an index that
          #  indirectly specifies a column where nonzero elements can be found.)"
          #
          # and from mxSetIr in [2]:
          # "The ir array must be in column-major order. That means that the
          #  ir array must define the row positions in column 1 (if any) first,
          #  then the row positions in column 2 (if any) second, and so on through
          #  column N. Within each column, row position 1 must appear prior to
          #  row position 2, and so on."
          ir <- mat5ReadValues(this)$value;

          # Note that the indices for MAT v5 sparse arrays start at 0 (not 1).
          if (any(ir < 0L) || (nrow > 0 && any(ir > nrow-1L))) {
            stop("MAT v5 file format error: Some elements in row vector 'ir' (sparse arrays) are out of range [0,", nrow-1L, "].");
          }

          #  "* jc - points to an integer array of length N+1 that contains..."
          jc <- mat5ReadValues(this)$value;
          if (length(jc) != ncol+1L) {
            stop("MAT v5 file format error: Length of column vector 'jc' (sparse arrays) is not ", ncol, "+1 as expected: ", length(jc));
          }

          # Read vector
          pr <- mat5ReadValues(this, logical=arrayFlags$logical)$value;

          if (verbose) {
            str(verbose, level=-102, header);
            str(verbose, level=-102, ir);
            str(verbose, level=-102, jc);
            str(verbose, level=-102, pr);
          }

          # "This subelement contains the imaginary data in the array, if one
          #  or more of the numeric values in the MATLAB array is a complex
          #  number (if the complex bit is set in Array Flags)." [1, p20]
          if (arrayFlags$complex) {
            # Read imaginary part
            pi <- mat5ReadValues(this, logical=arrayFlags$logical)$value;
            verbose && str(verbose, level=-102, pi);
          }

          ## Deal with odd MATLAB(tm) discrepancies.
          nzmax <- min(nzmax, jc[ncol+1L]);
          if (nzmax < length(ir)) { ir <- ir[1:nzmax]; }
          if (nzmax < length(pr)) { pr <- pr[1:nzmax]; }
          if (arrayFlags$complex) {
            if (nzmax < length(pi)) { pi <- pi[1:nzmax]; }
            pr <- complex(real=pr, imaginary=pi);
            pi <- NULL; # Not needed anymore
          }
        } # if (nzmax > 0)

        if (sparseMatrixClass == "Matrix"
            && .require("Matrix", quietly=TRUE)) {
          # Logical or numeric sparse Matrix?
          if (is.logical(pr)) {
            className <- "lgCMatrix";
          } else {
            pr <- as.double(pr);
            className <- "dgCMatrix";
          }

          # The "sparse" values
          # x = pr

          # (from,to) indices for each column (=> length(p) == ncol+1)
          p <- as.integer(jc)

          # Row indices
          i <- as.integer(ir)
          # Special case
          if (length(pr) == 0L && i == 0L) i <- integer(0L)

          # Matrix dimension
          Dim <- as.integer(c(nrow,ncol))

          if (verbose && isVisible(verbose, level=-102)) {
            verbose && cat(verbose, "x=pr:");
            verbose && str(verbose, pr);
            verbose && cat(verbose, "p:");
            verbose && str(verbose, p);
            verbose && cat(verbose, "i:");
            verbose && str(verbose, i);
            verbose && printf(verbose, "Dim=c(%d,%d)\n", Dim[1L], Dim[2L]);
          }

          matrix <- new(className, x=pr, p=p, i=i, Dim=Dim);
          matrix <- list(matrix);
          names(matrix) <- arrayName$name;
        } else if (sparseMatrixClass == "SparseM"
                 && .require("SparseM", quietly=TRUE)) {
          # Special case
          if (is.logical(pr)) {
            # Sparse matrices of SparseM cannot hold logical values.
            pr <- as.double(pr);
          } else {
            pr <- as.double(pr);
          }

          if (nrow == 0L || ncol == 0L) {
            matrix <- matrix(pr, nrow=nrow, ncol=ncol)
          } else if (length(pr) == 0L) {
            # Special case
            str(list(nrow=nrow, ncol=ncol))
            matrix <- SparseM::as.matrix.csc(0, nrow=nrow, ncol=ncol)
          } else {
            matrix <- new("matrix.csc",
                          ra=pr, ja=as.integer(ir)+1L, ia=as.integer(jc+1L),
                          dimension=as.integer(c(nrow, ncol)));
          }
          matrix <- list(matrix);
          names(matrix) <- arrayName$name;
        } else {
          # Create an expanded plain R matrix...
          if (is.logical(pr)) {
            zeroValue <- FALSE;
          } else {
            zeroValue <- 0;
          }
          matrix <- matrix(zeroValue, nrow=nrow, ncol=ncol);
          attr(matrix, "name") <- arrayName$name;

          # Now, for each column insert the non-zero elements
          #
          #  "* jc - points to an integer array of length N+1 that contains
          #    column index information. For j, in the range 0 <= j <= N-1,
          #    jc[j] is the index in ir and pr (and pi if it exists) of the
          #    first nonzero entry in the jth column and jc[j+1] - 1 index of
          #    the last nonzero entry. As a result, jc[N] is also equal to nnz,
          #    the number of nonzero entries in the matrix. If nnz is less
          #    than nzmax, then more nonzero entries can be inserted in the
          #    array without allocating additional storage."
          #
          #    Note: This is *not* how MAT v4 works.

          ## jc[N] = number of non-zero entries
##          stopifnot(all(jc <= length(pr)))
##          stopifnot(jc[length(jc)] == length(pr))

          ## Infer column indices 'ic' from 'jc'
          djc <- diff(jc)
          cols <- which(djc > 0)
          each <- djc[cols]
          ic <- rep(cols, times=each)
          djc <- cols <- each <- jc <- NULL
          ## (ir,ic) -> ii matrix indices (column first)
          ii <- (ic-1L)*nrow + ir + 1L
          ir <- ic <- NULL
          matrix[ii] <- pr;
          # Not needed anymore
          pr <- NULL;

          matrix <- list(matrix);
          names(matrix) <- arrayName$name;
        }
        verbose && exit(verbose);
      } # (d) mxSPARSE_CLASS
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      # (e) mxFUNCTION_CLASS (undocumented)
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      else if (arrayFlags$class %in% c("mxFUNCTION_CLASS", "mxOPAQUE_CLASS")) {
       ## NOTE: These are unknown territories and only reverse engineered
       ## since these array types/classes are undocumented [5];
       ## * mxFUNCTION_CLASS (=16):
       ##   https://github.com/HenrikBengtsson/R.matlab/issues/28
       ## * mxOPAQUE_CLASS (=17):
       ##   https://github.com/HenrikBengtsson/R.matlab/issues/32
       ##   Thread 'saveing/loading symbol table of annymous functions',
       ##   Octave Maintainers, April-May 2007:
       ##   - https://lists.gnu.org/archive/html/octave-maintainers/2007-04/msg00031.html
       ##   - https://lists.gnu.org/archive/html/octave-maintainers/2007-05/msg00032.html

       ## Next block
       tag <- mat5ReadTag(this)

       ## Read object as raw data
       raw <- readBinMat(con, what=raw(), size=1L, n=tag$nbrOfBytes)
       verbose && str(verbose, raw)

       ## Skip padding
       padding <- readBinMat(con, what=raw(), size=1L, n=tag$padding)

       matrix <- list(raw)
       names(matrix) <- arrayName$name
      }
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      # (f) Everything else but:
      #     (a) mxCELL_CLASS, (b) mxSTRUCT_CLASS, (c) mxOBJECT_CLASS,
      #   , (d) mxSPARSE_CLASS and (e) mxFUNCTION_CLASS.
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      else {
        data <- mat5ReadValues(this, logical=arrayFlags$logical);
        matrix <- data$value;

        verbose && cat(verbose, level=-5, "Converting to ", arrayFlags$class, " matrix.");
        if (arrayFlags$class == "mxDOUBLE_CLASS") {
          matrix <- as.double(matrix);
          dim(matrix) <- dimensionsArray$dim;
        } else if (arrayFlags$class == "mxSINGLE_CLASS") {
          matrix <- as.single(matrix);
          dim(matrix) <- dimensionsArray$dim;
        } else if (is.element(arrayFlags$class, c("mxINT8_CLASS", "mxUINT8_CLASS", "mxINT16_CLASS", "mxUINT16_CLASS", "mxINT32_CLASS", "mxUINT32_CLASS"))) {
          matrix <- as.integer(matrix);
          dim(matrix) <- dimensionsArray$dim;
        } else if (is.element(arrayFlags$class, c("mxINT64_CLASS", "mxUINT64_CLASS"))) {
          # Coerce 64-bit integers to doubles.
          matrix <- as.integer(matrix);
          dim(matrix) <- dimensionsArray$dim;
        } else if (arrayFlags$class == "mxCHAR_CLASS") {
          verbose && cat(verbose, level=-5, "Encoding type: ", tag$type)
          matrix <- matToCharArray(matrix, tag$type);
          dim <- dimensionsArray$dim;
          # AD HOC/special/illegal case?  /HB 2010-09-18
          if (length(matrix) == 0L && prod(dim) > 0) {
            matrix <- "";
          }
          dim(matrix) <- dim;
          matrix <- apply(matrix, MARGIN=1L, FUN=paste, collapse="");
          matrix <- as.matrix(matrix);
        } else {
          stop("Unknown or unsupported class id in array flags: ", arrayFlags$class);
        }

        matrix <- list(matrix);
        names(matrix) <- arrayName$name;
      } # (e) Everything else

      matrix;
    } # mat5ReadMiMATRIX()


    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Function to read a MAT v5 Data Element
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    readMat5DataElement <- function(this) {
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      # General structure of a MAT v5 Data Element:
      #
      #      1    2    3    4    5    6    7    8
      #   +----+----+----+----+----+----+----+----+
      #   |    Data type      |  Number of Bytes  |  Tag
      #   +---------------------------------------+
      #   |                                       |
      #   |             Variable size             |  Data
      #   |                                       |
      #   +---------------------------------------+
      #
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      tag <- mat5ReadTag(this);
      if (is.null(tag))
        return(NULL);

      if (tag$nbrOfBytes == 0L)
        return(list(NULL));

      if (tag$type == "miMATRIX") {
        verbose && enter(verbose, level=-3, "Reading (outer) miMATRIX");
        # Used to test if a matrix read contains an imaginary part too.
        left <<- tag$nbrOfBytes;

        data <- mat5ReadMiMATRIX(this, tag);
        if (verbose) {
          str(verbose, level=-4, data);
          exit(verbose);
        }
      } else {
        verbose && printf(verbose, level=-3, "Reading (outer) %.0f integers\n", tag$nbrOfBytes);
        ## FIXME: Is this really correct?, cf. Issue #30. /HB 2015-12-29
        ## Should it be: data <- mat5ReadMiMATRIX(this, tag);
        data <- readBinMat(con, what=integer(), size=1L, n=tag$nbrOfBytes, signed=tag$signed);
        verbose && str(verbose, level=-50, data)
      }

      data;
    } # readMat5DataElement()


    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # "Main program"
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Since readMat5() is wrapped inside the readMat() function, we can
    # assume that 'con' really is a connection.

    detectedEndian <<- "little";

    header <- readMat5Header(this, firstFourBytes=firstFourBytes);

    if (verbose) {
      cat(verbose, level=-100, "Read MAT v5 header:");
      print(verbose, level=-100, header);
      cat(verbose, level=-100, "Endian: ", detectedEndian);
    }

    result <- list();
    repeat {
      verbose && enter(verbose, level=-2, "Reading data element");
      data <- readMat5DataElement(this);
      if (is.null(data)) {
        verbose && exit(verbose);
        break;
      }
      result <- append(result, data);
      verbose && exit(verbose, suffix=paste("...done: '", names(data), "' [",
                   mode(data[[1L]]), ": ", paste(dim(data[[1L]]), collapse="x"),
                                                                "]", sep=""));
    }

    attr(result, "header") <- header;
    result;
  } # readMat5()
  #===========================================================================
  # MAT v5 specific                                                        END
  #===========================================================================

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Validate arguments
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Argument 'sparseMatrixClass':
  sparseMatrixClass <- match.arg(sparseMatrixClass);

  # Argument 'drop':
  if (is.logical(drop)) {
    stopifnot(length(drop) == 1L);
    if (drop) {
      # Use defaults
      drop <- eval(formals(sys.function(sys.parent()))$drop);
      drop <- match.arg(drop);
    } else {
      drop <- NULL;
    }
  } else if (is.character(drop)) {
    drop <- match.arg(drop);
  } else {
    stop("Argument 'drop' should either be a logical or a character vector: ", class(drop)[1L]);
  }


  # Argument 'verbose':
  if (inherits(verbose, "Verbose")) {
  } else if (is.numeric(verbose)) {
    verbose <- Verbose(threshold=verbose);
  } else {
    verbose <- as.logical(verbose);
    if (verbose) {
      verbose <- Verbose(threshold=-1);
    }
  }

  if (inherits(con, "connection")) {
    if (!isOpen(con)) {
      verbose && cat(verbose, level=-1, "Opens binary connection.");
      open(con, open="rb");
      on.exit({
        close(con);
        verbose && cat(verbose, level=-1, "Binary connection closed.");
      });
    }
  } else if (inherits(con, "raw")) {
    verbose && cat(verbose, level=-1, "Opens raw connection: ", paste(head(raw), collapse=", "));
    con <- rawConnection(con, open="rb");
    on.exit({
      close(con);
      verbose && cat(verbose, level=-1, "Binary file closed.");
    });
  } else {
    # For all other types of values of 'con' make it into a character string.
    # This will for instance also make it possible to use object of class
    # File in the R.io package to be used.
    con <- as.character(con);

    # Now, assume that 'con' is a filename specifying a file to be opened.
    verbose && cat(verbose, level=-1, "Opens binary file: ", con);
    con <- file(con, open="rb");
    on.exit({
      close(con);
      verbose && cat(verbose, level=-1, "Binary file closed.");
    });
  }

  # Assert that it is a binary connection that we are reading from
  if (summary(con)$text != "binary")
    stop("Can only read a MAT file structure from a *binary* connection.");


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Debug information
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (verbose && isVisible(verbose, -100)) {
    enter(verbose, "R.matlab options");
    cat(verbose, "R.matlab::readMat/rawBufferSize: ", rawBufferSize);
    cat(verbose, "R.matlab::readMat/rawBufferMethod: ", rawBufferMethod);
    cat(verbose, "R.matlab::readMat/onDecompressError: ", getOption("R.matlab::readMat/onDecompressError", "error"));

    exit(verbose);
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # "MATLAB uses the first four bytes to determine if a MAT-file uses a
  #  Version 5 format or a Version 4 format. If any of these bytes
  #  contain a zero, MATLAB will assume the file is a Version 4 MAT-file."
  #
  # Details:
  # For MAT v5 the first 124 bytes is free text followed by 2 bytes
  # specifying the version and 2 bytes specifying the endian, but for
  # MAT v4 the first four bytes represents the 'type'.
  #
  # Thus, we read the first four bytes and test if it can be a MAT v4 file.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  nbrOfBytesRead <- 0L;
  firstFourBytes <- readBinMat(con, what=integer(), size=1L, n=4L);
  if (is.null(firstFourBytes))
    stop("MAT file format error: Nothing to read. Empty input stream.");

  if (isMat4(firstFourBytes)) {
    verbose && cat(verbose, level=0, "Trying to read MAT v4 file stream.");
    readMat4(con, firstFourBytes=firstFourBytes, maxLength=maxLength);
  } else {
    verbose && cat(verbose, level=0, "Trying to read MAT v5 file stream.");
    readMat5(con, firstFourBytes=firstFourBytes, maxLength=maxLength);
  }
}) # readMat()



###########################################################################
# HISTORY:
# 2016-03-04
# o CLEANUP: Dropping uncompression by Rcompression package.  This also
#   makes option 'R.matlab::decompressWith' obsolete.
# 2015-01-31
# o BUG FIX: readMat(..., sparseMatrixClass='matrix') did not return
#   the correct results in all cases.  Added more package tests.
# o BUG FIX: readMat(..., sparseMatrixClass='SparseM') did not handle
#   all-zero sparse matrices.  Added package test for this.
# 2015-01-21
# o BUG FIX: readMat(..., sparseMatrixClass='Matrix') would give "Error
#   in validObject(.Object) : invalid class "dgCMatrix" object: lengths
#   of slots 'i' and 'x' must match" if length(x) == 0 and i == 0.
# 2014-10-05
# o BUG FIX: readMat() parsed an mxCELL_CLASS structure in correctly if
#   one of its names were empty.
# 2014-05-18
# o BUG FIX: Internal uncompressZlib() of readMat() opened several
#   raw connections without closing them.
# 2014-05-06
# o Added internal typeOfCompression() that infers type of compression
#   from the first two bytes.
# o Added internal uncompressZlib(), which seems to be able to uncompress
#   zlib streams via gzcon() but currently gives non-interruptive
#   "crc error 9153d47f f3535e68" messages from gzcon().
# 2014-05-01
# o Now the error messages on memDemprocess are slightly more informative:
#   'internal error Z_DATA_ERROR in memDecompress(gzip)' instead of only
#   'internal error -3 in memDecompress(2)'.
# 2014-04-28
# o Renamed convertGeneric() to convertASCII(), which now convert
#   all 8-bit ASCII characters.
# o BUG FIX: Local function convertGeneric() of readMat() only preserved
#   ASCII character in (0,32-127), which for instance meant that newlines
#   were dropped.  Reported by Steven Pav (San Francisco, CA).
# 2014-04-26
# o SPEEDUP: MAT5 mxCHAR_CLASS structures are now read slighly faster.
# 2014-02-03
# o BACKWARD COMPATIBILITY: For R (< 3.0.0), readMat() now defines a
#   local parse() function that supports argument 'keep.source'.
# 2014-01-28
# o BUG FIX: readMat(..., drop="singletonLists") would throw an error
#   if the singleton list dropped contained NULL and that NULL was
#   assigned to an element of an outer list, resulting in that element
#   being dropped.
# o Whenever there is an uncompress error in readMat(), it now tries to
#   infer what type of compression the buffer has by inspecting the first
#   two bytes and include the type in the error message.
# o Added option 'R.matlab::readMat/v4/textMatrixCollapse' controlling
#   whether MAT v4 text matrixes are collapsed into strings by row
#  ("byrow"; default), by column ("bycolumn") or not at all ("none").
# 2013-11-28
# o Now the 'INTERNAL ERROR' message readMat() throws on failed
#   decompression also includes the first and last bytes of the data
#   block that it tried to decompress.  This will further help
#   troubleshooting.
# 2013-09-11
# o CONSISTENCY:  Added argument 'drop' to readMat() to control how
#   singleton dimensions of for instance nested lists are dropped or not.
#   The defaults are now such that R.matlab v2.0.4 is consistent with
#   R.matlab v1.7.1 (R.matlab v2.0.0-2.0.3 were not).  Thanks to
#   Claudia Beleites at IPHT Jena, Germany for reporting on this.
# 2013-09-10
# o WORKAROUND/BUG FIX: readMat() would an error when parsing an empty
#   'mxCHAR_CLASS' matrix with a 0x0 dimension.  It is not clear whether
#   this is a valid MAT v5 structure or not, but I've added a workaround.
#   Thanks Claudia Beleites at IPHT Jena, Germany for reporting on this.
# 2013-07-17
# o DOCUMENTATION: Added section of '-v7.3' MAT files to help("readMat").
# 2013-07-11
# o Now the 'INTERNAL ERROR' message that people forward to the package
#   maintainer also includes the version of the R.matlab package.
# 2013-05-25
# o SPEEDUP: Dropped the explicit gc() call after decompressing.
# o SPEEDUP: Replaced all rm() calls with NULL assignments.
# 2013-05-22
# o SPEEDUP: Major speed up by dropping rm() calls in some internal
#   functions that are called many times.  For instance, a single
#   rm(tmp) call in the local function that reads MAT read tags
#   decreased the reading time of a single MAT file by 25%!
# o CLEANUP: Identified constants and named them in all upper case.
# o Now readMat() no longer generates warnings reporting on "In readBin(
#   con = rawBufferT, what = what, size = size, n = n, signed = signed,  :
#   'signed = FALSE' is only valid for integers of sizes 1 and 2."
# 2013-05-22
# o CONSISTENCY: Renamed option 'R.matlab::decompressWith' to
#   'R.matlab::readMat/decompressWith'.
# o SPEEDUP: Previously each call to internal readMat5DataElement()
#   would create a set of local utility functions.  Now these are
#   create only once per call to internal readMat5().
# o SPEEDUP: mat5IsSigned() now does fewer assignments/concatenations.
# o SPEEDUP: Minor speedups of readMat() when 'verbose' argument is enabled.
# o DOCUMENTATION: Restructured help("readMat").  Added a section on
#   'Speed performance'.
# 2012-06-07
# o BUG FIX: readMat() could not read sparse matrices containing logical
#   values, only numerics.  This was because the 'logical' bit in the
#   Array Flags was not utilized by readMat(), which in turn was because
#   the file format documentation is rather vague on how to use that bit.
#   This means that readMat() now represents sparse logical matrices
#   using logical values, except when sparseMatrixClass="SparseM",
#   because SparseM matrices can only hold numeric values.
#   Thanks to Irtisha Sinhg at Cornell University for reporting on this.
# 2012-05-05
# o Now readMat() decompression error messages are more informative.
# o Now it is possible to specify the decompression method for readMat().
# 2012-04-13
# o Added option 'R.matlab::readMat/onDecompressError' allowing to skip
#   data object that fails to uncompress.  This will at least allow
#   to read remaining objects in a MAT file.
# o Added a sanity check for the length of the internal 'zraw' buffer
#   to be uncompressed.
# 2012-04-12
# o BUG FIX: Forgot to add 'character.only=TRUE' in require() for
#   loading 'Rcompression' in the 2012-04-01 update.
# 2012-04-02
# o Made error message when failing to decompress data more informative.
# o Added verbose hpaste() details on the 'zraw' vector to be uncompressed.
# o BUG FIX: readMat(..., verbose=-111) would give an error on object
#   'zraw' not found.
# 2012-04-01
# o CLEANUP: Removed 'Rcompression' from set of "Suggests" packages,
#   because since R v2.10.0 (Oct 2009) we can use memDecompress() of
#   the 'base' package instead.  However, just in case someone is still
#   running older versions of R, readMat() does indeed still look for
#   'Rcompression' as a fallback.
# 2011-09-24
# o GENERALIZATION: Now readMat() utilizes base::memDecompress() to
#   uncompress compressed data structures, unless running R v2.9.x or
#   before, in case Rcompression::uncompress() is used, iff installed.
# 2011-07-25
# o CLEANUP: Now all references to the Rcompression package is within
#   the local uncompress() function of readMat().  This makes the code
#   more modular making it easier to implement alternatives to
#   Rcompression::uncompress().
# 2011-07-24
# o Now readMat() and writeMat() locally defines cat() (by copying the
#   one in R.utils), iff R.utils is loaded.
# 2011-02-01
# o ROBUSTNESS: Now using argument 'imaginary' (not 'imag') in calls
#   to complex().
# 2010-09-18 [HB]
# o BUG FIX: readMat() would throw an exception on 'Error in dim(matrix)
#   <- dimensionsArray$dim : dims [product 1] do not match the length of
#   object [0]' in rare cases related to empty strings.  Not sure if
#   those cases are legal, but added an ad hoc workaround for them.
#   Thanks Claude Flene at University of Turku for reporting this.
# o Added internal sapply0() to deal with the above bug.
# 2010-04-20 [HB]
# o DOCUMENTATION: Minor update to argument 'fixNames' of help(readMat).
#   Thanks Stephen Eglen (University of Cambridge) for the suggestion.
# 2010-02-03 [HB]
# o GENERALIZATION: Now readMat() can read also nested miMATRIX structures.
#   Issue reported by Jonathan Chard at Mango Solutions, UK.
# 2009-09-19 [HB]
# o MEMORY OPTIMIZATION: For very large compressed data objects, there
#   would not be enough memory to allocate the internal buffer resulting
#   in an error.  Before this buffer was initiated to be 10 times the size
#   of the compressed data.  If that fails, now readMat() tries smaller
#   and smaller initial buffers, before giving in up.  Also, it now starts
#   with a buffer 3 (not 10) times the compressed size.
#   Thanks to Michael Sumner for reporting this problem.
# 2008-02-12 [HB]
# o BUG FIX: Sparse matrices for 'SparseM' did not work.
# o Replaced all stop(paste()) with plain stop(). Same for warnings().
# 2008-01-28 [JR]
# o Support for sparse storage when one of the Matrix or SparseM
#   packages is available.
# o Add simple UTF-* string support.  Conversion should be accurate
#   when the R installation supports iconv.
# o Support for miCOMPRESSED when the Rcompression package is
#   available.
# o Fixed buffering to use the rawBuffer in readMat's scope.
# 2007-04-19
# o Added a "hint" to error message 'Tag type not supported:
#   miCOMPRESSED' to clarify that readMat() does not support
#   compressed MAT files.
# 2006-09-01
# o Trying to add support for gzip:ed data sections, but it does not
#   work out of the box.
# o Added more tag types according to [3].  Now the code also tests
#   for unsupported tag types, e.g. miCOMPRESSED.
# 2005-06-29
# o BUG FIX: Forgot to "implement" miSINGLE, i.e. to set 'knownTypes'
#   and 'knowWhats' for this. Thanks to Craig Aumann for the report.
# 2005-06-10
# o BUG FIX: readMat() would not read complex matrices correctly;
#   each element in a complex matrix was made into its own variable
#   with name "". Thanks to Chris Sims at Princeton University for
#   reporting this.
# o Now making use of the Verbose() class. Sorry, but this means
#   if verbose != FALSE, the function requires Verbose in R.utils.
# 2005-06-08
# o BUG FIX: readMat4Data() did not read 'text' matrices correctly.
#   Thanks to Chris Sims, Princeton University, for the patch.
# 2005-05-02
# o Updated such that multidimensional (not only one and two dims)
#   MATLAB struct:s can be read.
# 2005-04-22
# o Updated to read MATLAB struct:s as R structure:s.
# o BUG FIX: Reading empty struct:s (and cells) tried to read one
#   field because seq(0) and not seq(length=0) was used. Updated all
#   occurances of this problem.
# 2005-04-08
# o BUG FIX: In readMat5DataStructure() it might be data readTag()
#   returns a tag referering to a data block of zero length
#   (nbrOfBytes == 0). Now list(NULL) is returned in this case.
# o BUG FIX: Forgot to reading padded bytes after reading field names
#   in readFieldNames().
# o Added a small comment of differences between file format versions
#   and software versions.
# 2005-02-16
# o Added a reference to the new updated MAT-File Format v7 docs.
# o Made readMat() a default method.
# 2005-02-15
# o BUG FIX: readMat() would not read non-signed bytes correctly.
#   Forgot to add signed=tag$signed in internal readValues().
# 2004-10-13
# o UPDATE for R v2.0.0: matrix[r,c] with r or c with NA's are not
#   allowed anymore in R v2.0.0. Checks for this in readMiMATRIX().
# 2004-02-10
# o Added support for sparse matrices for MAT v5. Wow, that was
#   tricky, because the documention was sparse (ha!).
# o Added support for sparse matrices for MAT v4, by generating
#   sparse matrices in MATLAB and saving the in MAT v4 format and
#   looking at the 'help sparse' in MATLAB.
# o BUG FIX: When reading the MOPT header before I was incorrectly
#   assuming it consisted of four bytes [M,O,P,T], but it is as the
#   documentation "hints" an integer that should be separated into
#   four digits (base 10) such that M*10^3 + O*10^2 + P*10 + T is
#   the four-byte integer read. The problem is that you do not know
#   if the integer is signed or not or in little or big endian.
#   The new getMOPT() figures that out.
# o Added verbose output to readMat4() too. Good for debugging.
# o Added moptToString() for debug purposes.
# o BUG FIX: Used "sparce" instead of "sparse" in MOPT[4] tag (MAT v4).
# 2003-12-02
# o BUG FIX: Introduced a bug that made files written with big endian
#   not to work. The reason was that "<-" was used instead of "<<-"
#   in one new method. I do not like "<<-", but that is how it works.
# 2003-11-20
# o Made a wrapper readMat() for Andy Jacobson's readMat4() and my
#   readMat5() function. Both shared a lot of common functions, which
#   made it possible to clean up the code quite a bit. /HB
# o Replace all throw() with stop(paste()) to remove all dependancies
#   to the R.oo package. /HB
# o Added readMat4(). /HB
# 2003-04-04
# o Added a reference to the MAT-File Format document.
# o I forgot to remove some debug code that outputs information about
#   the Description comment everytime a MAT file is read. Removed. /HB
# 2002-11-11
# o BUG FIX: readMAT() would not work because getBits() previously in
#   package R.oo was removed. getBits() is now added as a local
#   function inside readMAT(). /HB
# 2002-09-03
# o readMAT() is now a stand-alone function. /HB
# o Internal code need to be cleanup in the same fashion as in  /HB
#   writeMAT.R. /HB
# o Made readMAT() out of old MATInputStream.R. /HB
# 2002-08-28
# o BUG FIX: The bug fix from yesterday where I thought the flag bits
#   should be readArrayFlags() in oposite order, was actually
#   incorrect. Excluded rev() again. /HB
# 2002-08-27
# o TO DO: This class should be cleaned up in the same way as
#   MATOutputStream is. /HB
# o BUG FIX: in readArrayFlags() the bits were read in the reverse
#   order, which resulted in incorrect values of complex, global, and
#   logical. /HB
# o Updated readHeader() to read the endian information and possible
#   adjust the version tag if it was Bigendian. First, then the
#   verification of the correct version number is done. /HB
# o TEST: Went to the web and downloaded a few sample MAT files.
#   All v5 files loaded with any problems. The v4 files were reported
#   to be non-supported via an exception. /HB
# o Added support for argument maxLength in read() and added
#   readMaxLength() for standardization (32-bit Littleendian integer)
#   and simplification. /HB
# o Improved as.character(). /HB
# o Added some Rdoc comments. /HB
# o Created. /HB
###########################################################################
