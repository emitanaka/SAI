#' Define the model you are going to use for the analyses.
#'
#' @param provider The provider name. Choose one from {"ollama", "openai"}.
#' @param model The model name, e.g. "llama3.1:8b" for Ollama and "gpt-4o-mini" for OpenAI.
#'
#' @examples
#' # Set model for Ollama
#' my_model <- set_model("ollama", "llama3.1:8b")
#'
#' # Set model for OpenAI
#' my_model <- set_model("openai", "gpt-4o-mini")
#'
#' @export
set_model <- function(provider = NULL, model = NULL) {
  if(is.null(provider)) cli::cli_abort("Please provide the provider name.")
  if(is.null(model)) cli::cli_abort("Please provide the model name.")

  model_info <- list(
    provider = provider,
    model_name = model
  )

  return(model_info)
}


