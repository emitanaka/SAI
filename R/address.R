#' Standardise address format
#'
#' This function standardise inconsistent address formats to a standard format.
#'
#' @param address_vector A character vector that is assumed to be addresses.
#' @examples
#' # Convert a vector of inconsistent formatted address to a standard format
#' x <- c("68/150 Acton Road, Acton ACT 2601","655 Jackson St, Dickson ACT 2602","Unit 60 523 Joey Cct, Layton NSW 6500","23/100 de burgh road, Southbank VIC 7800","999 Lords pl, Sydney nsw 6600","i don't know the address")
#' emend_clean_address(x)
#' # `copy = TRUE` copies the output into clipboard in a format that can be entered easily in the user's script
#'
#' @export
emend_clean_address <- function(address_vector, copy = FALSE){
  out <- emend_assist(
    c(list("You are a tool for reformatting addresses into a standard format. Follow these examples:

            Input: 31 constitution ave, canberra ACT 2601
            Output: 31 Constitution Avenue, Canberra ACT 2601

            Input: Unit 38 46 Oxford St, Darlinghurst NSW 2010
            Output: 38/46 Oxford Street, Darlinghurst NSW 2010

            Input: Unit 11, 17 Cohen Place, Melbourne VIC 3000
            Output: 11/17 Cohen Place, Melbourne VIC 3000

            Now, reformat the following addresses:
            Input: {address_vector*}
            Output: ")),
    format = "json")
  if(copy) clipr::write_clip(paste0(deparse(out), collapse = ""))
  out[[1]]$standard_format
}


# test function 1
emend_clean_address_1 <- function(address_vector, copy = FALSE){
  out <- emend_assist(
    c(list("Can you help me convert my address data to a standard format?
            My address data is {address_vector*}.
            Use full street name.
            Convert 'Unit Number Street Name' to 'Number/Number Street Name'.
            First letter uppercase.
            Only return me the converted addresses in a vector format.
            Return NA if it is not an address.")),
    format = "json")
  if(copy) clipr::write_clip(paste0(deparse(out), collapse = ""))
  out[[1]]
}
