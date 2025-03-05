#' Standardise date format
#'
#' This function standardise inconsistent date formats.
#'
#' @param dates_vector A character vector that is assumed to be dates.
#' @param input_format A character value to specify input date format.
#' @param ... Extra options for the large language model.
#'
#' @examples
#' x <- c("12/05/2024", "11/15/2024", "02/25/2024")
#' emend_clean_date(x, input_format = "MM/DD/YYYY")
#' # `copy = TRUE` copies the output into clipboard in a format that can be entered easily in the user's script
#'
#'
#'
#' @export
emend_clean_date <- function(dates_vector, input_format = "DD/MM/YYYY", copy = FALSE, ...) {
  out <- emend_assist(
    c(list("The input data is a vector of dates, the input dates are in format of {input_format*}.
            InputData = {dates_vector*}.
            Input data are in different date format.
            You need to convert the input date into YYYY-MM-DD.
            Only return the output dates in a vector format.
            If the input is not date, return NA.")),
    format = "json", ...)
  if(copy) clipr::write_clip(paste0(deparse(out), collapse = ""))
  as.Date(out[[1]])
}
