# Package repository

This is a repository holding R packages of the [tesselle](https://www.tesselle.org/) project. Most of the packages are distributed on [CRAN](https://cran.r-project.org/), but some data packages are too large and can only be installed from this repository.

## Download tesselle packages
 
If you want to install a package, simply use `install.packages()` with the additional repository:

``` r
repos <- c("https://packages.tesselle.org", getOption("repos"))
install.packages("tabula", repos = repos, type = "source")
```

## Use the repository

You can use this repository in your R package (always prefer the CRAN release if available). To do so, prepare the `DESCRIPTION` file of your R package:

* List the package under `Suggests:`
* Add the line `Additional_repositories: https://packages.tesselle.org`
* Test your package with `R CMD check --as-cran`

