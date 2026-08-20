test_that("does filter2 select rows correctly", {
  expect_equal(filter2(iris, 1:5), iris[1:5, ])
})

