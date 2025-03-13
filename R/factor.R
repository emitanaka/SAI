#' Match the input factor to supplied levels.
#'
#' @param .f A factor.
#' @param levels The levels of the factor.
#' @param chat The chat object defined by ellmer.
#' @param ... Other prompts to the LLM.
#'
#' @seealso [emend_lvl_sweep()]
#' @examples
#' chat <- chat_ollama(model = "llama3.1:8b", seed = 0, echo = "none")
#' emend_lvl_match(messy$country, levels = c("Asia", "Europe", "North America", "Oceania", "South America"), chat = chat)
#'
#' @export
emend_lvl_match <- function(.f, levels = NULL, chat = NULL, ...) {
  if(is.null(levels)) cli::cli_abort("Please provide the levels of the factor.")
  if(is.null(chat)) cli::cli_abort("Please provide the chat object.")

  lvls_unmatched <- setdiff(unique(.f), levels)
  lvls_intersect <- intersect(unique(.f), levels)

  chat$clone()
  chat$set_turns(list())

  matched <- lapply(lvls_unmatched, function(x){
    chat$chat(paste0(
      "For '", x, "' (which may be an acronym) return the best match from: ",
      paste(levels, collapse = ", "), ". ",
      "Return 'Unidentified' if no match, not confident or not sure.
      Return result only. No code writing or commentary. ",
      ...
    ))
  })

  out <- unlist(matched)
  out[!out %in% levels] <- "Unidentified"
  dict <- setNames(c(out, lvls_intersect), c(lvls_unmatched, lvls_intersect))
  structure(dict, class = c("emend_lvlmatch", class(dict)))
}

#' @export
format.emend_lvl_match <- function(x, ...) {
  out <- data.frame(original = names(x), converted = unname(unclass(x))) |>
    subset(is.na(converted) | original != converted)
  out <- out[order(out$converted), ]
  rownames(out) <- NULL
  out
}

#' @export
print.emend_lvl_match <- function(x, ...) {
  print(unclass(x))
  cli::cli_h1("Converted by emend:")
  out <- format(x)
  print(out, ...)
}

#' Match input factor to specified levels.
#' @param .f A factor.
#' @param levels The levels of the factor
#' @param chat A chat object defined by ellmer.
#' @param ... Other prompts to the LLM.
#'
#' @examples
#' chat <- chat_ollama(model = "llama3.1:8b", seed = 0, echo = "none")
#' emend_fct_match(messy$country, levels = c("UK", "USA", "Canada", "Australia", "NZ"), chat = chat)
#'
#' @export
emend_fct_match <- function(.f, levels = NULL, chat = NULL, ...) {
  dict <- emend_lvl_match(.f, levels, chat, ...)
  factor(unname(unclass(dict)[.f]), levels = levels)
}

#' Reorder the levels of the input factor in a meaningful way.
#' @param .f A vector of characters or a factor.
#' @param chat A chat object defined by ellmer.
#'
#' @examples
#' chat <- chat_ollama(model = "llama3.1:8b", seed = 0, echo = "none")
#' emend_fct_reorder(likerts$likert1, chat = chat) |> levels()
#'
#' @export
emend_fct_reorder <- function(.f, chat = NULL, ...) {
  if(is.null(.f)) cli::cli_abort("Please provide the input vector or factor.")
  if(!is.character(.f) && !is.factor(.f)) cli::cli_abort("Input must be a charactor vector or a factor.")
  if(is.null(chat)) cli::cli_abort("Please provide the chat object.")

  lvls <- reorder(unique(.f), chat = chat, ...)
  factor(.f, levels = lvls)
}

# reorder_3 replace function
reorder <- function(lvls, chat = NULL, ...) {

  chat$set_system_prompt(
    paste0(
      "You are a sentiment analysis model. Your task is to analyze the sentiment of the input sentence and provide a sentiment score. ",
      "The score should be a numerical value between -100 and 100, where: ",
      "* 100 indicates a very positive sentiment * 0 indicates a neutral sentiment * -100 indicates a very negative sentiment ",
      "Consider the overall tone of the sentence, including emotions, positivity, or negativity in the context. ",
      "Return score only."
    )
  )

  chat$set_turns(list())

  senti_scores <- lapply(lvls, function(x) {
    chat$chat(paste0(
      "Now process: ", x
    ))
  })

  scores <- as.numeric(unlist(senti_scores))

  df <- data.frame(Level = lvls, Score = scores)
  df_ordered <- df[order(df$Score), ]
  return(df_ordered$Level)
}

#' Clean up the levels for the input factor.
#'
#' @param .f A factor.
#' @param chat A chat object defined by ellmer.
#' @param ... Other prompts to the LLM.
#'
#' @examples
#' chat <- chat_ollama(model = "llama3.1:8b", seed = 0, echo = "none")
#' emend_lvl_sweep(messy$country, chat = chat)
#'
#' @export
emend_lvl_sweep <- function(.f, chat = NULL, ...){
  if(is.null(chat)) cli::cli_abort("Please provide the chat environment.")

  chat$clone()
  chat$set_turns(list())

  levels_0 <- unique(.f)
  levels_chat <- chat$chat(paste0(
    "I have a list of text data and they are messy. Some used abbreviations and some used full names. ",
    "Please standardise it using full names. ",
    ...,
    "Now process: ",
    paste(levels_0, collapse = ", "), ". ",
    "Return result in a pairwise JSON object only. No commentary. No code writing. No code wrapper."))

  levels_1 <- tryCatch({
    unlist(jsonlite::fromJSON(levels_chat))}, error = function(e) {
      cli::cli_warn("Failed to parse JSON response: {e$message}")
      return(setNames(rep(NA_character_, length(levels_0)), levels_0))
    })

  result <- dplyr::recode(.f, !!!levels_1)
  dict <- setNames(result, .f)
  structure(dict, class = c("emend_lvl_sweep", class(dict)))
}

#' @export
format.emend_lvl_sweep <- function(x, ...) {
  out <- data.frame(original = names(x), converted = unname(unclass(x))) |>
    subset(is.na(converted) | original != converted) |>
    unique()
  out <- out[order(out$converted), ]
  rownames(out) <- NULL
  out
}

#' @export
print.emend_lvl_sweep <- function(x, ...) {
  print(unclass(x))
  cli::cli_h1("Converted by emend:")
  out <- format(x)
  print(out, ...)
}
