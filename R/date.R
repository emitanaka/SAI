#' Reformat dates
#'
#' This function re-formats dates based on ...
#'
#' @param dates_vector A character vector that is assumed to be dates.
#' @param input_format A character value to specify input date format.
#' @param output_format A character value to specify output date format.
#'
#' @export
sai_date_format <- function(dates_vector, input_format = "DDMMYYYY", output_format = "YYYYMMDD", copy = FALSE, ...) {
  out <- sai_assist(
    c(list("The input data is a vector of dates, the input dates are in format of {input_format*}.
            InputData = {dates_vector*}.
            Input data are in different date format.
            You need to convert the input date into {output_format*}.
            Only return the output dates in a vector format.
            If the input is not date, return NA.")),
    format = "json")
  if(copy) clipr::write_clip(paste0(deparse(out), collapse = ""))
  out
}
