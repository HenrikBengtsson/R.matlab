# AnalyzeFMRI

Version: 1.1-17

## In both

*   checking whether package ‘AnalyzeFMRI’ can be installed ... WARNING
    ```
    Found the following significant warnings:
      Warning: no DISPLAY variable so Tk is not available
      Warning: loading Rplot failed
    See ‘/home/hb/repositories/R.matlab/revdep/checks/AnalyzeFMRI/new/AnalyzeFMRI.Rcheck/00install.out’ for details.
    ```

# DATforDCEMRI

Version: 0.55

## In both

*   checking package dependencies ... NOTE
    ```
    Depends: includes the non-default packages:
      ‘xtable’ ‘akima’ ‘R.oo’ ‘R.methodsS3’ ‘matlab’ ‘lattice’ ‘locfit’
      ‘grid’
    Adding so many packages to the search path is excessive and importing
    selectively is preferable.
    ```

*   checking DESCRIPTION meta-information ... NOTE
    ```
    Deprecated license: CC BY-NC-SA 3.0
    ```

*   checking dependencies in R code ... NOTE
    ```
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
    ```

*   checking R code for possible problems ... NOTE
    ```
    ...
    DAT : DATrun: no visible global function definition for ‘graphics.off’
    DAT : DATrun: no visible global function definition for ‘pdf’
    DAT : DATrun: no visible global function definition for ‘layout’
    DAT : DATrun: no visible global function definition for ‘par’
    DAT : DATrun: no visible global function definition for ‘plot’
    DAT : DATrun: no visible global function definition for ‘frame’
    DAT : DATrun: no visible global function definition for ‘lines’
    DAT : DATrun: no visible global function definition for ‘dev.off’
    DAT : DATrun: no visible global function definition for ‘writeMat’
    DAT: no visible binding for global variable ‘DAT.simData’
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

# fda

Version: 2.4.8

## In both

*   checking Rd cross-references ... NOTE
    ```
    Packages unavailable to check Rd xrefs: ‘Ecfun’, ‘ifultools’, ‘demography’
    ```

# hyperSpec

Version: 0.99-20180627

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  5.1Mb
      sub-directories of 1Mb or more:
        doc   3.8Mb
    ```

*   checking Rd cross-references ... NOTE
    ```
    Package unavailable to check Rd xrefs: ‘caTools’
    ```

# MethylMix

Version: 2.10.2

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘digest’
      All declared Imports should be used.
    ```

# retistruct

Version: 0.5.12

## In both

*   checking package dependencies ... NOTE
    ```
    Packages suggested but not available for checking:
      ‘gWidgets2RGtk2’ ‘cairoDevice’ ‘RGtk2’
    ```

