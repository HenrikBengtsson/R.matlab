###########################################################################/**
# @RdocClass Matlab
#
# @title "MATLAB client for remote or local MATLAB access"
#
# \description{
#  @classhierarchy
# }
#
# @synopsis
#
# \arguments{
#   \item{host}{Name of host to connect to.}
#   \item{port}{Port number on host to connect to.}
#   \item{remote}{If @TRUE, all data to and from the MATLAB server will
#      be transferred through the socket @connection, otherwise the data will
#      be transferred via a temporary file.}
# }
#
# \section{Fields and Methods}{
#  @allmethods
# }
#
# \section{Requirements}{
#   In order for \R to communicate with MATLAB, MATLAB v6 or higher is
#   needed. It will \emph{not} work with previous versions, because they
#   do not support Java!\cr
#
#   We use the term \emph{server} to say that MATLAB acts like a server
#   with regard to \R. Note that it a standard MATLAB session that runs.\cr
#
#   Also, the starting of the MatlabServer is simplier from MATLAB v7,
#   although it is pretty straightforward for MATLAB v6 too.
#   It is easier in MATLAB v7 and above, because the Java class required
#   for remote-data-transfer can be automatically/dynamically added to
#   the MATLAB Java classpath, whereas for MATLAB v6 it has to be
#   added manually (see below).
# }
#
# \section{Remote and non-remote connections}{
#   When a remote connection (argument \code{remote=TRUE}) is used,
#   data is send to and from MATLAB via a data stream. This is needed
#   when \R is running on a host with a seperated file system than
#   the one MATLAB is running on.
#
#   If not connection "remotely" (\code{remote=FALSE}), data is
#   communicated via the file system, that is, by saving and reading
#   it to temporary MAT files. \cr
#
#   Troubleshooting: If "remote" transfers are used, the
#   InputStreamByteWrapper Java class must be found by MATLAB,
#   otherwise an error will occur in MATLAB as soon as data is
#   send from \R to MATLAB. In all other cases, the above Java class
#   is \emph{not} needed.
# }
#
# \section{Starting the MATLAB server from within \R}{
#   The MATLAB server may be started from within \R by
#   calling \code{Matlab$startServer()}. By default 'matlab' is called;
#   if named differently set \code{options(matlab="matlab6.5")}, say.
#   \emph{The method is experimental and may not work on your system.}
#   By default the MATLAB server listens for connections on port 9999.
#   For other ports, set argument \code{port}, e.g.
#   \code{Matlab$startServer(port=9998)}.
#
#   Note that the code will \emph{not} halt and wait for MATLAB to get
#   started. Thus, you have to make sure you will wait long enough for
#   the server to get up and running before the \R client try to
#   connect. By default, the client will try once a second for 30 seconds
#   before giving up.
#   Moreover, on non-Windows systems, the above command will start MATLAB
#   in the background making all MATLAB messages be sent to the \R output
#   screen.
#   In addition, the method will copy the MatlabServer.m and
#   InputStreamByteWrapper.class files to the current directory
#   and start MATLAB from there.
# }
#
# \section{Starting the MATLAB server without \R}{
#   If the above does not work, the MATLAB server may be started manually
#   from MATLAB itself.  Please follow the below instructions carefully.
#
#   \bold{To be done once:}\cr
#   In MATLAB, add the path to the directory where MatlabServer.m sits.
#   See \code{help pathtool} in MATLAB on how to do this.
#   In R you can type \code{system.file("externals", package="R.matlab")}
#   to find out the path to MatlabServer.m.
#
#   \bold{For MATLAB v6 only:} Contrary to MATLAB v7 and above, MATLAB v6
#   cannot find the InputStreamByteWrapper class automatically. Instead,
#   the so called Java classpath has to be set manually. In MATLAB, type
#   \code{which('classpath.txt')} to find where the default
#   MATLAB classpath.txt file is located. Copy this file to the
#   \emph{current directory}, and append the \emph{path} (the directory)
#   of InputStreamByteWrapper.class to the end of classpath.txt.
#   The path of InputStreamByteWrapper.class can be identified by
#   \code{system.file("java", package="R.matlab")} in R.\cr
#
#   \bold{Lazy alternative:} Instead of setting path and classpaths,
#   you may try to copy the MatlabServer.m and InputStreamByteWrapper.class
#   to the current directory from which MATLAB is then started.
#
#   \bold{To start the server:}\cr
#   In order to start the MATLAB server, type\cr
#
#   \code{matlab -nodesktop -nosplash -r MatlabServer}\cr
#
#   If using MATLAB v6, make sure your \code{classpath.txt} is the
#   current directory!
#
#   This will start MATLAB and immediately call the MatlabServer(.m)
#   script. Here is how it should look like when the server starts:
#   \preformatted{
#    @include{../incl/MatlabServer.out}
#   }
#   Alternatively you can start MATLAB and type \code{MatlabServer}
#   at the prompt.
#
#   By default the MATLAB server listens for connections on port 9999.
#   For other ports, set environment variable \code{MATLABSERVER_PORT}.
# }
#
# \section{Confirmed MATLAB versions}{
#   This package has been confirmed to work \emph{successfully} out of
#   the box together with the following MATLAB versions:
#   MATLAB v6.1.0.450 (R12.1) [Jun 2001],
#   MATLAB v6.5.0.180913a (R13) [Jul 2002],
#   MATLAB v7.0.0.19901 (R14) [Jun 2004],
#   MATLAB v7.0.1.24704 (R14SP1) [Oct 2004],
#   MATLAB v7.0.4.365 (R14SP2) [Mar 2005],
#   MATLAB v7.2.0.232 (R2006a) [Mar 2006],
#   MATLAB v7.4.0 (R2007a) [Mar 2007]],
#   MATLAB v7.7.0.471 (R2008b) [Oct 2008],
#   MATLAB v7.10.0.499 (R2010a) [Mar 2010],
#   MATLAB v7.11.0.584 (R2010b) [Sep 2010],
#   MATLAB v7.14.0.739 (R2012a) [Mar 2012],
#   MATLAB v8.2.0.701 (R2013b) [Sep 2013], and
#   MATLAB v8.4.0 (R2014b) [Oct 2014].
#   If you successfully use a different/higher MATLAB version,
#   please tell us, so we can share it here.
#
#   It does \emph{not} work with MATLAB v5 or before.
# }
#
# \section{Security}{
#   There is \emph{no} security in the communication with the MATLAB
#   server. This means that if you start the MATLAB server, it will
#   wait for requests via the connection at the specified port. As
#   long as your \R session has not connected to this port, others
#   may be able to steal the connection and send malicious commands
#   (if they know the R.matlab protocol). The MATLAB server only
#   allows one connection. In other words, if you are connected it
#   is not possible for others to connect to the MATLAB server.
# }
#
# \section{MATLAB server is timing out}{
#   It might be that an @seemethod "evaluate" call to the MATLAB server
#   takes a long time for the server to finish resulting in a time-out
#   exception.  By default this happens after 30 seconds, but it can
#   be changed by modifying options, cf. @see "setOption".
# }
#
# \section{Multiple parallel MATLAB instances}{
#   You can launch multiple parallel MATLAB instance using this interface.
#   This can be done in separate R sessions or in a single one.  As long
#   as each MATLAB server/session is communicating on a separate port,
#   there is no limitation in the number of parallel MATLAB instances
#   that can be used.  Example:
#
#   \preformatted{
#    > library('R.matlab')
#    ## Start two seperate MATLAB servers
#    > Matlab$startServer(port=9997)
#    > Matlab$startServer(port=9999)
#
#    ## Connect to each of them
#    > matlab1 <- Matlab(port=9997); open(matlab1)
#    > matlab2 <- Matlab(port=9999); open(matlab2)
#
#    ## Evaluate expression in each of them
#    > evaluate(matlab1, "x=1+2; x")
#    > evaluate(matlab2, "y=1+2; y")
#   }
#
#   Note that the two MATLAB instance neither communicate nor
#   share variables.
# }
#
# \examples{\dontrun{@include "../incl/Matlab.Rex"}}
#
# @author
#
# \seealso{
#   Stand-alone methods @see "readMat" and @see "writeMat"
#   for reading and writing MAT file structures.
# }
#
# @visibility public
#*/###########################################################################
setConstructorS3("Matlab", function(host="localhost", port=9999, remote=!(host %in% c("localhost", "127.0.0.1"))) {
  # Argument 'port':
  if (!is.null(port)) {
    port <- Arguments$getInteger(port, range=c(1023,65535));
  }


  extend(Object(), "Matlab",
    con      = NULL,
    host     = as.character(host),
    port     = as.integer(port),
    remote   = as.logical(remote),
    .options = Options(),
    .verbose = NullVerbose()
  )
})


