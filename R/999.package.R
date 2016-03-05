#########################################################################/**
# @RdocPackage R.matlab
#
# \description{
#   @eval "getDescription(R.matlab)"
#
#   In brief, this package provides a one-directional interface from
#   \R to MATLAB, with communication taking place via a TCP/IP connection
#   and with data transferred either through another connection or via
#   the file system. On the MATLAB side, the TCP/IP connection is handled
#   by a small Java add-on.
#
#   The methods for reading and writing MAT files are stable.
#   The \R to MATLAB interface, that is the Matlab class, is less
#   prioritized and should be considered a beta version.
#
#   For package history, see \code{showHistory(R.matlab)}.
# }
#
# \section{Requirements}{
#   This is a cross-platform package implemented in plain \R.
#   This package depends on the \pkg{R.oo} package [1].
#
#   To use the Matlab class or requesting verbose output messages, the
#   \link[R.utils:R.utils-package]{R.utils} package is loaded
#   when needed (and therefore required in those cases).
#
#   The \code{readMat()} and \code{writeMat()} methods do \eqn{not}
#   require a MATLAB installation neither do they depend on the
#   @see "Matlab" class.
#
#   To connect to MATLAB, MATLAB v6 or higher is required.
#   It does \emph{not} work with MATLAB v5 or before (because those
#   versions do not support Java).
#   For confirmed MATLAB versions, see the @see "Matlab" class.
# }
#
# \section{Installation}{
#   To install this package do\cr
#
#   \code{install.packages("R.matlab")}
# }
#
# \section{To get started}{
#   To get started, see:
#   \enumerate{
#     \item @see "readMat" and @see "writeMat" - For reading and writing MAT files (MATLAB is \emph{not} needed).
#     \item @see "Matlab" - To start MATLAB and communicate with it from \R.
#   }
# }
#
# \section{Miscellaneous}{
#   A related initiative is \emph{RMatlab} by Duncan Temple Lang
#   and Omegahat.  It provides a bi-directional interface between the
#   \R and MATLAB languages. For more details, see
#   \url{http://www.omegahat.net/RMatlab/}.
#   To call R from MATLAB on Windows (only), see \emph{MATLAB R-link}
#   by Robert Henson available at the MATLAB Central File Exchange
#   (\url{http://www.mathworks.com/matlabcentral/fileexchange/loadFile.do?objectId=5051}).
# }
#
# \section{How to cite this package}{
#   Whenever using this package, please cite as\cr
#
#   @howtocite "R.matlab"
# }
#
# \section{Troubleshooting}{
#   \bold{In general}:\cr
#   For trouble shooting in general, rerun erroneous function with
#   verbose/debug messages turned on. For \code{readMat()} and \code{writeMat()}
#   see their help. For communication with a MATLAB server, use
#   \preformatted{
#    matlab <- Matlab()
#    setVerbose(matlab, threshold=-2)
#   }
#   The lower the threshold is the more information you will see.\cr
#
#   \bold{Cannot connect to MATLAB}:\cr
#   If R fails to connect to MATLAB, make sure to try the example in
#   help(Matlab) first.  Make sure that the MATLAB server is running
#   before trying to connect to it from R first.  If MATLAB is running
#   but \code{open()} times out, make sure MATLAB is listening to the
#   same port that R is trying to connect to.  If that does not help,
#   try to increase the time-out limit, see help(open.Matlab).\cr
#
#   \bold{Expected an 'answer' from MATLAB, but kept receiving nothing.}:\cr
#     When launching a really long MATLAB process by \code{evaluate()}, you
#   may get the above error message.\cr
#   \emph{Reason:} This happens because \code{evaluate()} expect a reply
#   from MATLAB as soon as MATLAB is done. The waiting should be "blocked",
#   i.e. it should wait until it receives something. For unknown reasons,
#   this is not always happening. The workaround we have implemented is to
#   try \code{readResult/maxTries} waiting \code{readResult/interval} seconds
#   inbetween.\cr
#   \emph{Solution:}
#   Increase the total waiting time by setting the above options, e.g.
#   \preformatted{
#    setOption(matlab, "readResult/interval", 10); # Default is 1 second
#    setOption(matlab, "readResult/maxTries", 30*(60/10)); # ~30 minutes
#   }
# }
#
# \section{Wishlist}{
#  Here is a list of features that would be useful, but which I have
#  too little time to add myself. Contributions are appreciated.
#  \itemize{
#    \item Add a function, say, \code{Matlab$createShortcut()} which
#          creates a Windows shortcut to start the MATLAB server
#          by double clicking it. It should be possible to create
#          it in the current directory or to the Desktop.
#          Maybe it is possible to do this upon installation and
#          even to a Start -> All Programs -> R menu.
#    \item To improve security, update the MatlabServer.m script to
#          allow the user to specify a "password" to be send upon
#          connection from R in order for MATLAB to accept the
#          connection. This password should be possible to specify
#          from the command line when starting MATLAB. If not given,
#          no password is required.
#    \item Add additional methods to the Matlab class. For instance,
#          inline function in MATLAB could have its own method.
#    \item Wrap up common MATLAB commands as methods of the Matlab
#          class, e.g. \code{who(matlab)}, \code{clear(matlab)} etc.
#          Can this be done automatically using "reflection", so
#          that required arguments are automatically detected?
#    \item Add access to MATLAB variables via \code{"$"} and
#          \code{"$<-"}, e.g. \code{matlab$A} and
#          \code{matlab$A <- 1234}. Is this wanted?
#          Maybe the same for functions, e.g. \code{matlab$dice(1000)}.
#          Is it possible to return multiple return values?
#  }
#
#  If you consider implement some of the above, make sure it is not
#  already implemented by downloading the latest "devel" version!
# }
#
# \section{Acknowledgements}{
#   Thanks to the following people who contributed with valuable
#   feedback, suggestions, code and more:
#   \itemize{
#    \item Patrick Drechsler, Biocenter, University of Wuerzburg.
#    \item Spencer Graves.
#    \item Andy Jacobson, Atmospheric and Oceanic Sciences Program,
#          Princeton University.
#    \item Jason Riedy, Computer Science Division,
#          University of California, Berkeley.
#    \item Chris Sims, Department of Economics, Princeton University.
#    \item Frank Stephen, National Renewable Energy Laboratory.
#    \item Yichun Wei, Department of Biological Sciences,
#          University of Southern California.
#    \item Wang Yu, ECE Department, Iowa State University.
#   }
# }
#
# \section{License}{
#   The releases of this package is licensed under
#   LGPL version 2.1 or newer.
#
#   The development code of the packages is under a private licence
#   (where applicable) and patches sent to the author fall under the
#   latter license, but will be, if incorporated, released under the
#   "release" license above.
# }
#
# @author
#
# \section{References}{
# [1] @include "../incl/BengtssonH_2003.bib.Rdoc" \cr
# }
#*/#########################################################################
