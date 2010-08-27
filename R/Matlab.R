###########################################################################/**
# @RdocClass Matlab
#
# @title "Matlab client for remote or local Matlab access"
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
#   \item{remote}{If @TRUE, all data to and from the Matlab server will
#      be transferred through the socket @connection, otherwise the data will
#      be transferred via a temporary file.}
# }
#
# \section{Fields and Methods}{
#  @allmethods
# }
#
# \section{Requirements}{
#   In order for \R to communicate with Matlab, Matlab v6 or higher is
#   needed. It will \emph{not} work with previous versions, because they
#   do not support Java!\cr
#
#   We use the term \emph{server} to say that Matlab acts like a server
#   with regard to \R. Note that it a standard Matlab session that runs.\cr
#
#   Also, the starting of the MatlabServer is simplier from Matlab v7,
#   although it is pretty straightforward for Matlab v6 too
#   (this has to do with the fact that in Matlab v7, the for 
#   remote-data-transfer required Java class can be dynamically 
#   added to the Matlab Java classpath).
# }
#
# \section{Remote and non-remote connections}{
#   When a remote connection (argument \code{remote=TRUE}) is used, 
#   data is send to and from Matlab via a data stream. This is needed
#   when \R is running on a host with a seperated file system than
#   the one Matlab is running on.
#
#   If not connection "remotely" (\code{remote=FALSE}), data is 
#   communicated via the file system, that is, by saving and reading 
#   it to temporary MAT files. \cr
#
#   Troubleshooting: If "remote" transfers are used, the 
#   InputStreamByteWrapper Java class must be found by Matlab,
#   otherwise an error will occur in Matlab as soon as data is
#   send from \R to Matlab. In all other cases, the above Java class
#   is \emph{not} needed.
# }
#
# \section{Starting the Matlab server from within \R}{
#   The Matlab server may be started from within \R by
#   calling \code{Matlab$startServer()}. By default 'matlab' is called; 
#   if named differently set \code{options(matlab="matlab6.5")}, say.
#   \emph{The method is experimental and may not work on your system.}
#   By default the Matlab server listens for connections on port 9999.
#   For other ports, set argument \code{port}, e.g.
#   \code{Matlab$startServer(port=9998)}.
#
#   Note that the code will \emph{not} halt and wait for Matlab to get
#   started. Thus, you have to make sure you will wait long enough for
#   the server to get up and running before the \R client try to 
#   connect. By default, the client will try once a second for 30 seconds
#   before giving up.
#   Moreover, on non-Windows systems, the above command will start Matlab
#   in the background making all Matlab messages be sent to the \R output
#   screen. 
#   In addition, the method will copy the MatlabServer and 
#   InputStreamByteWrapper files to the current directory and start
#   Matlab from there. 
# }
#
# \section{Starting the Matlab server without \R}{
#   If the above does not work, the Matlab server may be started manually
#   from Matlab itself.  Please follow the below instructions carefully.
#
#   \bold{To be done once:}\cr
#   In Matlab, add the path to the directory where MatlabServer.m sits.
#   See \code{help pathtool} in Matlab on how to do this.
#   In R you can type \code{system.file("externals", package="R.matlab")} 
#   to find out the path to MatlabServer.m.
#   
#   \bold{For Matlab v6 only:} Contrary to Matlab v6, Matlab v6 cannot
#   find the InputStreamByteWrapper class automatically. Instead, the
#   so called Java classpath has to be set. In Matlab, type 
#   \code{which('classpath.txt')} to find where the default 
#   Matlab classpath.txt file is located. Copy this file to the
#   \emph{current directory}, and append the \emph{path} (the directory) 
#   of InputStreamByteWrapper.class to the end of classpath.txt.
#   The path of InputStreamByteWrapper.class should be the same as 
#   the path of the MatlabServer.m that you identified above.\cr
#
#   \bold{Lazy alternative:} Instead of setting path and classpaths,
#   you may try to copy the MatlabServer.m and InputStreamByteWrapper.class 
#   to the current directory from which Matlab is then started.
#
#   \bold{To start the server:}\cr
#   In order to start the Matlab server, type\cr
#
#   \code{matlab -nodesktop -nosplash -r MatlabServer}\cr
#
#   If using Matlab v6, make sure your \code{classpath.txt} is the 
#   current directory!
#
#   This will start Matlab and immediately call the MatlabServer(.m)
#   script. Here is how it should look like when the server starts:
#   \preformatted{
#    @include{../incl/MatlabServer.out}
#   }
#   Alternatively you can start Matlab and type \code{MatlabServer}
#   at the prompt.
#
#   By default the Matlab server listens for connections on port 9999.
#   For other ports, set environment variable \code{MATLABSERVER_PORT}.
# }
#
# \section{Confirmed Matlab versions}{
#   This package has been confirmed to work \emph{successfully} out of 
#   the box together with:
#   Matlab v6.1.0.450 (R12.1), 
#   Matlab v6.5.0.180913a (R13),
#   Matlab v7.0.0.19901 (R14), 
#   Matlab v7.0.1.24704 (R14SP1),
#   Matlab v7.0.4.365 (R14SP2),
#   Matlab v7.2.0.232 (R2006a), 
#   Matlab 7.4.0 (R2007a), and
#   Matlab 7.7.0.471 (R2008b), and
#   Matlab version 7.10.0.499 (R2010a).
#   If you successfully use a different/higher Matlab version, 
#   please tell us, so we can share it here.
#
#   It does \emph{not} work with Matlab v5 or before!
# }
#
# \section{Security}{
#   There is \emph{no} security in the communication with the Matlab
#   server. This means that if you start the Matlab server, it will
#   wait for requests via the connection at the specified port. As
#   long as your \R session has not connected to this port, others
#   may be able to steal the connection and send malicious commands
#   (if they know the R.matlab protocol). The Matlab server only
#   allows one connection. In other words, if you are connected it
#   is not possible for others to connect to the Matlab server.
# }
#
# \section{Matlab server is timing out}{
#   It might be that an @seemethod "evaluate" call to the Matlab server
#   takes a long time for the server to finish resulting in a time-out
#   exception.  By default this happens after 30 seconds, but it can
#   be changed by modifying options, cf. @see "setOption".
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
  # By loading R.utils here, it is not required if only readMat() is used.
  require("R.utils") || throw("Package not available: R.utils");

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
# @title "Gets a string describing the current Matlab connection"
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

  s <- sprintf("%s: The Matlab host is '%s' and communication goes via port %d.", class(this)[1], this$host, this$port);
  s <- sprintf("%s Objects are passed via the %s (remote=%s).", s,
         (if (this$remote) "socket connection" else "local file system"),
         as.character(this$remote)
       );
  s <- sprintf("%s The connection to the Matlab server is %s.", s,
         (if (isOpen(this)) "opened" else "is closed (not opened)")
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
#      is check for an answer from the Matlab server before giving up.
#      Default values is 30 times.}
#   \item{readResult/interval}{The interval in seconds between each poll
#      for an answer.  Default interval is 1 (second).}
#  }
#
#  With default values of the above options, the \R Matlab client waits 
#  30 seconds for a reply from the Matlab server before giving up.
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
# @title "Tries to open a connection to the Matlab server"
#
# \description{
#   Tries to open a socket connection to the Matlab server. If the connection
#   could not be opened it the first time it will try to open it every
#   \code{interval} second up to \code{trials} times. 
# }
#
# @synopsis
#
# \arguments{
#  \item{trials}{The number of trials before giving up.}
#  \item{interval}{The interval in seconds between trials.}
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns @TRUE if a socket @connection to the Matlab server was
#   successfully opened, otherwise @FALSE.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("open", "Matlab", function(con, trials=30, interval=1, ...) {
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
      this$con <- socketConnection(host=this$host, port=as.integer(this$port), open="a+b", blocking=TRUE);
      ok <- TRUE;
      # It is not possible to return() from tryCatch()! /HB 050224
    }, error = function(ex) {
      # The Matlab server is not up and running yet. 
      # Wait a bit and try again.
      Sys.sleep(interval);
      count <<- count + 1;
    })

    if (ok) {
      # Connection to Matlab server was successful!
      return(TRUE);
    }
  } # while (count < trials)

  suffix <- sprintf("...failed (after %d tries)", as.integer(count));

  throw(sprintf("Failed to connection to Matlab on host '%s' (port %d) after trying %d times for approximately %.1f seconds.", this$host, as.integer(this$port), count, count*interval));

  return(FALSE);
});