###########################################################################/**
# @RdocMethod as.character
#
# @title "Gets a string describing the current MATLAB connection"
#
# \description{
#   @get "title".
# }
#
# @synopsis
#
# \arguments{
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns a @character string.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("as.character", "Matlab", function(x, ...) {
  # To please R CMD check
  this <- x;

  s <- sprintf("%s: The MATLAB host is '%s' and communication goes via port %d.", class(this)[1], this$host, this$port);
  s <- sprintf("%s Objects are passed via the %s (remote=%s).", s,
         (if (this$remote) "socket connection" else "local file system"),
         as.character(this$remote)
       );
  s <- sprintf("%s The connection to the MATLAB server is %s.", s,
         (if (isOpen(this)) "opened" else "closed (not opened)")
       );
  s;
})


###########################################################################/**
# @RdocMethod getOption
#
# @title "Gets the value of an option"
#
# \description{
#   @get "title" where the option is specified like a file pathname, e.g.
#   "readResult/maxTries".  See @seemethod "setOption" for what options
#   are available.
#   See the \link[R.utils]{Options} class for details.
# }
#
# @synopsis
#
# \arguments{
#  \item{...}{Arguments passed to
#    \code{\link[R.utils:getOption.Options]{getOption}}()
#    of the Options class.}
# }
#
# \value{
#   Returns the value of the option.
# }
#
# @author
#
# \seealso{
#   @seemethod "setOption".
#   @seeclass
# }
#*/###########################################################################
setMethodS3("getOption", "Matlab", function(this, ...) {
  getOption(this$.options, ...);
})


