#' SAI the general assistant
#'
#' @param prompt A list of prompts or text with a prompt.
#' @param model A list of model and vendor name. Use model helpers like `model_ollama()` and `model_openai()`.
#' @param args The arguments for the `model`.
#' @export
sai_assist <- function(prompt = NULL,
                       model = sai_get_option("model"),
                       args = args_model(model$vendor),
                       .content_envir = rlang::caller_env(),
                       ...) {

  if(is.null(prompt)) cli::cli_alert("To get started, provide a prompt.")
  if(is.list(prompt) & !is_prompt(prompt)) prompt <- lapply(prompt, function(x) as_prompt(x, .content_envir = .content_envir))
  if(is.character(prompt)) prompt <- lapply(prompt, function(x) prompt_user(x, .content_envir = .content_envir))
  if(is_prompt(prompt)) prompt <-list(prompt)
  msgs <- list(messages = c(prompt,
                            if(args$format == "json") list(prompt_user("Respond using JSON."))))

  # https://github.com/ollama/ollama/blob/main/docs/api.md#request-reproducible-outputs
  # https://github.com/ollama/ollama/blob/main/docs/modelfile.md#valid-parameters-and-values
  dots <- list(...)

  if(model$vendor == "ollama") {
    params <- c(list(model = model$model,
                     format = ifelse(args$format == "none", NA, args$format),
                     stop = args$stop,
                     keep_alive = args$keep_alive,
                     tools = args$tools,
                     options = list(if(!is.na(args$seed)) seed = args$seed,
                                    temperature = args$temperature,
                                    num_predict = args$num_predict,
                                    top_k = args$top_k,
                                    top_p = args$top_p,
                                    dots),
                     raw = TRUE,
                     stream = FALSE))

    request <- httr2::request(base_url = paste0('http://localhost:', args$port,'/api/chat'))
    request_with_data <- httr2::req_body_json(request, data = c(params, msgs))
    response <- httr2::req_perform(request_with_data)
    json <- httr2::resp_body_json(response)
    content <- json$message$content
    if(args$format == "json") {
      tryCatch({
        content <- jsonlite::fromJSON(content)
      }, error = function(e) {
        cli::cli_alert("The response is not in JSON format.")
      })
    }

  } else if(model$vendor == "openai") {
    api <- args$api %||% Sys.getenv("OPENAI_API_KEY")
    if(api == "") cli::cli_abort("Please set the OPENAI_API_KEY environment variable.")
    request <- httr2::request(base_url = "https://api.openai.com/v1/chat/completions")
    requesth <- httr2::req_headers(request,
                                  'Authorization' = paste('Bearer', api),
                                  'Content-Type' = 'application/json')
    args_parse <- args
    args_parse$format <- NULL
    args_parse$api <- NULL
    params <- c(list(model = model$model), args_parse, dots)
    request_with_data <- httr2::req_body_json(requesth, data = c(params, msgs))
    response <- httr2::req_perform(request_with_data)
    json <- httr2::resp_body_json(response)
    content <- json$choices[[1]]$message$content
  } else {
    cli::cli_abort("Currently the only vendor supported is Ollama and OpenAI.")
  }

  structure(content, class = c("sai", class(content)))
}

#' @export
print.sai <- function(x, ...) {
  if(is.list(x)) {
    print(unclass(x))
  } else if(is.character(x)) {
    cat(x)
  }
  x
}

#' Answer with yes or no
#'
#' @param prompt A prompt.
#' @export
sai_yes_no <- function(prompt) {
  if(is.character(prompt)) prompt <- list(prompt_user(prompt))
  out <- sai_assist(c(prompt, list(prompt_user("Answer with 'yes' or 'no'."))))
  grepl("yes", tolower(out))
}


#' Get the list of ollama models available locally
#'
#' @param port The port number.
#' @export
ollama_model_list <- function(port = sai_get_option("port")) {
  request <- httr2::request(base_url = paste0('http://localhost:', port, '/api/tags'))
  response <- httr2::req_perform(request)
  json <- httr2::resp_body_json(response)
  model_names <- map_chr(json$models, function(x) x$name)
  gsub(":latest$", "", model_names)
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
