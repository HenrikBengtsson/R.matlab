###########################################################################/**
# @RdocDefault readMat
#
# @title "Reads a MAT file structure from a connection or a file"
#
# \description{
#  Reads a MAT file structure from an input stream, either until End of File
#  is detected or until \code{maxLength} bytes has been read.
#  Using \code{maxLength} it is possible to read MAT file structure over
#  socket connections and other non-terminating input streams. In such cases
#  the \code{maxLength} has to be communicated before sending the actual
#  MAT file structure.
#
#  Both the MAT version 4 and MAT version 5 file formats are 
#  supported. The implementation is based on [1].
#
#  From Matlab v7, \emph{compressed} MAT version 5 files are used by
#  default [3].  This function supports reading such files,
#  if running R v2.10.0 or newer.
#  For older versions of R, the \pkg{Rcompression} package is used.
#  To install that package, please see instructions at
#  \url{http://www.omegahat.org/cranRepository.html}.
#  As a last resort, use \code{save -V6} in Matlab to write MAT files
#  that are compatible with Matlab v6, that is, to write 
#  non-compressed MAT version 5 files.
#
#  Note: Do not mix up version numbers for the Matlab software and
#  the Matlab file formats.
#
#  Recent versions of Matlab store some strings using Unicode
#  encodings.  If the R installation supports \code{\link{iconv}},
#  these strings will be read correctly.  Otherwise non-ASCII codes
#  are converted to NA.  Saving to an earlier file format version
#  may avoid this problem as well.
# }
#
# @synopsis
#
# \arguments{
#   \item{con}{Binary @connection from which the MAT file structure should be
#     read. A string is interpreted as filename, which then will be
#     opened (and closed afterwards).}
#   \item{maxLength}{The maximum number of bytes to be read from the input
#     stream, which should be equal to the length of the MAT file structure.
#     If \code{NULL}, data will be read until End Of File has been reached.}
#   \item{fixNames}{If @TRUE, underscores within names of Matlab variables
#     and fields are converted to periods.}
#   \item{verbose}{Either a @logical, a @numeric, or a @see "R.utils::Verbose"
#     object specifying how much verbose/debug information is written to
#     standard output. If a Verbose object, how detailed the information is
#     is specified by the threshold level of the object. If a numeric, the
#     value is used to set the threshold of a new Verbose object. If @TRUE, 
#     the threshold is set to -1 (minimal). If @FALSE, no output is written
#     (and neither is the \link[R.utils:R.utils-package]{R.utils} package required).
#   }
#   \item{sparseMatrixClass}{If \code{"matrix"}, a sparse matrix is expanded to
#     a regular @matrix.  If either \code{"Matrix"} (default) or \code{"SparseM"}, 
#     the sparse matrix representation by the package of the same name will be used. 
#     These packages are only loaded if the a sparse matrix is read.}
#   \item{...}{Not used.}
# }
#
# \value{
#   Returns a named @list structure containing all variables in the
#   MAT file structure.
# }
#
# \details{
#   For the MAT v5 format, \emph{cell} structures are read into
#   \R as a @list structure.
# }
#
# @examples "../incl/readMat.Rex"
#
# \author{
#   Henrik Bengtsson, Mathematical Statistics, Lund University.
#   The internal MAT v4 reader was written by 
#   Andy Jacobson at Program in Atmospheric and Oceanic Sciences, 
#   Princeton University. 
#   Support for reading compressed files via \pkg{Rcompression}, 
#   sparse matrices and UTF-encoded strings was added by 
#   Jason Riedy, UC Berkeley.
# }
#
# \seealso{
#   @see "writeMat".
# }
#
# \references{
#   [1] The MathWorks Inc., \emph{Matlab - MAT-File Format, version 5}, June 1999.\cr
#   [2] The MathWorks Inc., \emph{Matlab - Application Program Interface Guide, version 5}, 1998.\cr
#   [3] The MathWorks Inc., \emph{Matlab - MAT-File Format, version 7}, September 2009, \url{http://www.mathworks.com/access/helpdesk/help/pdf_doc/matlab/matfile_format.pdf}\cr
#   [4] The MathWorks Inc., \emph{Matlab - MAT-File Format, version R2012a}, September 2012, \url{http://www.mathworks.com/help/pdf_doc/matlab/matfile_format.pdf}\cr
# }
#
# @keyword file
# @keyword IO
#*/###########################################################################
setMethodS3("readMat", "default", function(con, maxLength=NULL, fixNames=TRUE, verbose=FALSE, sparseMatrixClass=c("Matrix", "SparseM", "matrix"), ...) {
  # The object 'this' is actually never used, but we might put 'con' or
  # similar in the structure some day, so we keep it for now. /HB 2007-06-10
  this <- list();


  #===========================================================================
  # General functions to read both MAT v4 and MAT v5 files.              BEGIN
  #===========================================================================
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  # willRead(), hasHead() and isDone() operators keep count on the number of
  # bytes actually read and compares it with 'maxLength'.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  nbrOfBytesRead <- 0;

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
  if (compareVersion(as.character(getRversion()), "2.7.0") < 0) {
    ASCII[1] <- eval(parse(text="\"\\000\""));
  }
 

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  # sapply(X, ...) function that treats length(X) == 0 specially
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  sapply0 <- function(X, FUN, ...) {
    if (length(X) == 0) {
      FUN(X, ...);
    } else {
      base::sapply(X, FUN=FUN, ...);
    }
  } # sapply0()

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  # Function to convert a vector of integers into a vector of ASCII chars.
  # 
  # Extracted from the R.oo package.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  intToChar <- function(i) {
    ASCII[i %% 256 + 1];
  } 

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  # Function to assert that it is possible to read a certain number of bytes.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  willRead <- function(nbrOfBytes) {
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
  fillRawBuffer <- function(need) {
    n <- length(rawBuffer);
    missing <- (need - n);
    if (missing < 0) {
      verbose && cat(verbose, level=-500, "Not filling, have enough data.")
      return(NULL);
    }
    raw <- readBin(con=con, what=raw(), n=missing);
    rawBuffer <<- c(rawBuffer, raw);
    NULL;
  }
  eatRawBuffer <- function(eaten) {
    n <- length(rawBuffer);
    if (eaten < n) {
      rawBuffer <<- rawBuffer[(eaten+1):n];
    }
    else {
      rawBuffer <<- NULL;
    }
    NULL;
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  # Function to read 'n' binary values of a data type of type 'what' 
  # and size 'size', cf. readBin(). 
  # This function will also keep track of the actual number of bytes read.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  readBinMat <- function(con, what, size=1, n, signed=TRUE, endian=detectedEndian) {
    # Check maxLength to see if we are done.
    if (isDone())
      return(c());
    if (is.na(signed))
      signed <- TRUE;  
    willRead(size*n);
   
    fillRawBuffer(size*n);

    bfr <- readBin(con=rawBuffer, what=what, size=size, n=n, signed=signed, endian=endian);
#    print(list(size=size, n=n, signed=signed, endian=endian, bfr=bfr));
    eatRawBuffer(size*n);

    hasRead(length(bfr)*size);
    bfr;
  } # readBinMat()
    
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  # Function to read 'nchars' characters from the input connection.
  # This function will also keep track of the actual number of bytes read.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  readCharMat <- function(con, nchars) {
    # Check maxLength to see if we are done.
    if (isDone())
      return(c());
  
    willRead(nchars);
    fillRawBuffer(nchars);
    bfr <- rawBuffer[1:nchars];
    bfr <- as.integer(bfr);
    bfr <- intToChar(bfr);
    bfr <- paste(bfr, collapse="");
#    bfr <- readChar(con=rawBuffer, nchars=nchars);
    eatRawBuffer(nchars);
    hasRead(nchars);
    bfr;
  } # readCharMat()


  ## convert* are internal helper functions.  They handle type dispatch
  ## and defaults for charset conversions.
  convertUTF8 <- function(ary) {
    ary <- intToChar(as.integer(ary));
    if (length(ary) > 0) {
      ary <- paste(ary, collapse="");
    }
    Encoding(ary) <- "UTF-8";
    ary;
  }

  convertGeneric <- function(ary) {
    ## Set entires outside the ASCII range to NA except for NUL.
    ary[ary>127|(ary!=0&ary<32)] <- NA;
    convertUTF8(ary);
  }

  ## By default, just pick out the ASCII range.
  convertUTF16 <- convertUTF32 <- convertGeneric;

  if (capabilities("iconv")) {
    utfs <- grep("UTF", iconvlist(), value=TRUE);
    ## The convertUTF{16,32} routines below work in big-endian, so
    ## look for UTF-16BE or UTF16BE, etc..
    has.utf16 <- utils::head(grep("UTF-?16BE", utfs, value=TRUE), n=1);
    has.utf32 <- utils::head(grep("UTF-?32BE", utfs, value=TRUE), n=1);
    rm(utfs);
    if (length(has.utf16) > 0) {
      convertUTF16 <- function(ary) {
        n <- length(ary);
        ary16 <- paste(intToChar(c(sapply(ary,
                                          function(x) { c(x%/%2^8,
                                                          x%%2^8); }))),
                       collapse="");
        iconv(ary16, has.utf16, "UTF-8");
      }
      convertUTF32 <- function(ary) {
        n <- length(ary);
        ary32 <- paste(intToChar(c(sapply(ary,
                                          function(x) { c((x%/%2^24)%%2^8,
                                                          (x%/%2^16)%%2^8,
                                                          (x%/%2^8)%%2^8,
                                                          x%%2^8); }))),
                       collapse="");
        iconv(ary32, has.utf32, "UTF-8");
      }
    }
  }

  charConverter <- function(type) {
    switch(type,
           miUTF8 = convertUTF8,
           miUTF16 = convertUTF16,
           miUTF32 = convertUTF32,
           convertGeneric);
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
  matToCharArray <- function(ary, type) {
    fn <- charConverter(type);
    sapply0(ary, FUN=fn);
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  # Function to push back a raw vector to the main input stream
  # This is used to push back a decompressed stream of data.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  pushBackRawMat <- function(con, raw) {
    rawBuffer <<- c(raw, rawBuffer);
    NULL;
  } # pushBackRawMat()


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  # Function to make a variable name into a safe R variable name.
  # For instance, underscores ('_') are replaced by periods ('.').
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  asSafeRName <- function(name) {
    if (fixNames) {
      name <- gsub("_", ".", name);
    }
    name;
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  # \description{
  #  Function to uncompress zlib compressed data.
  #  If R v2.10.0 or newer, we'll utilize base::memDecompress(), otherwise
  #  we'll utilize Rcompression::uncompress(), iff package is installed.
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
  uncompressMemDecompress <- function(zraw, asText=TRUE, type="gzip", ...) {
    # To please R CMD check for R versions before R v2.10.0
    memDecompress <- NULL; rm(memDecompress);
    unzraw <- memDecompress(zraw, type=type, asChar=asText, ...);
    unzraw;
  } # uncompressMemDecompress()


  # This is a smart wrapper function around Rcompression::uncompress(), 
  # which in order to avoid lack-of-memory allocation errors will via
  # trial and error find a reasonably sized internal inflation buffer.
  uncompressRcompression <- function(zraw, asText=TRUE, sizeRatio=3, delta=0.9, ...) {
    # TRICK: Hide 'Rcompression' from R CMD check
    pkgName <- "Rcompression";
    if (!require(pkgName, character.only=TRUE, quietly=TRUE)) {
      throw("Cannot read compressed data.  Omegahat.org package 'Rcompression' could not be loaded.  Alternatively, save your data in a non-compressed format by specifying -V6 when calling save() in Matlab or Octave.");
    }

    # Argument 'delta':
    if (delta <= 0 || delta >= 1) {
      throw("Argument 'delta' is out of range (0,1): ", delta);
    }

    # Get Rcompression::uncompress() without R CMD check noticing.
    uncompress <- getFromNamespace("uncompress", ns=pkgName);

    n <- length(zraw);
    unzraw <- NULL;

    verbose && printf(verbose, level=-50, "Compress data size: %.3f Mb\n", n/1024^2);

    lastException <- NULL;
    size <- NULL;
    while (is.null(unzraw) && sizeRatio >= 1) {
      # The initial size of the internal inflation buffer.  If it is too
      # small, Rcompression::uncompress() will try to *double* it, which
      # might be too big for memory allocation.
      size <- sizeRatio * n;

      verbose && printf(verbose, level=-50, "Size ratio: %.3f\n", sizeRatio);

      lastException <- NULL;
      tryCatch({
        unzraw <- uncompress(zraw, size=size, asText=asText);
        # Successful uncompression
        break;
      }, error = function(ex) {
        msg <- ex$message;
        # Is the error is due to corrupt data, ...
        if (regexpr("corrupted compressed", msg) != -1) {
          # ...then there is nothing we can do.
          errorMsg <- paste("Failed to uncompress data: ", msg, sep="");
          throw(errorMsg);
        }

        # Garbage collect
        gc();

        # ...but it could be that there is not enough memory
        lastException <<- ex;
      }) # tryCatch()

      sizeRatio <- delta * sizeRatio;
    } # while (...)

    # Failed?
    if (is.null(unzraw)) {
      msg <- lastException$message;
      throw(sprintf("Failed to uncompress compressed %d bytes (with smallest initial buffer size of %.3f Mb: %s)", n, size/1024^2, msg));
    }
  
    unzraw;
  } # uncompressRcompression()


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  # Decompression method
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  # Default decompress function
  uncompress <- function(...) {
    throw("Cannot decompress compressed MAT file because none of the decompression methods are available: ", hpaste(decompressWith0, maxHead=Inf));
  } # uncompress()
  attr(uncompress, "label") <- "N/A";


  # Override with available methods
  decompressWith <- getOption("R.matlab::decompressWith", c("memDecompress", "Rcompression"));

  # Validate option
  if (is.character(decompressWith)) {
  } else if (is.function(decompressWith)) {
  } else {
    throw("Unknown mode of 'R.matlab::decompressWith': ", mode(decompressWith));
  }

  decompressWith0 <- decompressWith;

  if (length(decompressWith) > 0) {
    if (is.character(decompressWith)) {
      # Is memDecompress() available?
      # memDecompress() was introduced in R v2.10.0
      if (is.element("memDecompress", decompressWith)) {
        if (getRversion() < "2.10.0" || !exists("memDecompress", mode="function")) {
          decompressWith <- setdiff(decompressWith, "memDecompress");
        }
      }
    
      # Is Rcompression package available?
      if (is.element("Rcompression", decompressWith)) {
        if (require("R.utils")) {
          if (!isPackageInstalled("Rcompression")) {
            decompressWith <- setdiff(decompressWith, "Rcompression");
          }
        }
      }

      # Select decompression method
      if (is.character(decompressWith)) {
        if (decompressWith[1] == "memDecompress") {
          uncompress <- uncompressMemDecompress;
          attr(uncompress, "label") <- decompressWith[1];
        } else if (decompressWith[1] == "Rcompression") {
          uncompress <- uncompressRcompression;
          attr(uncompress, "label") <- decompressWith[1];
        } else {
          # Don't throw an exception here, because it may be 
          # that the MAT files is not compressed.
        }
      }
    } else if (is.function(decompressWith)) {
      uncompress <- decompressWith;
      attr(uncompress, "label") <- "<function>";

    }
  } # if (length(decompressWith) > 0)


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  # Debug functions
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  debugIndent <- 0;
  debug <- function(..., sep="") {
    if (debugIndent > 0)
      cat(paste(rep(" ", length.out=debugIndent), collapse=""));
    cat(..., sep=sep);
    cat("\n");
  }

  debugPrint <- function(...) {
    print(...);
  }

  debugStr <- function(...) {
    str(...);
  }

  debugEnter <- function(..., indent=+1) {
    debug(..., "...");
    debugIndent <<- debugIndent + indent;
  }
  
  debugExit <- function(..., indent=-1) {
    debugIndent <<- debugIndent + indent;
    debug(..., "...done\n");
  }
  
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
    any(MOPT == 0);
  }

  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  # Function to convert four signed or unsigned integers in big or little
  # endian order into a (MOPT) vector c(M,O,P,T) of unsigned integers.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  getMOPT <- function(fourBytes) {
    if (length(fourBytes) != 4)
      stop("Argument 'fourBytes' must a vector of 4 bytes: ", length(fourBytes));
    
    # Make sure the four bytes are non-signed integers
    fourBytes <- as.integer(fourBytes);
    neg <- (fourBytes < 0);
    if (any(neg))
      fourBytes[neg] <- fourBytes[neg] + 256;

    base <- 256^(0:3);
    MOPT <- c(NA,NA,NA,NA);
    for (endian in c("little", "big")) {
      mopt <- sum(base*fourBytes);
      for (kk in 4:1) {
        MOPT[kk] <- mopt %% 10;
        mopt <- mopt %/% 10;
      }

      isMOPT <- (MOPT[1] %in% 0:4 && MOPT[2] == 0 && MOPT[3] %in% 0:5 && MOPT[4] %in% 0:2);
      if (isMOPT)
        break;

      base <- rev(base);
    } # for (endian ...)

    if (!isMOPT)
        stop("File format error: Not a valid MAT v4. The first four bytes (MOPT) were: ", paste(MOPT, collapse=", "));
    
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
        firstFourBytes <- readBinMat(con, what=integer(), size=1, n=4);
      }

      # If no bytes are read, we have reached the End Of Stream.
      if (length(firstFourBytes) == 0)
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
      if (MOPT[1] == 0) {
        detectedEndian <<- "little";
      } else if (MOPT[1] == 1) {
        detectedEndian <<- "big";
      } else if (MOPT[1] %in% 2:4) {
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
      header$ocode <- MOPT[2];
  
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
      if (MOPT[3] == 0) {
        # "64-bit double";
        header$what <- double();
        header$size <- 8;
        header$signed <- NA;
      } else if (MOPT[3] == 1) {
        # "32-bit single";
        header$what <- double();
        header$size <- 4;
        header$signed <- NA;
      } else if (MOPT[3] == 2) {
        # "32-bit signed integer";
        header$what <- integer();
        header$size <- 4;
        header$signed <- TRUE;  # Ignored by readBin() because 32-bit ints are always signed!
      } else if (MOPT[3] == 3) {
        # "16-bit signed integer";
        header$what <- integer();
        header$size <- 2;
        header$signed <- TRUE;
      } else if (MOPT[3] == 4) {
        # "16-bit unsigned integer";
        header$what <- integer();
        header$size <- 2;
        header$signed <- FALSE;
      } else if (MOPT[3] == 5) {
        # "8-bit unsigned integer";
        header$what <- integer();
        header$size <- 1;
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
      header$matrixType <- "numeric";
      if (MOPT[4] == 0) {
        header$matrixType <- "numeric";
      } else if (MOPT[4] == 1) {
        header$matrixType <- "text";
      } else if (MOPT[4] == 2) {
        header$matrixType <- "sparse";
      } else {
#        stop("Unknown fourth byte in MOPT header (not in [0,2]): ", paste(MOPT, collapse=", "));
      }

      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # The 'mrows' and 'ncols' fields
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # "The row dimension contains an integer with the number of rows in the matrix."
      header$mrows  <- readBinMat(con, what=integer(), size=4, n=1)

      # "The column dimension contains an integer with the number of columns in the matrix."
      header$ncols  <- readBinMat(con, what=integer(), size=4, n=1)

      verbose && cat(verbose, level=-50, "Matrix dimension: ", header$mrows, "x", header$ncols);

      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # The 'imagf' fields
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # "The imaginary flag is an integer whose value is either 0 or 1. If 1, 
      #  then the matrix has an imaginary part. If 0, there is only real data."
      header$imagf  <- readBinMat(con, what=integer(), size=4, n=1)

      verbose && cat(verbose, level=-60, "Matrix contains imaginary values: ", as.logical(header$imagf));

      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # The 'namelen' fields
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # "The name length contains an integer with 1 plus the length of the matrix name."
      header$namlen <- readBinMat(con, what=integer(), size=4, n=1)

      verbose && cat(verbose, level=-100, "Matrix name length: ", header$namlen-1);

      header;
    }
    
    
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Function to read a MAT v4 Matrix Data Format
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    readMat4Data <- function(con, header) {
      # "Immediately following the fixed length header is the data whose length
      #  is dependent on the variables in the fixed length header:"

      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # The 'name' field
      #
      # "The matrix name consists of 'namlen' ASCII bytes, the last one of which
      #  must be a null character (’\0’)."
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
##        data <- readCharMat(con, nchars=n);
##      data <- strsplit(data, split="");
        data <- readBinMat(con, what=header$what, size=header$size, 
                                                     signed=header$signed, n=n);
        data <- intToChar(data);
        
        # Make into a matrix
        dim(data) <- c(header$mrows, header$ncols);
        data <- apply(data, MARGIN=1, FUN=paste, sep="", collapse="");
      } else if (header$matrixType %in% c("numeric", "sparse")) {
        real <- readBinMat(con, what=header$what, size=header$size, signed=header$signed, n=n);
        if (header$imagf != 0) {
          verbose && cat(verbose, level=-2, "Reading imaginary part of complex data set.")
          imag <- readBinMat(con, what=header$what, size=header$size, signed=header$signed, n=n);
          data <- complex(real=real, imaginary=imag);
        } else {
          data <- real;
          rm(real);
        }
        
        # Make into a matrix or an array
        dim(data) <- c(header$mrows, header$ncols);
        
        if (header$matrixType == "sparse") {
          # From help sparse in Matlab:
          # "S = SPARSE(i,j,s,m,n,nzmax) uses the rows of [i,j,s] to generate an
          #  m-by-n sparse matrix with space allocated for nzmax nonzeros.  The
          #  two integer index vectors, i and j, and the real or complex entries
          #  vector, s, all have the same length, nnz, which is the number of
          #  nonzeros in the resulting sparse matrix S .  Any elements of s
          #  which have duplicate values of i and j are added together."

          # The last entry in 'data' is (only) used to specify the size of the 
          # matrix, i.e. to infer (m,n).

          i <- as.integer(data[,1]);
          j <- as.integer(data[,2]);
          s <- data[,3];
          rm(data);

          verbose && str(verbose, level=-102, header);
          verbose && str(verbose, level=-102, i);
          verbose && str(verbose, level=-102, j);
          verbose && str(verbose, level=-102, s);
          
          # When saving a sparse matrix, Matlab is making sure that one can infer
          # the size of the m-by-n sparse matrix for the index matrix [i,j]. If
          # there are no non-zero elements in the last row or last column, Matlab
          # saves a zero elements in such case.
          n <- max(i);
          m <- max(j);

          # Note that it can be the case that Matlab save the above extra element
          # just in case, meaning it might actually contain an repeated element.
          # If so, remove it. /HB 2008-02-12
          last <- length(i);
          if (last > 1 && i[last] == i[last-1] && j[last] == j[last-1]) {
            i <- i[-last];
            j <- j[-last];
            s <- s[-last];
          }

          if (sparseMatrixClass == "Matrix" && require("Matrix", quietly=TRUE)) {
            i <- i-as.integer(1);
            j <- j-as.integer(1);
            dim <- as.integer(c(n, m));
            data <- new("dgTMatrix", i=i, j=j, x=s, Dim=dim);
            data <- as(data, "dgCMatrix");
          } else if (sparseMatrixClass == "SparseM" && require("SparseM", quietly=TRUE)) {
            dim <- as.integer(c(n, m));
            data <- new("matrix.coo", ra=s, ia=i, ja=j, dimension=dim);
#            data <- as(data, "matrix.csc");
          } else {
            # Instead of applying row-by-row, we calculate the position of each 
            # sparse element in an hardcoded fashion.
            pos <- (j-1)*n + i;
            rm(i,j);  # Not needed anymore

# Instead, see 'last' above.
#            pos <- pos[-length(pos)];
#            s <- s[-length(s)];
          
            data <- matrix(0, nrow=n, ncol=m);
            data[pos] <- s;

            rm(pos, s); # Not needed anymore
          }
        }
      } else {
        stop("MAT v4 file format error: Unknown 'type' in header: ", header$matrixType);
      }

      verbose && cat(verbose, level=-60, "Matrix elements:\n");
      verbose && str(verbose, level=-60, data);
      
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
      rm(data);

      firstFourBytes <- NULL;
    } # repeat

    header <- list(version="4", endian=detectedEndian);
    attr(result, "header") <- header;
    result;
  } # readMat4()

  
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
    if (MOPT[1] == 0)
      mStr <- "IEEE Little Endian (PC, 386, 486, DEC Risc)"
    else if (MOPT[1] == 1)
      mStr <- "IEEE Big Endian (Macintosh, SPARC, Apollo,SGI, HP 9000/300, other Motorola)"
    else if (MOPT[1] == 2)
      mStr <- "VAX D-float"
    else if (MOPT[1] == 3)
      mStr <- "VAX G-float"
    else if (MOPT[1] == 4)
      mStr <- "Cray"
    else
      mStr <- sprintf("<Unknown value of MOPT[1]. Not in range [0,4]: %d.>", as.integer(MOPT[1]));

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # MOPT[2] "is always 0 (zero) and is reserved for future use."
    #
    # I've only seen a non-default value for ocode used once, by a
    # matfile library external to the MathWorks.  I believe it stands
    # for "order" code...whether a matrix is written in row-major or
    # column-major format.  Its value here will be ignored. /Andy November 2003
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    if (MOPT[2] == 0)
      oStr <- "Reserved for future use"
    else
      oStr <- sprintf("<Unknown value of MOPT[2]. Should be 0: %d.>", as.integer(MOPT[2]));

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
    if (MOPT[3] == 0)
      pStr <- "64-bit double"
    else if (MOPT[3] == 1)
      pStr <- "32-bit single"
    else if (MOPT[3] == 2)
      pStr <- "32-bit signed integer"
    else if (MOPT[3] == 3)
      pStr <- "16-bit signed integer"
    else if (MOPT[3] == 4)
      pStr <- "16-bit unsigned integer"
    else if (MOPT[3] == 5)
      pStr <- "8-bit unsigned integer"
    else
      pStr <- sprintf("<Unknown value of MOPT[3]. Not in range [0,5]: %d.>", as.integer(MOPT[3]));

    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # MOPT[4]  "indicates the matrix type according to the following table:
    #          0 Numeric (Full) matrix
    #          1 Text matrix
    #          2 Sparse matrix
    #          Note that the elements of a text matrix are stored as floating
    #          point numbers between 0 and 255 representing ASCII-encoded 
    #          characters."
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    if (MOPT[4] == 0)
      tStr <- "Numeric (Full) matrix"
    else if (MOPT[4] == 1)
      tStr <- "Text matrix"
    else if (MOPT[4] == 2)
      tStr <- "Sparse matrix"
    else
      tStr <- sprintf("<Unknown value of MOPT[4]. Not in range [0,2]: %d.>", as.integer(MOPT[4]));


    moptStr <- paste("MOPT[1]: ", mStr, ". MOPT[2]: ", oStr, ". MOPT[3]: ", pStr, ". MOPT[4]: ", tStr, ".", sep="");
    moptStr;
  } # moptToString()
  
  #===========================================================================
  # MAT v4 specific                                                        END
  #===========================================================================

  #===========================================================================
  # MAT v5 specific                                                      BEGIN
  #===========================================================================
  readMat5 <- function(con, maxLength=NULL, firstFourBytes=NULL) {
    # Used to test if there a matrix read contains an imaginary part too.
    left <- NA;

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
        firstFourBytes <- readBinMat(con, what=integer(), size=1, n=4);
  
      MOPT <- firstFourBytes;

      if (MOPT[1] %in% 0:4 && MOPT[2] == 0 && MOPT[3] %in% 0:5 && MOPT[4] %in% 0:2) {
        stop("Detected MAT file format v4. Do not use readMat5() explicitly, but use readMat().");
      }
  
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      #  Text [124 bytes] (we already have read four of them)
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # Paste the 'MOPT' above to the rest.
      description <- c(MOPT, readBinMat(con, what=integer(), size=1, n=120));
      description <- paste(intToChar(description), collapse="");
#      cat("Description: '", description, "'\n", sep="");
  
      # - - - - - - - - - - 
      #  Version
      # - - - - - - - - - - 
      # At this point we can not know which the endian is and we just have to
      # make a guess and adjust later. 
      version <- readBinMat(con, what=integer(), size=2, n=1, endian="little");

      # - - - - - - - - - - 
      #  Endian Indicator
      # - - - - - - - - - - 
      endian <- readCharMat(con, nchars=2);
      if (endian == "MI")
        detectedEndian <<- "big"
      else if (endian == "IM")
        detectedEndian <<- "little"
      else {
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
    # Function to read a MAT v5 Data Element
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    readMat5DataElement <- function(this) {
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      isSigned <- function(type) {
        signed   <- c("mxINT8_CLASS", "mxINT16_CLASS", "mxINT32_CLASS");
        signed   <- c(signed, "miINT8", "miINT16", "miINT32");
        unsigned <- c("mxUINT8_CLASS", "mxUINT16_CLASS", "mxUINT32_CLASS");
        unsigned <- c(unsigned, "miUINT8", "miUINT16", "miUINT32");
        if (!is.element(type, c(signed, unsigned)))
          return(NA);
        is.element(type, signed);
      } # isSigned()
       
    
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      #
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
      readTag <- function(this) {
        verbose && enter(verbose, level=-80, "Reading Tag");
        on.exit(verbose && exit(verbose));
        
        type <- readBinMat(con, what=integer(), size=4, n=1);
        # Did we read EOF?
        if (length(type) == 0)
          return(NULL);
      
        left <<- left - 4;

        # Data sizes and types according to [3]
        knownTypes <- c(
          "miMATRIX"=0,      
          "miINT8"=8, 	     #  1 miINT8 8 bit, signed					 
          "miUINT8"=8, 	     #  2 miUINT8 8 bit, unsigned				 
          "miINT16"=16,      #  3 miINT16 16-bit, signed				 
          "miUINT16"=16,     #  4 miUINT16 16-bit, unsigned			 
          "miINT32"=32,      #  5 miINT32 32-bit, signed				 
          "miUINT32"=32,     #  6 miUINT32 32-bit, unsigned			 
          "miSINGLE"=32,     #  7 miSINGLE IEEE 754 single format
          "--"=NA,			     #  8 -- Reserved										 
          "miDOUBLE"=64,     #  9 miDOUBLE IEEE 754 double format
          "--"=NA,			     # 10 -- Reserved										 
          "--"=NA,			     # 11 -- Reserved										 
          "miINT64"=64,	     # 12 miINT64 64-bit, signed				 
          "miUINT64"=64,     # 13 miUINT64 64-bit, unsigned			 
          "miMATRIX"=NA,     # 14 miMATRIX MATLAB array 
          "miCOMPRESSED"=NA, # 15 miCOMPRESSED Compressed Data
          "miUTF8"=8,        # 16 miUTF8 Unicode UTF-8 Encoded Character Data
          "miUTF16"=16,      # 17 miUTF16 Unicode UTF-16 Encoded Character Data
          "miUTF32"=32       # 18 miUTF32 Unicode UTF-32 Encoded Character Data
        );

        knownWhats <- list(
          "miMATRIX"=0, 
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
          "miUTF8"=integer(),
          "miUTF16"=integer(),
          "miUTF32"=integer()
        );

        nbrOfBytes <- NULL;

        # From [1, page 9]:
        # "Programming Note - When reading a MAT-file, you can tell if you 
        #  are processing a compressed data element by comparing the value
        #  of the first two bytes of the tag with the value zero (0). If
        #  these two bytes are not zero, the tag uses the compressed format."
        tmp <- type;
        bytes <- rep(NA, length=4);
        for (kk in 1:4) {
          bytes[kk] <- (tmp %% 256);
          tmp <- tmp %/% 256;
        }
        rm(tmp);
        compressed <- any(bytes[3:4] != 0);

        verbose && cat(verbose, level=-100, "Compressed tag: ", compressed);

#          if (type+1 < 1 || type+1 > length(knownTypes)) {
        if (compressed) {
 #           stop()
          # NOTE: Do not swap for different endians here. /HB 020827
          nbrOfBytes <- type %/% 2^16;
          type <- type %% 2^16;
          if (detectedEndian == "big") {
            tmp <- type;
#            type <- nbrOfBytes;
#            nbrOfBytes <- tmp;
          }
          if (type+1 < 1 || type+1 > length(knownTypes))
            stop("Unknown data type. Not in range [1,", length(knownTypes), "]: ", type);
          
          # Treat unsigned values too.
          padding <- 4 - ((nbrOfBytes-1) %% 4 + 1);
        } else {
#    print(c(size=size, n=n, signed=signed, endian=endian, bfr=bfr));
          nbrOfBytes <- readBinMat(con, what=integer(), size=4, n=1);
          left <<- left - 4;
          padding <- 8 - ((nbrOfBytes-1) %% 8 + 1);
        }
      
        type <- names(knownTypes)[type+1];
        sizeOf <- as.integer(knownTypes[type]);
        what <- knownWhats[[type]];
#        cat("type=", type, ", sizeOf=", sizeOf, ", what=", typeof(what), "\n", sep="");
      
        signed <- isSigned(type);
      
        tag <- list(type=type, signed=signed, sizeOf=sizeOf, what=what, nbrOfBytes=nbrOfBytes, padding=padding, compressed=compressed);
        
        verbose && print(verbose, level=-100, unlist(tag));

        if (identical(tag$type, "miCOMPRESSED")) {
          n <- tag$nbrOfBytes;
          zraw <- readBinMat(con=con, what=raw(), n=n);
          verbose && cat(verbose, level=-110, "Decompressing ", n, " bytes");
          verbose && printf(verbose, level=-110, "zraw [%d bytes]: %s\n", length(zraw), hpaste(zraw, maxHead=8, maxTail=8));
          # Sanity check
          stopifnot(identical(length(zraw), n));
## zraw0 <<- zraw;
          tryCatch({
            unzraw <- uncompress(zraw, asText=FALSE);

            verbose && printf(verbose, level=-110,
                    "Inflated %.3f times from %d bytes to %d bytes.\n", 
                    length(unzraw)/length(zraw), length(zraw), length(unzraw));

            pushBackRawMat(con, unzraw);
            rm(unzraw);
          }, error = function(ex) {
            msg <- ex$message;
            env <- globalenv(); # To please 'R CMD check'
            assign("R.matlab.debug.zraw", zraw, envir=env);
            msg <- sprintf("INTERNAL ERROR: Failed to decompress data (using '%s'). Please report to the R.matlab package maintainer (%s). The reason was: %s", attr(uncompress, "label"), getMaintainer(R.matlab), msg);
            onError <- getOption("R.matlab::readMat/onDecompressError");
            if (identical(onError, "warning")) {
              verbose && enter(verbose, "Skipping");
              verbose && cat(verbose, msg);
              warning(msg);
              verbose && exit(verbose);
            } else {
              throw(msg);
            }
          });
          rm(zraw);

          tag <- readTag(this);
        } # if (identical(tag$type, "miCOMPRESSED"))
  
        tag;
      } # readTag()
      
      
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      #
      # Subelement     Data Type  Number of Bytes
      # ---------------------------------------------------------------------
      # Array Flags    miUINT32   2*sizeOf(miUINT32) (8 bytes)
      
      readArrayFlags <- function(this) {
        verbose && enter(verbose, level=-70, "Reading Array Flags");
        on.exit(verbose && exit(verbose));
        
        getBits <- function(i) {
          ready <- FALSE;
          bits <- c();
          while (!ready) {
            bit <- i %% 2;
            bits <- c(bits, bit);
            i <- i %/% 2;
            ready <- (i==0);
          }
          bits;
        } # getBits()
  
        knownTypes <- c("mxCELL_CLASS"=NA, "mxSTRUCT_CLASS"=NA, "mxOBJECT_CLASS"=NA, "mxCHAR_CLASS"=8, "mxSPARSE_CLASS"=NA, "mxDOUBLE_CLASS"=NA, "mxSINGLE_CLASS"=NA, "mxINT8_CLASS"=8, "mxUINT8_CLASS"=8, "mxINT16_CLASS"=16, "mxUINT16_CLASS"=16, "mxINT32_CLASS"=32, "mxUINT32_CLASS"=32);

        # Read the first miUINT32 integer
        arrayFlags <- readBinMat(con, what=integer(), size=4, n=1);
        left <<- left - 4;

        # Byte 4 - Class
        # "Class. This field contains a value that identifies the MATLAB
        # array type (class) represented by the data element."
        #
        class <- arrayFlags %% 256;
        if (class < 1 || class > length(knownTypes)) { 
          stop("Unknown array type (class). Not in [1,", length(knownTypes), "]: ", class);
        }
        class <- names(knownTypes)[class];
        classSize <- knownTypes[class];

        arrayFlags <- arrayFlags %/% 256;

        # Byte 3 - Flags
        # "Flags. This field contains three, single-bit flags that indicate
        #  whether the numeric data is complex, global, or logical. If the
        #  complex bit is set, the data element includes an imaginary part
        #  (pi). If the global bit is set, MATLAB loads the data element as
        #  a global variable in the base workspace. If the logical bit is
        #  set, it indicates the array is used for logical indexing."
        flags <- arrayFlags %% 256;
        flags <- as.logical(getBits(flags + 2^8)[-9]);
        logical <- flags[2];
        global  <- flags[3];
        complex <- flags[4];

        # Bytes 1 & 2 - The two hi-bytes are "undefined".


        # Used for Sparse Arrays, otherwise undefined
        # Read the second miUINT32 integer
        nzmax <- readBinMat(con, what=integer(), size=4, n=1);
        left <<- left - 4;
        
        flags <- list(logical=logical, global=global, complex=complex, class=class, classSize=classSize, nzmax=nzmax);

        verbose && cat(verbose, level=-100, "Flags:");
        verbose && print(verbose, level=-100, unlist(flags[-1]));
        
        flags;
      } # readArrayFlags()
      
      
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      readDimensionsArray <- function(this) {
        verbose && enter(verbose, level=-70, "Reading Dimensions Array");
        on.exit(verbose && exit(verbose));
        
        tag <- readTag(this);
        if (tag$type != "miINT32") {
          throw("Tag type not supported: ", tag$type);
        }
      
        sizeOf <- tag$sizeOf %/% 8;
        len <- tag$nbrOfBytes %/% sizeOf;
        verbose && cat(verbose, level=-100, "Reading ", len, " integers each of size ", sizeOf, " bytes.");
        dim <- readBinMat(con, what=integer(), size=sizeOf, n=len);
        left <<- left - sizeOf*len;
        
        verbose && cat(verbose, level=-101, "Reading ", tag$padding, " padding bytes.");
        padding <- readBinMat(con, what=integer(), size=1, n=tag$padding);
        left <<- left - tag$padding;
        
        dimArray <- list(tag=tag, dim=dim);
        
        verbose && print(verbose, level=-100, list(dim=dim));
        
        dimArray;
      } # readDimensionsArray()
    
    
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      readName <- function(this) {
        verbose && enter(verbose, level=-70, "Reading Array Name");
        on.exit(verbose && exit(verbose));
        
        tag <- readTag(this);
      
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
        padding <- readBinMat(con, what=integer(), size=1, n=tag$padding);
        left <<- left - tag$padding;
        
      verbose && cat(verbose, level=-50, "Name: '", name, "'");
        
        list(tag=tag, name=name);
      } # readName()
      
      
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      readFieldNameLength <- function(this) {
        verbose && enter(verbose, level=-70, "Reading Field Name Length");
        on.exit(verbose && exit(verbose));
        
        tag <- readTag(this);
        if (tag$type != "miINT32") {
          throw("Tag type not supported: ", tag$type);
        }
      
        sizeOf <- tag$sizeOf %/% 8;
        len <- tag$nbrOfBytes %/% sizeOf;
  #      cat("sizeOf=", sizeOf, "\n");
  #      cat("len=", len, "\n");
        maxLength <- readBinMat(con, what=integer(), size=sizeOf, n=len);
        
        left <<- left - len;
      
        padding <- readBinMat(con, what=integer(), size=1, n=tag$padding);
        left <<- left - tag$padding;
      
       verbose && cat(verbose, level=-100, "Field name length+1: ", maxLength);

        list(tag=tag, maxLength=maxLength);
      } # readFieldNameLength()
      
      
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      readFieldNames <- function(this, maxLength) {
        verbose && enter(verbose, level=-70, "Reading Field Names");
        on.exit(verbose && exit(verbose));
        
        tag <- readTag(this);
        ## Be generous in what types are accepted for names; MATLAB(tm) has
        ## a habit of sprouting new file features.
      
        names <- c();
        sizeOf <- tag$sizeOf %/% 8;
        nbrOfNames <- tag$nbrOfBytes %/% maxLength;
  #      cat("tag$nbrOfBytes=",tag$nbrOfBytes,"\n");
  #      cat("maxLength=",maxLength,"\n");
  #      cat("nbrOfNames=",nbrOfNames,"\n");
        for (k in seq(length=nbrOfNames)) {
      #    name <- readCharMat(con, nchars=maxLength);
          name <- readBinMat(con, what=tag$what, size=sizeOf, n=maxLength);
          name <- matToString(name, tag$type);
          name <- asSafeRName(name);
          left <<- left - maxLength;
          names <- c(names, name);
        }

        verbose && cat(verbose, level=-101, "Reading ", tag$padding, " padding bytes.");
        padding <- readBinMat(con, what=integer(), size=1, n=tag$padding);
        left <<- left - tag$padding;

      verbose && cat(verbose, level=-50, "Field names: ", paste(paste("'", names, "'", sep=""), collapse=", "));
        
        list(tag=tag, names=names);
      } # readFieldNames()
    

      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      # From [1, page 26]:
      # "Fields Subelement - This subelement contains the value stored in a
      #  field. These values are MATLAB arrays, represented using the
      #  miMATRIX format specific to the array type: numeric array, sparse
      #  array, cell, object or other structure. See the appropriate section
      #  of this document for details about the MAT-file format of each of
      #  these array type. MATLAB reads and writes these fields in
      #  column-major order."
      readFields <- function(this, names) {
        verbose && enter(verbose, level=-70, "Reading Fields");
        on.exit(verbose && exit(verbose));
        
        fields <- list();
        for (k in seq(names)) {
          verbose && enter(verbose, level=-3, "Reading field: ", names[k]);
          field <- readMat5DataElement(this);
          fields <- c(fields, field);
          verbose && exit(verbose);
        }
        names(fields) <- names;
        
        fields;
      } # readFields()
    
    
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      readValues <- function(this, logical=FALSE) {
        verbose && enter(verbose, level=-70, "Reading Values");
        on.exit(verbose && exit(verbose));
        
        tag <- readTag(this);

        # "If the 'logical' bit is set, it indicates the array is used for
        # logical indexing." [4].  This is a rather vague explanation, but
        # by comparing the byte content of sparse matrices containing 
        # doubles to those containing logical, it appears as if the latter
        # are stored as single 0/1 bytes, regardless of what the "tag"
        # is indicating.
        if (logical) {
          # Override tag patarmeters.
          sizeOf <- 1L;
          what <- logical(0);
        } else {
          sizeOf <- tag$sizeOf %/% 8;
          what <- tag$what;
        }

        len <- tag$nbrOfBytes %/% sizeOf;

        verbose && cat(verbose, level=-100, "Reading ", len, " values each of ", sizeOf, " bytes. In total ", tag$nbrOfBytes, " bytes.");
        
        value <- readBinMat(con, what=what, size=sizeOf, n=len, signed=tag$signed);
        verbose && str(verbose, level=-102, value);
        
        left <<- left - sizeOf*len;
        
        verbose && cat(verbose, level=-101, "Reading ", tag$padding, " padding bytes.");
        
        padding <- readBinMat(con, what=integer(), size=1, n=tag$padding);
        
        left <<- left - tag$padding;
        
        list(tag=tag, value=value);
      } # readValues()
    
    
    
      # -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -   -
      readMiMATRIX <- function(this, tag) {
        verbose && enter(verbose, level=-70, "Reading miMATRIX");
        on.exit(verbose && exit(verbose));
        verbose && cat(verbose, level=-60, "Argument 'tag':");
        verbose && str(verbose, level=-60, tag);

        tag <- readTag(this);

        if (is.null(tag)) {
          verbose && cat(verbose, "Nothing more to read. Returning NULL.");
          verbose && exit(verbose);
          return(NULL);
        }

        if (tag$type == "miMATRIX") {
          verbose && enter(verbose, level=-70, "Reading a nested miMATRIX");
          node <- readMiMATRIX(this, tag);
          verbose && exit(verbose);
          verbose && exit(verbose);
          return(node);
        }


        if (tag$type != "miUINT32") {
          throw("Tag type not supported: ", tag$type);
        }

        arrayFlags <- readArrayFlags(this);
        verbose && cat(verbose, level=-100, "Array flags:");
        verbose && str(verbose, level=-70, arrayFlags);

        arrayFlags$tag <- tag;
        arrayFlags$signed <- isSigned(tag$type);

        dimensionsArray <- readDimensionsArray(this);
        arrayName <- readName(this);

#str(arrayName)
      
        if (arrayFlags$class == "mxCELL_CLASS") {
          nbrOfCells <- prod(dimensionsArray$dim);
          verbose && cat(verbose, level=-4, "Reading mxCELL_CLASS with ", nbrOfCells, " cells.");
          matrix <- list();
          for (kk in seq(length=nbrOfCells)) {
            tag <- readTag(this);
            cell <- readMiMATRIX(this, tag);
            matrix <- c(matrix, cell);
          }
          matrix <- list(matrix);
          names(matrix) <- arrayName$name;
        } else if (arrayFlags$class == "mxSTRUCT_CLASS") {
          nbrOfCells <- prod(dimensionsArray$dim);
          verbose && cat(verbose, level=-4, "Reading mxSTRUCT_CLASS with ", nbrOfCells, " cells in structure.");
          maxLength <- readFieldNameLength(this);
          names <- readFieldNames(this, maxLength=maxLength$maxLength);
          verbose && cat(verbose, level=-100, "Field names: ", paste(names$names, collapse=", "));
          nbrOfFields <- length(names$names);
          matrix <- list();
          for (kk in seq(length=nbrOfCells)) {
#            cat("Cell: ", kk, "...\n", sep="");
              fields <- readFields(this, names=names$names);
#            str(fields);
            matrix <- c(matrix, fields);
#            cat("Cell: ", kk, "...done\n", sep="");
          }
          names(matrix) <- NULL;

          # Set the dimension of the structure
          dim <- c(nbrOfFields, dimensionsArray$dim);
          if (prod(dim) > 0) {
            matrix <- structure(matrix, dim=dim);
            dimnames <- rep(list(NULL), length(dim(matrix)));
            dimnames[[1]] <- names$names;
            dimnames(matrix) <- dimnames;
          }

          # Finally, put the structure in a named list.
          matrix <- list(matrix);
          names(matrix) <- arrayName$name;

          verbose && cat(verbose, level=-60, "Read a 'struct':");
          verbose && str(verbose, level=-60, matrix);

#old#          maxLength <- readFieldNameLength(this);
#old#          names <- readFieldNames(this, maxLength=maxLength$maxLength);
#old#         print(names);
#old#          fields <- readFields(this, names=names$names);
#old#          names(fields) <- arrayName$name;
#old#          str(fields);
#old#          matrix <- list(fields);
#old#          names(matrix) <- arrayName$name;
        } else if (arrayFlags$class == "mxOBJECT_CLASS") {
          className <- readName(this)$name;
          maxLength <- readFieldNameLength(this);
          verbose && cat(verbose, level=-4, "Reading mxOBJECT_CLASS of class '", className, "' with ", maxLength, " fields.");
          names <- readFieldNames(this, maxLength=maxLength$maxLength);
          fields <- readFields(this, names=names$names);
          class(fields) <- className;
          matrix <- list(fields);
          names(matrix) <- arrayName$name;
        } else if (arrayFlags$complex) {
          verbose && enter(verbose, level=-4, "Reading complex matrix.")
          pr <- readValues(this, logical=arrayFlags$logical);
          if (left > 0)
            pi <- readValues(this, logical=arrayFlags$logical);
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
        } else if (arrayFlags$class == "mxSPARSE_CLASS") {
          # Dimensions of the sparse matrix
          nrow <- dimensionsArray$dim[1];
          ncol <- dimensionsArray$dim[2];

          verbose && cat(verbose, level=-4, "Reading mxSPARSE_CLASS ", nrow, "x", ncol, " matrix.");
          
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
          if (nzmax > 0) {
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
            ir <- readValues(this)$value;
            
            # Note that the indices for MAT v5 sparse arrays start at 0 (not 1).
            ir <- ir + 1;
            if (any(ir < 1 | ir > nrow)) {
              stop("MAT v5 file format error: Some elements in row vector 'ir' (sparse arrays) are out of range [1,", nrow, "].");
            }

            #  "* jc - points to an integer array of length N+1 that contains..."
            jc <- readValues(this)$value;
            if (length(jc) != ncol+1) {
              stop("MAT v5 file format error: Length of column vector 'jc' (sparse arrays) is not ", ncol, "+1 as expected: ", length(jc));
            }

            # Read vector
            pr <- readValues(this, logical=arrayFlags$logical)$value;

            verbose && str(verbose, level=-102, header);
            verbose && str(verbose, level=-102, ir);
            verbose && str(verbose, level=-102, jc);
            verbose && str(verbose, level=-102, pr);
            
            # "This subelement contains the imaginary data in the array, if one
            #  or more of the numeric values in the MATLAB array is a complex
            #  number (if the complex bit is set in Array Flags)." [1, p20]
            if (arrayFlags$complex) {
              # Read imaginary part
              pi <- readValues(this, logical=arrayFlags$logical)$value;
              verbose && str(verbose, level=-102, pi);
            }

            ## Deal with odd MATLAB(tm) discrepancies.
            nzmax <- min(nzmax, jc[ncol+1]);
            if (nzmax < length(ir)) { ir <- ir[1:nzmax]; }
            if (nzmax < length(pr)) { pr <- pr[1:nzmax]; }
            if (arrayFlags$complex) {
              if (nzmax < length(pi)) { pi <- pi[1:nzmax]; }
              pr <- complex(real=pr, imaginary=pi);
              rm(pi); # Not needed anymore!
            }
          } # if (nzmax > 0)

          if (sparseMatrixClass == "Matrix"
              && require("Matrix", quietly=TRUE)) {
            # Logical or numeric sparse Matrix?
            if (is.logical(pr)) {
              className <- "lgCMatrix";
            } else {
              pr <- as.double(pr);
              className <- "dgCMatrix";
            }
            matrix <- new(className,
                          x=pr, p=as.integer(jc), i=as.integer(ir-1),
                          Dim=as.integer(c(nrow,ncol)));
            matrix <- list(matrix);
            names(matrix) <- arrayName$name;
          }
          else if (sparseMatrixClass == "SparseM"
                   && require("SparseM", quietly=TRUE)) {
            if (is.logical(pr)) {
              # Sparse matrices of SparseM cannot hold logical values.
              pr <- as.double(pr);
            } else {
              pr <- as.double(pr);
            }
            matrix <- new("matrix.csc",
                          ra=pr, ja=as.integer(ir), ia=as.integer(jc+1),
                          dimension=as.integer(c(nrow, ncol)));
            matrix <- list(matrix);
            names(matrix) <- arrayName$name;
          }
          else {
            # Create expanded matrix...
            if (is.logical(pr)) {
              defValue <- FALSE;
            } else {
              defValue <- 0;
            }
            matrix <- matrix(defValue, nrow=nrow, ncol=ncol);
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
            for (col in seq(length=length(jc)-1)) {
              first <- jc[col];
              last  <- jc[col+1]-1;
              idx <- seq(from=first, to=last);
              value <- pr[idx];
              row <- ir[idx];
              ok <- is.finite(row);
              row <- row[ok];
              value <- value[ok];
              matrix[row,col] <- value;
            }
            rm(ir,jc,first,last,idx,value,row); # Not needed anymore

            matrix <- list(matrix);
            names(matrix) <- arrayName$name;
          }
          # End mxSPARSE_CLASS
        } else {
          data <- readValues(this, logical=arrayFlags$logical);
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
          } else if (arrayFlags$class == "mxCHAR_CLASS") {
            matrix <- matToCharArray(matrix, tag$type);
            dim <- dimensionsArray$dim;
            # AD HOC/special/illegal case?  /HB 2010-09-18
            if (length(matrix) == 0 && prod(dim) > 0) {
              matrix <- "";
            }
            dim(matrix) <- dim;
            matrix <- apply(matrix, MARGIN=1, FUN=paste, collapse="");
            matrix <- as.matrix(matrix);
          } else {
            stop("Unknown or unsupported class id in array flags: ", arrayFlags$class);
          }
      
          matrix <- list(matrix);
          names(matrix) <- arrayName$name;
        }
      
        matrix;
      } # readMiMATRIX()
    

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
      tag <- readTag(this);
      if (is.null(tag))
        return(NULL);

      if (tag$nbrOfBytes == 0)
        return(list(NULL));

      left <<- tag$nbrOfBytes;
      if (tag$type == "miMATRIX") {
        verbose && enter(verbose, level=-3, "Reading (outer) miMATRIX");
        data <- readMiMATRIX(this, tag);
        verbose && str(verbose, level=-4, data);
        verbose && exit(verbose);
      } else {
        verbose && printf(verbose, level=-3, "Reading (outer) %.0f integers", tag$nbrOfBytes);
        data <- readBinMat(con, what=integer(), size=1, n=tag$nbrOfBytes, signed=tag$signed);
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

    verbose && cat(verbose, level=-100, "Read MAT v5 header:");
    verbose && print(verbose, level=-100, header);
    verbose && cat(verbose, level=-100, "Endian: ", detectedEndian);

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
                   mode(data[[1]]), ": ", paste(dim(data[[1]]), collapse="x"), 
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

  # Argument 'verbose':
  if (inherits(verbose, "Verbose")) {
    # Use cat() of R.utils here (and not the one in 'base')
    cat <- R.utils::cat;
  } else if (is.numeric(verbose)) {
    require("R.utils") || throw("Package not available: R.utils");
    verbose <- Verbose(threshold=verbose);
    # Use cat() of R.utils here (and not the one in 'base')
    cat <- R.utils::cat;
  } else {
    verbose <- as.logical(verbose);
    if (verbose) {
      require("R.utils") || throw("Package not available: R.utils");
      verbose <- Verbose(threshold=-1);
      # Use cat() of R.utils here (and not the one in 'base')
      cat <- R.utils::cat;
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
  nbrOfBytesRead <- 0;
  firstFourBytes <- readBinMat(con, what=integer(), size=1, n=4);
  if (is.null(firstFourBytes))
    stop("MAT file format error: Nothing to read. Empty input stream.");

  if (isMat4(firstFourBytes)) {
    verbose && cat(verbose, level=0, "Trying to read MAT v4 file stream...");
    readMat4(con, firstFourBytes=firstFourBytes, maxLength=maxLength);
  } else {
    verbose && cat(verbose, level=0, "Trying to read MAT v5 file stream...");
    readMat5(con, firstFourBytes=firstFourBytes, maxLength=maxLength);
  }
}) # readMat()



###########################################################################
# HISTORY:
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
#   Matlab struct:s can be read.
# 2005-04-22
# o Updated to read Matlab struct:s as R structure:s.
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
#   sparse matrices in Matlab and saving the in MAT v4 format and
#   looking at the 'help sparse' in Matlab.
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
