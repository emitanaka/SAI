% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/translate.R
\name{sai_is_language}
\alias{sai_is_language}
\title{Determine if the input is a particular language}
\usage{
sai_is_language(text, language = sai_get_option("language"))
}
\arguments{
\item{text}{The text.}

\item{language}{The language to check. The default is "English".}
}
\description{
Determine if the input is a particular language
}
\examples{
sai_is_language(c("猿も木から落ちる", "你好", "bon appetit"),
                language = "Japanese")
}
\seealso{
Other translate: 
\code{\link{sai_translate}()},
\code{\link{sai_what_language}()}
}
\concept{translate}
