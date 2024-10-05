
#' Reorder levels of an ordinal factor
#'
#' This function reorders the levels of a factor based on the sentiment scores of the levels.
#' Using this function can be expensive (depending on the LLM used and user's computer spec)
#' so users may wish to use this interactively only and copy the output into their script.
#'
#'
#' @param .f A character vector that is assumed to be an ordinal factor.
#' @param copy A logical value to indicate whether the output should be copied into the
#'  user's clipboard.
#' @examples
#' # to get the new level order
#' # users should check if the new order
#' sai_lvl_order(likerts$likert1)
#' # `copy = TRUE` copies the output into clipboard in a format that can be
#' # entered easiliy in the user's script
#' sai_lvl_order(likerts$likert1, copy = TRUE)
#' # to apply the new levels directly to the input
#' sai_fct_reorder(likerts$likert1)
#'
#' @export
sai_lvl_order <- function(.f, copy = FALSE, ...) {
  lvls <- unique(.f)
  res <- reorder_3(lvls, ...)
  if(copy) clipr::write_clip(paste0(deparse(res), collapse = ""))
  res
}

#' @rdname sai_lvl_order
#' @export
sai_fct_reorder <- function(.f) {
  lvls <- sai_lvl_order(.f)
  factor(.f, levels = lvls)
}


# This seems to be better
reorder_2 <- function(lvls, ...) {
  out <- sai_assist("Give the sentiment score, where negative score means negative sentiment,
                     for each level of the input: {lvls*}",
                    format = "json")
  res <- names(sort(unlist(out)))
  if(length(res) != length(lvls) | !all(res %in% lvls)) {
      cli::cli_warn("Could not reorder the levels meaningfully.")
      return(lvls)
  }
  res
}


