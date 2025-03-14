% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/address.R
\name{emend_clean_address}
\alias{emend_clean_address}
\title{Standardise address format}
\usage{
emend_clean_address(address_vector, chat = NULL)
}
\arguments{
\item{address_vector}{A character vector that is assumed to be addresses.}

\item{chat}{A chat object defined by ellmer.}
}
\description{
This function standardise inconsistent address formats to a standard format.
}
\examples{
# Convert a vector of inconsistent formatted address to a standard format
x <- c("68/150 Acton Road, Acton ACT 2601", "655 Jackson St, Dickson ACT 2602", "Unit 60 523 Joey Cct, Layton NSW 6500", "23/100 de burgh road, Southbank VIC 7800", "999 Lords pl, Sydney nsw 6600", "i don't know the address")
chat <- chat_ollama(model = "llama3.1:8b", seed = 0, echo = "none")
emend_clean_address(x, chat = chat)

}
