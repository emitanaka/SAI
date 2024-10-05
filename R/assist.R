#' SAI the general assistant
#'
#' @param prompt A list of prompts or text with a prompt.
#' @param model A list of model and vendor name. Use model helpers like `model_ollama()` and `model_openai()`.
#' @export
sai_assist <- function(prompt = NULL,
                       model = sai_get_option("model"),
                       format = model$args$format,
                       .content_envir = rlang::caller_env(),
                       ...) {

  if(is.null(prompt)) cli::cli_alert("To get started, provide a prompt.")
  if(is.list(prompt) & !is_prompt(prompt)) prompt <- lapply(prompt, function(x) as_prompt(x, .content_envir = .content_envir))
  if(is.character(prompt)) prompt <- lapply(prompt, function(x) prompt_user(x, .content_envir = .content_envir))
  if(is_prompt(prompt)) prompt <-list(prompt)
  msgs <- list(messages = c(prompt,
                            if(format == "json") list(prompt_user("Respond using JSON."))))

  # https://github.com/ollama/ollama/blob/main/docs/api.md#request-reproducible-outputs
  # https://github.com/ollama/ollama/blob/main/docs/modelfile.md#valid-parameters-and-values
  dots <- list(...)

  if(model$vendor == "ollama") {
    params <- c(list(model = model$model,
                     format = ifelse(format == "none", NA, format),
                     stop = model$args$stop,
                     keep_alive = model$args$keep_alive,
                     tools = model$args$tools,
                     options = list(if(!is.na(model$args$seed)) seed = model$args$seed,
                                    temperature = model$args$temperature,
                                    num_predict = model$args$num_predict,
                                    top_k = model$args$top_k,
                                    top_p = model$args$top_p,
                                    dots),
                     raw = TRUE,
                     stream = FALSE))

    request <- httr2::request(base_url = paste0('http://localhost:', model$args$port,'/api/chat'))
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

  } else if(model$vendor == "openai") {
    api <- model$args$api %||% Sys.getenv("OPENAI_API_KEY")
    if(api == "") cli::cli_abort("Please set the OPENAI_API_KEY environment variable.")
    request <- httr2::request(base_url = "https://api.openai.com/v1/chat/completions")
    requesth <- httr2::req_headers(request,
                                  'Authorization' = paste('Bearer', api),
                                  'Content-Type' = 'application/json')
    args_parse <- model$args
    args_parse$format <- NULL
    args_parse$api <- NULL
    args_parse$seed <- NULL
    params <- c(list(model = model$model), args_parse, dots)
    request_with_data <- httr2::req_body_json(requesth, data = c(params, msgs))
    response <- httr2::req_perform(request_with_data)
    json <- httr2::resp_body_json(response)
    content <- json$choices[[1]]$message$content
  } else if(model$vendor == "mistral") {
    api <- model$args$api %||% Sys.getenv("MISTRAL_API_KEY")
    if(api == "") cli::cli_abort("Please set the MISTRAL_API_KEY environment variable.")
    request <- httr2::request(base_url = "https://api.mistral.ai/v1/chat/completions")
    requesth <- httr2::req_headers(request,
                                   'Authorization' = paste('Bearer', api),
                                   'Content-Type' = 'application/json',
                                   'Accept' = 'application/json')
    args_parse <- model$args
    args_parse$format <- NULL
    args_parse$api <- NULL
    args_parse$tool_choice <- NULL
    args_parse$tools <- NULL
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