###########################################################################/**
# @RdocMethod setOption
#
# @title "Sets the value of an option"
#
# \description{
#   @get "title" where the option is specified like a file pathname, e.g.
#   "readResult/maxTries". See the \link[R.utils]{Options} class for details.
# }
#
# @synopsis
#
# \arguments{
#  \item{...}{Arguments passed to
#    \code{\link[R.utils:getOption.Options]{setOption()}}
#    of the Options class.}
# }
#
# \value{
#   Returns the previous value of the option.
# }
#
# \section{Available options}{
#  \itemize{
#   \item{readResult/maxTries}{The maximum number of times the connection
#      is check for an answer from the MATLAB server before giving up.
#      Default values is 30 times.}
#   \item{readResult/interval}{The interval in seconds between each poll
#      for an answer.  Default interval is 1 (second).}
#  }
#
#  With default values of the above options, the \R MATLAB client waits
#  30 seconds for a reply from the MATLAB server before giving up.
# }
#
# @author
#
# \seealso{
#   @seemethod "getOption".
#   @seeclass
# }
#*/###########################################################################
setMethodS3("setOption", "Matlab", function(this, ...) {
  setOption(this$.options, ...);
})



###########################################################################/**
# @RdocMethod open
#
# @title "Tries to open a connection to the MATLAB server"
#
# \description{
#   Tries to open a socket connection to the MATLAB server. If the connection
#   could not be opened it the first time it will try to open it every
#   \code{interval} second up to \code{trials} times.
# }
#
# @synopsis
#
# \arguments{
#  \item{trials}{The number of trials before giving up.}
#  \item{interval}{The interval in seconds between trials.}
#  \item{timeout}{The timeout for the socket connection}
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns @TRUE if a socket @connection to the MATLAB server was
#   successfully opened, otherwise @FALSE.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("open", "Matlab", function(con, trials=30, interval=1, timeout = getOption("timeout"), ...) {
  # To please R CMD check.
  # close() is already a generic function in 'base'.
  this <- con;

  enter(this$.verbose, sprintf("Opens a blocked connection to host '%s' (port %d)", this$host, as.integer(this$port)));
  suffix <- "...done";
  on.exit(exit(this$.verbose, suffix=suffix), add=TRUE);

  count <- 0;
  while (count < trials) {
    ok <- FALSE;
    tryCatch({
      printf(this$.verbose, level=-1, "Try #%d.\n", as.integer(count));
      suppressWarnings({
        this$con <- socketConnection(host=this$host, port=as.integer(this$port), open="a+b", blocking=TRUE, timeout = timeout);
      });
      ok <- TRUE;
      # It is not possible to return() from tryCatch()! /HB 050224
    }, error = function(ex) {
      # The MATLAB server is not up and running yet.
      # Wait a bit and try again.
      Sys.sleep(interval);
      count <<- count + 1;
    })

    if (ok) {
      # Connection to MATLAB server was successful!
      return(TRUE);
    }
  } # while (count < trials)

  suffix <- sprintf("...failed (after %d tries)", as.integer(count));

  throw(sprintf("Failed to connect to MATLAB on host '%s' (port %d) after trying %d times for approximately %.1f seconds.", this$host, as.integer(this$port), count, count*interval));

  return(FALSE);
});





###########################################################################/**
# @RdocMethod isOpen
#
# @title "Checks if connection to the MATLAB server is open"
#
# \description{
#  Checks if connection to the MATLAB server is open.
# }
#
# @synopsis
#
# \arguments{
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns @TRUE if @connection is open, otherwise @FALSE.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("isOpen", "Matlab", function(con, ...) {
  # isOpen() is already a function in 'base'.
  this <- con;
  (!is.null(this$con) && isOpen(this$con))
})



###########################################################################/**
# @RdocMethod finalize
#
# @title "Finalizes the object if deleted"
#
# \description{
#   @get "title". If a MATLAB connection is opened, it is closed.
#
#   Note that you should never have to call this method explicitly. It is
#   called automatically whenever the object is removed from memory
#   (by the garbage collector).
# }
#
# @synopsis
#
# \arguments{
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns nothing.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("finalize", "Matlab", function(this, ...) {
  enter(this$.verbose, level=-100, "Finalizing the Matlab object");
  on.exit(exit(this$.verbose), add=TRUE);

  close(this);
}, createGeneric=FALSE)



