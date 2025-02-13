#' Match the input factor to supplied levels.
#'
#' @param .f A factor.
#' @param levels The levels of the factor.
#' @param model The model defined by [set_model()].
#' @param ... Other prompts to the LLM.
#'
#' @seealso [lvl_sweep()]
#'
#' @export
lvl_match <- function(.f, levels = NULL, model = NULL, ...) {
  if(is.null(levels)) cli::cli_abort("Please provide the levels of the factor.")
  if(is.null(model)) cli::cli_abort("Please provide the chat environment.")

  lvls_unmatched <- setdiff(unique(.f), levels)
  lvls_intersect <- intersect(unique(.f), levels)

  if (model$provider == "ollama") {
    chat <- ellmer::chat_ollama(model = model$model_name)
  } else if (model$provider == "openai") {
    chat <- ellmer::chat_openai(model = model$model_name)
  } else {
    print("Your model is not supported by emend.")
  }

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
fct_match <- function(.f, levels = NULL, model = NULL, ...) {
  dict <- lvl_match(.f, levels, model, ...)
  factor(unname(unclass(dict)[.f]), levels = levels)
}

#' @rdname lvl_order
#' @export
fct_reorder <- function(.f, model = NULL, ...) {
  if(is.null(model)) cli::cli_abort("Please provide the chat environment.")
  lvls <- lvl_order(.f, model, ...)
  factor(.f, levels = lvls)
}

#' Reorder levels of an ordinal factor
#'
#' This function reorders the levels of a factor based on the sentiment scores of the levels.
#' Using this function can be expensive (depending on the LLM used and user's computer spec)
#' so users may wish to use this interactively only and copy the output into their script.
#'
#' @param .f A character vector that is assumed to be an ordinal factor.
#' @param model A model defined by [set_model()].
#' @param copy A logical value to indicate whether the output should be copied into the
#'  user's clipboard.
#' @param ... Extra prompts to the LLM.
#'
#' @examples
#' # to get the new level order
#' # users should check if the new order
#' lvl_order(likerts$likert1)
#' # `copy = TRUE` copies the output into clipboard in a format that can be
#' # entered easiliy in the user's script
#' lvl_order(likerts$likert1, copy = TRUE)
#' # to apply the new levels directly to the input
#' fct_reorder(likerts$likert1)
#'
#' @export
lvl_order <- function(.f, model = NULL, copy = FALSE, ...) {
  lvls <- unique(.f)
  res <- reorder_3(lvls, model, ...)
  if(copy) clipr::write_clip(paste0(deparse(res), collapse = ""))
  res
}

# works for all
reorder_3 <- function(lvls, model = NULL, ...) {

  if (model$provider == "ollama") {
    chat <- ellmer::chat_ollama(model = model$model_name)
  } else if (model$provider == "openai") {
    chat <- ellmer::chat_openai(model = model$model_name)
  } else {
    print("Your model is not supported by emend.")
  }

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
#' @param model The model defined by [set_model()].
#' @param ... Other prompts to the LLM.
#'
#' @export
lvl_sweep <- function(.f, model = NULL, ...){
  if(is.null(model)) cli::cli_abort("Please provide the chat environment.")

  if (model$provider == "ollama") {
    chat <- ellmer::chat_ollama(model = model$model_name)
  } else if (model$provider == "openai") {
    chat <- ellmer::chat_openai(model = model$model_name)
  } else {
    print("Your model is not supported by emend.")
  }

  levels_0 <- unique(.f)
  levels_chat <- chat$chat(paste0(
    "I have a list of text data and they are messy. ",
    "Please convert it to a standardised category. ",
    "Use full names. ",
    ...,
    "Now process: ",
    paste(levels_0, collapse = ", "), ". ",
    "Return result only in a pairwise JSON object. No commentary.
                  No code writing.
                  Example output:
                  {'original': 'standardised',
                   'original': 'standardised'}. "))
  levels_1 <- unlist(jsonlite::fromJSON(levels_chat))
  result <- dplyr::recode(.f, !!!levels_1)
  dict <- setNames(result, .f)
  structure(dict, class = c("lvl_sweep", class(dict)))
}

#' @export
format.lvl_sweep <- function(x, ...) {
  out <- data.frame(original = names(x), converted = unname(unclass(x))) |>
    subset(is.na(converted) | original != converted)
  out <- out[order(out$converted), ]
  rownames(out) <- NULL
  out
}

#' @export
print.lvl_sweep <- function(x, ...) {
  print(unclass(x))
  cli::cli_h1("Converted by SAI:")
  out <- format(x)
  print(out, ...)
}
