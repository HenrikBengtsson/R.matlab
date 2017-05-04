# Setup

## Platform

|setting  |value                        |
|:--------|:----------------------------|
|version  |R version 3.4.0 (2017-04-21) |
|system   |x86_64, linux-gnu            |
|ui       |X11                          |
|language |en                           |
|collate  |en_US.UTF-8                  |
|tz       |America/Los_Angeles          |
|date     |2017-05-03                   |

## Packages

|package     |*  |version    |date       |source                              |
|:-----------|:--|:----------|:----------|:-----------------------------------|
|R.matlab    |   |3.6.1-9000 |2017-05-04 |local (HenrikBengtsson/R.matlab@NA) |
|R.methodsS3 |   |1.7.1      |2016-02-16 |cran (@1.7.1)                       |
|R.oo        |   |1.21.0     |2016-11-01 |cran (@1.21.0)                      |
|R.utils     |   |2.5.0      |2016-11-07 |cran (@2.5.0)                       |
|SparseM     |   |1.77       |2017-04-23 |cran (@1.77)                        |

# Check results
3 packages with problems

## AnalyzeFMRI (1.1-16)
Maintainer: P Lafaye de Micheaux <lafaye@dms.umontreal.ca>

1 error  | 1 warning  | 5 notes

```
checking examples ... ERROR
Running examples in ‘AnalyzeFMRI-Ex.R’ failed
The error most likely occurred in:

> base::assign(".ptime", proc.time(), pos = "CheckExEnv")
> ### Name: Threshold.Bonferroni
> ### Title: Calculates Bonferroni Threshold
> ### Aliases: Threshold.Bonferroni
> ### Keywords: utilities
> 
> ### ** Examples
> 
> Threshold.Bonferroni(0.05, 1000)
Error in if (type == "Normal") return(qnorm(1 - p.val/n)) : 
  the condition has length > 1
Calls: Threshold.Bonferroni
Execution halted

checking whether package ‘AnalyzeFMRI’ can be installed ... WARNING
Found the following significant warnings:
  Warning: no DISPLAY variable so Tk is not available
See ‘/home/hb/repositories/R.matlab/revdep/checks/AnalyzeFMRI.Rcheck/00install.out’ for details.

checking DESCRIPTION meta-information ... NOTE
Malformed Title field: should not end in a period.

checking top-level files ... NOTE
Non-standard files/directories found at top level:
  ‘niftidoc’ ‘tst.hdr’ ‘tst.img’

checking R code for possible problems ... NOTE
ICAspat: no visible global function definition for ‘rnorm’
ICAtemp: no visible global function definition for ‘rnorm’
N2G.Class.Probability: no visible global function definition for
  ‘dnorm’
N2G.Class.Probability: no visible global function definition for
  ‘dgamma’
N2G.Density: no visible global function definition for ‘dnorm’
N2G.Density: no visible global function definition for ‘dgamma’
N2G.Fit: no visible global function definition for ‘optim’
... 64 lines ...
  jpeg median optim optimize par pf plot pnorm points pt qf qgamma
  qnorm qt quantile rnorm sd text write.table
Consider adding
  importFrom("grDevices", "dev.off", "heat.colors", "jpeg")
  importFrom("graphics", "abline", "axis", "box", "image", "par", "plot",
             "points", "text")
  importFrom("stats", "dgamma", "dnorm", "fft", "median", "optim",
             "optimize", "pf", "pnorm", "pt", "qf", "qgamma", "qnorm",
             "qt", "quantile", "rnorm", "sd")
  importFrom("utils", "glob2rx", "write.table")
to your NAMESPACE file.

checking Rd line widths ... NOTE
Rd file 'GaussSmoothArray.Rd':
  \usage lines wider than 90 characters:
     GaussSmoothArray(x, voxdim=c(1, 1, 1), ksize=5, sigma=diag(3, 3), mask=NULL, var.norm=FALSE)

Rd file 'N2G.Spatial.Mixture.Rd':
  \usage lines wider than 90 characters:
     N2G.Spatial.Mixture(data, par.start = c(4, 2, 4, 2, 0.9, 0.05), ksize, ktype = c("2D", "3D"), mask = NULL)
  \examples lines wider than 100 characters:
     ans <- N2G.Spatial.Mixture(y, par.start = c(4, 2, 4, 2, 0.9, 0.05), ksize = 3, ktype = "2D", mask = m) 
... 21 lines ...
Rd file 'f.complete.hdr.nifti.list.create.Rd':
  \usage lines wider than 90 characters:
     f.complete.hdr.nifti.list.create(file,dim.info=character(1),dim,intent.p1=single(1),intent.p2=single(1),intent.p3=single(1),intent.code ... [TRUNCATED]

Rd file 'threeDto4D.Rd':
  \usage lines wider than 90 characters:
     threeDto4D(outputfile,path.in=NULL,prefix=NULL,regexp=NULL,times=NULL,list.of.in.files=NULL,path.out=NULL,is.nii.pair=FALSE,hdr.number= ... [TRUNCATED]
  \examples lines wider than 100 characters:
     # path.fonc <- "/network/home/lafayep/Stage/Data/map284/functional/MondrianApril2007/preprocessing/1801/smoothed/"

These lines will be truncated in the PDF manual.

checking compiled code ... NOTE
File ‘AnalyzeFMRI/libs/AnalyzeFMRI.so’:
  Found no calls to: ‘R_registerRoutines’, ‘R_useDynamicSymbols’

It is good practice to register native routines and to disable symbol
search.

See ‘Writing portable packages’ in the ‘Writing R Extensions’ manual.
```

