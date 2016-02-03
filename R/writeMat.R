###########################################################################/**
# @RdocDefault writeMat
#
# @title "Writes a MAT file structure"
#
# \description{
#  This function takes the given variables (\code{...}) and places them in a
#  MAT file structure, which is then written to a binary connection.
# }
#
# @synopsis
#
# \arguments{
#   \item{con}{Binary @connection to which the MAT file structure should be
#     written to. A string is interpreted as filename, which then will be
#     opened (and closed afterwards).}
#   \item{...}{\emph{Named} variables to be written where the names
#     must be unique.}
#   \item{matVersion}{A @character string specifying what MAT file format
#     version to be written to the connection. If \code{"5"}, a MAT v5 file
#     structure is written. No other formats are currently supported.}
#   \item{onWrite}{Function to be called just before starting to write to
#     connection. Since the MAT file structure does not contain information
#     about the total size of the structure this argument makes it possible
#     to first write the structure size (in bytes) to the connection.}
#   \item{verbose}{Either a @logical, a @numeric, or a @see "R.utils::Verbose"
#     object specifying how much verbose/debug information is written to
#     standard output. If a Verbose object, how detailed the information is
#     is specified by the threshold level of the object. If a numeric, the
#     value is used to set the threshold of a new Verbose object. If @TRUE,
#     the threshold is set to -1 (minimal). If @FALSE, no output is written
#     (and neither is the \link[R.utils:R.utils-package]{R.utils} package required).
#   }
#
#   Note that \code{...} must \emph{not} contain variables with names equal
#   to the arguments \code{matVersion} and \code{onWrite}, which were choosen
#   because we believe they are quite unique to this write method.
# }
#
# \value{
#   Returns (invisibly) the number of bytes written. Any bytes written by
#   any onWrite function are \emph{not} included in this count.
# }
#
# \section{Limitations}{
#  Currently only the uncompressed MAT version 5 file format [6] is
#  supported, that is, compressed MAT files cannot be written (only read).
#
#  Moreover, the maximum variable size supported by the MAT version 5
#  file format is 2^31 bytes [6].  In R, this limitation translates to
#  2^31-1 bytes, which corresponds to for instance an integer object
#  with 536870912 elements or double object with 268435456 elements.
# }
#
# \section{Details on onWrite()}{
#   If specified, the \code{onWrite()} function is called before the
#   data is written to the connection.  This function must take a @list
#   argument as the first argument.  This will hold the element \code{con}
#   which is the opened @connection to be written to.
#   It will also hold the element \code{length}, which specified the
#   number of bytes to be written.  See example for an illustration.
#
#   \emph{Note}, in order to provide the number of bytes before actually
#   writing the data, a two-pass procedure has to be taken, where the
#   first pass is immitating a complete writing without writing anything
#   to the connection but only counting the total number of bytes. Then
#   in the second pass, after calling \code{onWrite()}, the data is written.
# }
#
# \examples{@include "../incl/writeMat.Rex"
#
# \dontrun{
# # When writing to a stream connection the receiver needs to know on
# # beforehand how many bytes are available. This can be done by using
# # the 'onWrite' argument.
# onWrite <- function(x)
#   writeBin(x$length, con=x$con, size=4, endian="little");
#   writeMat(con, A=A, B=B, onWrite=onWrite)
# }
# }
#
# @author
#
# \references{
#   [1] The MathWorks Inc., \emph{MATLAB - MAT-File Format, version 5}, June 1999.\cr
#   [2] The MathWorks Inc., \emph{MATLAB - Application Program Interface Guide, version 5}, 1998.\cr
#   [3] The MathWorks Inc., \emph{MATLAB - MAT-File Format, version 7}, September 2009.\cr
#   [4] The MathWorks Inc., \emph{MATLAB - MAT-File Format, version R2012a}, September 2012.\cr
#   [5] The MathWorks Inc., \emph{MATLAB - MAT-File Format, version R2015b}, September 2015.\cr
#   [6] The MathWorks Inc., \emph{MATLAB - MAT-File Versions}, December 2015.
#       \url{http://www.mathworks.com/help/matlab/import_export/mat-file-versions.html}\cr
# }
#
# \seealso{
#   @see "readMat".
# }
#
# @keyword file
# @keyword IO
#*/###########################################################################
setMethodS3("writeMat", "default", function(con, ..., matVersion="5", onWrite=NULL, verbose=FALSE) {
  #===========================================================================
  # General functions to write MAT v5 files (and later MAT v4 files).    BEGIN
  #===========================================================================
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # The MAT file format (<= 7) only supports 2^31 bytes per variable [6]
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  MAX_WRITABLE_BYTES <- min(2^31, .Machine$integer.max)
  maxBytesError <- function(nbrOfBytes, size) {
    throw(sprintf("MAT file format error: Object is too large to be written to a MAT v%s file, which only supports variables of maximum 2^31 bytes. The object that cannot be written has %.0f elements each of %d bytes totalling %.0f bytes: %s", matVersion, nbrOfBytes/size, size, nbrOfBytes, sQuote(conDescription)))
  }

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Function to write (or just count) an object to a connection.
  #
  # This function will also keep track of the actual number of bytes written.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  writeBinMat <- function(con, object, size, signed=TRUE, endian="little") {
    nbrOfBytes <- size*length(object)

    ## Is the number of bytes supported by the MAT file format?
    if (nbrOfBytes > MAX_WRITABLE_BYTES) maxBytesError(nbrOfBytes, size)

    if (!is.null(con)) {
      writeBin(object, con=con, size=size, endian=endian)
    }

    nbrOfBytes
  } # writeBinMat()


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Function to write (or just count) a character string to a connection.
  #
  # This function will also keep track of the actual number of bytes written.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  writeCharMat <- function(con, object, nchars=nchar(object)) {
    if (!is.null(con)) {
      writeChar(object, con=con, nchars=nchars, eos=NULL);
###      verbose && printf(verbose, "writeCharMat(<length=%d>, nchars=%d)\n", length(object), nchars);
    }
    nchars;
  } # writeCharMat()


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # ASCII is the 8-bit ASCII table with ASCII characters from 0-255.
  #
  # Extracted from the R.oo package. Also inside readMat().
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
  if (getRversion() < "2.7.0") ASCII[1] <- eval(parse(text="\"\\000\""))


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Function to convert a vector of ASCII chars into a vector of integers.
  #
  # Extracted from the R.oo package.
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  charToInt <- function(ch) {
    match(ch, ASCII) - 1;
  }


  #===========================================================================
  # General functions to write MAT v5 files (and later MAT v4 files).      END
  #===========================================================================


  #===========================================================================
  # MAT v5 specific                                                      BEGIN
  #===========================================================================
  writeMat5 <- function(con, objects, onWrite=onWrite, format="matlab") {
    writeHeader <- function(con) {
      verbose && enter(verbose, "writeHeader()");

      # Write 124 bytes header description
      rVersion <- paste(c(R.Version()$major, R.Version()$minor), collapse=".");
      description <- paste("MATLAB 5.0 MAT-file, Platform: ", .Platform$OS.type, ", Software: R v", rVersion, ", Created on: ", date(), sep="");
      bfr <- charToInt(unlist(strsplit(description, "")));
      bfr <- c(bfr, rep(32, max(124-length(bfr),0)));
      if (length(bfr) > 124) bfr <- bfr[1:124];
      nbrOfBytes <- writeBinMat(con, as.integer(bfr), size=1);

      # Write version
      version <- 256L;
      nbrOfBytes <- nbrOfBytes + writeBinMat(con, version, size=2, endian="little");

      # Write endian information
      nbrOfBytes <- nbrOfBytes + writeCharMat(con, "IM");

      verbose && exit(verbose);

      # Return number of bytes written
      nbrOfBytes;
    } # writeHeader()


    writeDataElement <- function(con, object, nbrOfBytes=NA) {
      #      1    2    3    4    5    6    7    8
      #   +----+----+----+----+----+----+----+----+
      #   |    Data type      |  Number of Bytes  |  Tag
      #   +---------------------------------------+
      #   |                                       |
      #   |             Variable size             |  Data
      #   |                                       |
      #   +---------------------------------------+

      verbose && enter(verbose, "writeDataElement()");

      writeTag <- function(dataType, nbrOfBytes, compressed=FALSE) {
##        verbose && enter(verbose, sprintf("writeTag(%s, nbrOfBytes=%d, compressed=%s)", dataType, nbrOfBytes, compressed));
        knownTypes <- c("miINT8"=8, "miUINT8"=8, "miINT16"=16, "miUINT16"=16, "miINT32"=32, "miUINT32"=32, "miSINGLE"=NA, NA, "miDOUBLE"=64, NA, NA, "miINT64"=64, "miUINT64"=64, "miMATRIX"=NA);
        type <- which(names(knownTypes) == dataType);
        if (length(type) == 0)
          stop(paste("Unknown Data Element Tag type: ", dataType, sep=""));

        ## Is the number of bytes supported by the MAT file format?
        if (nbrOfBytes > MAX_WRITABLE_BYTES) maxBytesError(nbrOfBytes, knownTypes[type]/8)

        nbrOfBytesTag <- nbrOfBytes

        nbrOfBytes <- 0;
        if (compressed) {
          bfr <- nbrOfBytesTag * 256^2 + type;
          nbrOfBytes <- nbrOfBytes + writeBinMat(con, as.integer(bfr), size=4, endian="little");
        } else {
          nbrOfBytes <- nbrOfBytes + writeBinMat(con, as.integer(type), size=4, endian="little");
          nbrOfBytes <- nbrOfBytes + writeBinMat(con, as.integer(nbrOfBytesTag), size=4, endian="little");
        }

        # Sanity check
        if(nbrOfBytes != 4 && nbrOfBytes != 8) {
          stop("Internal error: Number of bytes written by writeTag() is not 4 or 8: ", nbrOfBytes);
        }

###        verbose && exit(verbose);

        # Return number of bytes written
        nbrOfBytes;
      } # writeTag()

      writePadding <- function(padding, ...) {
        if (padding > 0) {
###          verbose && enter(verbose, "Padding with ", padding, " zeros");
          writeBinMat(con, rep(0L, times=padding), size=1);
###          verbose && exit(verbose);
        }
        padding;
      } # writePadding()


      writeArrayFlags <- function(class, complex=FALSE, global=FALSE, logical=FALSE) {
        verbose && enter(verbose, "writeArrayFlags(): ", class);

        knownClasses <- c("mxCELL_CLASS"=NA, "mxSTRUCT_CLASS"=NA, "mxOBJECT_CLASS"=NA, "mxCHAR_CLASS"=8, "mxSPARSE_CLASS"=NA, "mxDOUBLE_CLASS"=NA, "mxSINGLE_CLASS"=NA, "mxINT8_CLASS"=8, "mxUINT8_CLASS"=8, "mxINT16_CLASS"=16, "mxUINT16_CLASS"=16, "mxINT32_CLASS"=32, "mxUINT32_CLASS"=32);
        classID <- which(names(knownClasses) == class);
        if (length(classID) == 0)
          stop(paste("Unknown tag type: ", class, sep=""));

        flags <- c(2^3*complex, 2^2*global, 2^1*logical, 0);
        flags <- sum(flags);

        # Array Flags [miUINT32]
        tagSize <- writeTag(dataType="miUINT32", nbrOfBytes=8);
        nbrOfBytes <- tagSize;

        bfr <- flags*256 + classID;
        nbrOfBytes <- nbrOfBytes + writeBinMat(con, as.integer(bfr), size=4, endian="little");

        # Undefined
        nbrOfBytes <- nbrOfBytes + writeBinMat(con, 0L, size=4);

        verbose && exit(verbose);

        # Return number of written bytes
        nbrOfBytes;
      } # writeArrayFlags()


      writeDimensionsArray <- function(dim=c(1,1)) {
        nbrOfDimensions <- length(dim);
        nbrOfBytes <- nbrOfDimensions*4;

        verbose && enter(verbose, "writeDimensionsArray(): dim=c(", paste(dim, collapse=","), ")");

        # Pad bytes?
        padding <- 8 - ((nbrOfBytes-1) %% 8 + 1);
        if (padding < 0) {
          stop("Internal error: Negative padding: ", padding);
        }

        # Dimensions Array [miINT32]
        tagSize <- writeTag(dataType="miINT32", nbrOfBytes=nbrOfBytes);
        nbrOfBytes <- tagSize;

        # Write the dimensions
        nbrOfBytes <- nbrOfBytes + writeBinMat(con, as.integer(dim), size=4, signed=TRUE, endian="little");

        # Write padded bytes
        nbrOfBytes <- nbrOfBytes + writePadding(padding);

        verbose && exit(verbose);

        # Return number of bytes written
        nbrOfBytes;
      } # writeDimensionsArray()


      writeArrayName <- function(name) {
        verbose && enter(verbose, "writeArrayName(): '", name, "'");
        name <- charToInt(unlist(strsplit(name,"")));
        nbrOfBytes <- length(name);

        # NOTE: Compression is not optional (as stated in [1]). /HB 020828
        compressed <- (nbrOfBytes > 0 && nbrOfBytes <= 4);

        # Pad bytes?
        if (compressed) {
          padding <- 4 - ((nbrOfBytes-1) %% 4 + 1);
        } else {
          padding <- 8 - ((nbrOfBytes-1) %% 8 + 1);
        }
        if (padding < 0) {
          stop("Internal error: Negative padding: ", padding);
        }

        # Dimensions Array [miINT8]
        tagSize <- writeTag(dataType="miINT8", nbrOfBytes=nbrOfBytes, compressed=compressed);
        nbrOfBytes <- tagSize;

        # Write characters
        if (length(name) > 0) {
          nbrOfBytes <- nbrOfBytes + writeBinMat(con, as.integer(name), size=1, endian="little");
        }

        # Write padded bytes
        nbrOfBytes <- nbrOfBytes + writePadding(padding);

        verbose && exit(verbose);

        # Return number of bytes written
        nbrOfBytes;
      } # writeArrayName()


      writeNumericPart <- function(values) {
        verbose && enter(verbose, "writeNumericPart(): ", length(values), " value(s).");

        if (is.integer(values)) {
          dataType <- "miINT32"
          sizeOf <- 4
        } else if (is.double(values)) {
          dataType <- "miDOUBLE"
          sizeOf <- 8
        } else {
          dataType <- "miDOUBLE"
          sizeOf <- 8
        }

        values <- as.vector(values)
        nbrOfBytes <- length(values) * sizeOf

        # Pad bytes?
        padding <- 8 - ((nbrOfBytes-1) %% 8 + 1);
        if (padding < 0) {
          stop("Internal error: Negative padding: ", padding);
        }

        # Numeric Part [Any of the numeric data types]
        tagSize <- writeTag(dataType=dataType, nbrOfBytes=nbrOfBytes);
        nbrOfBytes <- tagSize;

        # Write numeric values
        nbrOfBytes <- nbrOfBytes + writeBinMat(con, values, size=sizeOf, endian="little");

        # Write padded bytes
        nbrOfBytes <- nbrOfBytes + writePadding(padding);

        verbose && exit(verbose);

        # Return number of bytes written
        nbrOfBytes;
      } # writeNumericPart()



      writeCharPart <- function(values) {
        verbose && enter(verbose, "writeCharPart(): '", values, "'");

        values <- charToInt(unlist(strsplit(values, "")));
        values <- as.vector(values);

        sizeOf <- 2
        nbrOfBytes <- length(values) * sizeOf

        # Pad bytes?
        padding <- 8 - ((nbrOfBytes-1) %% 8 + 1);
        if (padding < 0) {
          stop("Internal error: Negative padding: ", padding);
        }

        # NOTE: MATLAB is not following the tags fully! Characters
        #       can *not* be written as miINT8 here, since MATLAB
        #       will assume miUINT16 anyway. /HB 020828
        # Character Part [miUINT16]
        tagSize <- writeTag(dataType="miUINT16", nbrOfBytes=nbrOfBytes);
        nbrOfBytes <- tagSize;

        # Write characters
        nbrOfBytes <- nbrOfBytes + writeBinMat(con, as.integer(values), size=sizeOf);

        # Write padded bytes
        nbrOfBytes <- nbrOfBytes + writePadding(padding);

        verbose && exit(verbose);

        # Return number of bytes written
        nbrOfBytes;
      } # writeCharPart()


      writeFieldNameLength <- function(maxLength=32) {
        verbose && enter(verbose, "writeFieldNameLength(): ", maxLength);

       nbrOfBytes <- 4;

        # Pad bytes?
        padding <- 4 - ((nbrOfBytes-1) %% 4 + 1);
        if (padding < 0) {
          stop("Internal error: Negative padding: ", padding);
        }

        # Field Name Length [miINT32]
        tagSize <- writeTag(dataType="miINT32", nbrOfBytes=4, compressed=TRUE);
        nbrOfBytes <- tagSize;

        # Write maxLength
        nbrOfBytes <- nbrOfBytes + writeBinMat(con, as.integer(maxLength), size=4, endian="little");

        # Write padded bytes
        nbrOfBytes <- nbrOfBytes + writePadding(padding);

        verbose && exit(verbose);

        # Return number of bytes written
        nbrOfBytes;
      } # writeFieldNameLength()


      writeFieldNames <- function(fieldNames, maxLength=32) {
        verbose && enter(verbose, "writeFieldNames(): ", length(fieldNames), " names(s)");

        verbose && cat(verbose, "Field names: ", hpaste(sQuote(fieldNames)))

        # Field Names [miINT8]
        nbrOfBytes <- length(fieldNames)*maxLength;

        tagSize <- writeTag(dataType="miINT8", nbrOfBytes=nbrOfBytes);
        nbrOfBytes <- tagSize;

        for (kk in seq_along(fieldNames)) {
          name <- fieldNames[kk];
          if (nchar(name) > maxLength-1)
            stop(paste("Too long field name: ", name, sep=""));
          bfr <- charToInt(unlist(strsplit(name, "")));
          # Append trailing '\0'
          bfr <- c(bfr, 0);
          # Pad with '\0':s
          bfr <- c(bfr, rep(0, max(0, maxLength-length(bfr))));
          nbrOfBytes <- nbrOfBytes + writeBinMat(con, as.integer(bfr), size=1);
        }

        verbose && exit(verbose);

        # Return number of bytes written
        nbrOfBytes;
      } # writeFieldNames()



      writeNumericArray <- function(name, data) {
        verbose && enter(verbose, "writeNumericArray(): ", name);

        if (is.integer(data)) {
          class <- "mxINT32_CLASS"
          sizeOf <- 4
        } else if (is.double(data)) {
          class <- "mxDOUBLE_CLASS"
          sizeOf <- 8
        } else if (is.complex(data)) {
          class <- "mxDOUBLE_CLASS"
          sizeOf <- 8
        } else {
          class <- "mxDOUBLE_CLASS"
          sizeOf <- 8
        }
        complex <- is.complex(data);
        global  <- FALSE;
        logical <- is.logical(data);
#        str(list(name, class, complex, global, logical, data));

        nbrOfBytes <- writeArrayFlags(class=class, complex=complex, global=global, logical=logical);
        nbrOfBytes <- nbrOfBytes + writeDimensionsArray(dim=dim(data));
        nbrOfBytes <- nbrOfBytes + writeArrayName(name=name);
        if (is.complex(data)) {
          nbrOfBytes <- nbrOfBytes + writeNumericPart(Re(data));
          nbrOfBytes <- nbrOfBytes + writeNumericPart(Im(data));
        } else {
          nbrOfBytes <- nbrOfBytes + writeNumericPart(data);
        }

        verbose && exit(verbose);

        # Return number of bytes written
        nbrOfBytes;
      } # writeNumericArray()


      writeCharArray <- function(name, data) {
        verbose && enter(verbose, "writeCharArray(): '", data, "'");

        if (length(data) > 1)
          stop("writeCharArray() only supports one string at the time.");

        nbrOfBytes <- writeArrayFlags(class="mxCHAR_CLASS", complex=FALSE, global=FALSE, logical=FALSE);
        nbrOfBytes <- nbrOfBytes + writeDimensionsArray(dim=c(1,nchar(data)));
        nbrOfBytes <- nbrOfBytes + writeArrayName(name=name);
        nbrOfBytes <- nbrOfBytes + writeCharPart(data);

        verbose && exit(verbose);

        # Return number of bytes written
        nbrOfBytes;
      } # writeCharArray()


      writeStructure <- function(name, structure) {
        verbose && enter(verbose, sprintf("writeStructure(name=%s)", sQuote(name)));

        nbrOfBytes <- writeArrayFlags(class="mxSTRUCT_CLASS", complex=FALSE, global=FALSE, logical=FALSE);
        nbrOfBytes <- nbrOfBytes + writeDimensionsArray(dim=c(1,1));
        nbrOfBytes <- nbrOfBytes + writeArrayName(name=name);
        nbrOfBytes <- nbrOfBytes + writeFieldNameLength(maxLength=32);
        nbrOfBytes <- nbrOfBytes + writeFieldNames(names(structure), maxLength=32);
        for (kk in seq_along(structure)) {
          field <- structure[[kk]];
          verbose && printf(verbose, "Field %s:\n", sQuote(names(structure)[kk]))
          ## FIXME: The following turns vectors and arrays into
          ## one-column matrices, cf. Issue #30. /HB 2015-12-29
          field <- as.matrix(field)
          field <- list(field)
          ## Should we add? names(field) <- names(structure)[kk]
          nbrOfBytes <- nbrOfBytes + writeDataElement(con, field)
        }

        verbose && exit(verbose);

        # Return number of bytes written
        nbrOfBytes;
      } # writeStructure()


      writeCellArrayDataElement <- function(name, cells) {
        complex <- is.complex(cells);
        global  <- FALSE;
        logical <- is.logical(cells);

        nbrOfBytes <- writeArrayFlags(class="mxCELL_CLASS", complex=complex, global=global, logical=logical);
        nbrOfBytes <- nbrOfBytes + writeDimensionsArray(dim=dim(cells));
        nbrOfBytes <- nbrOfBytes + writeArrayName(name=name);
        for (kk in seq_along(cells)) {
          cell <- cells[kk];
          nbrOfBytes <- nbrOfBytes + writeDataElement(con, cell);
        }

        # Return number of bytes written
        nbrOfBytes;
      } # writeCellArrayDataElement()


      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # writeDataElement() main code
      # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
      # Count only?
      if (is.na(nbrOfBytes)) {
        verbose && enter(verbose, "Counting only");
        nbrOfBytes <- writeDataElement(con=NULL, object=object, nbrOfBytes=0);
        tagSize <- attr(nbrOfBytes, "tagSize");
        nbrOfBytes <- nbrOfBytes - tagSize;
        verbose && cat(verbose, "nbrOfBytes=", nbrOfBytes);
        verbose && exit(verbose);
      }

      # Get the data element (and its name)
      name <- names(object);
      if (is.null(name))
        name <- "";
    #    stop("Name of object is missing.");
      value <- object[[1]];

      if (is.null(value)) {
        value <- as.array(integer(0));
      }

      # Get the data type
      dataType <- "miMATRIX"

      if (is.integer(value)) {
        dataType <- "miINT32"
        sizeOf <- 4
      }

      if (is.double(value)) {
        dataType <- "miDOUBLE"
        sizeOf <- 8
      }

      if (is.complex(value)) {
        sizeOf <- 2*8
      }

      if (is.character(value)) {
        dataType <- "miMATRIX"
        sizeOf <- 1
      }

      if (is.list(value)) {
        dataType <- "miMATRIX"
        sizeOf <- 1
      }

      if (!is.null(dim(value))) {
        dataType <- "miMATRIX"
      }

#      # Get the number of bytes
#      nbrOfBytes <- length(value) * sizeOf

      # "For data elements representing "MATLAB arrays", (type miMATRIX),
      # the value of the Number Of Bytes field includes padding bytes in
      # the total. For all other MAT-file data types, the value of the
      # Number of Bytes field does *not* include padding bytes."
      if (dataType == "miMATRIX") {
        padding <- 8 - ((nbrOfBytes-1) %% 8 + 1)
        if (padding < 0) {
          stop("Internal error: Negative padding: ", padding);
        }
        if (padding > 0) {
            nbrOfBytes <- nbrOfBytes + padding;
        }
      }

      # Write the Data Element Tag
      tagSize <- writeTag(dataType=dataType, nbrOfBytes=nbrOfBytes);
      nbrOfBytes <- tagSize;

      if (is.numeric(value) || is.complex(value)) {
        if (is.null(dim(value)))
          value <- as.matrix(value);
        nbrOfBytes <- nbrOfBytes + writeNumericArray(name=name, data=value);
      } else if (is.character(value)) {
        if (length(value) == 1) {
          nbrOfBytes <- nbrOfBytes + writeCharArray(name=name, data=value);
        } else {
          value <- as.matrix(value);
          nbrOfBytes <- nbrOfBytes + writeCellArrayDataElement(name=name, cells=value);
        }
      } else if (is.list(value)) {
        nbrOfBytes <- nbrOfBytes + writeStructure(name=name, structure=value);
      }

      verbose && exit(verbose);

      attr(nbrOfBytes, "tagSize") <- tagSize;

      # Return number of bytes written
      nbrOfBytes;
    } # writeDataElement()


    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # "Main program"
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Validate arguments
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Argument 'verbose':
    if (inherits(verbose, "Verbose")) {
    } else if (is.numeric(verbose)) {
      verbose <<- Verbose(threshold=verbose);
    } else {
      verbose <- as.logical(verbose);
      if (verbose) {
        verbose <<- Verbose(threshold=-1);
      }
    }

    # Since writeMat5() is wrapped inside the writeMat() function, we can
    # assume that 'con' really is a connection and 'objects' really is a
    # list.

    # If format == "matlab" (default), all scalars and vectors are
    # written as arrays, which is the only format MATLAB reads.
    # Otherwise, they are written as is, which the MAT v5 format indeed
    # supports. However, since this is probably not going to be needed
    # by anyone, we have decided to not put the 'format' argument in the
    # main function readMat(), but if ever need, just add it there too.
    if (!is.null(format) && format == "matlab") {
      for (kk in seq_along(objects)) {
        object <- objects[[kk]];
        if (!is.null(object)) {
          if (!is.array(object) && !is.list(object)) {
            object <- as.array(object);
          }
          objects[[kk]] <- object;
        }
      }
    }


    writeAll <- function(con, objects) {
      nbrOfBytes <- writeHeader(con);

      for (kk in seq_along(objects)) {
        object <- objects[kk];   # NOT [[kk]], has to be a list!
        nbrOfBytes <- nbrOfBytes + writeDataElement(con, object);
      }

      # Return bytes written
      nbrOfBytes;
    } # writeAll()


    # When writing to streams, that is, to other connections than files,
    # we have to "send over" the number of bytes first to inform the
    # receiver how big the succeeding streamed MAT object is.
    # In order to accomplish this, we first have to count the number of
    # bytes needed and then we send the stream.  Here we do this by
    # a two-pass procedure: 1) count Number of Bytes of written while
    # writing to "void", and 2) redo the same with real writing.

    # Count size of MAT structure in bytes and pass to onWrite()?
    if (!is.null(onWrite)) {
      nbrOfBytes <- writeAll(con=NULL, objects);
      onWrite(list(con=con, length=nbrOfBytes));
    }

    # Write MAT structure to connection
    nbrOfBytes <- writeAll(con, objects);

    invisible(nbrOfBytes);
  } # writeMat5()
  #===========================================================================
  # MAT v5 specific                                                        END
  #===========================================================================

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # "Main program"
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Make sure arguments are named, otherwise name them automagically
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Wrap up the objects to be written in a list structure.
  args <- list(...);

  # Assert that objects to be written by writeMat() are named
  names <- names(args);
  if (is.null(names) || any(names == "")) {
    throw("Detected non-named objects. Non-named objects will not be available in MATLAB if completed. Use writeMat(..., x=a, y=y) and not writeMat(..., x=a, y): ", deparse(sys.call()));
  }

  if (any(duplicated(names))) {
    throw("Detected objects with duplicated names (", paste(names[duplicated(names)], collapse=", "), "). Only the last occurance of each duplicated object will be available in MATLAB if completed: ", deparse(sys.call()));
  }

