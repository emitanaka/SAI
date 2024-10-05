test_that("multiplication works", {
  x <- runif(200)
  y <- x^2 + 3 * x
  png(tf1 <- tempfile(fileext = ".png"))
  plot(lm(y ~ x), 1)
  dev.off()
  x <- runif(200)
  y <- x + rnorm(200)
  png(tf1 <- tempfile(fileext = ".png"))
  plot(lm(y ~ x), 1)
  dev.off()
  img <- "https://upload.wikimedia.org/wikipedia/commons/3/35/Ggplot2_Violin_Plot.png"

  prompt_user("What does the image contain?", images = tf1) |>
    sai_assist(model = "llava:7b")
})
