test_that("emend_fct_match map messy data to correct levels", {
  chat_mock <- ellmer::chat_ollama(model = "llama3.1:8b", seed = 0, echo = "none")

  truth_1 <- factor(c("UK", "USA", "Canada", "UK", "USA", "Canada", "UK", "USA", "NZ",
               "NZ", "Australia", "NZ", "UK", "UK", "UK", "USA", "UK", "Australia",
               "USA", "Australia"), levels = c("UK", "USA", "Canada", "Australia", "NZ"))
  result_1 <- emend_fct_match(messy$country, levels = c("UK", "USA", "Canada", "Australia", "NZ"), chat = chat_mock)
  expect_equal(result_1, truth_1)
})
