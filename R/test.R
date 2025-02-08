library(ellmer)

options(ellmer_timeout_s = 360000)

#' Match the input factor to supplied levels
#'
#' @param .f A factor.
#' @param levels The levels of the factor.
#' @param chat The chat environment from ellmer.
#' @param ... Other prompts to the LLM.
#'
#' @seealso [sai_lvl_sweep()]
#' @export
lvl_match <- function(.f, levels = NULL, chat, ...) {
  if(is.null(levels)) cli::cli_abort("Please provide the levels of the factor.")
  if(is.null(chat)) cli::cli_abort("Please provide the chat environment.")

  lvls_unmatched <- setdiff(unique(.f), levels)
  lvls_intersect <- intersect(unique(.f), levels)

  matched <- lapply(lvls_unmatched, function(x){
    chat$chat(paste0(
      "You are a data cleaning expert. ",
      "Standardise the following input text into one of the levels from: ",
      paste(levels, collapse = ","), ". ",
      "If no match, return 'Unidentified'. Return result only. ",
      "No code writing. ",
      ...,
      "Input: 'messy_text' ",
      "Output: 'level' ",
      "Now process: ", x
    ))
  })

  out <- unlist(matched)
  out[!out %in% levels] <- "Unidentified"
  dict <- setNames(c(out, lvls_intersect), c(lvls_unmatched, lvls_intersect))
  structure(dict, class = c("lvl_match", class(dict)))
}

#' @export
format.lvl_match <- function(x, ...) {
  out <- data.frame(original = names(x), converted = unname(unclass(x))) |>
    subset(is.na(converted) | original != converted)
  out <- out[order(out$converted), ]
  rownames(out) <- NULL
  out
}

#' @export
print.lvl_match <- function(x, ...) {
  print(unclass(x))
  cli::cli_h1("Converted by SAI:")
  out <- format(x)
  print(out, ...)
}

#' @rdname lvl_match
#' @export
fct_match <- function(.f, levels = NULL, chat, ...) {
  dict <- lvl_match(.f, levels, chat, ...)
  factor(unname(unclass(dict)[.f]), levels = levels)
}

messy <-  c("USA", "UK", "U.S.", "England", "united state", "United States", "United Kingdom")
levels <-  c("United States", "United Kingdom", "Unidentified")

chat <- chat_ollama(model = "llama3.1:8b")
cleaned_data <- fct_match(messy, levels, chat)
cleaned_data