###   if (is.null(names)) {
###     names <- rep("", times=length(args));
###   }
###
###   # Detect non-named arguments
###   notNamed <- (nchar(names) == 0);
###   idxs <- which(notNamed);
###   if (length(idxs) > 0) {
###     # Inferring the names from the passed objects
###     names2 <- as.character(substitute(args));
###     names2 <- names2[idxs];
###
###     # Check which are syntactically valid R names,
###     # e.g. not just writeMat(..., 1:10).
###     isValid <- sapply(names2, FUN=function(name) {
###       expr <- parse(text=sprintf("%s <- NULL;", name));
###       res <- tryCatch({ eval(expr); TRUE }, error=function(ex) { FALSE });
###       res;
###     });
###
###     # Fix invalid names
###     if (any(!isValid)) {
###       names3 <- names2[!isValid];
###       names3 <- sprintf("unnamed%d", seq_along(names3));
###       names2[!isValid] <- names3;
###     }
###
###     # Add the inferred names
###     names[idxs] <- names2;
###     names(args) <- names;
###   } # if (length(idxs) > 0)


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Setup the connection to be written to
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  ## Close connection when exiting?
  close <- FALSE
  on.exit({ if (close) close(con) })

  ## Description of the output file/connection
  conDescription <- NA_character_

  ## Writing to temporary file?
  pathnameT <- NULL

  if (inherits(con, "connection")) {
    if (!isOpen(con)) {
      open(con, open="wb")
      close <- TRUE
    }
    conDescription <- as.character(summary(con)$description)
  } else {
    # For all other types of values of 'con' make it into a character string.
    # This will for instance also make it possible to use object of class
    # File in the R.io package to be used.
    pathname <- as.character(con)

    ## Default has always been to overwrite existing file
    ## Should this be made an argument?
    overwrite <- TRUE
    pathname <- Arguments$getWritablePathname(pathname, mustNotExist=FALSE)
    if (overwrite && isFile(pathname)) file.remove(pathname)

    ## Write to temporary file and rename only if successful
    pathnameT <- pushTemporaryFile(pathname)
    conDescription <- pathnameT

    # Now, assume that 'con' is a filename specifying a file to be opened.
    con <- file(pathnameT, open="wb")
    close <- TRUE
  }

  # Assert that it is a binary connection
  if (summary(con)$text != "binary")
    stop("Can only write a MAT file structure to a *binary* connection.");



  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Write the data
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (matVersion == "5") {
    nbrOfBytes <- writeMat5(con, objects=args, onWrite=onWrite)
  } else {
    stop(paste("Can not write MAT file. Unknown or unsupported MAT version: ",
                                                         matVersion, sep=""))
  }

  ## Close connection (only iff opened above)
  if (close) {
    close <- FALSE
    close(con)
  }

  ## Rename temporary file? (only iff successful)
  if (!is.null(pathnameT)) popTemporaryFile(pathnameT)

  invisible(nbrOfBytes)
}) # writeMat()