###########################################################################/**
# @RdocMethod isOpen
#
# @title "Checks if connection to the Matlab server is open"
#
# \description{
#  Checks if connection to the Matlab server is open.
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
  # isOpen() is already a generic function in 'base'.
  this <- con;
  (!is.null(this$con) && isOpen(this$con))
})



###########################################################################/**
# @RdocMethod finalize
#
# @title "Finalizes the object if deleted"
#
# \description{
#   @get "title". If a Matlab connection is opened, it is closed.
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
})



###########################################################################/**
# @RdocMethod close
#
# @title "Closes connection to Matlab server"
#
# \description{
#  Closes connection to Matlab server. After closing the connection the Matlab
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
    printf(this$.verbose, level=-2, "Sending a command to the Matlab server telling it to close down...\n");

    writeCommand(this, "quit");
    printf(this$.verbose, level=-2, "Sending a command to the Matlab server telling it to close down...ok\n");

    printf(this$.verbose, level=-2, "Waiting for a reply from the Matlab server...\n");

    res <- readResult(this);
    resStr <- if (is.null(res)) 0 else res;
    printf(this$.verbose, level=-2, "Waiting for a reply from the Matlab server...ok: '%d'\n", as.integer(resStr));

    if (!is.null(res)) {
      warning(res);
    }
    printf(this$.verbose, level=-2, "Closing the connection to the Matlab server...\n");
    close(this$con);
    this$con <- NULL;
    printf(this$.verbose, level=-2, "Closing the connection to the Matlab server...ok\n");
  } else if (!is.null(this$con)) {
   suffix <- "...already closed";
   warning("Matlab session is already closed.");
  }
});




