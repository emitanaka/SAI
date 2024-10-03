force_base64_encoding <- function(x) {
  if(!is_base64(x)) x <- base64enc::base64encode(x)
  x
}

is_base64 <- function(x) {
  # https://stackoverflow.com/questions/8571501/how-to-check-whether-a-string-is-base64-encoded-or-not
  grepl("^([A-Za-z0-9+/]{4})*([A-Za-z0-9+/]{3}=|[A-Za-z0-9+/]{2}==)?$", x)
}


sai_describe_image <- function(x) {

}
