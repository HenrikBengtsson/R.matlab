# CRAN submission R.matlab 3.6.2

on 2018-09-26

This submission addresses the R-devel CRAN check error ("Error in base::getOption(...) : 'x' must be a character string") related to recent updates in base::getOption() and testing with _R_S3_METHOD_LOOKUP_BASEENV_AFTER_GLOBALENV_=true.

I've verified that this submission causes no issues for any of the 17 reverse (non-recursive) package dependencies available on CRAN and Bioconductor.

Thanks in advance


## Notes not sent to CRAN

### R CMD check --as-cran validation

The package has been verified using `R CMD check --as-cran` on:

* Platform x86_64-apple-darwin15.6.0 (64-bit) [Travis CI]:
  - R version 3.4.4 (2018-03-15)
  - R version 3.5.0 (2018-04-23)

* Platform x86_64-unknown-linux-gnu (64-bit) [Travis CI]:
  - R version 3.4.4 (2017-01-27) [sic!]
  - R version 3.5.1 (2017-01-27) [sic!]
  - R Under development (unstable) (2018-09-26 r75369)

* Platform x86_64-pc-linux-gnu (64-bit):
  - R version 3.1.2 (2014-10-31)
  - R version 3.2.0 (2015-04-16)
  - R version 3.3.0 (2016-05-03)
  - R version 3.4.0 (2017-04-21)
  - R version 3.5.1 (2018-07-02)

* Platform i686-pc-linux-gnu (32-bit):
  - R version 3.4.4 (2018-03-15)

* Platform i386-w64-mingw32 (32-bit) [Appveyor CI]:
  - R Under development (unstable) (2018-09-25 r75362)

* Platform x86_64-w64-mingw32 (64-bit) [Appveyor CI]:
  - R version 3.5.1 (2018-07-02)
  - R Under development (unstable) (2018-09-25 r75362)

* Platform x86_64-w64-mingw32 (64-bit) [r-hub]:
  - R Under development (unstable) (2018-07-30 r75016)

* Platform x86_64-w64-mingw32/x64 (64-bit) [win-builder]:
  - R version 3.5.1 (2018-07-02)
  - R Under development (unstable) (2018-09-26 r75364)
