# Setup

## Platform

|setting  |value                        |
|:--------|:----------------------------|
|version  |R version 3.3.1 (2016-06-21) |
|system   |x86_64, linux-gnu            |
|ui       |X11                          |
|language |en                           |
|collate  |C                            |
|tz       |NA                           |
|date     |2016-10-18                   |

## Packages

|package     |*  |version    |date       |source                              |
|:-----------|:--|:----------|:----------|:-----------------------------------|
|R.matlab    |   |3.6.0-9000 |2016-10-19 |local (HenrikBengtsson/R.matlab@NA) |
|R.methodsS3 |   |1.7.1      |2016-02-16 |cran (@1.7.1)                       |
|R.oo        |   |1.20.0     |2016-02-17 |cran (@1.20.0)                      |
|R.utils     |   |2.4.0      |2016-09-14 |cran (@2.4.0)                       |
|SparseM     |   |1.72       |2016-09-06 |cran (@1.72)                        |

# Check results
4 packages with problems

## AnalyzeFMRI (1.1-16)
Maintainer: P Lafaye de Micheaux <lafaye@dms.umontreal.ca>

0 errors | 1 warning  | 4 notes

```
checking whether package 'AnalyzeFMRI' can be installed ... WARNING
Found the following significant warnings:
  Warning: no DISPLAY variable so Tk is not available
See '/cbc/henrik/repositories/R.matlab/revdep/checks/AnalyzeFMRI.Rcheck/00install.out' for details.

checking DESCRIPTION meta-information ... NOTE
Malformed Title field: should not end in a period.

checking top-level files ... NOTE
Non-standard files/directories found at top level:
  'niftidoc' 'tst.hdr' 'tst.img'

checking R code for possible problems ... NOTE
ICAspat: no visible global function definition for 'rnorm'
ICAtemp: no visible global function definition for 'rnorm'
N2G.Class.Probability: no visible global function definition for
  'dnorm'
N2G.Class.Probability: no visible global function definition for
  'dgamma'
N2G.Density: no visible global function definition for 'dnorm'
N2G.Density: no visible global function definition for 'dgamma'
N2G.Fit: no visible global function definition for 'optim'
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
```

## TRONCO (2.4.3)
Maintainer: BIMIB Group <tronco@disco.unimib.it>  
Bug reports: https://github.com/BIMIB-DISCo/TRONCO

1 error  | 2 warnings | 1 note 

```
checking tests ... ERROR
Running the tests in 'tests/testthat.R' failed.
Last 13 lines of output:
  Type 'q()' to quit R.
  
  > Sys.setenv("R_TESTS" = "")
  > 
  > library(testthat)
  > library(TRONCO)
  > 
  > test_check("TRONCO")
  Error in .check_ncores(length(names)) : 63 simultaneous processes spawned
  Calls: test_check ... tronco.kfold.prederr -> makeCluster -> makePSOCKcluster -> .check_ncores
  testthat results ================================================================
  OK: 120 SKIPPED: 0 FAILED: 0
  Execution halted

checking examples ... WARNING
checking a package with encoding  'UTF-8'  in an ASCII locale

 ERROR
Running examples in 'TRONCO-Ex.R' failed
The error most likely occurred in:

> base::assign(".ptime", proc.time(), pos = "CheckExEnv")
> ### Name: tronco.bootstrap
> ### Title: tronco bootstrap
> ### Aliases: tronco.bootstrap
> 
> ### ** Examples
> 
> data(test_model)
> boot = tronco.bootstrap(test_model, nboot = 1)
*** Executing now the bootstrap procedure, this may take a long time...
	Expected completion in approx. 00h:00m:00s 
Error in .check_ncores(length(names)) : 63 simultaneous processes spawned
Calls: tronco.bootstrap ... bootstrap -> makeCluster -> makePSOCKcluster -> .check_ncores
Execution halted

checking re-building of vignette outputs ... WARNING
Error in re-building vignettes:
  ...
Warning in replayPlot(x) : font metrics unknown for character 0xa
Warning in replayPlot(x) : font metrics unknown for character 0xa
Warning in replayPlot(x) : font metrics unknown for character 0xa
Warning in replayPlot(x) : font metrics unknown for character 0xa
Warning in replayPlot(x) : font metrics unknown for character 0xa
Warning in replayPlot(x) : font metrics unknown for character 0xa
Warning in replayPlot(x) : font metrics unknown for character 0xa
Warning in replayPlot(x) : font metrics unknown for character 0xa
Quitting from lines 1141-1143 (vignette.Rnw) 
Error: processing vignette 'vignette.Rnw' failed with diagnostics:
63 simultaneous processes spawned
Execution halted


checking R code for possible problems ... NOTE
Found the following assignments to the global environment:
File 'TRONCO/R/capri.hypotheses.R':
  assign("lifting.genotypes", genotypes, envir = .GlobalEnv)
  assign("lifting.annotations", annotations, envir = .GlobalEnv)
  assign("lifting.edges", NULL, envir = .GlobalEnv)
  assign("fisher.pvalues", NULL, envir = .GlobalEnv)
  assign("lifting.genotypes", roll.back.lifting.genotypes, envir = .GlobalEnv)
  assign("lifting.annotations", roll.back.lifting.annotations, 
    envir = .GlobalEnv)
  assign("lifting.edges", roll.back.lifting.edges, envir = .GlobalEnv)
  assign("fisher.pvalues", roll.back.fisher.pvalues, envir = .GlobalEnv)
  assign("lifting.edges", lifting.edges.temp, envir = .GlobalEnv)
  assign("fisher.pvalues", fisher.pvalues.temp, envir = .GlobalEnv)
  assign("fisher.pvalues", fisher.pvalues.temp, envir = .GlobalEnv)
  assign("fisher.pvalues", fisher.pvalues.temp, envir = .GlobalEnv)
```

