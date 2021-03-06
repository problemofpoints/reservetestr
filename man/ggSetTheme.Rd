% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/formatting.R
\name{ggSetTheme}
\alias{ggSetTheme}
\title{Set ggplot2 to use custom color scheme}
\usage{
ggSetTheme()
}
\description{
Use ggplot2's theming facility to set defaults
}
\details{
This function sets the default look (colors, linetypes, etc.) of ggplot2 to
match custom color scheme.  Exhibits not made with ggplot2 will not
be affected.
}
\examples{

ggSetTheme()

}
\seealso{
\code{\link{theme_set}},
\code{\link{update_geom_defaults}},
\code{\link{ggThemeCustom}}
}
