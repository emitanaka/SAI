force_base64_encoding <- function(x) {
  if(!is_base64(x)) x <- base64enc::base64encode(x)
  x
}

is_base64 <- function(x) {
  # https://stackoverflow.com/questions/8571501/how-to-check-whether-a-string-is-base64-encoded-or-not
  grepl("^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)?$", x)
}

#' Describe the input image
#'
#' This requires a multimodal LLM like `llava:7b` to be installed.
#'
#' @param x A url or path to the image.
#' @param model The LLM to use.
#'
#' @export
sai_describe_image <- function(x,
                               model = sai_get_option("model")) {

  if(model$vendor=="ollama" && !grepl("llava", model$model)) cli::cli_abort("For ollama models, only multimodal models like {.var llava} can process images. Use the argument say {.code model = \"llava:8b\"}.")
  sai_assist(prompt_user("Describe the image.", images = x),
             model = model)
}