###########################################################################/**
# @RdocMethod writeCommand
#
# @title "Writes (sends) a command to the Matlab server"
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
    commands <- c("quit", "", "eval", "send", "receive", "send-remote", "receive-remote", "echo");
    if (!is.element(cmd, commands))
      return(as.integer(0));
    as.integer(which(commands == cmd) - 2);
  }

  b <- getCommandByte(this, cmd);
  
  printf(this$.verbose, level=-2, "Sending a command '%s' (%d) to the Matlab server...\n", cmd, as.integer(b));
  
  res <- Java$writeByte(this$con, b);
  
  printf(this$.verbose, level=-2, "Sending a command '%s' (%d) to the Matlab server...ok\n", cmd, as.integer(b));
  
  res;
}, private=TRUE);



###########################################################################/**
# @RdocMethod readResult
#
# @title "Reads results from the Matlab server"
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
  # and that the 'answer' Matlab sends is not transfered in time. In
  # other words, if we try again a little bit later it seems to work.
  # This is should be considered a temporary work-around until we
  # understand what really happens. /HB 2004-02-24
  # Thomas Romary, France, reported the a similar problem on 2005-05-25
  # for his 30 minutes Matlab process. Added the option for users to set
  # the number times and at what intervals (in sections) readResult()
  # should query Matlab for. /HB 2005-05-25
  maxTries <- getOption(this, "readResult/maxTries", defaultValue=30);
  interval <- getOption(this, "readResult/interval", defaultValue=1);

  count <- 0;
  ready <- FALSE;
  while (!ready) {
    count <- count + 1;
    printf(this$.verbose, level=-2, "Retrieve reply from the Matlab server (try %d)...\n", as.integer(count));

    answer <- Java$readByte(this$con);
    ready <- (length(answer) > 0);
    if (!ready) {
      printf(this$.verbose, level=-2, "Strange! Received an \"empty\" reply although the connection should be blocking. Will try again...\n");
      if (count <= maxTries) {
        Sys.sleep(interval);
      } else {
        throw("Excepted an 'answer' from Matlab, but kept receiving nothing. Tried ", maxTries, " times at intervals of approximately ", interval, " seconds. To change this, see ?setOption.Matlab.");
      }
    }
  }

  if (answer == 0) {
    printf(this$.verbose, level=-1, "Received an 'OK' reply (%d) from the Matlab server.\n", answer);

    res <- NULL;
  } else if (answer == -1) {
    lasterr <- Java$readUTF(this$con);
    printf(this$.verbose, level=-1, "Received an 'MatlabException' reply (%d) from the Matlab server: '%s'\n", answer, as.character(lasterr));
    throw("MatlabException: ", lasterr);
  } else {
    printf(this$.verbose, level=-1, "Received an generic reply from the Matlab server: %d\n", answer);
    res <- answer;
  }
  res;
}, private=TRUE);





