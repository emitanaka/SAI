#' Create a list of model and vendor
#'
#' @param model The name of the model
#' @param vendor The name of the vendor
#'
#' @export
model_vendor <- function(model, vendor) {
  get(paste0("model_", vendor))(model)
}

#' @rdname model_vendor
#' @export
model_ollama <- function(model = 'llama3.1:8b') {
  available_model_list <- ollama_model_list()
  # https://github.com/ollama/ollama#model-library
  abort_if_model_not_available(model, "ollama", available_model_list)
  list(model = model, vendor = "ollama")
}

#' @rdname model_vendor
#' @export
model_openai <- function(model = "gpt-4o-mini") {
  available_model_list <- openai_model_list()
  abort_if_model_not_available(model, 'openai', available_model_list)
  list(model = model, vendor = "ollama")
}

#' Specify the default arguments of the model
#'
#' @param vendor The vendor of the model.
#' @seealso [args_ollama()]
#' @export
args_model <- function(vendor, ...) {
  abort_if_not_single_text(vendor)
  get(paste0("args_", vendor))(...)
}

#' Specify the arguments of Ollama
#'
#' @param port The port number of the Ollama server.
#' @param format The format to use. Default is "none" and currently only other option is "json".
#' @param temperature The temperature of the model where higher temperature means higher creativity.
#' @param stop A list of stop sequences to use.
#' @param seed The seed to use for the model.
#' @param top_k The top k tokens to consider.
#' @param top_p The nucleus sampling or penalty. It limits the cumulative probability of the most likely tokens.
#'   Higher values allow more tokens and diverse responses, and while lower values are more focused and constrained answers.
#' @param num_predict The number of predictions to make.
#' @param keep_alive The time to keep the server alive.
#' @export
args_ollama <- function(port = sai_get_option("port"),
                        format = c("none", "json"),
                        tools = NULL,
                        temperature = 0,
                        stop = NA,
                        seed = NA,
                        top_k = 1,
                        top_p = 0.1,
                        num_predict = sai_get_option("num_predict"),
                        keep_alive = "5m") {
  format <- match.arg(format)
  list(port = port,
       format = format,
       tools = tools,
       temperature = temperature,
       stop = stop,
       seed = seed,
       top_k = top_k,
       top_p = top_p,
       num_predict = num_predict,
       keep_alive = keep_alive)
}


#' Specify the arguments of OpenAI
#'
#' @param api The API key to use.
#' @param format The format
#' @param max_tokens The maximum number of tokens to generate. This limits the length of the response.
#'   Tokens refers to a unit of text the model reads and can vary from one character to several words,
#'   varying based on the model. As a rule of thumb 1 token is approximately 4 characters or 0.75 words
#'   for English text.
#' @param n The number of completions/responses to generate.
#' @param frequency_penalty The frequency penalty to use. It discourages the model from repeating the same text.
#'  A lower value results in the model more likely to repeat information.
#' @param presence_penalty Avoidance of specific topics in response provided in the user messages.
#'   A lower value make the model less concerned about preventing these topics.
#' @inheritParams args_ollama
#'
#' @export
args_openai <- function(api = NULL,
                        format = "none",
                        max_tokens = 100,
                        temperature = 0,
                        top_p = 0.1,
                        n = 1,
                        stop = NULL,
                        presence_penalty = 0.2,
                        frequency_penalty = 1) {
  list(api = api,
       format = format,
       max_tokens = max_tokens,
       temperature = temperature,
       top_p = top_p,
       n = n,
       stop = stop,
       presence_penalty = presence_penalty,
       frequency_penalty = frequency_penalty)
}
