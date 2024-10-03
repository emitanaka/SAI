
# doesn't work!!

tool_prop <- function(description = "", type = "string", enum = NULL) {
  list(type = type, description = description, enum = enum)
}

tool_parameters <- function(...) {
  dots <- list(...)
  list(type = "object",
       properties = dots,
       required = names(dots))
}

tool_register <- function(name, description, parameters) {
  list(type = "function",
       `function` = list(name = name,
                         description = description,
                         parameters = parameters))
}
