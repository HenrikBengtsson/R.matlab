code <- c(
  "function [win,aver]=dice(B)",
  "%Play the dice game B times",
  "gains=[-1,2,-3,4,-5,6];",
  "plays=unidrnd(6,B,1);",
  "win=sum(gains(plays));",
  "aver=win;"
)

setFunction(matlab, code)
evaluate(matlab, "[w,a]=dice(1000);")
res <- getVariable(matlab, c("w", "a"))
print(res)