# works for all
reorder_3 <- function(lvls, ...) {
  dots <- list(...)
  out <- sai_assist(c(list("Rank the sentiment scores for each level of the input: {lvls*}.
                    Positive connotations like satisfied or likely should have positive scores.
                    Negative connotations like unsatisfied or unlikely should have negative scores.
                    Satisfied should have a higher score than somewhat satisfied.
                    Agree should have a higher score than somewhat agree.
                    Neutral elements should have a score of 0.
                    Just give the scores.
                    If 'not applicable' or 'not answered', assign NA."), dots),
                    format = "json")
  vec <- unlist(out)
  # break ties
  if(any(duplicated(vec))) {
    dups <- vec[duplicated(vec)]
    out2 <- sai_assist(c(list("Rank the sentiment scores for each level of the input: {lvls[vec %in% dups]*}.
                    Positive connotations like satisfied or likely should have positive scores.
                    Negative connotations like unsatisfied or unlikely should have negative scores.
                    Satisfied should have a higher score than somewhat satisfied.
                    Agree should have a higher score than somewhat agree.
                    Neutral elements should have a score of 0.
                    Just give the scores for each element.
                    If 'not applicable' or 'not answered', assign NA."), dots),
                    format = "json")
    vec2 <- unlist(out2)
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
# Another strategy above is to compare two at a time
# Or if there are many categories, split them and compare like any sorting algorithm




#' Sweep factor levels to group similar levels together
#'
#' This function attempts to automatically standardise input labels that should
#' have been the same by making a few assumptions. The assumptions include that
#' the levels with high frequency are correct and low frequency levels may contain
#' typos or alternative representation of other existing levels.
#'
#' Be warned that this function is experimental and may not work as intended.
#'
#' @param .f A factor
#' @param known A character vector of the levels that are known to be correct. If none
#'   are provided, it is assumed that no correct values are known. If an element has a name
#'   associated with it, it is assumed that the name is what is recorded and the value is
#'   what the actual label should be.
#' @param wrong A character vector of the levels known to be wrong and should be
#'   grouped with another level.
#' @param nlevels_max The maximum number of levels.
#' @param nlevels_min The minimum number of levels.
#' @param nlevels_top The number of levels that are correct based on the top frequencies, excluding
#'  levels that have observations less than `n_min`.
#' @param nlevels_bottom The number of levels that are incorrect based on the bottom frequencies,
#'   excluding those that have observation less than `n_min`.
#' @param n_min The minimum of observations for each level. The default is 1.
#' @seealso [sai_lvl_match()]
#' @export
sai_fct_sweep <- function(.f,
                          known = NULL,
                          wrong = NULL,
                          nlevels_max = length(unique(.f)) - length(wrong),
                          nlevels_min = length(unique(known)) + 1,
                          nlevels_top = round(nlevels_max * 0.25),
                          nlevels_bottom = 0,
                          n_min = 1L,
                          ...) {

  abort_if_not_chr(.f)
  if(!is.null(known)) abort_if_not_chr(known)
  abort_if_not_single_numeric(n_min)
  abort_if_not_single_numeric(nlevels_max)
  abort_if_not_single_numeric(nlevels_min)


  if(is.null(known)) {
    lvls_known <- character(0)
    f <- .f
  } else {
    lvls_known <- unique(known)
    nms_known <- names(known)
    nms_known[nms_known == ""] <- known[nms_known == ""]
    lvls_missing <- setdiff(unique(.f), nms_known)
    dict_all <- c(nms_known, setNames(lvls_missing, lvls_missing))
    # fix up all the known ones
    f <- dict_all[.f]
  }
  tt <- table(f)
  wrong <- unique(c(wrong, setdiff(names(tt)[tt < n_min], known)))

  if(nlevels_top > 0) {
    top <- setdiff(setdiff(names(tt[rank(-tt) <= nlevels_top]), wrong), known)
    ntop <- max(nlevels_max - length(unique(known)), length(top), 0)
    if(length(top)) top <- top[seq(ntop)]
    known <- unique(c(known, top))
  }

  if(nlevels_bottom > 0) {
    wrong <- unique(c(wrong, setdiff(names(tt[rank(tt) <= nlevels_bottom]), known)))
  }

  unknown <- setdiff(unique(f), c(wrong, known))
  if(length(wrong)) {
    dict <- sai_lvl_match(wrong, levels = c(unknown, known), "Only match if supremely confident using trusted sources.")
    dict <- na.omit(dict)
  } else {
    dict <- NULL
    unknown_set <- unknown
    for(x in unknown) {
      d <- sai_lvl_match(x, levels = c(known, setdiff(unknown_set, x)), "Only match if supremely confident  using trusted sources.")
      if(!is.na(d)) {
        unknown_set <- setdiff(unknown_set, names(d))
        dict <- c(dict, d)
      }
    }
  }
  lvl_unmatched <- setdiff(unique(f), names(dict))
  dict_all <- c(dict, setNames(lvl_unmatched, lvl_unmatched))
  known_updated <- c(known, setdiff(dict, known))
  new_f <- dict_all[f]
  nl <- length(unique(f))
  if(nl <= nlevels_max & nl >= nlevels_min) return(factor(new_f, levels = unique(new_f)))
  out <- sai_fct_sweep(unname(new_f), known = known_updated, nlevels_max = nlevels_max, nlevels_min = nlevels_min,
                       nlevels_top = nlevels_top, nlevels_bottom = nlevels_bottom, n_min = n_min)
  setNames(out, .f)
}

#' Match the input factor to supplied levels
#'
#' @param .f A factor.
#' @param levels The levels of the factor.
#' @param ... Other prompts to the LLM.
#'
#' @seealso [sai_lvl_sweep()]
#' @export
sai_lvl_match <- function(.f, levels = NULL, ...) {
  if(is.null(levels)) cli::cli_abort("Please provide the levels of the factor.")
  lvls_unmatched <- setdiff(unique(.f), levels)
  lvls_intersect <- intersect(unique(.f), levels)
  matched <- lapply(lvls_unmatched, function(x) {
    sai_assist(list(prompt_user("For '{x}' (which may be an acronym) return the best match from {levels*}.
                           Return 'NA' if no match, not confident or not sure.
                           "),
                    ...),
               format = "json")[[1]]
  })
  out <- unname(unlist(matched))
  out[!out %in% levels] <- NA
  dict <- setNames(c(out, lvls_intersect), c(lvls_unmatched, lvls_intersect))
  structure(dict, class = c("sai_lvl_match", class(dict)))
}

#' @export
format.sai_lvl_match <- function(x, ...) {
  out <- data.frame(original = names(x), converted = unname(unclass(x))) |>
    subset(is.na(converted) | original != converted)
  out <- out[order(out$converted), ]
  rownames(out) <- NULL
  out
}

#' @export
print.sai_lvl_match <- function(x, ...) {
  print(unclass(x))
  cli::cli_h1("Converted by SAI:")
  out <- format(x)
  print(out, ...)
}

#' @rdname sai_lvl_match
#' @export
sai_fct_match <- function(.f, levels = NULL, ...) {
  dict <- sai_lvl_match(.f, levels, ...)
  factor(unname(unclass(dict)[.f]), levels = levels)
}

#' @rdname sai_fct_sweep
#' @export
sai_lvl_sweep <- function(.f,
                          known = NULL,
                          wrong = NULL,
                          nlevels_max = length(unique(.f)) - length(wrong),
                          nlevels_min = length(unique(known)) + 1,
                          nlevels_top = round(nlevels_max * 0.25),
                          nlevels_bottom = 0,
                          n_min = 1L,
                          ...) {
  dict <- sai_fct_sweep(.f,
                        known = known,
                        wrong = wrong,
                        nlevels_max = nlevels_max,
                        nlevels_min = nlevels_min,
                        nlevels_top = nlevels_top,
                        nlevels_bottom = nlevels_bottom,
                        n_min = n_min,
                        ...)

  res <- setNames(as.character(dict), .f)
  structure(res[!duplicated(paste0(res, names(res)))], class = c("sai_lvl_match", class(res)))
}
