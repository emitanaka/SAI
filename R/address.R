#' Standardise address format
#'
#' This function standardise inconsistent address formats.
#'
#' @param address_vector A character vector that is assumed to be addresses.
#' @param output_format A character value to specify output address format.
#'
#' @export
sai_clean_address <- function(address_vector, output_format = "155/255 Dickson St, Acton ACT 2602", copy = FALSE, ...){
  out <- sai_assist(
    c(list("The input data {address_vector*} is a vector of messy addresses.
            You need to standardise the input address to the format like {output_format*}.
            Example 1:
            Input: 'Unit 2, 100 Wentworth Place, Newtown NSW 6800',
            Output: '2/100 Wentworth Pl, Newtown NSW 6800'.
            Example 2:
            Input: '658 cleaning street, daton nsw 6900',
            Output: '658 Cleaning St, Daton NSW 6900'.
            Only return the output address in a vector format.
            If the input is not address, return NA.")),
    format = "json")
  if(copy) clipr::write_clip(paste0(deparse(out), collapse = ""))
  out
}