###########################################################################/**
# @RdocMethod startServer
#
# @title "Static method which starts a Matlab server"
#
# \description{
#  Static method which starts a Matlab server on the local machine. Note
#  that Matlab v6 or later is required, since the Matlab server relies on
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
#    set specifying which port the Matlab server should listen to for
#    clients trying to connect.  The default port is 9999.}
#  \item{minimize}{When starting Matlab on Windows, it is always opened
#    in a new window (see @see "1. The Matlab server running in Matlab"). 
#    If this argument is @TRUE, the new window is minimized, otherwise not.
#    This argument is ignored on non-Windows systems.}
#  \item{options}{A @character @vector of options used to call the
#    Matlab application.}
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
#   telling wether Matlab was successfully started or not.
#
#   To specify the full path to the matlab software set the \code{matlab}
#   option, e.g. \code{options(matlab="/opt/bin/matlab6.1")}. If no such
#   option exists, the value \code{"matlab"} will be used.
#
#   The Matlab server relies on two files: 1) MatlabServer.m and
#   2) InputStreamByteWrapper.class (from InputStreamByteWrapper.java).
#   These files exists in the externals/ directory of this package. However,
#   if they do not exist in the current directory, which is the directory
#   where Matlab is started, copies of them will automatically be made.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("startServer", "Matlab", function(this, matlab=getOption("matlab"), port=9999, minimize=TRUE, options=c("nodesktop", "nodisplay", "nosplash"), ...) {
  # By loading R.utils here, it is not required if only readMat() is used.
  require("R.utils") || throw("Package not available: R.utils");

  # Argument 'port':
  if (!is.null(port)) {
    port <- Arguments$getInteger(port, range=c(1023,65535));
    Sys.setenv("MATLABSERVER_PORT"=port);
  }

  enter(this$.verbose, "Starting the Matlab server");
  on.exit(exit(this$.verbose), add=TRUE);

  # Make sure MatlabServer.m, InputStreamByteWrapper.class, and
  # InputStreamByteWrapper.java exist in the current directory, otherwise
  # create copies of them in the current directory.
  filename <- "MatlabServer.m";
  if (!file.exists(filename)) {
    src <- system.file("externals", filename, package="R.matlab");
    file.copy(src, filename, overwrite=FALSE);
    printf(this$.verbose, level=-1, "Matlab server file copied: '%s'\n", filename);
  } else {
    printf(this$.verbose, level=-1, "Matlab server file found: '%s'\n", filename);
  }
  
  filename <- "InputStreamByteWrapper.class";
  if (!file.exists(filename)) {
    src <- system.file("externals", filename, package="R.matlab");
    file.copy(src, filename, overwrite=FALSE);
    printf(this$.verbose, level=-1, "Matlab server file copied: '%s'\n", filename);
  } else {
    printf(this$.verbose, level=-1, "Matlab server file found: '%s'\n", filename);
  }
  
  filename <- "InputStreamByteWrapper.java";
  if (!file.exists(filename)) {
    src <- system.file("externals", filename, package="R.matlab");
    file.copy(src, filename, overwrite=FALSE);
    printf(this$.verbose, level=-1, "Matlab server file copied: '%s'\n", filename);
  } else {
    printf(this$.verbose, level=-1, "Matlab server file found: '%s'\n", filename);
  }
  
  # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
  # Setup call string to start Matlab
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
  printf(this$.verbose, level=-1, "Matlab server start command: '%s'\n", cmd);

  if (OST == "windows") {
    res <- system(cmd, wait=FALSE);
  } else {
    res <- system(cmd);
  }

  printf(this$.verbose, level=-1, "Return value: %d\n", as.integer(res));
  
  res;
}, static=TRUE);





