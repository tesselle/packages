# packages

Most of the R packages of the [tesselle](https://www.tesselle.org/) project are distributed on [CRAN](https://cran.r-project.org/), but some data packages are too large and can only be installed from our universe: [tesselle.r-universe.dev](https://tesselle.r-universe.dev).

If available, CRAN releases must be regarded as the preferred source.

## Download tesselle packages

If you want to install a package, simply use `install.packages()` with the additional repository:

``` r
## Enable this universe
options(repos = c(tesselle = 'https://tesselle.r-universe.dev',
                  CRAN = 'https://cloud.r-project.org'))

## Install some packages
install.packages("tabula")
```

## Use the repository

You can use this repository in your R package (always prefer the CRAN release if available). To do so, prepare the `DESCRIPTION` file of your R package:

* List the package under `Suggests:`
* Add the line `Additional_repositories: https://tesselle.r-universe.dev`
* Test your package with `R CMD check --as-cran`
