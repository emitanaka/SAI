test_that("clean address works", {
  x <- c("Unit 2 211 La Trobe St, Melbourne VIC 3000",
         "Unit 93 97 Plenty Rd, Bundoora VIC 3083",
         "1 barton street, cobar nsw 2835",
         "30 Orr St, Queenstown TAS 7467",
         "29 Buckley st, Yorkeys Knob QLD 4878")

  output <- c("2/211 La Trobe Street, Melbourne VIC 3000",
              "93/97 Plenty Road, Bundoora VIC 3083",
              "1 Barton Street, Cobar NSW 2835",
              "30 Orr Street, Queenstown TAS 7467",
              "29 Buckley Street, Yorkeys Knob QLD 4878")

  expect_equal(sai_clean_address(x), output)
})
