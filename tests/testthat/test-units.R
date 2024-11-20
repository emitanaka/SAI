test_that("multiplication works", {
  c("20mL", "400L", "20 micro L") |>
    sai_standardise_units(unit = "ml")


  c("", "3.3 billion words", "34 billion tokens", "33 billion words",
    "40GB", "300 billion tokens", "825 GiB", "825 GiB", "4 Tb", "400 billion tokens",
    "1.6 trillion tokens", "300 billion tokens", "1.56T words,",
    "825 GiB", "1.4 trillion tokens", "768 billion tokens", "180 billion tokens",
    "1.7TB", "38.5B tokens from webpages filtered for mathematical content and from papers submitted to the arXiv preprint server",
    "106 billion tokens", "1.3 trillion", "1.4 trillion", "Unknown",
    "", "1 trillion tokens, from RefinedWeb (filtered web text corpus)",
    "363 billion token dataset based on Bloomberg's data sources, plus 345 billion tokens from general purpose datasets",
    "329 billion tokens", "1.5 trillion tokens", "Unknown", "3.6 trillion tokens",
    "2 trillion tokens", "Unknown", "Unknown", "Unknown", "Unknown",
    "Unknown", "Unknown", "Unknown", "1.4T tokens", "Unknown", "6T tokens",
    "Unknown", "4.8T Tokens", "3T Tokens", "9T Tokens", "15.6T tokens"
  ) |>
    sai_standardise_units(unit = "tokens", "Take words to be the same as tokens.")
})
