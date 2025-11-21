## HW6_testscript.R

test_that("check validity method exists", {
  expect_false({
    validity_method <- getValidity(getClassDef("sparse_numeric"))
    is.null(validity_method)
  })
})

test_that("check validity method", {
  expect_true({
    x <- new("sparse_numeric",
             value = c(1, 2, 3, 1),
             pos = c(1L, 2L, 3L, 5L),
             length = 5L)
    validObject(x)
  })
})

test_that("check validity method 2", {
  expect_error({
    x <- new("sparse_numeric",
             value = c(1, 2, 3, 1),
             pos = c(1L, 2L, 3L, 5L),
             length = 5L)
    x@length <- 2L
    validObject(x)
  })
})

test_that("check coercion return class", {
  expect_s4_class({
    x <- as(c(0, 0, 0, 1, 2), "sparse_numeric")
  }, "sparse_numeric")
})

test_that("check for show method", {
  expect_no_error({
    getMethod("show", "sparse_numeric")
  })
})

test_that("check for plot method", {
  expect_no_error({
    getMethod("plot", c("sparse_numeric", "sparse_numeric"))
  })
})

test_that("plot shows without error", {
  x <- as(c(1,0,2), "sparse_numeric")
  y <- as(c(0,3,1), "sparse_numeric")
  expect_no_error(plot(x, y))
})

test_that("check for + method", {
  expect_no_error({
    getMethod("+", c("sparse_numeric", "sparse_numeric"))
  })
})

test_that("check for - method", {
  expect_no_error({
    getMethod("-", c("sparse_numeric", "sparse_numeric"))
  })
})

test_that("check for * method", {
  expect_no_error({
    getMethod("*", c("sparse_numeric", "sparse_numeric"))
  })
})

test_that("sparse add generic", expect_true(isGeneric("sparse_add")))
test_that("sparse mult generic", expect_true(isGeneric("sparse_mult")))
test_that("sparse sub generic", expect_true(isGeneric("sparse_sub")))
test_that("sparse crossprod generic", expect_true(isGeneric("sparse_crossprod")))

test_that("sparse add formals", {
  expect_true(length(formals(sparse_add)) >= 2L)
})

test_that("sparse mult formals", {
  expect_true(length(formals(sparse_mult)) >= 2L)
})

test_that("sparse sub formals", {
  expect_true(length(formals(sparse_sub)) >= 2L)
})

test_that("sparse crossprod formals", {
  expect_true(length(formals(sparse_crossprod)) >= 2L)
})

test_that("check returned class for add", {
  expect_s4_class({
    x <- as(c(0, 0, 0, 1, 2), "sparse_numeric")
    y <- as(c(1, 1, 0, 0, 4), "sparse_numeric")
    sparse_add(x, y)
  }, "sparse_numeric")
})

test_that("sparse_add", {
  result <- as(c(1, 1, 0, 1, 6), "sparse_numeric")
  expect_equal({
    x <- as(c(0, 0, 0, 1, 2), "sparse_numeric")
    y <- as(c(1, 1, 0, 0, 4), "sparse_numeric")
    sparse_add(x, y)
  }, result)
})

test_that("sparse_add handles mixed results", {
  result <- c(0,1,0)
  x <- as(c(1, -1, 0), "sparse_numeric")
  y <- as(c(-1,  2, 0), "sparse_numeric")
  expect_equal(as(sparse_add(x, y), "numeric"), result)
})

test_that("sparse add dense", {
  result <- as(c(2, 4, 6, 10, 12), "sparse_numeric")
  expect_equal({
    x <- as(c(1, 3, 4, 1, 2), "sparse_numeric")
    y <- as(c(1, 1, 2, 9, 10), "sparse_numeric")
    sparse_add(x, y)
  }, result)
})

test_that("all zero wrong length", {
  expect_error({
    x <- as(rep(0, 10), "sparse_numeric")
    y <- as(rep(0, 9), "sparse_numeric")
    sparse_add(x, y)
  })
})

test_that("sparse_mult runs correctly", {
  result <- as(c(3, 0, 8, 6), "sparse_numeric")
  expect_equal({
    x <- as(c(3, 0, 2, 2), "sparse_numeric")
    y <- as(c(1, 0, 4, 3), "sparse_numeric")
    sparse_mult(x, y)
  }, result)
})

test_that("sparse_mult errors", {
  x <- as(c(1,2,3), "sparse_numeric")
  y <- as(c(1,2), "sparse_numeric")
  expect_error(sparse_mult(x, y))
})


test_that("sparse_sub runs correctly", {
  result <- as(c(5, 4, 0, 2), "sparse_numeric")
  expect_equal({
    x <- as(c(10, 9, 0, 7), "sparse_numeric")
    y <- as(c(5, 5, 0, 5), "sparse_numeric")
    sparse_sub(x, y)
  }, result)
})

test_that("sparse_sub errors", {
  x <- as(c(1,2,3), "sparse_numeric")
  y <- as(c(1,2), "sparse_numeric")
  expect_error(sparse_sub(x, y))
})

test_that("sparse_crossprod runs correctly", {
  result <- 13
  expect_equal({
    x <- as(c(1, 0, 2), "sparse_numeric")
    y <- as(c(3, 4, 5), "sparse_numeric")
    sparse_crossprod(x, y)
  }, result)
})

test_that("mean runs correctly", {
  x <- as(c(0, 6, 0, 4), "sparse_numeric")
  expect_equal(mean(x), (6+4) / 4)
})

test_that("norm", {
  x <- as(c(3, 4), "sparse_numeric")
  expect_equal(norm(x), 5)
})

test_that("standardize runs correctly", {
  result <- c(-1, 1)
  expect_equal({
    x <- as(c(1, 3), "sparse_numeric")
    as(standardize(x), "numeric")
  }, result)
})

test_that("standardize errors", {
  x <- as(rep(3, 5), "sparse_numeric")
  expect_error(standardize(x))
})

test_that("+ works", {
  result <- c(1,3,3)
  x <- as(c(1,0,2), "sparse_numeric")
  y <- as(c(0,3,1), "sparse_numeric")
  expect_equal(as(x + y, "numeric"), result)
})

test_that("- works", {
  result <- c(3,2,0)
  x <- as(c(5,3,1), "sparse_numeric")
  y <- as(c(2,1,1), "sparse_numeric")
  expect_equal(as(x - y, "numeric"), result)
})

test_that("* works", {
  result <- c(2,0,9)
  x <- as(c(2,0,3), "sparse_numeric")
  y <- as(c(1,4,3), "sparse_numeric")
  expect_equal(as(x * y, "numeric"), result)
})


test_that("+ errors", {
  x <- as(c(0,1,0), "sparse_numeric")
  y <- as(c(1,2), "sparse_numeric")
  expect_error(x + y)
})

test_that("* errors", {
  x <- as(c(1,0,1), "sparse_numeric")
  y <- as(c(1,2), "sparse_numeric")
  expect_error(x * y)
})

test_that("sparse_mult returns empty sparse vector", {
  result <- as(c(0, 0, 0), "sparse_numeric")
  expect_equal({
    x <- as(c(1, 0, 0), "sparse_numeric")
    y <- as(c(0, 2, 0), "sparse_numeric")
    sparse_mult(x, y)
  }, result)
})


