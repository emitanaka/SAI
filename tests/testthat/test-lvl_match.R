test_that("emend_lvl_match match messy data to correct levels", {
  chat_mock <- ellmer::chat_ollama(model = "llama3.1:8b", seed = 0, echo = "none")

  dict_1 <- setNames(c(c("Europe", "North America", "North America", "Europe", "North America", "Oceania", "Oceania", "Oceania"), c()),
                     c(c("UK", "US", "Canada", "United Kingdom", "USA", "New Zealand", "NZ", "Australia"), c()))
  truth_1 <- structure(dict_1, class = c("emend_lvl_match", class(dict_1)))
  result_1 <- emend_lvl_match(messy$country,
                              levels = c("Asia", "Europe", "North America", "Oceania", "South America"),
                              chat = chat_mock)
  expect_equal(result_1, truth_1)

  dict_2 <- setNames(c(c("USA", "UK", "NZ"), c("UK", "Canada", "USA", "NZ", "Australia")),
                     c(c("US", "United Kingdom", "New Zealand"), c("UK", "Canada", "USA", "NZ", "Australia")))
  truth_2 <- structure(dict_2, class = c("emend_lvl_match", class(dict_2)))
  result_2 <- emend_lvl_match(messy$country, levels = c("UK", "USA", "Canada", "Australia", "NZ"), chat = chat_mock)
  expect_equal(result_2, truth_2)
})