###########################################################################/**
# @RdocMethod evaluate
#
# @title "Evaluates a Matlab expression"
#
# \description{
#  Evaluates one or several Matlab expressions on the Matlab server. This
#  method will not return until the Matlab server is done.
#
#  If an error occured in Matlab an exception will be thrown. This expection
#  can be caught by \code{\link[base:conditions]{tryCatch}()}.
#
#  If you receieve error message \emph{Excepted an 'answer' from Matlab, 
#  but kept receiving nothing}, see "Troubleshooting" under ?R.matlab.
# }
#
# @synopsis
#
# \arguments{
#   \item{...}{One or several string with Matlab expressions. If several
#     strings are given they will be concatenated with the separator 
#     \code{collapse}.}
#   \item{collapse}{Separator to be used to concatenate expressions.}
# }
#
# \value{
#   Returns (invisibly) @NULL if expressions were evaluated successfully. 
#   An exception might also be thrown.
# }
#
# @author
#
# \seealso{
#   @seeclass
# }
#*/###########################################################################
setMethodS3("evaluate", "Matlab", function(this, ..., collapse=";") {
  expr <- paste(..., collapse=collapse);
  
  printf(this$.verbose, level=0, "Sending expression on the Matlab server to be evaluated...: '%s'\n", expr);
  
  writeCommand(this, "eval");
  Java$writeUTF(this$con, expr);

  res <- readResult(this);

  resStr <- if (is.null(res)) 0 else res;
  printf(this$.verbose, level=0, "Evaluated expression on the Matlab server with return code %d.\n", as.integer(resStr));
  
  invisible(res);
})






###########################################################################/**
# @RdocMethod getVariable
#
# @title "Gets one or several Matlab variables"
#
# \description{
#   Gets one or several Matlab variables from the Matlab server. 
#   The transfer of the data can be done locally via a temporary file
#   (\code{remote=FALSE}) or through the socket @connection (\code{remote=TRUE}),
#   which is always available.
# }
#
# @synopsis
#
# \arguments{
#  \item{variables}{String vector of Matlab containing names of variable that
#   are to be retrieved from the Matlab server.}
#  \item{remote}{If @TRUE the variables are transferred on the 
#   socket @connection, otherwise they are transferred via a temporary file.}
#  \item{...}{Not used.}
# }
#
# \value{
#   Returns a \code{list} structure containing the Matlab variables as named
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

  printf(this$.verbose, level=0, "Retrieving variables from the Matlab server: %s\n", vars);

  expr <- paste("variables = {", vars, "};", sep="");
  answer <- evaluate(this, expr);
  
  if (remote == FALSE) {
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Communication of data via the file system
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    printf(this$.verbose, level=-1, "Asks the Matlab server to send variables via the local file system...\n");

    writeCommand(this, "send");
    filename <- Java$readUTF(this$con);
    printf(this$.verbose, level=-1, "Reading variables from the local MAT file '%s'...\n", filename);

    data <- readMat(filename);
  } else {
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Communication of data via data stream
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    printf(this$.verbose, level=-1, "Asks the Matlab server to send variables via the socket connection...\n");

    writeCommand(this, "send-remote");
    maxLength <- Java$readInt(this$con);
    printf(this$.verbose, level=-1, "Will read a MAT file of length %.0f bytes...", maxLength);

    if (maxLength == -1) {
      lasterr <- Java$readUTF(this$con);
      throw("MatlabException: ", lasterr);
    }
    data <- readMat(this$con, maxLength=maxLength);
  }
  printf(this$.verbose, level=0, "Retrieved the variables via a MAT file structure:\n");
  str(this$.verbose, level=0, data);

  printf(this$.verbose, level=-1, "Replying to the Matlab server that the data was retrieve successfully: 0\n");

  Java$writeByte(this$con, 0);

  data;
});



