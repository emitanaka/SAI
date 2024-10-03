test_that("factor", {


# fix factor labels -------------------------------------------------------

 #sai_fct_sweep(messy$suburb)

  expect_equal(sai_fct_match(messy$country, c("USA", "UK", "Canada")),
               structure(c(UK = 2L, US = 1L, Canada = 3L, UK = 2L, US = 1L,
                           Canada = 3L, `United Kingdom` = 2L, USA = 1L, `New Zealand` = NA,
                           NZ = NA, Australia = NA, `New Zealand` = NA, UK = 2L, `United Kingdom` = 2L,
                           UK = 2L, US = 1L, `United Kingdom` = 2L, Australia = NA, US = 1L,
                           Australia = NA), levels = c("USA", "UK", "Canada"), class = "factor"))

  expect_equal(sai_fct_match(messy$country, c("Asia", "Europe", "Africa", "Oceania", "Americas")),
               structure(c(UK = 2L, US = 5L, Canada = 5L, UK = 2L, US = 5L,
                           Canada = 5L, `United Kingdom` = 2L, USA = 5L, `New Zealand` = 4L,
                           NZ = 4L, Australia = 4L, `New Zealand` = 4L, UK = 2L, `United Kingdom` = 2L,
                           UK = 2L, US = 5L, `United Kingdom` = 2L, Australia = 4L, US = 5L,
                           Australia = 4L), levels = c("Asia", "Europe", "Africa", "Oceania",
                                                       "Americas"), class = "factor"))

  expect_equal(sai_fct_match(messy$school, c("Research School of Biology", "Research School of Physics", "College of Health and Medicine")),
               structure(c(`Research School of Biology` = 1L, `Resrch School of Biology` = 1L,
                           `Resarch Schl of Biology` = 1L, RSB = 1L, Biology = 1L, `Research School of Physics` = 2L,
                           `College of Health & Medicine` = 3L, `College of Health and Medicine` = 3L,
                           CHM = 3L, CHM = 3L, `College of Health & Medicine` = 3L, `Research School of Physics` = 2L,
                           CHM = 3L, `College of Health and Medicine` = 3L, CHM = 3L, `College of Health & Medicine` = 3L,
                           `College of Health and Medicine` = 3L, `Research School of Physics` = 2L,
                           `College of Health & Medicine` = 3L, `Resarch Schl of Biology` = 1L
               ), levels = c("Research School of Biology", "Research School of Physics",
                             "College of Health and Medicine"), class = "factor"))

  expect_equal(sai_fct_match(messy$school, c("RSB", "RSP", "CHM")),
               structure(c(`Research School of Biology` = 1L, `Resrch School of Biology` = 1L,
                           `Resarch Schl of Biology` = 1L, RSB = 1L, Biology = 1L, `Research School of Physics` = 2L,
                           `College of Health & Medicine` = 3L, `College of Health and Medicine` = 3L,
                           CHM = 3L, CHM = 3L, `College of Health & Medicine` = 3L, `Research School of Physics` = 2L,
                           CHM = 3L, `College of Health and Medicine` = 3L, CHM = 3L, `College of Health & Medicine` = 3L,
                           `College of Health and Medicine` = 3L, `Research School of Physics` = 2L,
                           `College of Health & Medicine` = 3L, `Resarch Schl of Biology` = 1L
               ), levels = c("RSB", "RSP", "CHM"), class = "factor"))


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
