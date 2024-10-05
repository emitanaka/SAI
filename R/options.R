
op.sai <- list(sai.model = model_ollama(.check_model_availability = FALSE),
               sai.language = "English")


#' @name sai_option
NULL

#' Get or set an option for the `sai` package
#'
#' @param x The name of the option to get or set.
#' @param val The value of the option to set.
#' @rdname sai_option
#' @export
sai_get_option <- function(x = c("model", "language", "all")) {
  x <- match.arg(x)
  if(x == "all") {
    op.sai
  } else {
    opt_name <- paste0("sai.", x)
    res <- getOption(opt_name)
    if(!is.null(res)) return(res)
    op.sai[[opt_name]]
  }
}


#' @rdname sai_option
#' @export
sai_set_option <- function(x = c("model", "language"), val) {
  x <- match.arg(x)
  args <- setNames(list(val), paste0("sai.", x))
  do.call(options, args)
}

#' @rdname sai_option
#' @export
sai_set_model <- function(val) {
  options(sai.model = val)
}

#' @rdname sai_option
#' @export
sai_set_model_args <- function(...) {
  args <- list(...)
  model <- getOption("sai.model") %||% op.sai[["sai.model"]]
    ifelse(is.null(res), op.sai[["sai.model"]], )
  for(nm in names(args)) model[[nm]] <- args[[nm]]
  options(sai.model = model)
}


#' @rdname sai_option
#' @export
sai_set_language <- function(val) {
  options(sai.language = val)
}