###########################################################################/**
# @RdocMethod setVariable
#
# @title "Sets one or several Matlab variables"
#
# \description{
#   Sets one or several \R variables on the Matlab server. 
#   The transfer of the data can be done locally via a temporary file
#   (\code{remote=FALSE}) or through the socket @connection (\code{remote=TRUE}),
#   which is always available.
# }
#
# @synopsis
#
# \arguments{
#   \item{...}{Named \R variables to be set in Matlab.}
#   \item{remote}{If @TRUE the variables are transferred on the 
#     socket @connection, otherwise they are transferred via a temporary file.}
# }
#
# \value{
#   Returns nothing. If the Matlab server did not received the variables
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
  printf(this$.verbose, level=-1, "Sends R variables to the Matlab server: %s\n", paste(paste("'", names(list(...)), "'", sep=""), collapse=", "));
  enter(this$.verbose, "Setting Matlab variable on server");
  on.exit(exit(this$.verbose), add=TRUE);
  
  if (remote == FALSE) {
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Communication of data via the file system
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    printf(this$.verbose, level=-1, "Sends R variables to the Matlab server via the local file system...\n");

    # Write to file first to get file size...
    tmpname <- paste(tempfile(), ".mat", sep="");
    on.exit(unlink(tmpname));
    printf(this$.verbose, level=-1, "Writes R variables to the MAT file '%s'...\n", tmpname);

    writeMat(tmpname, ...);  # Write first and then tell Matlab to read.
    printf(this$.verbose, level=-1, "Writes R variables to the MAT file '%s'...ok\n", tmpname);
    printf(this$.verbose, level=-1, "Tells the Matlab server where to find the MAT file.\n");

    writeCommand(this, "receive");
    Java$writeUTF(this$con, tmpname);
  } else {
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 
    # Communication of data via data stream
    # - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - - 

    # This requires that InputStreamByteWrapper is in the Java CLASSPATH of
    # Matlab, otherwise an error will be given in Matlab, but not before this
    # command is sent.

    printf(this$.verbose, level=-1, "Sends R variables to the Matlab server via the socket connection...\n");

    writeCommand(this, "receive-remote");
    # Note the usage of onWrite to write the length before sending the
    # MAT file structure.
    writeMat(this$con, ..., onWrite=function(x) Java$writeInt(this$con, x$length));
  }

  # Wait for Matlab to tell if it received the variables sucessfully or not.
  printf(this$.verbose, level=-1, "Waits for the Matlab server to reply...\n");

  answer <- Java$readByte(this$con);
  printf(this$.verbose, level=-1, "Received a reply from the Matlab server: %d\n", answer);
  
  invisible(answer);
});



