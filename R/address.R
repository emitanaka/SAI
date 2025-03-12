#' Standardise address format
#'
#' This function standardise inconsistent address formats to a standard format.
#'
#' @param address_vector A character vector that is assumed to be addresses.
#' @param chat A chat object defined by ellmer.
#'
#' @examples
#' # Convert a vector of inconsistent formatted address to a standard format
#' x <- c("68/150 Acton Road, Acton ACT 2601", "655 Jackson St, Dickson ACT 2602",
#' "Unit 60 523 Joey Cct, Layton NSW 6500", "23/100 de burgh road, Southbank VIC 7800",
#' "999 Lords pl, Sydney nsw 6600", "i don't know the address")
#' emend_clean_address(x)
#'
#' @export
emend_clean_address <- function(address_vector, chat = NULL){

  if (!is.character(address_vector)) {rlang::abort("Input must be a character vector.")}
  if (is.null(chat)) {rlang::abort("Please provide the chat environment.")}

  chat$clone()
  chat$set_turns(list())

  converted <- lapply(address_vector, function(x){
    response <- chat$chat(paste0(
      "You are a tool for reformatting addresses into a standard format. Return result only, no explanation or comment.

       Follow these examples:

       Input: 31 constitution ave, canberra ACT 2601
       Output: 31 Constitution Avenue, Canberra ACT 2601

       Input: Unit 38 46 Oxford St, Darlinghurst NSW 2010
       Output: 38/46 Oxford St, Darlinghurst NSW 2010

       Input: Unit 11, 17 Cohen Place, Melbourne VIC 3000
       Output: 11/17 Cohen Place, Melbourne VIC 3000

       Now process: ", x
    ))
    return(response)
  })

  return(unlist(converted))
}