## fda (2.4.4)
Maintainer: J. O. Ramsay <ramsay@psych.mcgill.ca>

1 error  | 0 warnings | 4 notes

```
checking examples ... ERROR
Running examples in ‘fda-Ex.R’ failed
The error most likely occurred in:

> base::assign(".ptime", proc.time(), pos = "CheckExEnv")
> ### Name: density.fd
> ### Title: Compute a Probability Density Function
> ### Aliases: density.fd
> ### Keywords: smooth
> 
... 18 lines ...
Iteration  Criterion  Neg. Log L  Grad. Norm
      0    89.587973 89.587973  4.604874
      1    62.3490391 62.3490391  0.8397873
      2    58.611230 58.611230  0.374036
      3    57.8930196 57.8930196  0.1253422
      4    57.6821675 57.6821675  0.1296681
      5    57.4458456 57.4458456  0.1785299
Error in if (limwrd) ind <- 1 else limwrd <- TRUE : 
  the condition has length > 1
Calls: density.fd -> stepchk
Execution halted

checking dependencies in R code ... NOTE
'library' or 'require' calls in package code:
  ‘R.matlab’ ‘RCurl’ ‘nlme’ ‘quadprog’
  Please use :: or requireNamespace() instead.
  See section 'Suggested packages' in the 'Writing R Extensions' manual.

checking S3 generic/method consistency ... NOTE
Found the following apparent S3 methods exported but not registered:
  fRegress.CV fRegress.stderr norder.bspline plot.cca.fd plot.pca.fd
See section ‘Registering S3 methods’ in the ‘Writing R Extensions’
manual.

checking R code for possible problems ... NOTE
AmpPhaseDecomp: no visible global function definition for ‘cov’
Fperm.fd: no visible global function definition for ‘quantile’
Fperm.fd: no visible binding for global variable ‘quantile’
Fperm.fd: no visible global function definition for ‘plot’
Fperm.fd: no visible global function definition for ‘lines’
Fperm.fd: no visible global function definition for ‘abline’
Fperm.fd: no visible global function definition for ‘legend’
Fperm.fd: no visible global function definition for ‘hist’
Fstat.fd: no visible binding for global variable ‘var’
... 129 lines ...
Consider adding
  importFrom("grDevices", "dev.new")
  importFrom("graphics", "abline", "axis", "hist", "legend", "lines",
             "locator", "matlines", "mtext", "par", "plot", "points",
             "polygon", "text", "title")
  importFrom("stats", "approx", "coef", "cov", "dist", "fitted",
             "formula", "integrate", "lsfit", "model.frame",
             "model.matrix", "na.fail", "na.pass", "optimize", "predict",
             "predict.lm", "quantile", "terms", "var")
  importFrom("utils", "read.table")
to your NAMESPACE file.

checking Rd cross-references ... NOTE
Packages unavailable to check Rd xrefs: ‘Ecfun’, ‘ifultools’, ‘FinTS’, ‘demography’
```

## TRONCO (2.8.0)
Maintainer: BIMIB Group <tronco@disco.unimib.it>  
Bug reports: https://github.com/BIMIB-DISCo/TRONCO

0 errors | 1 warning  | 0 notes

```
checking examples ... WARNING
Found the following significant warnings:
  Warning: 3 simultaneous processes spawned
  Warning: 3 simultaneous processes spawned
  Warning: 3 simultaneous processes spawned
Note that CRAN packages must never use more than two cores
simultaneously during their checks.
Examples with CPU or elapsed time > 5s
                  user system elapsed
tronco.bootstrap 0.104   0.02  13.063
```

