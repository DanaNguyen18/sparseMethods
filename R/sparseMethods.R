#'
#'@importFrom methods new show
#' @importFrom graphics points legend
NULL

#' Sparse Numeric Vector Class
#'
#' Defining an S4 class for storing numeric vectors by
#' holding only nonzero values and their positions
#'
#' @slot value A numeric vector of nonzero values
#' @slot pos Integer vector giving positions of each nonzero value
#' @slot length Integer specifying length of the vector
#'
#' @export
setClass(
    Class = "sparse_numeric",
    slots = c(
        value = "numeric",
        pos = "integer",
        length = "integer"
    )
)

# Validity Check for sparse_numeric objects
# Ensures the object satisfies constraints like:
# value and pos must have the same length
# no position can exceed the vector length
#
# Returns TRUE if valid, otherwise an error message
setValidity(
  Class = "sparse_numeric",
  method = function(object) {
    if (length(object@value) != length(object@pos))
      return("Length of value needs to equal pos")
    if (any(object@pos > object@length))
      return("Pos index needs to be less than or equal to length")
    TRUE
  }
)

# Coerce numeric to sparse_numeric
# Converts a base R numeric vector into a sparse representation
# by storing only the nonzero values and their positions
setAs("numeric", "sparse_numeric",
      function(from) {
        pos <- which(from != 0)
        new("sparse_numeric",
            value = from[pos],
            pos = as.integer(pos),
            length = as.integer(length(from)))
      })

# Coerce sparse_numeric to Numeric
# Converts sparse representation back to
# full numeric vector
setAs("sparse_numeric", "numeric",
      function(from) {
        x <- numeric(from@length)
        x[from@pos] <- from@value
        x
      })

# Generic methods

#' Sparse addition
#'
#' Adds two sparse numeric vectors
#'
#' @param x A 'sparse_numeric' object
#' @param y A 'sparse_numeric' object
#' @return A new 'sparse_numeric' object
#' @export
setGeneric("sparse_add", function(x, y) {
  standardGeneric("sparse_add")
})

#' Sparse multiplication
#'
#' Multiplication of two sparse numeric vectors
#'
#' @param x A 'sparse_numeric' object
#' @param y A 'sparse_numeric' object
#'
#' @return A 'sparse_numeric' object
#' @export
setGeneric("sparse_mult", function(x, y) {
  standardGeneric("sparse_mult")
})

#' Sparse subtraction
#'
#' Subtracts two sparse vectors
#'
#' @param x A 'sparse_numeric' object
#' @param y A 'sparse_numeric' object
#'
#' @return A 'sparse_numeric' object
#' @export
setGeneric("sparse_sub", function(x, y) {
  standardGeneric("sparse_sub")
})

#' Sparse cross production
#'
#' Computes the dot product of two sparse vectors
#'
#' @param x A 'sparse_numeric' object
#' @param y A 'sparse_numeric' object
#'
#' @return A 'sparse_numeric' object
#' @export
setGeneric("sparse_crossprod", function(x, y) {
  standardGeneric("sparse_crossprod")
})

#' Sparse mean
#'
#' Computers the mean of a full vector represetned by a sparse object
#'
#' @param x A 'sparse_numeric' object
#'
#' @return A 'sparse_numeric' object
#' @export
setGeneric("mean", function(x) {
  standardGeneric("mean")
})

#' Sparse norm
#'
#' Computes the norm of a sparse vector
#'
#' @param x A 'sparse_numeric' object
#'
#' @return A 'sparse_numeric' object
#' @export
setGeneric("norm", function(x) {
  standardGeneric("norm")
})

#' Sparse standardize
#'
#' Standardizes a sparse vector
#'
#' @param x A 'sparse_numeric' object
#'
#' @return A 'sparse_numeric' object
#' @export
setGeneric("standardize", function(x) {
  standardGeneric("standardize")
})

# Set methods

#' @describeIn sparse_add Add two sparse vectors
#' @export
setMethod("sparse_add", c("sparse_numeric", "sparse_numeric"),
          function(x, y){
          if (x@length != y@length)
            stop("Lengths of sparse vectors must equal")

          all_positions <- sort(unique(c(x@pos, y@pos))) # non zeros
          x_index <- match(all_positions, x@pos)
          y_index <- match(all_positions, y@pos)

          x_vals <- ifelse(is.na(x_index), 0, x@value[x_index]) # assign 0 for NA values, or X value otherwise
          y_vals <- ifelse(is.na(y_index), 0, y@value[y_index])

          results <- x_vals + y_vals
          nonzero_results <- results != 0

          new("sparse_numeric",
              value = results[nonzero_results],
              pos = as.integer(all_positions[nonzero_results]),
              length = x@length)
          })

