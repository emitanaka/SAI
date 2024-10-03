
#' Translate text from one language to another
#'
#' @param text The text to translate.
#' @param from The language to translate from. The default is NULL (not specified).
#' @param to The language to translate to. The default is "English". The default
#' can be modified using `sai_set_language()`.
#'
#'
#' @family translate
#'
#' @examples
#' # example code
#' sai_translate(c("猿も木から落ちる", "在公寓区，周边有很多吃的还有大型超市，很方便"))
#'
#' @export
sai_translate <- function(text, from = NULL, to = sai_get_option("language")) {
  abort_if_not_text(text)

  map_chr(text, function(x) {
    sai_assist(list(prompt_user(x),
                    if(is.null(from)) prompt_user("Translate the above text to {to}.")
                    else prompt_user("Translate the above text from {from} to {to}.")),
               format = "none")
  })
}


#' Determine if the input is a particular language
#'
#' @param text The text.
#' @param language The language to check. The default is "English".
#' @examples
#' sai_is_language(c("猿も木から落ちる", "在公寓区，周边有很多吃的还有大型超市，很方便"),
#'                 language = "Japanese")
#' @family translate

#' @export
sai_is_language <- function(text, language = sai_get_option("language")) {
  abort_if_not_text(text)
  # TODO: check what language and see if this is matched with above

  map_lgl(text, function(x) {
    sai_yes_no(list(prompt_user(x),
                    prompt_user("Is the above text in {language}?")))
  })
}

#' Determine the language of the input text
#'
#' @param text The text.
#' @family translate
#' @examples
#' sai_what_language(c("猿も木から落ちる", "在公寓区，周边有很多吃的还有大型超市，很方便"))
#' @export
sai_what_language <- function(text) {
  abort_if_not_text(text)
  map_chr(text, function(x) {
    sai_assist(list(prompt_user(x),
                    prompt_user("What language is the above text in?")),
               format = "json")[[1]]
  })
}
