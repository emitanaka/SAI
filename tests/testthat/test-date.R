test_that("date cleaning works", {
  x <- c("12/05/2024", "11/15/2024", "02/25/2024")

  output <- as.Date(c("2024-12-05", "2024-11-15", "2024-02-25"))

  expect_equal(sai_clean_date(x, input_format = "MM/DD/YYYY"), output)
})
