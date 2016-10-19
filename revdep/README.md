# Setup

## Platform

|setting  |value                        |
|:--------|:----------------------------|
|version  |R version 3.3.1 (2016-06-21) |
|system   |x86_64, linux-gnu            |
|ui       |X11                          |
|language |en                           |
|collate  |en_US.UTF-8                  |
|tz       |SystemV/PST8PDT              |
|date     |2016-10-19                   |

## Packages

|package     |*  |version    |date       |source                              |
|:-----------|:--|:----------|:----------|:-----------------------------------|
|R.matlab    |   |3.6.0-9000 |2016-10-19 |local (HenrikBengtsson/R.matlab@NA) |
|R.methodsS3 |   |1.7.1      |2016-02-16 |CRAN (R 3.3.1)                      |
|R.oo        |   |1.20.0     |2016-02-17 |CRAN (R 3.3.1)                      |
|R.utils     |   |2.4.0      |2016-09-14 |cran (@2.4.0)                       |
|SparseM     |   |1.72       |2016-09-06 |cran (@1.72)                        |

# Check results
14 packages

## AnalyzeFMRI (1.1-16)
Maintainer: P Lafaye de Micheaux <lafaye@dms.umontreal.ca>

0 errors | 1 warning  | 4 notes

```
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
```

## CINOEDV (2.0)
Maintainer: Junliang Shang <shangjunliang110@163.com>

0 errors | 0 warnings | 1 note 

```
checking R code for possible problems ... NOTE
BatCINOEDV: no visible global function definition for ‘graphics.off’
CoInformation: no visible global function definition for ‘combn’
CombinationEntropy: no visible global function definition for ‘hist’
ConstructCompleteGraph: no visible global function definition for
  ‘dev.new’
ConstructCompleteGraph: no visible global function definition for ‘par’
ConstructCompleteGraph: no visible global function definition for
  ‘plot’
DegreeAnalysis: no visible global function definition for ‘dev.new’
... 19 lines ...
PlotTopEffects: no visible global function definition for ‘title’
Undefined global functions or variables:
  barplot combn dev.new graphics.off hist install.packages layout lines
  par plot rainbow runif title
Consider adding
  importFrom("grDevices", "dev.new", "graphics.off", "rainbow")
  importFrom("graphics", "barplot", "hist", "layout", "lines", "par",
             "plot", "title")
  importFrom("stats", "runif")
  importFrom("utils", "combn", "install.packages")
to your NAMESPACE file.
```

## DATforDCEMRI (0.55)
Maintainer: Gregory Z. Ferl <ferl.gregory@gene.com>

0 errors | 0 warnings | 4 notes

```
checking package dependencies ... NOTE
Depends: includes the non-default packages:
  ‘xtable’ ‘akima’ ‘R.oo’ ‘R.methodsS3’ ‘matlab’ ‘lattice’ ‘locfit’
  ‘grid’
Adding so many packages to the search path is excessive and importing
selectively is preferable.

checking DESCRIPTION meta-information ... NOTE
Deprecated license: CC BY-NC-SA 3.0

checking dependencies in R code ... NOTE
'library' or 'require' calls to packages already attached by Depends:
  ‘R.methodsS3’ ‘R.oo’ ‘akima’ ‘graphics’ ‘grid’ ‘lattice’ ‘locfit’
  ‘matlab’ ‘xtable’
  Please remove these calls from your code.
'library' or 'require' call to ‘R.matlab’ in package code.
  Please use :: or requireNamespace() instead.
  See section 'Suggested packages' in the 'Writing R Extensions' manual.
Packages in Depends field not imported from:
  ‘R.methodsS3’ ‘R.oo’ ‘akima’ ‘grid’ ‘lattice’ ‘locfit’ ‘matlab’
  ‘xtable’
  These packages need to be imported from (in the NAMESPACE file)
  for when this namespace is loaded but not attached.

checking R code for possible problems ... NOTE
DAT : DATrun : calch: no visible global function definition for
  ‘preplot’
DAT : DATrun: no visible global function definition for ‘rot90’
DAT : DATrun: no visible global function definition for ‘median’
DAT : DATrun: no visible global function definition for ‘locfit.robust’
DAT : DATrun: no visible global function definition for ‘preplot’
DAT : DATrun: no visible global function definition for ‘dev.new’
DAT : DATrun: no visible global function definition for ‘image’
DAT : DATrun: no visible global function definition for ‘palette’
... 16 lines ...
Undefined global functions or variables:
  DAT.simData colorRampPalette dev.new dev.off dev.set frame
  graphics.off image layout lines locator locfit.robust median palette
  par pdf plot preplot rot90 text writeMat
Consider adding
  importFrom("grDevices", "colorRampPalette", "dev.new", "dev.off",
             "dev.set", "graphics.off", "palette", "pdf")
  importFrom("graphics", "frame", "image", "layout", "lines", "locator",
             "par", "plot", "text")
  importFrom("stats", "median", "preplot")
to your NAMESPACE file.
```

## eemR (0.1.4)
Maintainer: Philippe Massicotte <pm@bios.au.dk>  
Bug reports: https://github.com/PMassicotte/eemR/issues

0 errors | 0 warnings | 0 notes

## fda (2.4.4)
Maintainer: J. O. Ramsay <ramsay@psych.mcgill.ca>

0 errors | 0 warnings | 4 notes

