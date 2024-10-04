op.sai <- list(sai.model = "llama3.1:8b",
               sai.vendor = "ollama",
               sai.port = 11434,
               sai.language = "English",
               sai.num_predict = 1000)

#' @name sai_option
NULL

#' Get or set an option for the `sai` package
#'
#' @param x The name of the option to get or set.
#' @param val The value of the option to set.
#' @rdname sai_option
#' @export
sai_get_option <- function(x = c("model", "vendor", "port", "language", "num_predict", "all")) {
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
sai_set_option <- function(x = c("model", "port", "num_predict", "language"), val) {
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
sai_set_port <- function(val) {
  options(sai.port = val)
}

#' @rdname sai_option
#' @export
sai_set_language <- function(val) {
  options(sai.language = val)
}
