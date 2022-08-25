# CRAN submission R.matlab 3.7.0

on 2022-08-25

I've verified this submission has no negative impact on any of the 23 reverse package dependencies available on CRAN and Bioconductor.

Thank you


## Notes not sent to CRAN

### R CMD check validation

The package has been verified using `R CMD check --as-cran` on:

| R version     | GitHub | R-hub    | mac/win-builder |
| ------------- | ------ | -------- | --------------- |
| 3.4.x         | L      |          |                 |
| 4.0.x         | L      |          |                 |
| 4.1.x         | L M W  |          |                 |
| 4.2.x         | L M W  | L M M1 W | M1 W            |
| devel         | L M W  | L        |    W            |

*Legend: OS: L = Linux, M = macOS, M1 = macOS M1, W = Windows*


R-hub checks:

```r
res <- rhub::check(platform = c(
  "debian-clang-devel", "debian-gcc-patched", "linux-x86_64-rocker-gcc-san",
  "macos-highsierra-release-cran", "macos-m1-bigsur-release",
  "windows-x86_64-release"))
print(res)
```

gives

```
── R.matlab 3.7.0: OK

  Build ID:   R.matlab_3.7.0.tar.gz-414de5507ffd46ab8b9d7dcd398a0d03
  Platform:   Debian Linux, R-devel, clang, ISO-8859-15 locale
  Submitted:  6m 29.4s ago
  Build time: 3m 32.2s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── R.matlab 3.7.0: OK

  Build ID:   R.matlab_3.7.0.tar.gz-4ffbfa1c533445dfae421bbbf9cf9e17
  Platform:   Debian Linux, R-patched, GCC
  Submitted:  6m 29.5s ago
  Build time: 3m 30s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── R.matlab 3.7.0: PREPERROR

  Build ID:   R.matlab_3.7.0.tar.gz-f66bc33035394ba68eba7250b6d48990
  Platform:   Debian Linux, R-devel, GCC ASAN/UBSAN
  Submitted:  8m 29.2s ago
  Build time: 7m 58s

❯ Build failed during preparation or aborted

── R.matlab 3.7.0: OK

  Build ID:   R.matlab_3.7.0.tar.gz-8e4e0c23c56a45a9a0c9ad1a0ea32e0d
  Platform:   macOS 10.13.6 High Sierra, R-release, CRAN's setup
  Submitted:  6m 29.5s ago
  Build time: 1m 41.9s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── R.matlab 3.7.0: OK

  Build ID:   R.matlab_3.7.0.tar.gz-2531257f8bb84158b2e58f54bdf43283
  Platform:   Apple Silicon (M1), macOS 11.6 Big Sur, R-release
  Submitted:  6m 29.5s ago
  Build time: 1m 4.2s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔

── R.matlab 3.7.0: OK

  Build ID:   R.matlab_3.7.0.tar.gz-fb3ff24143204655bd8f74d15d289de5
  Platform:   Windows Server 2022, R-release, 32/64 bit
  Submitted:  6m 29.5s ago
  Build time: 4m 21.3s

0 errors ✔ | 0 warnings ✔ | 0 notes ✔
```

Comment: The PREPERROR is probably a hiccup on R-hub.
