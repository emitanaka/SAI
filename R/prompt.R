#' Prompt input for the LLM
#'
#' A helper function to create the prompt input.
#'
#' @param content A single text with any content in "{}" evaluated as an R expression.
#'   If the bracket contains "*" at the end (or regular expression match as specified in `.collapse_regex`)
#'   then it collapses into a comma separated list in a square bracket with each element single quoted.
#'   E.g. "{1:3*}" expands to ['1', '2', '3'].
#' @param role The role should be "user", "assistant" or "system".
#' @param images A list of path or url to the images (or base64 encoded images).
#' @param tool_calls Currently doesn't work as intended.
#' @param .content_envir The environment used to evaluate `content`.
#' @param .collapse_regex The regular expression match to collapse the content.
#' @examples
#' prompt_user("What should I eat today? Pick one of {c('Ramen', 'Pizza', 'Burger')*}.")
#' @export
prompt_user <- function(content, images = NULL, tool_calls = NULL, .content_envir = rlang::caller_env(), .collapse_regex = "[*]$") {
  prompt(content, role = "user", images = images, tool_calls = tool_calls, .content_envir = .content_envir, .collapse_regex = .collapse_regex)
}



prompt <- function(content,
                   role = c("user", "assistant", "system"),
                   images = NULL,
                   tool_calls = NULL,
                   .content_envir = rlang::caller_env(),
                   .collapse_regex = "[*]$") {

  abort_if_not_single_text(content)


  if(!is.null(images)) {
    if(!is.list(images) | length(images) > 1) {
      images <- list(force_base64_encoding(images))
    } else {
      images <- lapply(images, force_base64_encoding)
    }
  }

  role <- match.arg(role)
  out <- list(role = role,
              content = glue::glue(content, .transformer = collapse_transformer(.collapse_regex), .envir = .content_envir))
  if(!is.null(images)) out$images <- images
  if(!is.null(tool_calls)) out$tool_calls = tool_calls
  structure(out, class = c("prompt", class(out)))
}

#' Is this a prompt?
#'
#' @param x An input.
#' @return A logical value to indicate if it is a prompt or not.
#' @seealso [as_prompt()]
#' @examples
#' is_prompt(prompt_user("Hi!"))
#' @export
is_prompt <- function(x, role) {
  is <- inherits(x, "prompt")
  if(missing(role)) return(is)
  switch(role,
         user = x$role == "user",
         assistant = x$role == "assistant",
         system = x$role == "system")
}

#' @rdname is_prompt
#' @export
is_prompt_user <- function(x) {
  is_prompt(x, role = "user")
}

#' @rdname is_prompt
#' @export
is_prompt_system <- function(x) {
  is_prompt(x, role = "system")
}

#' @rdname is_prompt
#' @export
is_prompt_assistant <- function(x) {
  is_prompt(x, role = "assistant")
}

#' Make it into prompt
#'
#' @param x An input.
#' @param role The role.
#' @seealso [is_prompt()]
#' @export
as_prompt <- function(x, role, .content_envir = rlang::caller_env()) {
  if(!is_prompt(x) & missing(role)) return(prompt(x, role = "user", .content_envir = .content_envir))
  if(!is_prompt(x)) return(prompt(x, role = role, .content_envir = .content_envir))
  if(missing(role)) return(x)
  x$role <- role
  x
}



#' @rdname prompt_user
#' @export
prompt_assistant <- function(content, images = NULL, tool_calls = NULL,  .content_envir = rlang::caller_env(), .collapse_regex = "[*]$") {
  prompt(content, role = "assistant", images = images, tool_calls = tool_calls, .content_envir = .content_envir, .collapse_regex = .collapse_regex)
}

#' @rdname prompt_user
#' @export
prompt_system <- function(content, images = NULL, tool_calls = NULL,  .content_envir = rlang::caller_env(), .collapse_regex = "[*]$") {
  prompt(content, role = "system", images = images, tool_calls = tool_calls, .content_envir = .content_envir, .collapse_regex = .collapse_regex)
}

