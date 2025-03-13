test_that("emend_fct_reorder reorder input factor", {
  chat_mock <- ellmer::chat_ollama(model = "llama3.1:8b", seed = 0, echo = "none")

  truth_1 <- c("Strongly Disagree", "Disagree", "Somewhat Disagree", "Neutral", "Somewhat Agree", "Agree", "Strongly Agree")
  result_1 <- emend_fct_reorder(likerts$likert1, chat = chat_mock) |> levels()
  expect_equal(result_1, truth_1)

  truth_2 <- c("Strongly Disagree", "Disagree", "Neutral", "Agree", "Strongly Agree")
  result_2 <- emend_fct_reorder(likerts$likert2, chat = chat_mock) |> levels()
  expect_equal(result_2, truth_2)

  truth_3 <- c()
  result_3 <- emend_fct_reorder(likerts$likert3, chat = chat_mock) |> levels()

})
