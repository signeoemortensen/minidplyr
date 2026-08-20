test_that("does select2 select columns correctly", {
  expect_equal(select2(iris, 1:5), iris[ , 1:5])
})