###########################################################################/**
# @RdocMethod close
#
# @title "Closes connection to MATLAB server"
#
# \description{
#  Closes connection to MATLAB server. After closing the connection the MATLAB
#  server can never more be access again.
# }
#
# @synopsis
#
# \arguments{
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns what @seemethod "close" returns.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("close", "Matlab", function(con, ...) {
  # close() is already a generic function in 'base'.
  this <- con;

  enter(this$.verbose, sprintf("Closing connection to host '%s' (port %d)", this$host, as.integer(this$port)));
  suffix <- "...done";
  on.exit(exit(this$.verbose, suffix=suffix), add=TRUE);

  if (isOpen(this)) {
    printf(this$.verbose, level=-2, "Sending a command to the MATLAB server telling it to close down...\n");

    writeCommand(this, "quit");
    printf(this$.verbose, level=-2, "Sending a command to the MATLAB server telling it to close down...ok\n");

    printf(this$.verbose, level=-2, "Waiting for a reply from the MATLAB server...\n");

    res <- readResult(this);
    resStr <- if (is.null(res)) 0 else res;
    printf(this$.verbose, level=-2, "Waiting for a reply from the MATLAB server...ok: '%d'\n", as.integer(resStr));

    if (!is.null(res)) {
      warning(res);
    }
    printf(this$.verbose, level=-2, "Closing the connection to the MATLAB server...\n");
    close(this$con);
    this$con <- NULL;
    printf(this$.verbose, level=-2, "Closing the connection to the MATLAB server...ok\n");
  } else if (!is.null(this$con)) {
   suffix <- "...already closed";
   warning("MATLAB session is already closed.");
  }
});




###########################################################################/**
# @RdocMethod writeCommand
#
# @title "Writes (sends) a command to the MATLAB server"
#
# \description{
#  @get "title".
#
#  This method is for internal use only.
# }
#
# @synopsis
#
# \arguments{
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns nothing.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("writeCommand", "Matlab", function(this, cmd, ...) {
  getCommandByte <- function(this, cmd) {
    commands <- c("quit", "", "eval", "send", "receive", "send-remote", "receive-remote", "echo", "evalc");
    if (!is.element(cmd, commands))
      return(0L);
    as.integer(which(commands == cmd) - 2L);
  }

  b <- getCommandByte(this, cmd);

  printf(this$.verbose, level=-2, "Sending a command '%s' (%d) to the MATLAB server...\n", cmd, as.integer(b));

  res <- Java$writeByte(this$con, b);

  printf(this$.verbose, level=-2, "Sending a command '%s' (%d) to the MATLAB server...ok\n", cmd, as.integer(b));

  res;
}, private=TRUE);



###########################################################################/**
# @RdocMethod readResult
#
# @title "Reads results from the MATLAB server"
#
# \description{
#  @get "title".
#
#  This method is for internal use only.
# }
#
# @synopsis
#
# \arguments{
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns an \R object.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("readResult", "Matlab", function(this, ...) {
  # BUG FIX?!? Linda Werner found out that it sometimes happend that
  # answer == NULL below, which is strange because we read from a
  # connection that blocks if there is nothing to read. See ?open
  # for more details. Anyway, it seems that there is a timing problem
  # and that the 'answer' MATLAB sends is not transfered in time. In
  # other words, if we try again a little bit later it seems to work.
  # This is should be considered a temporary work-around until we
  # understand what really happens. /HB 2004-02-24
  # Thomas Romary, France, reported the a similar problem on 2005-05-25
  # for his 30 minutes MATLAB process. Added the option for users to set
  # the number times and at what intervals (in sections) readResult()
  # should query MATLAB for. /HB 2005-05-25
  maxTries <- getOption(this, "readResult/maxTries", defaultValue=30);
  interval <- getOption(this, "readResult/interval", defaultValue=1);

  count <- 0;
  ready <- FALSE;
  while (!ready) {
    count <- count + 1;
    printf(this$.verbose, level=-2, "Retrieve reply from the MATLAB server (try %d)...\n", as.integer(count));

    answer <- Java$readByte(this$con);
    ready <- (length(answer) > 0);
    if (!ready) {
      printf(this$.verbose, level=-2, "Strange! Received an \"empty\" reply although the connection should be blocking. Will try again...\n");
      if (count <= maxTries) {
        Sys.sleep(interval);
      } else {
        throw("Expected an 'answer' from MATLAB, but kept receiving nothing. Tried ", maxTries, " times at intervals of approximately ", interval, " seconds. To change this, see ?setOption.Matlab.");
      }
    }
  }

  if (answer == 0) {
    printf(this$.verbose, level=-1, "Received an 'OK' reply (%d) from the MATLAB server.\n", answer);

    res <- NULL;
  } else if (answer == -1) {
    lasterr <- Java$readUTF(this$con);
    printf(this$.verbose, level=-1, "Received an 'MatlabException' reply (%d) from the MATLAB server: '%s'\n", answer, as.character(lasterr));
    throw("MatlabException: ", lasterr);
  } else {
    printf(this$.verbose, level=-1, "Received an generic reply from the MATLAB server: %d\n", answer);
    res <- answer;
  }
  res;
}, private=TRUE);





