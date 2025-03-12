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
#' @param .f A factor.
#' @param chat A chat object defined by ellmer
#' @param ... Other prompts to the LLM.
#'
#' @examples
#' chat <- chat_ollama(model = "llama3.1:8b", seed = 0, echo = "none")
#' emend_fct_reorder(likerts$likert1, chat = chat) |> levels()
#'
#' @export
emend_fct_reorder <- function(.f, chat = NULL, ...) {
  if(is.null(chat)) cli::cli_abort("Please provide the chat object.")
  lvls <- emend_lvl_order(.f, chat, ...)
  factor(.f, levels = lvls)
}

#' Reorder levels of an ordinal factor
#'
#' This function reorders the levels of a factor based on the sentiment scores of the levels.
#' Using this function can be expensive (depending on the LLM used and user's computer spec)
#' so users may wish to use this interactively only and copy the output into their script.
#'
#' @param .f A character vector that is assumed to be an ordinal factor.
#' @param chat A chat object defined by ellmer.
#' @param copy A logical value to indicate whether the output should be copied into the
#'  user's clipboard.
#' @param ... Extra prompts to the LLM.
#'
#' @examples
#' # to get the new level order
#' # users should check if the new order
#' chat <- chat_ollama(model = "llama3.1:8b", seed = 0, echo = "none")
#' emend_lvl_order(likerts$likert1, chat = chat)
#' # `copy = TRUE` copies the output into clipboard in a format that can be
#' # entered easiliy in the user's script
#' emend_lvl_order(likerts$likert1, chat = chat, copy = TRUE)
#'
#' @export
emend_lvl_order <- function(.f, chat = NULL, copy = FALSE, ...) {
  lvls <- unique(.f)
  res <- reorder_3(lvls, chat, ...)
  if(copy) clipr::write_clip(paste0(deparse(res), collapse = ""))
  res
}

# works for all
reorder_3 <- function(lvls, chat = NULL, ...) {

  chat$clone()
  chat$set_turns(list())

  out <- chat$chat(paste0(
    "Rank the sentiment scores for each level of the input: ",
    paste(lvls, collapse = ", "), ". ",
    "Positive connotations like satisfied or likely should have positive scores.
                    Negative connotations like unsatisfied or unlikely should have negative scores.
                    Satisfied should have a higher score than somewhat satisfied.
                    Agree should have a higher score than somewhat agree.
                    Neutral elements should have a score of 0.
                    Just give the scores. Return result only in JSON object.
                    Return a valid JSON object without any backticks around it.
                    No commentary. "))
  out_json <- jsonlite::fromJSON(out)
  vec <- unlist(out_json)
  # break ties
  if(any(duplicated(vec))) {
    dups <- vec[duplicated(vec)]
    out2 <- chat$chat(paste0(
      "Rank the sentiment scores for each level of the input: ",
      paste(lvls[vec %in% dups], collapse = ", "), ". ",
      "Positive connotations like satisfied or likely should have positive scores.
                    Negative connotations like unsatisfied or unlikely should have negative scores.
                    Satisfied should have a higher score than somewhat satisfied.
                    Agree should have a higher score than somewhat agree.
                    Neutral elements should have a score of 0.
                    Just give the scores. Return result only in JSON object.
                    Return a valid JSON object without any backticks around it.
                    No commentary.  ",
      ...
    ))
    out2_json <- jsonlite::fromJSON(out2)
    vec2 <- unlist(out2_json)
    vec2 <- vec2 / sum(vec2)
    vec[vec %in% dups] <- vec[vec %in% dups] + vec2
  }
  res <- names(sort(vec))
  if(length(vec) != length(lvls)) {
    cli::cli_warn("Could not reorder the levels meaningfully.")
    return(lvls)
  }
  if(!all(res %in% lvls)) {
    res <- names(sort(setNames(vec, lvls)))
  }
  res
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