######################################################################
# HISTORY:
# 2011-07-24
# o Now readMat() and writeMat() locally defines cat() (by copying the
#   one in R.utils), iff R.utils is loaded.
# 2010-10-29
# o Now writeMat() gives an error, if non-unique object names
#   are detected.
# o Now writeMat() gives an error, not a warning, if non-named
#   objects are detected.
# o BUG FIX: The test for non-named objects to writeMat() did not
#   work correctly.
# 2010-10-28
# o DOCUMENTATION: Clarified in the help of writeMat() that it can
#   only write 'uncompressed' MAT files.
# o ROBUSTNESS: Although readMat() can read non-named objects, in
#   MATLAB it is only the 'load()' function call that can read it
#   but not the plain 'load' call.  Because of this, writeMat()
#   will now give a warning if it detects non-named objects.  For
#   instance, in writeMat("foo.mat", x=a, y) the object 'a' is
#   named (as "x") whereas 'y' is not.  To name the objects and
#   avoid the warning, use writeMat("foo.mat", x=a, y=y).
# 2008-10-29
# o If onWrite == NULL, then there is no longer an outer two-pass scan
#   for figuring out the size of MAT structure.  However, instead
#   each readDataElement() has to do a two-pass scan in order to
#   figure out the number of bytes before writing each element.
# o BUG FIX: Arrays with more than two dimension would be written
#   as vectors.  Thanks Minho Chae for reporting this.
# o BUG FIX: From v1.2.2, writeMat() would generate corrupt MAT files.
#   Reverted writeMat() back to v1.2.1 and updated as above.
# 2008-07-12
# o CLEAN UP: Removed debugging/asserting code based on the stack
#   'nbrOfBytesList', and beginTag() and endTag().
# o Now the first pass counting the number of bytes to be written is
#   skipped if argument 'onWrite' is not given.  Thank to
#   Adam Grossman at Stanford University for providing code this.
# 2005-02-16
# o Made writeMat() a default method.
# 2003-11-25
# o For consistency with readMat(), the writeMat5() was renamed to
#   writeMat().
# 2003-04-04
# o Added a reference to the MAT-File Format document.
# 2002-09-03
# o Added argument 'onWrite'.
# o Now the function returns the number of bytes written.
# o Added argument 'format' to makes it easier to force all datatypes
#   to be written as matrices, which is the only datatype MATLAB
#   knows about.
# o Now writeMAT() is a stand-alone function.
# o Made writeHeader() and writeDataElement() internal functions to
#   write(). This is a step towards a R.oo free write() function.
# 2002-08-28
# o Calculates the Number Of Bytes by using a two-pass approach.
# 2002-08-27
# o TO SOLVE: How can one calculate all the Number Of Bytes values
#   *before* writing anything to the stream?
# o Created from MATInputStream.R.
######################################################################
