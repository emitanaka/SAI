test_that("emend_lvl_sweep clean up the levels", {
  chat_mock <- ellmer::chat_ollama(model = "llama3.1:8b", seed = 0, echo = "none")

  dict_1 <- setNames(c("United Kingdom", "USA", "Canada", "United Kingdom", "USA", "Canada", "United Kingdom",
                       "USA", "New Zealand", "New Zealand", "Australia", "New Zealand", "United Kingdom", "United Kingdom",
                       "United Kingdom", "USA", "United Kingdom", "Australia", "USA", "Australia"),
                     messy$country)
  truth_1 <- structure(dict_1, class = c("emend_lvl_sweep", class(dict_1)))
  result_1 <- emend_lvl_sweep(messy$country, chat = chat_mock)
  expect_equal(result_1, truth_1)
})
