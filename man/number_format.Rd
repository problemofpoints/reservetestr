% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/formatting.R
\name{number_format}
\alias{number_format}
\title{Format number in comma style}
\usage{
number_format(x, digits = 0, ...)
}
\arguments{
\item{x}{numeric vector}

\item{digits}{number of digits to keep}

\item{...}{additional parameters passed to \link{formatC}}
}
\value{
character vector of formatted numbers
}
\description{
Format number in comma style
}
\examples{
number_format(10000.12, digits = 2)

}
