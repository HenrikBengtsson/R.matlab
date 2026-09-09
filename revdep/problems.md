# aRchi

<details>

* Version: 2.1.2
* GitHub: https://github.com/umr-amap/aRchi
* Source code: https://github.com/cran/aRchi
* Date/Publication: 2022-08-07 14:30:05 UTC
* Number of recursive dependencies: 86

Run `revdep_details(, "aRchi")` for more info

</details>

## In both

*   checking examples ... ERROR
    ```
    Running examples in ‘aRchi-Ex.R’ failed
    The error most likely occurred in:
    
    > ### Name: read_QSM
    > ### Title: Read a QSM
    > ### Aliases: read_QSM
    > 
    > ### ** Examples
    > 
    > file=system.file("extdata","Tree_1_TreeQSM.txt",package = "aRchi")
    > QSM=read_QSM(file,model="treeQSM")
    Warning in readMat5or73Header(this, firstFourBytes = firstFourBytes) :
      Unknown endian: 29. Will assume Bigendian.
    Warning in readMat5or73Header(this, firstFourBytes = firstFourBytes) :
      Unknown MAT version tag: 14132. Will assume version 5.
    Error in mat5ReadTag(this) : 
      Unknown data type. Not in range [1, 19]: 14638
    Calls: read_QSM ... readMat.default -> readMat5 -> readMat5DataElement -> mat5ReadTag
    Execution halted
    ```

# BacArena

<details>

* Version: 1.8.2
* GitHub: https://github.com/euba/BacArena
* Source code: https://github.com/cran/BacArena
* Date/Publication: 2020-05-20 15:40:12 UTC
* Number of recursive dependencies: 65