#' @describeIn sparse_mult Multiples two sparse vectors
#' @export
setMethod("sparse_mult", c("sparse_numeric", "sparse_numeric"),
          function(x, y){
            if (x@length != y@length)
              stop("Lengths of sparse vectors must equal")

            common_positions <- intersect(x@pos, y@pos)
            results <- x@value[match(common_positions, x@pos)] * y@value[match(common_positions, y@pos)]
            nonzero_results <- results != 0

            new("sparse_numeric",
                value = results[nonzero_results],
                pos = as.integer(common_positions[nonzero_results]),
                length = x@length)
          })

#' @describeIn sparse_sub Subtracts two sparse vectors
#' @export
setMethod("sparse_sub", c("sparse_numeric", "sparse_numeric"),
          function(x, y){
            if (x@length != y@length)
              stop("Lengths of sparse vectors must equal")

            all_positions <- sort(unique(c(x@pos, y@pos))) # non zeros
            x_index <- match(all_positions, x@pos)
            y_index <- match(all_positions, y@pos)

            x_vals <- ifelse(is.na(x_index), 0, x@value[x_index]) # assign 0 for NA values, or X value otherwise
            y_vals <- ifelse(is.na(y_index), 0, y@value[y_index])

            results <- x_vals - y_vals
            nonzero_results <- results != 0

            new("sparse_numeric",
                value = results[nonzero_results],
                pos = as.integer(all_positions[nonzero_results]),
                length = x@length)
          })

#' @describeIn sparse_crossprod Cross products two sparse vectors
#' @export
setMethod("sparse_crossprod", c("sparse_numeric", "sparse_numeric"),
          function(x, y) {
            if (x@length != y@length)
              stop("Lengths of sparse vectors must equal")
            common_positions <- intersect(x@pos, y@pos)
            sum(x@value[match(common_positions, x@pos)] * y@value[match(common_positions, y@pos)])
          })


#' @describeIn mean Mean of a sparse vector
#' @export
setMethod("mean", "sparse_numeric", function(x) {
  sum(x@value) / x@length
})

#' @describeIn norm Normalize a sparse vector
#' @export
setMethod("norm", "sparse_numeric", function(x) {
  sqrt(sum(x@value^2))
})

#' @describeIn standardize Standardize a sparse vector
#' @export
setMethod("standardize", "sparse_numeric", function(x) {
  mu <- sum(x@value) / x@length
  deviations <- rep(-mu, x@length)
  deviations[x@pos] <- x@value - mu

  sd_value <- sqrt(sum(deviations^2) / x@length)
  if(sd_value == 0)
    stop("Can't stardadize a constant vector")

  val <- deviations / sd_value
  stan_value <- val != 0
  new("sparse_numeric",
      value = val[stan_value],
      pos = as.integer(which(stan_value)),
      length = x@length)
})

#' @describeIn sparse_add '+' symbol for sparse_numeric vectors
#' @param e1 First operand (sparse_numeric)
#' @param e2 Second operand (sparse_numeric)
#' @export
setMethod("+", c("sparse_numeric", "sparse_numeric"), function(e1, e2) {
  sparse_add(e1,e2)
})

#' @describeIn sparse_mult '*' symbol for sparse_numeric vectors
#' @param e1 First operand (sparse_numeric)
#' @param e2 Second operand (sparse_numeric)
#' @export
setMethod("*", c("sparse_numeric", "sparse_numeric"), function(e1, e2) {
  sparse_mult(e1,e2)
})

#' @describeIn sparse_sub '-' symbol for sparse_numeric vectors
#' @param e1 First operand (sparse_numeric)
#' @param e2 Second operand (sparse_numeric)
#' @export
setMethod("-", c("sparse_numeric", "sparse_numeric"), function(e1, e2) {
  sparse_sub(e1,e2)
})

#' Show Method for sparse_numeric
#'
#' Provides a print statement of the vector
#'
#' @param object A `sparse_numeric` object
#'
#' @export
setMethod("show", "sparse_numeric", function(object) {
  cat("Here is an object of class 'sparse_numeric'\n")
  cat("The length is ", object@length)
  cat(paste("Pos:Value", object@pos, ":", object@value, collapse = ", "))
})

#' Plot Two Sparse Numeric Vectors
#'
#' Plots the nonzero values of two sparse vectors on the same graph
#'
#' @param x A `sparse_numeric` object
#' @param y A `sparse_numeric` object
#' @param ... Additional graphical parameters
#'
#' @export
setMethod("plot", c("sparse_numeric", "sparse_numeric"),
          function(x, y, ...) {
            plot(x@pos, x@value, col = "blue", pch = 19,
                 xlab = "Position", ylab = "Value",
                 main = "Sparse Vectors Comparison", ...)
            points(y@pos, y@value, col = "orange", pch = 17)
            legend("topright", legend = c("x", "y"),
                   col = c("blue", "orange"), pch = c(19, 17))
          })
