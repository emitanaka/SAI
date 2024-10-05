
abort_if_not_single_text <- function(x, call = rlang::caller_env()) {
  if(!(is.character(x) & length(x) == 1)) cli::cli_abort("Please provide a single text only.", call = call)
}

abort_if_not_single_numeric <- function(x, call = rlang::caller_env()) {
  if(!(is.numeric(x) & length(x) == 1)) cli::cli_abort("Please provide a single number only.", call = call)
}

abort_if_not_text <- function(x, call = rlang::caller_env()) {
  if(!is.character(x)) cli::cli_abort("Please provide a single text only.", call = call)
}

abort_if_not_chr <- function(x, call = rlang::caller_env()) {
  if(!is.character(x) & !is.factor(x)) cli::cli_abort("Please provide a text only.", call = call)
}

# maybe below is not needed?
prompt_collapse <- function(x, sep = ", ") {
  paste0("[", paste0(x, collapse = sep), "]")
}

# as inspired by the glue doc
collapse_transformer <- function(regex) {
  function(text, envir) {
    collapse <- grepl(regex, text)
    if (collapse) {
      text <- sub(regex, "", text)
    }
    res <- glue::identity_transformer(text, envir)
    if (collapse) {
      paste0("[", glue::glue_collapse(paste0("'", res, "'"), sep = ", "), "]")
    } else {
      res
    }
  }
}

abort_if_model_not_available <- function(model, vendor, mlist, call = rlang::caller_env()) {
  if(!model %in% mlist) cli::cli_abort("The model {.var {model}} is not available from the vendor {.var {vendor}}.",
                                       call = call)
}



# Compatibility functions for `purrr`

map_mold <- function(.x, .f, .mold, ...) {
  out <- vapply(.x, .f, .mold, ..., USE.NAMES = FALSE)
  names(out) <- names(.x)
  out
}

map_chr <- function (.x, .f, ...) {
  map_mold(.x, .f, character(1), ...)
}

map_lgl <- function(.x, .f, ...) {
  map_mold(.x, .f, logical(1), ...)
}


`%||%` <- function(a, b) {
  if (!is.null(a)) a else b
}