###########################################################################/**
# @RdocMethod setFunction
#
# @title "Defines a Matlab function"
#
# \description{
#   Creates an M-file on the Matlab server machine (in the working directory)
#   containing the specified Matlab function definition.
# }
#
# @synopsis
#
# \arguments{
#  \item{code}{The Matlab function definition.}
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
  enter(this$.verbose, "Setting Matlab function on server");
  on.exit(exit(this$.verbose), add=TRUE);

  printf(this$.verbose, level=-1, "Building Matlab source code for the function to be passed to the Matlab server...\n");
  code <- paste(code, collapse=collapse);
  
  pos <- regexpr("^[ \t\n\r\v]*function[^=]*=[^ \t\n\r\v(]", code);
  if (pos == -1) {
    throw("The code does not contain a proper Matlab function defintion: ", substring(code, 1, 20), "...");
  }

  if (is.null(name)) {
    nameStart = as.integer(pos + attr(pos, "match.length")-1);
    pos <- regexpr("^[ \t\n\r\v]*function[^=]*=[^( \t\n\r\v]*[( \t\n\r\v]", code);
    if (pos == -1) {
      throw("The code does not contain a open parentesis ('(') or a whitespace that defines the end of the function name: ", substring(code, 1, 20), "...");
    }
    nameStop = as.integer(pos + attr(pos, "match.length")-2);
    name <- substring(code, nameStart, nameStop);
  }

  printf(this$.verbose, level=-1, "Building Matlab source code for the function to be passed to the Matlab server...done\n");
  printf(this$.verbose, level=-2, "Function name: %s\n", name);
  str(this$.verbose, level=-2, code);
  
  filename <- paste(name, ".m", sep="");
  setVariable(this, fcndef=list(name=name, filename=filename, code=code));
  expr <- "fid = fopen(fcndef.filename, 'w'); fprintf(fid, '%s', fcndef.code); fclose(fid); rehash;";
  res <- evaluate(this, expr);
});




###########################################################################/**
# @RdocMethod setVerbose
#
# @title "Sets the verbose level to get more details about the Matlab access"
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
#   Matlab access is given, such as the Matlab server is started etc.
#   If the threshold is \code{-1}, details about the communication with the
#   Matlab server is given.
#   If the threshold is \code{-2}, low-level details about the communication
#   with the Matlab server is given, such as what commands are sent etc.
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
# 2010-08-27
# o Updated example(Matlab) slightly.
# o Clarified the Rdoc for Matlab.
# 2007-01-22
# o Replaced Sys.putenv() with new Sys.setenv(). 
# 2006-12-28
# o Updated Rdoc for evaluate() to say that it returns NULL (not 0).
# o Now open() throws an error if connection to Matlab failed.
# o Argument 'port' of startServer() now defaults to '9999' to make it more
#   explicit what the default port is.
# 2006-12-27
# o Added setVerbose() to the example of Matlab.
# 2006-08-24
# o Added more details on available options in setOption().
# 2006-08-15
# o A user confirmed that the Matlab Server works with Matlab v7.2.0.232.
# 2006-01-21
# o Added argument 'port' to Matlab$startServer(..., port=NULL).
# o Added another Matlab version that is confirmed to work with the package.
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
# o Updated the Rdoc comments. Now there is a specific Matlab v7 and higher
#   section and one for Matlab v6.
# 2005-02-15
# o Added arguments '...' in order to match any generic functions. 
# 2005-02-11
# o Added Rdoc comments about security.
# o Added Rdoc comments about currently supported Matlab version.
# o Removed an old getClass().
# 2005-02-10
# o Added Rdoc comments to all methods.
# 2004-02-24
# o Added as.character().
# o Added a lot of verbose code at different verbose levels for all
#   methods.
# o Added setVerbose() and getVerbose() based on the Verbose class.
# o WORK AROUND: It sometimes happens that the reply from Matlab is not
#   transferred "quick enough" and even if the connection should block we
#   receive NULL giving an error. The work around for now is to try to
#   read the answer again. The symptom was that an error in readResult()
#   complain about "if (answer == 0)" where answer was of length 0.
#   This work around was done in readResult() only for now.
# 2003-11-25
# o Since readMAT() was renamed readMat() (and same for writeMAT()) this
#   file had to be updated.
# 2003-04-04
# o Added more help about starting the Matlab server.
# 2003-01-16
# o Now require(R.io) is loaded with the package and not when the first
#   Matlab client/server method is called. The former approach was a little
#   bit annoying.
# 2002-10-23
# o Class now making use of static class Java when reading and writing
#   data types to and from the connection.
# 2002-09-05
# o Added 'hehash' in setFunction() to make Matlab find the new function.
# 2002-09-03
# o Added setFunction().
# o Improved open() with option to retry several times.
# o Cleaned up the code and wrote up the Rdoc comments.
# 2002-08-26
# o Created.
############################################################################

