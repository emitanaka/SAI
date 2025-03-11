#' Translate text from one language to another
#'
#' @param text The text to translate.
#' @param from The language to translate from. The default is NULL (not specified).
#' @param to The language to translate to. The default is "English". The default
#' can be modified using `sai_set_language()`.
#'
#' @family translate
#'
#' @examples
#' # example code
#' sai_translate(c("猿も木から落ちる", "你好", "bon appetit"))
#'
#' @export
translate <- function(text, from = NULL, to = "English") {

  if (!is.character(text)) {
    rlang::abort("Input must be a character vector.")
  }

  map_chr(text, function(x) {
    sai_assist(list(prompt_user(x),
                    if(is.null(from)) prompt_user("Translate the above text to {to}. Just return the translated text.")
                    else prompt_user("Translate the above text from {from} to {to}. Just return the translated text.")))
  })
}
