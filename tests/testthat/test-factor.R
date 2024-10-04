test_that("factor", {


# fix factor labels -------------------------------------------------------

 #sai_fct_sweep(messy$suburb)

  expect_equal(sai_fct_match(messy$country, c("USA", "UK", "Canada")),
               structure(c(2L, 1L, 3L, 2L, 1L, 3L, 2L, 1L, NA, NA, NA, NA, 2L,
                           2L, 2L, 1L, 2L, NA, 1L, NA), levels = c("USA", "UK", "Canada"
                           ), class = "factor"))

  expect_equal(sai_fct_match(messy$country, c("Asia", "Europe", "Africa", "Oceania", "Americas")),
               structure(c(2L, 5L, 5L, 2L, 5L, 5L, 2L, 5L, 4L, 4L, 4L, 4L, 2L,
                           2L, 2L, 5L, 2L, 4L, 5L, 4L), levels = c("Asia", "Europe", "Africa",
                                                                   "Oceania", "Americas"), class = "factor"))

  expect_equal(sai_fct_match(messy$school, c("Research School of Biology", "Research School of Physics", "College of Health and Medicine")),
               structure(c(1L, 1L, 1L, 1L, 1L, 2L, 3L, 3L, 3L, 3L, 3L, 2L, 3L,
                           3L, 3L, 3L, 3L, 2L, 3L, 1L), levels = c("Research School of Biology",
                                                                   "Research School of Physics", "College of Health and Medicine"
                           ), class = "factor"))

  expect_equal(sai_fct_match(messy$school, c("RSB", "RSP", "CHM")),
               structure(c(1L, 1L, 1L, 1L, 1L, 2L, 3L, 3L, 3L, 3L, 3L, 2L, 3L,
                           3L, 3L, 3L, 3L, 2L, 3L, 1L), levels = c("RSB", "RSP", "CHM"), class = "factor"))


# ordinal variables -------------------------------------------------------

  expect_equal(sai_lvl_order(likerts$likert1),
               c("Strongly Disagree", "Disagree", "Somewhat Disagree", "Neutral", "Somewhat Agree",
                 "Agree", "Strongly Agree"))

  expect_equal(sai_lvl_order(likerts$likert2),
               c("Strongly Disagree", "Disagree", "Neutral", "Agree", "Strongly Agree"))

  expect_equal(sai_lvl_order(likerts$likert3),
               c("I strongly disagree", "I disagree", "I'm neutral about this",
                 "I agree", "I strongly agree"))

  expect_equal(sai_lvl_order(likerts$likert4),
               c("Never", "Rarely", "Sometimes", "Often", "Always"))

  expect_equal(sai_lvl_order(likerts$likert5),
               c("Very poor", "Poor", "Average", "Good", "Excellent"))

  expect_equal(sai_lvl_order(likerts$likert6),
               c("Very unlikely", "Unlikely", "Neutral", "Likely", "Very likely"))


  # expect_equal(sai_lvl_order(likerts$likert7),
  #              c("Not at all", "Slightly", "Moderately", "Very", "Extremely"))

  expect_equal(sai_lvl_order(likerts$likert8),
               c("Very dissatisfied", "Somewhat dissatisfied", "Neither dissatisfied or satisfied",
                 "Somewhat satisfied", "Very satisfied"))

  # expect_equal(sai_lvl_order(likerts$likert9),

  #              c("Not a priority", "Low priority", "Somewhat priority", "Neutral",
  #                "Moderate priority", "High priority", "Essential priority"))

})
