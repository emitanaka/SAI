#' Create a list of model and vendor
#'
#' @param model The name of the model
#' @param vendor The name of the vendor
#' @family large-lanugage-models
#' @export
model_vendor <- function(model, vendor, ...) {
  get(paste0("model_", vendor))(model, ...)
}

#' Set the Ollama model
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
#' @family large-lanugage-models
#' @export
model_ollama <- function(model = 'llama3.1:8b',
                         port = 11434,
                         format = c("none", "json"),
                         tools = NULL,
                         temperature = 0,
                         stop = NA,
                         seed = NA,
                         top_k = 1,
                         top_p = 0.1,
                         num_predict = 1000,
                         keep_alive = "5m",
                         .check_model_availability = TRUE) {
  format <- match.arg(format)
  if(.check_model_availability) {
    available_model_list <- ollama_model_list()
    # https://github.com/ollama/ollama#model-library
    abort_if_model_not_available(model, "ollama", available_model_list)
  }
  list(model = model, vendor = "ollama",
       args = list(port = port,
                   format = format,
                   tools = tools,
                   temperature = temperature,
                   stop = stop,
                   seed = seed,
                   top_k = top_k,
                   top_p = top_p,
                   num_predict = num_predict,
                   keep_alive = keep_alive))
}


#' Set an OpenAI model
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
#' @inheritParams model_ollama
#' @family large-lanugage-models
#' @export
model_openai <- function(model = "gpt-4o-mini",
                         api = NULL,
                         seed = NA,
                         format = "none",
                         max_tokens = 100,
                         temperature = 0,
                         top_p = 0.1,
                         n = 1,
                         stop = NULL,
                         presence_penalty = 0.2,
                         frequency_penalty = 1) {
  available_model_list <- openai_model_list()
  abort_if_model_not_available(model, 'openai', available_model_list)
  list(model = model, vendor = "openai",
       args = list(api = api,
                   seed = seed,
                   format = format,
                   max_tokens = max_tokens,
                   temperature = temperature,
                   top_p = top_p,
                   n = n,
                   stop = stop,
                   presence_penalty = presence_penalty,
                   frequency_penalty = frequency_penalty))
}

#' Set a model from Mistral AI
#'
#' @param min_tokens The minimum number of tokens to generate.
#' @param safe_prompt Whether to use safe prompt or not.
#' @param tools The list of tools. Not implemented.
#' @param tool_choice The choice of tool. Not implemented.
#' @inheritParams model_openai
#' @family large-lanugage-models
#' @export
model_mistral <- function(model = "open-mistral-7b",
                          temperature = 0,
                          top_p = 0.1,
                          max_tokens = 100,
                          min_tokens = 0,
                          stop = NULL,
                          seed = NA,
                          format = "none",
                          safe_prompt = FALSE,
                          tools = NULL,
                          tool_choice = "auto") {
  abort_if_model_not_available(model, 'mistral', mistral_model_list())
  list(model = model, vendor = "mistral",
       args = list(temperature = temperature,
                   top_p = top_p,
                   max_tokens = max_tokens,
                   min_tokens = min_tokens,
                   format = format,
                   stop = stop,
                   random_seed = seed,
                   tools = tools,
                   stream = FALSE,
                   safe_prompt = safe_prompt,
                   tool_choice = tool_choice,
                   response_format = switch(format,
                                            none = list(type = "text"),
                                            json = list(type = "json_object"))))
}




#' Get the list of ollama models available locally
#'
#' @param port The port number.
#' @export
ollama_model_list <- function(port = sai_get_option("model")$args$port) {
  request <- httr2::request(base_url = paste0('http://localhost:', port, '/api/tags'))
  response <- httr2::req_perform(request)
  json <- httr2::resp_body_json(response)
  model_names <- map_chr(json$models, function(x) x$name)
  gsub(":latest$", "", model_names)
}

#' Get the list of Mistral AI models
#'
#' @param api The Mistral AI API key.
#' @export
mistral_model_list <- function(api = NULL) {
  api <- api %||% Sys.getenv("MISTRAL_API_KEY")
  request <- httr2::request(base_url = 'https://api.mistral.ai/v1/models')
  requesth <- httr2::req_headers(request,
                                 'Authorization' = paste('Bearer', api))
  response <- httr2::req_perform(requesth)
  json <- httr2::resp_body_json(response)
  unique(map_chr(json$data, function(x) x$name))
}


#' Get the list of OpenAI models
#'
#' @param api The OpenAI API key. Provide "none" to get the list without an API key.
#' @export
openai_model_list <- function(api = NULL) {
  # Last extracted 2024-10-05
  models <- c("gpt-4o-realtime-preview-2024-10-01", "chatgpt-4o-latest",
              "dall-e-2", "tts-1", "tts-1-1106", "gpt-4-0125-preview", "gpt-3.5-turbo-0125",
              "gpt-4o-2024-05-13", "gpt-4-turbo-preview", "gpt-3.5-turbo",
              "whisper-1", "gpt-4-turbo", "gpt-3.5-turbo-16k", "text-embedding-3-small",
              "gpt-3.5-turbo-1106", "tts-1-hd", "tts-1-hd-1106", "gpt-3.5-turbo-instruct-0914",
              "gpt-4-0613", "gpt-4o-2024-08-06", "gpt-4", "gpt-3.5-turbo-instruct",
              "gpt-4-1106-preview", "babbage-002", "davinci-002", "dall-e-3",
              "gpt-4o", "gpt-4-turbo-2024-04-09", "text-embedding-ada-002",
              "gpt-4o-mini", "gpt-4o-realtime-preview", "text-embedding-3-large",
              "gpt-4o-mini-2024-07-18")

  if(!is.null(api) && api == "none") {
    cli::cli_alert("The list of OpenAI models below was last extracted in 2024-10-05 so may not be up-to-date.")
    return(models)
  }

  api <- api %||% Sys.getenv("OPENAI_API_KEY")
  request <- httr2::request(base_url = 'https://api.openai.com/v1/models')
  requesth <- httr2::req_headers(request,
                                 'Authorization' = paste('Bearer', api))
  response <- httr2::req_perform(requesth)
  json <- httr2::resp_body_json(response)
  map_chr(json$data, function(x) x$id)
}

