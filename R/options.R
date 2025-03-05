
op.emend <- list(emend.model = model_ollama(.check_model_availability = FALSE),
               emend.language = "English")


#' @name emend_option
NULL

#' Get or set an option for the `emend` package
#'
#' @param x The name of the option to get or set.
#' @param val The value of the option to set.
#' @rdname emend_option
#' @export
emend_get_option <- function(x = c("model", "language", "all")) {
  x <- match.arg(x)
  if(x == "all") {
    op.emend
  } else {
    opt_name <- paste0("emend.", x)
    res <- getOption(opt_name)
    if(!is.null(res)) return(res)
    op.emend[[opt_name]]
  }
}


#' @rdname emend_option
#' @export
emend_set_option <- function(x = c("model", "language"), val) {
  x <- match.arg(x)
  args <- setNames(list(val), paste0("emend.", x))
  do.call(options, args)
}

#' @rdname emend_option
#' @export
emend_set_model <- function(val) {
  options(emend.model = val)
}

#' @rdname emend_option
#' @export
emend_set_model_args <- function(...) {
  args <- list(...)
  model <- getOption("emend.model") %||% op.emend[["emend.model"]]
    ifelse(is.null(res), op.emend[["emend.model"]], )
  for(nm in names(args)) model[[nm]] <- args[[nm]]
  options(emend.model = model)
}


#' @rdname emend_option
#' @export
emend_set_language <- function(val) {
  options(emend.language = val)
}

