#' Translate text from one language to another
#'
#' @param text The text to translate.
#' @param from The language to translate from. The default is NULL (not specified).
#' @param to The language to translate to. The default is "English". The default
#' can be modified using `emend_set_language()`.
#'
#'
#' @family translate
#'
#' @examples
#' # example code
#' emend_translate(c("猿も木から落ちる", "你好", "bon appetit"))
#'
#' @export
emend_translate <- function(text, from = NULL, to = emend_get_option("language")) {
  abort_if_not_text(text)

  map_chr(text, function(x) {
    emend_assist(list(prompt_user(x),
                    if(is.null(from)) prompt_user("Translate the above text to {to}. Just return the translated text.")
                    else prompt_user("Translate the above text from {from} to {to}. Just return the translated text.")))
  })
}


#' Determine if the input is a particular language
#'
#' @param text The text.
#' @param language The language to check. The default is "English".
#' @examples
#' emend_is_language(c("猿も木から落ちる", "你好", "bon appetit"),
#'                 language = "Japanese")
#' @family translate

#' @export
emend_is_language <- function(text, language = emend_get_option("language")) {
  abort_if_not_text(text)
  # TODO: check what language and see if this is matched with above

  map_lgl(text, function(x) {
    emend_yes_no(list(prompt_user(x),
                    prompt_user("Is the above text in {language}?")))
  })
}

#' Determine the language of the input text
#'
#' @param text The text.
#' @family translate
#' @examples
#' emend_what_language(c("猿も木から落ちる", "你好", "bon appetit"))
#' @export
emend_what_language <- function(text) {
  abort_if_not_text(text)
  map_chr(text, function(x) {
    emend_assist(list(prompt_user(x),
                    prompt_user("What language is the above text in?")),
               format = "json")[[1]]
  })
}
