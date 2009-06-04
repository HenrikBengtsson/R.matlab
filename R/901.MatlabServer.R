#########################################################################/**
# @RdocDocumentation "1. The Matlab server running in Matlab"
#
# \description{
#  This section gives addition details on the Matlab server.
#  At the end, the MatlabServer.m script and the 
#  InputStreamByteWrapper.java code is shown.
# }
#
# \section{Starting the Matlab server on Windows}{
#  Note that you "cannot prevent Matlab from creating a window when 
#  starting on Windows systems, but you can force the window to be hidden, 
#  by using " the option -minimize. 
#  See \url{http://www.mathworks.com/support/solutions/data/1-16B8X.html}
#  for more information.
# }
#
# \section{MatlabServer.m script}{
#  \preformatted{
#   @include "../inst/externals/MatlabServer.m"
#  }\emph{}
# }
#
# \section{InputStreamByteWrapper.(class|java) script}{
#  The Java class InputStreamByteWrapper is needed in order for Matlab to
#  \emph{receive} \emph{data} via a data stream. \R sends data via a data
#  stream if, and only if, the connection was setup for "remote" 
#  communication, that is, with argument \code{remote=TRUE}). 
#
#  \preformatted{
#   @include "../inst/externals/InputStreamByteWrapper.java"
#  }\emph{}
# }
#*/#########################################################################  

