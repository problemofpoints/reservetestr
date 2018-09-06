####
# Miscellaneous formatting functions ====
#  functions to format tables and graphs
# ===


#' Default Color Scheme
#'
#' List of default custom colors
#'
#' Convenience list of colors in #RGB format.  Just type
#' names(custom_colors) to see the list of colors included.
#'
#' @examples
#'
#' \dontrun{ggplot() + geom_line(aes(x=-5:5, y=(-5:5)^2), colour=custom_colors$gold)}
#'
#' @export
custom_colors <- list(blue="#0083A9",
                   brown="#4F4525",
                   cream="#D3CD88",
                   darkblue="#0039A6",
                   darkcream="#7E7830",
                   darkgray="#808080",
                   darkgreen="#3E5B00",
                   gold="#F0AB00",
                   green="#7AB800",
                   lightblue="#5EB6E4",
                   lightergray="#F2F2F2",
                   lightgray="#BFBFBF",
                   lightpurple="#BC5FCD",
                   maroon="#822433",
                   midnightblue="#003F72",
                   purple="#6E267B",
                   red="#E11B22",
                   teal="#0083A9",
                   yellow="#FFE600")

#' Custom ggplot2 theme
#'
#' Use ggplot2's theming facility to set defaults
#'
#' This function sets the default look (colors, linetypes, etc.) of ggplot2 to
#' match color scheme.  Exhibits not made with ggplot2 will not
#' be affected.
#'
#' @param base_size default font size
#' @param base_family font family to use. Default is "sans".
#'
#' @seealso \code{\link{theme_bw}}, \code{\link{theme_set}}
#' @examples
#'
#' ggThemeCustom()
#'
#' @export
ggThemeCustom <- function(base_size=12, base_family="sans") {
  (ggplot2::theme_bw(base_size=base_size, base_family=base_family)
   + ggplot2::theme(panel.border=ggplot2::element_blank(),
                    plot.background = ggplot2::element_blank(),
                    panel.background = ggplot2::element_blank(),
                    axis.line=ggplot2::element_line(colour="black"),
                    panel.grid.major=ggplot2::element_line(
                      color=custom_colors$lightergray, linetype="dashed"),
                    panel.grid.major.x=ggplot2::element_blank(),
                    panel.grid.minor=ggplot2::element_line(),
                    panel.grid.minor.x=ggplot2::element_blank(),
                    panel.grid.minor.y=ggplot2::element_blank(),
                    strip.background=ggplot2::element_rect(colour="white", size=0.5),
                    legend.key=ggplot2::element_blank(),
                    strip.text=ggplot2::element_text(color = custom_colors$teal),
                    axis.line.x=ggplot2::element_line(
                      color=custom_colors$lightgray, size=0.5),
                    axis.line.y=ggplot2::element_line(
                      color=custom_colors$lightgray, size=0.5),
                    axis.ticks=ggplot2::element_line(
                      color=custom_colors$lightgray),
                    plot.title = ggplot2::element_text(hjust = 0, size = 11,
                                                       color = custom_colors$teal)))
}

#' Set ggplot2 to use custom color scheme
#'
#' Use ggplot2's theming facility to set defaults
#'
#' This function sets the default look (colors, linetypes, etc.) of ggplot2 to
#' match custom color scheme.  Exhibits not made with ggplot2 will not
#' be affected.
#'
#' @seealso
#' \code{\link{theme_set}},
#' \code{\link{update_geom_defaults}},
#' \code{\link{ggThemeCustom}}
#' @examples
#'
#' ggSetTheme()
#'
#' @export
ggSetTheme <- function() {
  ggplot2::update_geom_defaults("point", list(colour=custom_colors$teal, size=1.5))
  ggplot2::update_geom_defaults("line", list(colour=custom_colors$teal, size=1))
  ggplot2::update_geom_defaults("abline", list(colour="black", size=1))
  ggplot2::update_geom_defaults("hline", list(colour="black", size=1))
  ggplot2::update_geom_defaults("smooth", list(colour=custom_colors$red))
  ggplot2::update_geom_defaults("bar",
                                list(colour="white", fill=custom_colors$teal))
  ggplot2::update_geom_defaults("col",
                                list(colour="white", fill=custom_colors$teal))
  ggplot2::update_geom_defaults("boxplot",
                                list(colour="white", fill=custom_colors$teal))
  ggplot2::update_geom_defaults("hline",
                                list(colour=custom_colors$darkgray, size=1.0))
  ggplot2::update_geom_defaults("vline",
                                list(colour=custom_colors$darkgray, size=1.0))

  ggplot2::theme_set(ggThemeCustom())
}


#' Format number in comma style
#'
#' @param x numeric vector
#' @param digits number of digits to keep
#' @param ... additional parameters passed to [formatC]
#'
#' @return character vector of formatted numbers
#' @export
#'
#' @examples
#' number_format(10000.12, digits = 2)
#'
number_format <- function(x, digits = 0, ...){

  stopifnot(is.numeric(x))

  formatC(x, big.mark = ",", digits = digits, format = "f", ...)

}

#' Format number in percent style
#'
#' @param x numeric vector
#' @param digits number of digits to keep
#' @param ... additional parameters passed to [formatC]
#'
#' @return character vector of formatted percentages
#' @export
#'
#' @examples
#' pct_format(0.8546, digits = 2)
#'
pct_format <- function(x, digits = 2, ...){

  stopifnot(is.numeric(x))

  paste0(number_format(x * 100, digits = digits, ...), "%")

}
