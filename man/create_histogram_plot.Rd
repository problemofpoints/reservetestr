% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/exhibits.R
\name{create_histogram_plot}
\alias{create_histogram_plot}
\title{Create histogram}
\usage{
create_histogram_plot(
  method_results,
  cv_limits = c(0, 1),
  by_line = TRUE,
  bin_number = NULL
)
}
\arguments{
\item{method_results}{a \code{tibble} output from \code{\link[=run_single_backtest]{run_single_backtest()}}}

\item{cv_limits}{a numeric vector with upper and lower bound used to filter estimated CVs. Default is c(0,1)}

\item{by_line}{a logical. Should graph be facetting by line. Default is TRUE}

\item{bin_number}{a numeric value giving the number of bins to use in the histogram.}
}
\value{
a ggplot2 object
}
\description{
Create histogram
}
