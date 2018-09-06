context("formatting")


test_that("we can create an aon themed ggplot", {

  ggSetTheme()

  gg_test <- ggplot2::qplot(utils::head(iris)$Sepal.Length)
  expect_is(gg_test, "ggplot")

})

test_that("we can format a number in comma style", {

  expect_equal(number_format(10000.12, digits = 2), "10,000.12")
  expect_equal(number_format(10000.12, digits = 0), "10,000")
  expect_equal(number_format(99.15652, digits = 1), "99.2")
  expect_error(number_format("99.15652"))

})

test_that("we can format a number in percent style", {

  expect_equal(pct_format(0.8546, digits = 2), "85.46%")
  expect_equal(pct_format(1000.2, digits = 0), "100,020%")
  expect_equal(pct_format(0.764, digits = 1), "76.4%")
  expect_error(pct_format("0.854"))

})