###########################################################################/**
# @RdocMethod startServer
#
# @title "Static method which starts a MATLAB server"
#
# \description{
#  Static method which starts a MATLAB server on the local machine. Note
#  that MATLAB v6 or later is required, since the MATLAB server relies on
#  Java.
# }
#
# @synopsis
#
# \arguments{
#  \item{matlab}{An optional @character string specifying the name of
#    the matlab command, if different from \code{"matlab"}. An absolute
#    path are possible.}
#  \item{port}{An optional @integer in [1023,65535].
#    If given, the environment variable \code{MATLABSERVER_PORT} is
#    set specifying which port the MATLAB server should listen to for
#    clients trying to connect.  The default port is 9999.}
#  \item{minimize}{When starting MATLAB on Windows, it is always opened
#    in a new window (see @see "1. The MATLAB server running in MATLAB").
#    If this argument is @TRUE, the new window is minimized, otherwise not.
#    This argument is ignored on non-Windows systems.}
#  \item{options}{A @character @vector of options used to call the
#    MATLAB application.}
#  \item{workdir}{The working directory to be used by MATLAB.}
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns nothing.
# }
#
# \details{
#   This method is currently supported on Windows and Unix systems. Other
#   systems are untested, but might work anyway.
#
#   Note that this method will return immediately upon calling
#   \code{system()} internally, i.e. you will not receive a return value
#   telling wether MATLAB was successfully started or not.
#
#   To specify the full path to the matlab software set the \code{matlab}
#   option, e.g. \code{options(matlab="/opt/bin/matlab6.1")}. If no such
#   option exists, the value \code{"matlab"} will be used.
#
#   The MATLAB server relies on two files:
#   1) MatlabServer.m and 2) InputStreamByteWrapper.class
#   These files exists in the externals/ and java/ directories of this
#   package. However, if they do not exist in the current directory,
#   which is the directory where MATLAB is started, copies of them will
#   automatically be made.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("startServer", "Matlab", function(this, matlab=getOption("matlab"), port=9999, minimize=TRUE, options=c("nodesktop", "nodisplay", "nosplash"), workdir=".", ...) {
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Validate arguments
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Argument 'port':
  if (!is.null(port)) {
    port <- Arguments$getInteger(port, range=c(1023,65535));
    Sys.setenv("MATLABSERVER_PORT"=port);
  }

  # Argument 'workdir':
  workdir <- Arguments$getWritablePath(workdir);


  enter(this$.verbose, "Starting the MATLAB server");
  on.exit(exit(this$.verbose), add=TRUE);

  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Set working directory
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  if (!is.null(workdir) && (workdir != ".")) {
    opwd <- setwd(workdir);
    on.exit(setwd(opwd), add=TRUE);
    cat(this$.verbose, level=-1, "MATLAB working directory: ", getwd());
  }


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Make MATLAB server files available in the current directory
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  src1 <- system.file(package="R.matlab", "externals", "MatlabServer.m");
  src2 <- system.file(package="R.matlab", "java", "InputStreamByteWrapper.class");
  srcs <- c(src1, src2);
  for (src in srcs) {
    filename <- basename(src);
    enter(this$.verbose, level=-1, sprintf("MATLAB server file '%s'", filename));
    copyFile(src, filename, overwrite=TRUE, verbose=less(this$.verbose, 50));

    # Sanity check
    filename <- Arguments$getReadablePathname(filename, mustExist=TRUE);

    exit(this$.verbose);
  } # for (filename ...)


  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  # Setup call string to start MATLAB
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
  cmd <- matlab;
  if (is.null(cmd))
    cmd <- "matlab";

  OST <- .Platform$OS.type;
  if (OST == "windows") {
    optionPrefix <- "/";
    if (minimize)
      options <- c(options, "minimize");
  } else {
    optionPrefix <- "-";
  }
  options <- c(options, "r MatlabServer");
  options <- paste(optionPrefix, options, sep="");
  options <- paste(options, collapse=" ");
  cmd <- paste(cmd, options, sep=" ");
  if (OST != "windows")
    cmd <- paste(cmd, "&", sep=" ");
  printf(this$.verbose, level=-1, "MATLAB server start command: '%s'\n", cmd);

  if (OST == "windows") {
    res <- system(cmd, wait=FALSE);
  } else {
    res <- system(cmd);
  }

  printf(this$.verbose, level=-1, "Return value: %d\n", as.integer(res));

  res;
}, static=TRUE)