```
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
Packages unavailable to check Rd xrefs: ‘Ecfun’, ‘FinTS’, ‘demography’
```

## geometry (0.3-6)
Maintainer: David C. Sterratt <david.c.sterratt@ed.ac.uk>  
Bug reports: https://r-forge.r-project.org/tracker/?group_id=1149

0 errors | 0 warnings | 0 notes

## hyperSpec (0.98-20150304)
Maintainer: Claudia Beleites <chemometrie@beleites.de>

0 errors | 0 warnings | 1 note 

```
checking R code for possible problems ... NOTE
Warning: local assignments to syntactic functions: ~
Warning: local assignments to syntactic functions: ~
.cut.ticks: no visible global function definition for ‘head’
.jdx.TABULAR.PAC: no visible global function definition for ‘head’
.jdx.hdr.concentrations: no visible global function definition for
  ‘modifyList’
.jdx.readhdr: no visible global function definition for ‘maintainer’
.labels: no visible global function definition for ‘modifyList’
.levelplot: no visible global function definition for ‘modifyList’
... 56 lines ...
  ‘modifyList’
plot,hyperSpec-character: no visible global function definition for
  ‘modifyList’
Undefined global functions or variables:
  chull col2rgb colorRampPalette head maintainer modifyList read.table
  relist rgb str tail unstack write.table
Consider adding
  importFrom("grDevices", "chull", "col2rgb", "colorRampPalette", "rgb")
  importFrom("utils", "head", "maintainer", "modifyList", "read.table",
             "relist", "str", "tail", "unstack", "write.table")
to your NAMESPACE file.
```

## KATforDCEMRI (0.740)
Maintainer: Gregory Z. Ferl <ferl.gregory@gene.com>

0 errors | 0 warnings | 2 notes

```
checking DESCRIPTION meta-information ... NOTE
Malformed Title field: should not end in a period.

checking R code for possible problems ... NOTE
KAT : aif.shift.func: no visible global function definition for
  ‘approxfun’
KAT : roi.modelT: no visible global function definition for ‘tail’
KAT : roi.modelT: no visible global function definition for ‘head’
KAT : roi.modelxT: no visible global function definition for ‘tail’
KAT : roi.modelxT: no visible global function definition for ‘head’
KAT : calch: no visible global function definition for ‘preplot’
KAT : calchFUNC: no visible global function definition for ‘preplot’
KAT: no visible global function definition for ‘median’
... 34 lines ...
  graphics.off head image layout lines locator median optim palette par
  pdf plot points preplot quantile tail text write.table
Consider adding
  importFrom("grDevices", "colorRampPalette", "dev.new", "dev.off",
             "dev.set", "graphics.off", "palette", "pdf")
  importFrom("graphics", "abline", "frame", "image", "layout", "lines",
             "locator", "par", "plot", "points", "text")
  importFrom("stats", "approxfun", "median", "optim", "preplot",
             "quantile")
  importFrom("utils", "head", "tail", "write.table")
to your NAMESPACE file.
```

## oXim (1.0.1)
Maintainer: Wencheng Lau-Medrano <luis.laum@gmail.com>

0 errors | 0 warnings | 0 notes

## poweRlaw (0.60.3)
Maintainer: Colin Gillespie <csgillespie@gmail.com>  
Bug reports: https://github.com/csgillespie/poweRlaw/issues

0 errors | 0 warnings | 0 notes

## retistruct (0.5.10)
Maintainer: David C. Sterratt <david.c.sterratt@ed.ac.uk>  
Bug reports: https://github.com/davidcsterratt/retistruct/issues

0 errors | 0 warnings | 1 note 

```
checking R code for possible problems ... NOTE
ReconstructedOutline: no visible global function definition for
  ‘dev.set’
TriangulatedOutline: no visible global function definition for
  ‘na.omit’
compute.kernel.estimate: no visible global function definition for
  ‘contourLines’
compute.kernel.estimate: no visible global function definition for
  ‘aggregate’
computeTearRelationships: no visible global function definition for
... 179 lines ...
  importFrom("grDevices", "as.raster", "contourLines", "dev.copy2pdf",
             "dev.cur", "dev.new", "dev.off", "dev.print", "dev.set",
             "jpeg", "palette", "pdf", "png", "rainbow", "svg", "tiff")
  importFrom("graphics", "abline", "axis", "boxplot", "hist", "identify",
             "lines", "mtext", "par", "plot", "plot.new", "points",
             "polygon", "segments", "text", "title")
  importFrom("stats", "aggregate", "dist", "lm", "na.omit", "optim",
             "optimise", "sd")
  importFrom("utils", "install.packages", "packageDescription",
             "read.csv", "write.csv")
to your NAMESPACE file.
```

## sisal (0.46)
Maintainer: Mikko Korpela <mvkorpel@iki.fi>

0 errors | 0 warnings | 0 notes

## SLOPE (0.1.3)
Maintainer: Evan Patterson <epatters@stanford.edu>

0 errors | 0 warnings | 0 notes

## TRONCO (2.6.0)
Maintainer: BIMIB Group <tronco@disco.unimib.it>  
Bug reports: https://github.com/BIMIB-DISCo/TRONCO

0 errors | 1 warning  | 1 note 

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
tronco.bootstrap 0.168  0.012  12.384

checking R code for possible problems ... NOTE
Found the following assignments to the global environment:
File ‘TRONCO/R/capri.hypotheses.R’:
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

