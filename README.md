
# Homework 6 R Package: Sparse Numeric Vector Class and Methods

<!-- badges: start -->

[![R-CMD-check](https://github.com/DanaNguyen18/sparseMethods/actions/workflows/R-CMD-check.yaml/badge.svg)](https://github.com/DanaNguyen18/sparseMethods/actions/workflows/R-CMD-check.yaml)
<!-- badges: end -->

# Description

`sparseMethods` provides an S4 class, `sparse_numeric`, for efficiently
storing numeric vectors by keeping only the nonzero entries and their
positions.

The package implements:

- Custom S4 class `sparse_numeric` for sparse vectors (`value`, `pos`,
  `length`)
- Arithmetic on sparse vectors: `+`, `-`, `*`
- Sparse functions: `sparse_add()`, `sparse_sub()`, `sparse_mult()`,
  `sparse_crossprod()`
- Vector summaries: `mean()`, `norm()`, `standardize()`
- Visualization with `plot()`
- Custom printing via `show()`
- Full reference documentation generated using **roxygen2**
- Automated testing framework using **testthat**
- A **pkgdown** website for easy navigation and examples

This package successfully passes **R CMD check** with 0 errors, 0
warnings, and 0 notes and achieves 95% test coverage.

# Installation

You can install the development version of **sparseMethods** from GitHub
using:

``` r
# install.packages("devtools")
devtools::install_github("DanaNguyen18/sparseMethods")
#> Using GitHub PAT from the git credential store.
#> Downloading GitHub repo DanaNguyen18/sparseMethods@HEAD
#> ── R CMD build ─────────────────────────────────────────────────────────────────
#>      checking for file ‘/private/var/folders/k4/qgfqzjys1_g3p4ts79shryh80000gn/T/RtmpLjCfRn/remotes80d714e22432/DanaNguyen18-sparseMethods-56f87c4/DESCRIPTION’ ...  ✔  checking for file ‘/private/var/folders/k4/qgfqzjys1_g3p4ts79shryh80000gn/T/RtmpLjCfRn/remotes80d714e22432/DanaNguyen18-sparseMethods-56f87c4/DESCRIPTION’
#>   ─  preparing ‘sparseMethods’:
#>    checking DESCRIPTION meta-information ...  ✔  checking DESCRIPTION meta-information
#>   ─  checking for LF line-endings in source and make files and shell scripts
#>   ─  checking for empty or unneeded directories
#>   ─  building ‘sparseMethods_0.0.0.9000.tar.gz’
#>      
#> 
```

## Example

This is a basic example showing you the methods.

``` r
library(sparseMethods)
#> 
#> Attaching package: 'sparseMethods'
#> The following objects are masked from 'package:base':
#> 
#>     mean, norm

# Create sparse vectors
x <- as(c(1, 0, 3, 0, 5), "sparse_numeric")
y <- as(c(0, 4, 0, 2, 1), "sparse_numeric")

# Print the sparse vectors
x
#> Here is an object of class 'sparse_numeric'
#> The length is  5 
#>  Pos:Value 1 : 1,  Pos:Value 3 : 3,  Pos:Value 5 : 5
y
#> Here is an object of class 'sparse_numeric'
#> The length is  5 
#>  Pos:Value 2 : 4,  Pos:Value 4 : 2,  Pos:Value 5 : 1

# Arithmetic
x + y
#> Here is an object of class 'sparse_numeric'
#> The length is  5 
#>  Pos:Value 1 : 1,  Pos:Value 2 : 4,  Pos:Value 3 : 3,  Pos:Value 4 : 2,  Pos:Value 5 : 6
x - y
#> Here is an object of class 'sparse_numeric'
#> The length is  5 
#>  Pos:Value 1 : 1,  Pos:Value 2 : -4,  Pos:Value 3 : 3,  Pos:Value 4 : -2,  Pos:Value 5 : 4
x * y
#> Here is an object of class 'sparse_numeric'
#> The length is  5 
#>  Pos:Value 5 : 5

# Cross product (dot product)
sparse_crossprod(x, y)
#> [1] 5

# Means and norms
mean(x)
#> [1] 1.8
norm(x)
#> [1] 5.91608

# Standardization
standardize(x)
#> Here is an object of class 'sparse_numeric'
#> The length is  5 
#>  Pos:Value 1 : -0.412568498503517,  Pos:Value 2 : -0.928279121632914,  Pos:Value 3 : 0.618852747755276,  Pos:Value 4 : -0.928279121632914,  Pos:Value 5 : 1.65027399401407

# Plot
plot(x, y)
```

<img src="man/figures/README-unnamed-chunk-3-1.png" width="100%" />

``` r

# Show
show(x)
#> Here is an object of class 'sparse_numeric'
#> The length is  5 
#>  Pos:Value 1 : 1,  Pos:Value 3 : 3,  Pos:Value 5 : 5
```

# PkgDown Website and License

The pkgDown website can be accessed at:
<http://dananguyen18.github.io/sparseMethods/>

This package is released under the MIT license.
