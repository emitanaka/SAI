% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/factor.R
\name{sai_fct_sweep}
\alias{sai_fct_sweep}
\alias{sai_lvl_sweep}
\title{Sweep factor levels to group similar levels together}
\usage{
sai_fct_sweep(
  .f,
  known = NULL,
  wrong = NULL,
  nlevels_max = length(unique(.f)) - length(wrong),
  nlevels_min = length(unique(known)) + 1,
  nlevels_top = round(nlevels_max * 0.25),
  nlevels_bottom = 0,
  n_min = 1L,
  ...
)

sai_lvl_sweep(
  .f,
  known = NULL,
  wrong = NULL,
  nlevels_max = length(unique(.f)) - length(wrong),
  nlevels_min = length(unique(known)) + 1,
  nlevels_top = round(nlevels_max * 0.25),
  nlevels_bottom = 0,
  n_min = 1L,
  ...
)
}
\arguments{
\item{.f}{A factor}

\item{known}{A character vector of the levels that are known to be correct. If none
are provided, it is assumed that no correct values are known. If an element has a name
associated with it, it is assumed that the name is what is recorded and the value is
what the actual label should be.}

\item{wrong}{A character vector of the levels known to be wrong and should be
grouped with another level.}

\item{nlevels_max}{The maximum number of levels.}

\item{nlevels_min}{The minimum number of levels.}

\item{nlevels_top}{The number of levels that are correct based on the top frequencies, excluding
levels that have observations less than \code{n_min}.}

\item{nlevels_bottom}{The number of levels that are incorrect based on the bottom frequencies,
excluding those that have observation less than \code{n_min}.}

\item{n_min}{The minimum of observations for each level. The default is 1.}
}
\description{
This function attempts to automatically standardise input labels that should
have been the same by making a few assumptions. The assumptions include that
the levels with high frequency are correct and low frequency levels may contain
typos or alternative representation of other existing levels.
}
\details{
Be warned that this function is experimental and may not work as intended.
}
\seealso{
\code{\link[=sai_lvl_match]{sai_lvl_match()}}
}
