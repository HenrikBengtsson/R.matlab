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

*   checking package dependencies ... ERROR
    ```
    Packages required but not available: 'lidR', 'Rfast', 'VoxR'
    
    See section ‘The DESCRIPTION file’ in the ‘Writing R Extensions’
    manual.
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

*   checking package dependencies ... ERROR
    ```
    Package required but not available: ‘ReacTran’
    
    See section ‘The DESCRIPTION file’ in the ‘Writing R Extensions’
    manual.
    ```

# eemR

<details>

* Version: 1.0.1
* GitHub: https://github.com/PMassicotte/eemR
* Source code: https://github.com/cran/eemR
* Date/Publication: 2019-06-26 13:50:03 UTC
* Number of recursive dependencies: 105

Run `revdep_details(, "eemR")` for more info

</details>

## In both

*   checking package dependencies ... NOTE
    ```
    Packages suggested but not available for checking: 'cdom', 'extrafont'
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

*   checking running R code from vignettes ...
    ```
      ‘chondro.pdf.asis’ using ‘UTF-8’... OK
      ‘fileio.pdf.asis’ using ‘UTF-8’... OK
      ‘baseline.Rnw’ using ‘UTF-8’... failed
      ‘flu.Rnw’ using ‘UTF-8’... OK
      ‘hyperspec.Rnw’ using ‘UTF-8’... failed
      ‘laser.Rnw’ using ‘UTF-8’... OK
      ‘plotting.Rnw’ using ‘UTF-8’... OK
     WARNING
    Errors in running code in vignettes:
    when running code in ‘baseline.Rnw’
    ...
    Loading required package: baseline
    Warning in library(package, lib.loc = lib.loc, character.only = TRUE, logical.return = TRUE,  :
      there is no package called ‘baseline’
    
    > bl <- baseline(corrected[[]], method = "modpolyfit", 
    +     degree = 4)
    
      When sourcing ‘hyperspec.R’:
    Error: could not find function "baseline"
    Execution halted
    ```

*   checking package dependencies ... NOTE
    ```
    Package suggested but not available for checking: ‘baseline’
    ```

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
    Warning: Using `as.character()` on a quosure is deprecated as of rlang 0.3.0.
    Please use `as_label()` or `as_name()` instead.
    This warning is displayed once per session.
    --- finished re-building ‘plotting.Rnw’
    
    SUMMARY: processing the following files failed:
      ‘baseline.Rnw’ ‘hyperspec.Rnw’
    
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

# LRQMM

<details>

* Version: 1.2.3
* GitHub: NA
* Source code: https://github.com/cran/LRQMM
* Date/Publication: 2021-10-04 07:50:06 UTC
* Number of recursive dependencies: 29

Run `revdep_details(, "LRQMM")` for more info

</details>

## In both

*   checking package dependencies ... ERROR
    ```
    Packages required but not available:
      'GeneticsPed', 'kinship2', 'MCMCglmm', 'rsvd'
    
    See section ‘The DESCRIPTION file’ in the ‘Writing R Extensions’
    manual.
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

# NetworkToolbox

<details>

* Version: 1.4.2
* GitHub: NA
* Source code: https://github.com/cran/NetworkToolbox
* Date/Publication: 2021-05-28 11:40:06 UTC
* Number of recursive dependencies: 103

Run `revdep_details(, "NetworkToolbox")` for more info

</details>

## In both

*   checking package dependencies ... ERROR
    ```
    Packages required but not available: 'qgraph', 'IsingFit'
    
    See section ‘The DESCRIPTION file’ in the ‘Writing R Extensions’
    manual.
    ```

# pathviewr

<details>

* Version: 1.1.3
* GitHub: https://github.com/ropensci/pathviewr
* Source code: https://github.com/cran/pathviewr
* Date/Publication: 2022-08-22 07:50:14 UTC
* Number of recursive dependencies: 151

Run `revdep_details(, "pathviewr")` for more info

</details>

## In both

*   checking package dependencies ... ERROR
    ```
    Package required but not available: ‘anomalize’
    
    See section ‘The DESCRIPTION file’ in the ‘Writing R Extensions’
    manual.
    ```

# raveio

<details>

* Version: 0.0.7
* GitHub: https://github.com/beauchamplab/raveio
* Source code: https://github.com/cran/raveio
* Date/Publication: 2022-06-20 18:20:01 UTC
* Number of recursive dependencies: 136

Run `revdep_details(, "raveio")` for more info

</details>

## In both

*   checking package dependencies ... ERROR
    ```
    Package required but not available: ‘threeBrain’
    
    Package suggested but not available for checking: ‘rpymat’
    
    See section ‘The DESCRIPTION file’ in the ‘Writing R Extensions’
    manual.
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

*   checking package dependencies ... ERROR
    ```
    Packages required but not available: 'RImageJROI', 'geometry'
    
    Packages suggested but not available for checking:
      'gWidgets2RGtk2', 'cairoDevice', 'RGtk2'
    
    See section ‘The DESCRIPTION file’ in the ‘Writing R Extensions’
    manual.
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

*   checking package dependencies ... ERROR
    ```
    Packages required but not available: 'qgraph', 'effects'
    
    Package suggested but not available for checking: ‘spreadr’
    
    See section ‘The DESCRIPTION file’ in the ‘Writing R Extensions’
    manual.
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

*   checking package dependencies ... ERROR
    ```
    Package required but not available: ‘editData’
    
    See section ‘The DESCRIPTION file’ in the ‘Writing R Extensions’
    manual.
    ```

# sojourner

<details>

* Version: 1.10.0
* GitHub: https://github.com/sheng-liu/sojourner
* Source code: https://github.com/cran/sojourner
* Date/Publication: 2022-04-26
* Number of recursive dependencies: 103

Run `revdep_details(, "sojourner")` for more info

</details>

## In both

*   checking package dependencies ... ERROR
    ```
    Package required but not available: ‘sampSurf’
    
    See section ‘The DESCRIPTION file’ in the ‘Writing R Extensions’
    manual.
    ```

# staRdom

<details>

* Version: 1.1.25
* GitHub: https://github.com/MatthiasPucher/staRdom
* Source code: https://github.com/cran/staRdom
* Date/Publication: 2022-03-21 15:50:02 UTC
* Number of recursive dependencies: 158

Run `revdep_details(, "staRdom")` for more info

</details>

## In both

*   checking package dependencies ... ERROR
    ```
    Packages required but not available:
      'eemR', 'multiway', 'GGally', 'drc', 'cdom'
    
    Package suggested but not available for checking: ‘xlsx’
    
    See section ‘The DESCRIPTION file’ in the ‘Writing R Extensions’
    manual.
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

*   checking package dependencies ... ERROR
    ```
    Packages required but not available:
      'tsibble', 'fabletools', 'tsfeatures', 'feasts', 'janitor'
    
    See section ‘The DESCRIPTION file’ in the ‘Writing R Extensions’
    manual.
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
      installed size is  6.8Mb
      sub-directories of 1Mb or more:
        libs   5.2Mb
    ```

