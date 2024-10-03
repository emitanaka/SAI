#' SAI the general assistant
#'
#' @param prompt A list of prompts or text with a prompt.
#' @param model The ollama model name, e.g. `llama3.2:1b` (default), `gemma:7b`, `llama3.1:8b`
#' @param port The port number.
#' @param format The format to use. Default is NA and currently only other option is "json".
#' @param temperature The temperature of the model where higher temperature means higher creativity.
#' @param stop A list of stop sequences to use.
#' @export
sai_assist <- function(prompt = NULL,
                       model = sai_get_option("model"),
                       port = sai_get_option("port"),
                       format = c("none", "json"),
                       tools = NULL,
                       temperature = 0,
                       stop = NA,
                       seed = NA,
                       top_k = 1,
                       top_p = 0.1,
                       num_predict = sai_get_option("num_predict"),
                       keep_alive = "5m",
                       .content_envir = rlang::caller_env(),
                       ...) {

  available_model_list <- ollama_model_list()
  # https://github.com/ollama/ollama#model-library
  if(!model %in% available_model_list) cli::cli_abort("The model {.var {model}} is not available.")

  format <- match.arg(format)

  if(is.null(prompt)) cli::cli_li(c("To get started, provide a prompt."))

  # https://github.com/ollama/ollama/blob/main/docs/api.md#request-reproducible-outputs
  # https://github.com/ollama/ollama/blob/main/docs/modelfile.md#valid-parameters-and-values
  dots <- list(...)
  params <- c(list(model = model,
                   format = ifelse(format == "none", NA, format),
                   stop = stop,
                   keep_alive = keep_alive,
                   tools = tools,
                   options = list(if(!is.na(seed)) seed = seed,
                                  temperature = temperature,
                                  num_predict = num_predict,
                                  top_k = top_k,
                                  top_p = top_p,
                                  dots),
                   raw = TRUE,
                   stream = FALSE))


  if(is.list(prompt) & !is_prompt(prompt)) prompt <- lapply(prompt, function(x) as_prompt(x, .content_envir = .content_envir))
  if(is.character(prompt)) prompt <- lapply(prompt, function(x) prompt_user(x, .content_envir = .content_envir))
  if(is_prompt(prompt)) prompt <-list(prompt)
  msgs <- list(messages = c(prompt,
                            if(format == "json") list(prompt_user("Respond using JSON."))))

  request <- httr2::request(base_url = paste0('http://localhost:', port,'/api/chat'))
  request_with_data <- httr2::req_body_json(request, data = c(params, msgs))
  response <- httr2::req_perform(request_with_data)
  json <- httr2::resp_body_json(response)
  content <- json$message$content
  if(format == "json") {
    tryCatch({
      content <- jsonlite::fromJSON(content)
    }, error = function(e) {
      cli::cli_alert("The response is not in JSON format.")
    })
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

#' @export
sai_yes_no <- function(prompt) {
  if(is.character(prompt)) prompt <- list(prompt_user(prompt))
  out <- sai_assist(c(prompt, list(prompt_user("Answer with 'yes' or 'no'."))),
                    format = "none")
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
