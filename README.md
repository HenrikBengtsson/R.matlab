# R.matlab: Read and Write MAT Files and Call MATLAB from Within R


## Installation
R package R.matlab is available on [CRAN](https://cran.r-project.org/package=R.matlab) and can be installed in R as:
```r
install.packages("R.matlab")
```

### Pre-release version

To install the pre-release version that is available in Git branch `develop` on GitHub, use:
```r
remotes::install_github("HenrikBengtsson/R.matlab@develop")
```
This will install the package from source.  



## Contributions

This Git repository uses the [Git Flow](http://nvie.com/posts/a-successful-git-branching-model/) branching model (the [`git flow`](https://github.com/petervanderdoes/gitflow-avh) extension is useful for this).  The [`develop`](https://github.com/HenrikBengtsson/R.matlab/tree/develop) branch contains the latest contributions and other code that will appear in the next release, and the [`master`](https://github.com/HenrikBengtsson/R.matlab) branch contains the code of the latest release, which is exactly what is currently on [CRAN](https://cran.r-project.org/package=R.matlab).

Contributing to this package is easy.  Just send a [pull request](https://help.github.com/articles/using-pull-requests/).  When you send your PR, make sure `develop` is the destination branch on the [R.matlab repository](https://github.com/HenrikBengtsson/R.matlab).  Your PR should pass `R CMD check --as-cran`, which will also be checked by <a href="https://travis-ci.org/HenrikBengtsson/R.matlab">Travis CI</a> and <a href="https://ci.appveyor.com/project/HenrikBengtsson/r-matlab">AppVeyor CI</a> when the PR is submitted.


## Software status

| Resource:     | CRAN        | Travis CI       | Appveyor         |
| ------------- | ------------------- | --------------- | ---------------- |
| _Platforms:_  | _Multiple_          | _Linux & macOS_ | _Windows_        |
| R CMD check   | <a href="https://cran.r-project.org/web/checks/check_results_R.matlab.html"><img border="0" src="http://www.r-pkg.org/badges/version/R.matlab" alt="CRAN version"></a> | <a href="https://travis-ci.org/HenrikBengtsson/R.matlab"><img src="https://travis-ci.org/HenrikBengtsson/R.matlab.svg" alt="Build status"></a>   | <a href="https://ci.appveyor.com/project/HenrikBengtsson/r-matlab"><img src="https://ci.appveyor.com/api/projects/status/github/HenrikBengtsson/R.matlab?svg=true" alt="Build status"></a> |
| Test coverage |                     | <a href="https://codecov.io/gh/HenrikBengtsson/R.matlab"><img src="https://codecov.io/gh/HenrikBengtsson/R.matlab/branch/develop/graph/badge.svg" alt="Coverage Status"/></a>     |                  |
