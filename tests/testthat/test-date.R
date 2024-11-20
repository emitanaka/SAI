test_that("date cleaning works", {
  x <- c("12/05/2024", "11/15/2024", "02/25/2024")

  skip_on_cran()
  expect_equal(sai_clean_date(x, input_format = "MM/DD/YYYY"),
               structure(c(20062, 20042, 19778), class = "Date"))
})
