# Extracts the function name from a MATLAB function definition.
#
# Given the source code of a MATLAB function, returns the name of the
# function as a single string.  Whitespace is allowed anywhere it is
# allowed in MATLAB, in particular between the '=' and the function
# name, e.g. 'function [win, aver] = dice(B)'.
#
# If 'code' does not contain a proper function definition, or if the end
# of the function name cannot be identified, an empty string is returned
# with attribute 'error' set to "missing-definition" or
# "missing-name-end", respectively.
parseMatlabFunctionName <- function(code) {
  code <- paste(code, collapse = "\n")

  ## A proper 'function ... = <name>' definition?
  pos <- regexpr("^[[:space:]]*function[^=]*=[[:space:]]*[^[:space:](]", code)
  if (pos == -1L) {
    res <- ""
    attr(res, "error") <- "missing-definition"
    return(res)
  }
  nameStart <- as.integer(pos + attr(pos, "match.length") - 1L)

  ## The function name ends at the first '(' or whitespace that follows it
  pos <- regexpr("^[[:space:]]*function[^=]*=[[:space:]]*[^([:space:]]*[([:space:]]", code)
  if (pos == -1L) {
    res <- ""
    attr(res, "error") <- "missing-name-end"
    return(res)
  }
  nameStop <- as.integer(pos + attr(pos, "match.length") - 2L)

  substring(code, nameStart, nameStop)
}


stop_if_not <- function(...) {
  res <- list(...)
  n <- length(res)
  if (n == 0L) return()

  for (ii in 1L:n) {
    res_ii <- .subset2(res, ii)
    if (length(res_ii) != 1L || is.na(res_ii) || !res_ii) {
        mc <- match.call()
        call <- deparse(mc[[ii + 1]], width.cutoff = 60L)
        if (length(call) > 1L) call <- paste(call[1L], "...")
        stop(sQuote(call), " is not TRUE", call. = FALSE, domain = NA)
    }
  }
}