Run `revdep_details(, "BacArena")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is 10.8Mb
      sub-directories of 1Mb or more:
        R      1.2Mb
        data   3.3Mb
        libs   5.7Mb
    ```

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘glpkAPI’
      All declared Imports should be used.
    ```

# hyperSpec

<details>

* Version: 0.100.0
* GitHub: https://github.com/r-hyperspec/hyperSpec
* Source code: https://github.com/cran/hyperSpec
* Date/Publication: 2021-09-13 13:00:02 UTC
* Number of recursive dependencies: 141

Run `revdep_details(, "hyperSpec")` for more info

</details>

## In both

*   checking re-building of vignette outputs ... NOTE
    ```
    Error(s) in re-building vignettes:
    --- re-building ‘chondro.pdf.asis’ using asis
    --- finished re-building ‘chondro.pdf.asis’
    
    --- re-building ‘fileio.pdf.asis’ using asis
    --- finished re-building ‘fileio.pdf.asis’
    
    --- re-building ‘baseline.Rnw’ using Sweave
    Loading required package: lattice
    Loading required package: grid
    ...
    l.14 \usepackage
                    []{helvet}^^M
    !  ==> Fatal error occurred, no output PDF file produced!
    --- failed re-building ‘plotting.Rnw’
    
    SUMMARY: processing the following files failed:
      ‘baseline.Rnw’ ‘flu.Rnw’ ‘hyperspec.Rnw’ ‘laser.Rnw’ ‘plotting.Rnw’
    
    Error: Vignette re-building failed.
    Execution halted
    ```

# lans2r

<details>

* Version: 1.1.0
* GitHub: https://github.com/KopfLab/lans2r
* Source code: https://github.com/cran/lans2r
* Date/Publication: 2020-06-24 05:20:03 UTC
* Number of recursive dependencies: 85

Run `revdep_details(, "lans2r")` for more info

</details>

## In both

*   checking LazyData ... NOTE
    ```
      'LazyData' is specified without a 'data' directory
    ```

# MethylMix

<details>

* Version: 2.26.0
* GitHub: NA
* Source code: https://github.com/cran/MethylMix
* Date/Publication: 2022-04-26
* Number of recursive dependencies: 81

Run `revdep_details(, "MethylMix")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘digest’
      All declared Imports should be used.
    ```

*   checking R code for possible problems ... NOTE
    ```
    MethylMix: no visible global function definition for ‘is’
    Undefined global functions or variables:
      is
    Consider adding
      importFrom("methods", "is")
    to your NAMESPACE file (and ensure that your DESCRIPTION Imports field
    contains 'methods').
    ```

# retistruct

<details>

* Version: 0.6.3
* GitHub: https://github.com/davidcsterratt/retistruct
* Source code: https://github.com/cran/retistruct
* Date/Publication: 2020-04-04 10:10:02 UTC
* Number of recursive dependencies: 85

Run `revdep_details(, "retistruct")` for more info

</details>

## In both

*   checking package dependencies ... NOTE
    ```
    Packages suggested but not available for checking:
      'gWidgets2RGtk2', 'cairoDevice', 'RGtk2'
    ```

*   checking dependencies in R code ... NOTE
    ```
    Namespace in Imports field not imported from: ‘RTriangle’
      All declared Imports should be used.
    ```

# scalpel

<details>

* Version: 1.0.3
* GitHub: NA
* Source code: https://github.com/cran/scalpel
* Date/Publication: 2021-02-03 05:30:02 UTC
* Number of recursive dependencies: 38

Run `revdep_details(, "scalpel")` for more info

</details>

## In both

*   checking LazyData ... NOTE
    ```
      'LazyData' is specified without a 'data' directory
    ```

# SemNeT

<details>

* Version: 1.4.3
* GitHub: https://github.com/AlexChristensen/SemNeT
* Source code: https://github.com/cran/SemNeT
* Date/Publication: 2021-09-04 04:40:02 UTC
* Number of recursive dependencies: 158

Run `revdep_details(, "SemNeT")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘RColorBrewer’ ‘grid’ ‘purrr’
      All declared Imports should be used.
    ```

*   checking Rd cross-references ... NOTE
    ```
    Packages unavailable to check Rd xrefs: ‘NetworkToolbox’, ‘SemNetCleaner’
    ```

# SemNetCleaner

<details>

* Version: 1.3.4
* GitHub: https://github.com/AlexChristensen/SemNetCleaner
* Source code: https://github.com/cran/SemNetCleaner
* Date/Publication: 2021-09-16 14:00:02 UTC
* Number of recursive dependencies: 93

Run `revdep_details(, "SemNetCleaner")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘editData’ ‘miniUI’
      All declared Imports should be used.
    ```

# sojourner

<details>

* Version: 1.10.0
* GitHub: https://github.com/sheng-liu/sojourner
* Source code: https://github.com/cran/sojourner
* Date/Publication: 2022-04-26
* Number of recursive dependencies: 113

Run `revdep_details(, "sojourner")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  5.3Mb
      sub-directories of 1Mb or more:
        doc       1.4Mb
        extdata   3.5Mb
    ```

# SuperPCA

<details>

* Version: 0.4.0
* GitHub: NA
* Source code: https://github.com/cran/SuperPCA
* Date/Publication: 2021-07-26 12:30:07 UTC
* Number of recursive dependencies: 36

Run `revdep_details(, "SuperPCA")` for more info

</details>

## In both

*   checking dependencies in R code ... NOTE
    ```
    Namespaces in Imports field not imported from:
      ‘R.matlab’ ‘fBasics’ ‘spls’
      All declared Imports should be used.
    ```

# theft

<details>

* Version: 0.3.9.6
* GitHub: https://github.com/hendersontrent/theft
* Source code: https://github.com/cran/theft
* Date/Publication: 2022-05-31 09:20:02 UTC
* Number of recursive dependencies: 151

Run `revdep_details(, "theft")` for more info

</details>

## In both

*   checking re-building of vignette outputs ... ERROR
    ```
    Error(s) in re-building vignettes:
      ...
    --- re-building ‘theft.Rmd’ using rmarkdown
    No IDs removed. All value vectors good for feature extraction.
    Running computations for catch22...
    Warning: As of 0.1.14 the feature 'CO_f1ecac' returns a double instead of int
    This warning is displayed once per session.
    
    Calculations completed for catch22.
    Null testing method 'model free shuffles' is fast. Consider running more permutations for more reliable results. N = 10000 is recommended.
    ...
    Quitting from lines 283-301 (theft.Rmd) 
    Error: processing vignette 'theft.Rmd' failed with diagnostics:
    argument is of length zero
    --- failed re-building ‘theft.Rmd’
    
    SUMMARY: processing the following file failed:
      ‘theft.Rmd’
    
    Error: Vignette re-building failed.
    Execution halted
    ```

# TRONCO

<details>

* Version: 2.28.0
* GitHub: https://github.com/BIMIB-DISCo/TRONCO
* Source code: https://github.com/cran/TRONCO
* Date/Publication: 2022-04-26
* Number of recursive dependencies: 98

Run `revdep_details(, "TRONCO")` for more info

</details>

## In both

*   checking re-building of vignette outputs ... WARNING
    ```
    Error(s) in re-building vignettes:
    Warning in tools:::buildVignettes(dir = "/c4/home/henrik/repositories/R.matlab/revdep/checks/TRONCO/new/TRONCO.Rcheck/vign_test/TRONCO") :
      Files named as vignettes but with no recognized vignette engine:
       ‘vignettes/1_introduction.Rmd’
       ‘vignettes/2_loading_data.Rmd’
       ‘vignettes/3_data_visualization.Rmd’
       ‘vignettes/4_data_manipulation.Rmd’
       ‘vignettes/5_model_inference.Rmd’
       ‘vignettes/6_post_reconstruction.Rmd’
       ‘vignettes/7_import_export.Rmd’
    ...
    l.189 \RequirePackage
                         {parnotes}^^M
    !  ==> Fatal error occurred, no output PDF file produced!
    --- failed re-building ‘vignette.Rnw’
    
    SUMMARY: processing the following file failed:
      ‘vignette.Rnw’
    
    Error: Vignette re-building failed.
    Execution halted
    ```

*   checking files in ‘vignettes’ ... NOTE
    ```
    Files named as vignettes but with no recognized vignette engine:
       ‘vignettes/1_introduction.Rmd’
       ‘vignettes/2_loading_data.Rmd’
       ‘vignettes/3_data_visualization.Rmd’
       ‘vignettes/4_data_manipulation.Rmd’
       ‘vignettes/5_model_inference.Rmd’
       ‘vignettes/6_post_reconstruction.Rmd’
       ‘vignettes/7_import_export.Rmd’
    (Is a VignetteBuilder field missing?)
    ```

# VMDecomp

<details>

* Version: 1.0.1
* GitHub: https://github.com/mlampros/VMDecomp
* Source code: https://github.com/cran/VMDecomp
* Date/Publication: 2022-07-04 15:40:02 UTC
* Number of recursive dependencies: 68

Run `revdep_details(, "VMDecomp")` for more info

</details>

## In both

*   checking installed package size ... NOTE
    ```
      installed size is  6.2Mb
      sub-directories of 1Mb or more:
        libs   4.8Mb
    ```

