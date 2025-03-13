test_that("emend_fct_reorder reorder input factor", {
  chat_mock <- ellmer::chat_ollama(model = "llama3.1:8b", seed = 0, echo = "none")

  truth_1 <- c("Strongly Disagree", "Disagree", "Somewhat Disagree", "Neutral", "Somewhat Agree", "Agree", "Strongly Agree")
  result_1 <- emend_fct_reorder(likerts$likert1, chat = chat_mock) |> levels()
  expect_equal(result_1, truth_1)

  truth_2 <- c("Strongly Disagree", "Disagree", "Neutral", "Agree", "Strongly Agree")
  result_2 <- emend_fct_reorder(likerts$likert2, chat = chat_mock) |> levels()
  expect_equal(result_2, truth_2)

  truth_3 <- c("I strongly disagree", "I disagree", "I'm neutral about this", "I agree", "I strongly agree")
  result_3 <- emend_fct_reorder(likerts$likert3, chat = chat_mock) |> levels()
  expect_equal(result_3, truth_3)

  truth_4 <- c("Never", "Rarely", "Sometimes", "Often", "Always")
  result_4 <- emend_fct_reorder(likerts$likert4, chat = chat_mock) |> levels()
  expect_equal(result_4, truth_4)

  truth_5 <- c("Very poor", "Poor", "Average", "Good", "Excellent")
  result_5 <- emend_fct_reorder(likerts$likert5, chat = chat_mock) |> levels()
  expect_equal(result_5, truth_5)

  truth_6 <- c("Very unlikely", "Unlikely", "Neutral", "Likely", "Very likely")
  result_6 <- emend_fct_reorder(likerts$likert6, chat = chat_mock) |> levels()
  expect_equal(result_6, truth_6)

  # does not work for likert7

  truth_8 <- c("Very dissatisfied", "Somewhat dissatisfied", "Neither dissatisfied or satisfied", "Somewhat satisfied", "Very satisfied")
  result_8 <- emend_fct_reorder(likerts$likert8, chat = chat_mock) |> levels()
  expect_equal(result_8, truth_8)

  truth_9 <- c("Not a priority", "Low priority", "Somewhat priority", "Moderate priority", "High priority", "Essential priority")
  result_9 <- emend_fct_reorder(likerts$likert9, chat = chat_mock) |> levels()
  expect_equal(result_9, truth_9)

  # total 8 tests, should pass 8
})