###########################################################################/**
# @RdocMethod evaluate
#
# @title "Evaluates a MATLAB expression"
#
# \description{
#  Evaluates one or several MATLAB expressions on the MATLAB server. This
#  method will not return until the MATLAB server is done.
#
#  If an error occurred in MATLAB an exception will be thrown. This
#  exception can be caught by \code{\link[base:conditions]{tryCatch}()}.
#
#  If you receive error message \emph{Expected an 'answer' from MATLAB,
#  but kept receiving nothing}, see "Troubleshooting" under ?R.matlab.
# }
#
# @synopsis
#
# \arguments{
#   \item{...}{One or several string with MATLAB expressions. If several
#     strings are given they will be concatenated with the separator
#     \code{collapse}.}
#   \item{collapse}{Separator to be used to concatenate expressions.}
#   \item{capture}{If @TRUE, MATLAB output is captured into a string,
#     otherwise not.}
# }
#
# \value{
#   If \code{caputure} is @TRUE, then a @character string of MATLAB output
#   is returned, otherwise the MATLAB status code.
#   The MATLAB status code is also/always returned as attribute \code{status}.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("evaluate", "Matlab", function(this, ..., collapse=";", capture=FALSE) {
  capture <- Arguments$getLogical(capture)

  expr <- paste(..., collapse=collapse)

  printf(this$.verbose, level=0, "Sending expression on the MATLAB server to be evaluated...: '%s'\n", expr)

  cmd <- if (capture) "evalc" else "eval"
  writeCommand(this, cmd)
  Java$writeUTF(this$con, expr)

  ## Retrieve result from MATLAB - throws exception if error
  status <- readResult(this)

  statusT <- if (is.null(status)) 0L else as.integer(status)
  printf(this$.verbose, level=0, "Evaluated expression on the MATLAB server with return code %d.\n", statusT)

  if (capture) {
    statusT <- Java$readUTF(this$con)
    attr(statusT, "status") <- status
    status <- statusT
  } else {
    attr(status, "status") <- status
  }

  invisible(status)
})



###########################################################################/**
# @RdocMethod getVariable
#
# @title "Gets one or several MATLAB variables"
#
# \description{
#   Gets one or several MATLAB variables from the MATLAB server.
#   The transfer of the data can be done locally via a temporary file
#   (\code{remote=FALSE}) or through the socket @connection (\code{remote=TRUE}),
#   which is always available.
# }
#
# @synopsis
#
# \arguments{
#  \item{variables}{String vector of MATLAB containing names of variable that
#   are to be retrieved from the MATLAB server.}
#  \item{remote}{If @TRUE the variables are transferred on the
#   socket @connection, otherwise they are transferred via a temporary file.}
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns a \code{list} structure containing the MATLAB variables as named
#   values.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("getVariable", "Matlab", function(this, variables, remote=this$remote, ...) {
  vars <- paste("'", variables, "'", sep="");
  vars <- paste(vars, collapse=", ");

  printf(this$.verbose, level=0, "Retrieving variables from the MATLAB server: %s\n", vars);

  expr <- paste("MatlabServer_variables = {", vars, "};", sep="");
  answer <- evaluate(this, expr);

  if (remote == FALSE) {
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Communication of data via the file system
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    printf(this$.verbose, level=-1, "Asks the MATLAB server to send variables via the local file system...\n");

    writeCommand(this, "send");
    result <- Java$readInt(this$con);
    if (result == -1L) {
      lasterr <- Java$readUTF(this$con);
      Java$writeByte(this$con, 0);  # Send ACK back to Matlab
      throw("MatlabException: ", lasterr);
    }
    filename <- Java$readUTF(this$con);
    printf(this$.verbose, level=-1, "Reading variables from the local MAT file '%s'...\n", filename);

    data <- readMat(filename);
  } else {
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Communication of data via data stream
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    printf(this$.verbose, level=-1, "Asks the MATLAB server to send variables via the socket connection...\n");

    writeCommand(this, "send-remote");
    maxLength <- Java$readInt(this$con);
    printf(this$.verbose, level=-1, "Will read a MAT file of length %.0f bytes...", maxLength);

    if (maxLength == -1) {
      lasterr <- Java$readUTF(this$con);
      Java$writeByte(this$con, 0);  # Send ACK back to Matlab
      throw("MatlabException: ", lasterr);
    }
    data <- readMat(this$con, maxLength=maxLength);
  }
  printf(this$.verbose, level=0, "Retrieved the variables via a MAT file structure:\n");
  str(this$.verbose, level=0, data);

  printf(this$.verbose, level=-1, "Replying to the MATLAB server that the data was retrieve successfully: 0\n");

  Java$writeByte(this$con, 0);

  data;
});



