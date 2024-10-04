test_that("translation works", {
  text <- c("猿も木から落ちる", "你好", "bon appetit")
  expect_equal(sai_what_language(text),
               c("Japanese", "Chinese", "French"))

  expect_equal(sai_is_language(text, language = "Japanese"),
               c(TRUE, FALSE, FALSE))
})