## hyperSpec (0.98-20150304)
Maintainer: Claudia Beleites <chemometrie@beleites.de>

0 errors | 2 warnings | 1 note 

```
checking sizes of PDF files under 'inst/doc' ... WARNING
  'gs+qpdf' made some significant size reductions:
     compacted 'plotting.pdf' from 868Kb to 580Kb
  consider running tools::compactPDF(gs_quality = "ebook") on these files

checking re-building of vignette outputs ... WARNING
Error in re-building vignettes:
  ...
Tracing function "spc.fit.poly.below" in package "hyperSpec"
Tracing function "spc.fit.poly.below" in package "hyperSpec"
Tracing function "spc.fit.poly.below" in package "hyperSpec"
Tracing function "spc.fit.poly.below" in package "hyperSpec"
Untracing function "spc.fit.poly.below" in package "hyperSpec"
Error in texi2dvi(file = file, pdf = TRUE, clean = clean, quiet = quiet,  : 
  Running 'texi2dvi' on 'baseline.tex' failed.
... 8 lines ...
<read *> 
         
l.12 \usepackage
                []{helvet}^^M
!  ==> Fatal error occurred, no output PDF file produced!
Calls: <Anonymous> -> do.call -> <Anonymous> -> texi2pdf -> texi2dvi
Execution halted
make: *** [baseline.pdf] Error 1
Error in buildVignettes(dir = "/cbc/henrik/repositories/R.matlab/revdep/checks/hyperSpec.Rcheck/vign_test/hyperSpec") : 
  running 'make' failed
Execution halted

checking R code for possible problems ... NOTE
Warning: local assignments to syntactic functions: ~
Warning: local assignments to syntactic functions: ~
.cut.ticks: no visible global function definition for 'head'
.jdx.TABULAR.PAC: no visible global function definition for 'head'
.jdx.hdr.concentrations: no visible global function definition for
  'modifyList'
.jdx.readhdr: no visible global function definition for 'maintainer'
.labels: no visible global function definition for 'modifyList'
.levelplot: no visible global function definition for 'modifyList'
... 56 lines ...
  'modifyList'
plot,hyperSpec-character: no visible global function definition for
  'modifyList'
Undefined global functions or variables:
  chull col2rgb colorRampPalette head maintainer modifyList read.table
  relist rgb str tail unstack write.table
Consider adding
  importFrom("grDevices", "chull", "col2rgb", "colorRampPalette", "rgb")
  importFrom("utils", "head", "maintainer", "modifyList", "read.table",
             "relist", "str", "tail", "unstack", "write.table")
to your NAMESPACE file.
```

## sisal (0.46)
Maintainer: Mikko Korpela <mvkorpel@iki.fi>

0 errors | 1 warning  | 0 notes

```
checking examples ... WARNING
checking a package with encoding  'UTF-8'  in an ASCII locale

Examples with CPU or elapsed time > 5s
                    user system elapsed
plotSelected.sisal 5.813  0.025   5.845
```