###########################################################################/**
# @RdocMethod setVariable
#
# @title "Sets one or several MATLAB variables"
#
# \description{
#   Sets one or several \R variables on the MATLAB server.
#   The transfer of the data can be done locally via a temporary file
#   (\code{remote=FALSE}) or through the socket @connection (\code{remote=TRUE}),
#   which is always available.
# }
#
# @synopsis
#
# \arguments{
#   \item{...}{Named \R variables to be set in MATLAB.}
#   \item{remote}{If @TRUE the variables are transferred on the
#     socket @connection, otherwise they are transferred via a temporary file.}
# }
#
# \value{
#   Returns nothing. If the MATLAB server did not received the variables
#   successfully an exception is thrown.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("setVariable", "Matlab", function(this, ..., remote=this$remote) {
  printf(this$.verbose, level=-1, "Sends R variables to the MATLAB server: %s\n", paste(paste("'", names(list(...)), "'", sep=""), collapse=", "));
  enter(this$.verbose, "Setting MATLAB variable on server");
  on.exit(exit(this$.verbose), add=TRUE);

  if (remote == FALSE) {
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Communication of data via the file system
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    printf(this$.verbose, level=-1, "Sends R variables to the MATLAB server via the local file system...\n");

    # Write to file first to get file size...
    tmpname <- paste(tempfile(), ".mat", sep="");
    on.exit(unlink(tmpname));
    printf(this$.verbose, level=-1, "Writes R variables to the MAT file '%s'...\n", tmpname);

    writeMat(tmpname, ...);  # Write first and then tell MATLAB to read.
    printf(this$.verbose, level=-1, "Writes R variables to the MAT file '%s'...ok\n", tmpname);
    printf(this$.verbose, level=-1, "Tells the MATLAB server where to find the MAT file.\n");

    writeCommand(this, "receive");
    Java$writeUTF(this$con, tmpname);
  } else {
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -
    # Communication of data via data stream
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - -

    # This requires that InputStreamByteWrapper is in the Java CLASSPATH of
    # MATLAB, otherwise an error will be given in MATLAB, but not before this
    # command is sent.

    printf(this$.verbose, level=-1, "Sends R variables to the MATLAB server via the socket connection...\n");

    writeCommand(this, "receive-remote");
    # Note the usage of onWrite to write the length before sending the
    # MAT file structure.
    writeMat(this$con, ..., onWrite=function(x) Java$writeInt(this$con, x$length));
  }

  # Wait for MATLAB to tell if it received the variables sucessfully or not.
  printf(this$.verbose, level=-1, "Waits for the MATLAB server to reply...\n");

  answer <- Java$readByte(this$con);
  printf(this$.verbose, level=-1, "Received a reply from the MATLAB server: %d\n", answer);

  invisible(answer);
});



###########################################################################/**
# @RdocMethod setFunction
#
# @title "Defines a MATLAB function"
#
# \description{
#   Creates an M-file on the MATLAB server machine (in the working directory)
#   containing the specified MATLAB function definition.
# }
#
# @synopsis
#
# \arguments{
#  \item{code}{The MATLAB function definition.}
#  \item{name}{Optional name of the function, which will defined the
#     name of the M-file where the function is stored. If @NULL,
#     the name is extracted from the code.}
#  \item{collapse}{The string that the code lines, if there are more than
#     one, is going to be concattenated with.}
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns nothing.
# }
#
# \examples{\dontrun{@include "../incl/Matlab.setFunction.Rex"}}
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("setFunction", "Matlab", function(this, code, name=NULL, collapse="\n", ...) {
  enter(this$.verbose, "Setting MATLAB function on server");
  on.exit(exit(this$.verbose), add=TRUE);

  printf(this$.verbose, level=-1, "Building MATLAB source code for the function to be passed to the MATLAB server...\n");
  code <- paste(code, collapse=collapse);

  pos <- regexpr("^[ \t\n\r\v]*function[^=]*=[^ \t\n\r\v(]", code);
  if (pos == -1) {
    throw("The code does not contain a proper MATLAB function definition: ", substring(code, 1, 20), "...");
  }

  if (is.null(name)) {
    nameStart = as.integer(pos + attr(pos, "match.length") - 1L);
    pos <- regexpr("^[ \t\n\r\v]*function[^=]*=[^( \t\n\r\v]*[( \t\n\r\v]", code);
    if (pos == -1) {
      throw("The code does not contain a open parentesis ('(') or a whitespace that defines the end of the function name: ", substring(code, 1, 20), "...");
    }
    nameStop = as.integer(pos + attr(pos, "match.length") - 2L);
    name <- substring(code, nameStart, nameStop);
  }

  printf(this$.verbose, level=-1, "Building MATLAB source code for the function to be passed to the MATLAB server...done\n");
  printf(this$.verbose, level=-2, "Function name: %s\n", name);
  str(this$.verbose, level=-2, code);

  filename <- paste(name, ".m", sep="");
  setVariable(this, MatlabServer_tmp_fcndef=list(name=name, filename=filename, code=code));
  expr <- "MatlabServer_tmp_fid = fopen(MatlabServer_tmp_fcndef.filename, 'w'); fprintf(MatlabServer_tmp_fid, '%s', MatlabServer_tmp_fcndef.code); fclose(MatlabServer_tmp_fid); rehash; clear MatlabServer_tmp_fcndef MatlabServer_tmp_fid;";
  res <- evaluate(this, expr);
});




###########################################################################/**
# @RdocMethod setVerbose
#
# @title "Sets the verbose level to get more details about the MATLAB access"
#
# \description{
#   @get "title".
# }
#
# @synopsis
#
# \arguments{
#  \item{threshold}{A threshold that the \code{level} argument
#     of any write method has to be equal to or larger than in order to the
#     message being written.
#     Thus, the lower the threshold is the more and more details will be
#     outputted. If a large @numeric or @FALSE, no verbose output will be
#     given.}
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns the previous threshold value (an @integer) used.
# }
#
# \details{
#   If the threshold is set to zero (default) general comments about the
#   MATLAB access is given, such as the MATLAB server is started etc.
#   If the threshold is \code{-1}, details about the communication with the
#   MATLAB server is given.
#   If the threshold is \code{-2}, low-level details about the communication
#   with the MATLAB server is given, such as what commands are sent etc.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("setVerbose", "Matlab", function(this, threshold=0, ...) {
  verbose <- this$.verbose;
  oldThreshold <- getThreshold(verbose);

  if (identical(threshold, FALSE)) {
    verbose <- NullVerbose();
  } else {
    verbose <- Verbose();
  }
  setThreshold(verbose, threshold);

  this$.verbose <- verbose;

  invisible(oldThreshold);
})





