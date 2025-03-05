

emend_standardise_units <- function(x, unit = "", ...) {
  emend_assist(c(list("Standardise the unit in {x*} to {unit}. If unknown, return NA. Return a vector."), list(...)), format = "json")[[1]]
}
