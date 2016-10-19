# CRAN submission R.matlab 3.6.1
on 2016-10-19

I've verified that this submission causes *no* issues for
any of the 14 reverse (non-recursive) package dependencies
available on CRAN and Bioconductor.

Thanks in advance


## Notes not sent to CRAN

### R CMD check --as-cran validation

The package has been verified using `R CMD check --as-cran` on:

* Platform x86_64-apple-darwin13.4.0 (64-bit) [Travis CI]:
#  - R 3.2.4 Revised (2016-03-16 r70336)
  - R version 3.3.1 (2016-06-21)
  
* Platform x86_64-unknown-linux-gnu (64-bit) [Travis CI]:
  - R version 3.2.5 (2016-04-14)
  - R version 3.3.1 (2016-06-21)
  - R Under development (unstable) (2016-10-19 r71539)

* Platform x86_64-pc-linux-gnu (64-bit):
  - R version 3.0.3 (2014-03-06)
  - R version 3.1.3 (2015-03-09)
  - R version 3.2.5 (2016-04-14)
  - R version 3.3.1 (2016-06-21)
  - R version 3.3.1 Patched (2016-10-17 r71531)
  - R Under development (unstable) (2016-10-18 r71535)

* Platform i686-pc-linux-gnu (32-bit):
  - R version 3.3.1 (2016-06-21)

* Platform i386-w64-mingw32 (32-bit) [Appveyor CI]:
  - R Under development (unstable) (2016-10-18 r71535)

* Platform x86_64-w64-mingw32/x64 (64-bit) [Appveyor CI]:
  - R version 3.3.1 (2016-06-21)
  - R Under development (unstable) (2016-10-18 r71535)

* Platform x86_64-w64-mingw32/x64 (64-bit) [win-builder]:
  - R version 3.3.1 (2016-06-21)
  - R Under development (unstable) (2016-10-18 r71535)


### Reverse package check validation

All of the 14 reverse (non-recursive) package dependencies available
on CRAN and Bioconductor have been checked against this version
with `R CMD check --as-cran` (using `devtools::revdep_check()`).
See `revdeps/` folder for full results.

This version does _not_ introduce any known issues for any of
those packages.
