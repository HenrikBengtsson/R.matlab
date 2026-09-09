library("R.matlab")

message("parseMatlabFunctionName() ...")

parseMatlabFunctionName <- R.matlab:::parseMatlabFunctionName

## Whitespace between '=' and the function name (Issue #57)
name <- parseMatlabFunctionName("function [win, aver] = dice(B)")
print(name)
stopifnot(name == "dice", is.null(attr(name, "error")))

## No whitespace between '=' and the function name
name <- parseMatlabFunctionName("function [win, aver] =dice(B)")
print(name)
stopifnot(name == "dice", is.null(attr(name, "error")))

## Single return value, with and without whitespace
stopifnot(parseMatlabFunctionName("function y = foo(x)") == "foo")
stopifnot(parseMatlabFunctionName("function y=foo(x)") == "foo")

## Leading whitespace and multi-line code
code <- c(
  "function [win, aver] = dice(B)",
  "%Play the dice game B times",
  "win = B;",
  "aver = win/B;"
)
stopifnot(parseMatlabFunctionName(code) == "dice")

## Whitespace (no parenthesis) marking the end of the function name
stopifnot(parseMatlabFunctionName(c("function y = foo", "y = 1;")) == "foo")

## Not a function definition
name <- parseMatlabFunctionName("x = 1 + 2;")
stopifnot(name == "", identical(attr(name, "error"), "missing-definition"))

message("parseMatlabFunctionName() ... DONE")