############################################################################
# HISTORY:
# 2015-01-08
# o BUG FIX: Matlab$getVariable() for a non-existing variable would
#   crash the R-to-Matlab communication if remote=FALSE.
# 2014-12-17
# o ROBUSTNESS: Now Matlab$startServer() always overwrites any existing
#   'MatlabServer.m' and 'InputStreamByteWrapper.class' to make sure the
#   most recent versions are used.
# 2014-10-10
# o CRAN POLICIES/CLEANUP: Matlab$startServer() no longer copies the
#   InputStreamByteWrapper.java, only the *.class file, which was moved
#   to java/ of the *installed* package.
# 2014-07-24
# o Added section on parallel MATLAB instances to help('Matlab').
# 2014-06-22
# o Added argument 'workdir' to Matlab$startServer().
# 2014-01-28
# o CLEANUP: open() for Matlab no longer generates warnings on
#   "socketConnection(...) ... cannot be opened", which occured while
#   waiting/polling for the Matlab server to startup and respond.
# o ROBUSTNESS: Now Matlab$startServer() asserts that all MATLAB server
#   files that are indeed successfully copied.
# 2014-01-21
# o TYPO: A closed Matlab connection would report that the "...MATLAB
#   server is is closed (not opened)." - note "is is".
# 2011-12-08
# o DOCUMENTATION: Added a section to help(Matlab) on how to connect
#   through firewalls.
# 2010-10-26
# o Clarified and corrected some sentences the help(Matlab).
# 2010-08-27
# o Updated example(Matlab) slightly.
# o Clarified the Rdoc for Matlab.
# 2007-01-22
# o Replaced Sys.putenv() with new Sys.setenv().
# 2006-12-28
# o Updated Rdoc for evaluate() to say that it returns NULL (not 0).
# o Now open() throws an error if connection to MATLAB failed.
# o Argument 'port' of startServer() now defaults to '9999' to make it more
#   explicit what the default port is.
# 2006-12-27
# o Added setVerbose() to the example of Matlab.
# 2006-08-24
# o Added more details on available options in setOption().
# 2006-08-15
# o A user confirmed that the MATLAB Server works with MATLAB v7.2.0.232.
# 2006-01-21
# o Added argument 'port' to Matlab$startServer(..., port=NULL).
# o Added another MATLAB version that is confirmed to work with the package.
# 2005-06-10
# o Now R.utils is loaded by the constructor and all static methods.
# 2005-06-09
# o Now making use of the new NullVerbose() class.
# 2005-05-26
# o Modified setVerbose() slighty.
# 2005-05-03
# o Moved "external" files such as MatlabServer.m to inst/externals/.
# 2005-02-24
# o Removed the use of trycatch() in favor of tryCatch().
# o Updated the Rdoc comments. Now there is a specific MATLAB v7 and higher
#   section and one for MATLAB v6.
# 2005-02-15
# o Added arguments '...' in order to match any generic functions.
# 2005-02-11
# o Added Rdoc comments about security.
# o Added Rdoc comments about currently supported MATLAB version.
# o Removed an old getClass().
# 2005-02-10
# o Added Rdoc comments to all methods.
# 2004-02-24
# o Added as.character().
# o Added a lot of verbose code at different verbose levels for all
#   methods.
# o Added setVerbose() and getVerbose() based on the Verbose class.
# o WORK AROUND: It sometimes happens that the reply from MATLAB is not
#   transferred "quick enough" and even if the connection should block we
#   receive NULL giving an error. The work around for now is to try to
#   read the answer again. The symptom was that an error in readResult()
#   complain about "if (answer == 0)" where answer was of length 0.
#   This work around was done in readResult() only for now.
# 2003-11-25
# o Since readMAT() was renamed readMat() (and same for writeMAT()) this
#   file had to be updated.
# 2003-04-04
# o Added more help about starting the MATLAB server.
# 2003-01-16
# o Now require(R.io) is loaded with the package and not when the first
#   MATLAB client/server method is called. The former approach was a little
#   bit annoying.
# 2002-10-23
# o Class now making use of static class Java when reading and writing
#   data types to and from the connection.
# 2002-09-05
# o Added 'hehash' in setFunction() to make MATLAB find the new function.
# 2002-09-03
# o Added setFunction().
# o Improved open() with option to retry several times.
# o Cleaned up the code and wrote up the Rdoc comments.
# 2002-08-26
# o Created.
############################################################################

