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
2 packages with problems

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

