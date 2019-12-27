



#' Create p-p plot
#'
#' @param method_results a `tibble` output from [run_single_backtest()]
#' @param cv_limits a numeric vector with upper and lower bound used to filter estimated CVs. Default is c(0,1)
#' @param by_line a logical. Should graph be faceting by line. Default is TRUE
#' @param confidence_level a numeric value indicating what confidence level to use in graph. Default is 0.95. NOT WORKING!
#'
#' @return a ggplot2 object
#' @export
#'
create_pp_plot <- function(method_results, cv_limits = c(0,1), by_line = TRUE, confidence_level = 0.95){

  if(!("tbl_df" %in% class(method_results))){
    stop("input `loss_data` isn't a tibble`. Please fix.")
  }
  if(!all.equal(names(method_results), c("line","group_id","company","method","actual_ultimate","actual_unpaid","mean_ultimate_est",
                                "mean_unpaid_est", "stddev_est", "cv_unpaid_est", "implied_pctl"))){
    stop("input `method_results` is not a valid output from `reservetestr::run_single_method.")
  }

  method_results_filtered <-  method_results %>%
    dplyr::filter(!is.na(.data$cv_unpaid_est) & .data$cv_unpaid_est < cv_limits[2] & .data$cv_unpaid_est > cv_limits[1])

  if(by_line){
    method_results_filtered <- dplyr::group_by(method_results_filtered, .data$line)
  }

  se_line <- dplyr::summarise(method_results_filtered, n = dplyr::n(), se = 1.36 / sqrt(dplyr::n()))

  gg_data <- method_results_filtered %>%
    dplyr::arrange(.data$implied_pctl) %>%
    dplyr::mutate(fitted = cumsum(rep(1/(dplyr::n()+1), dplyr::n()))) %>%
    dplyr::arrange(.data$line, .data$group_id)

  gg_plot <- ggplot2::ggplot(data = gg_data) +
    ggplot2::geom_abline(colour="#808080", size=0.65) +
    ggplot2::geom_abline(data=se_line, ggplot2::aes(intercept=.data$se, slope=1),
                colour="#808080", size=0.65, linetype=5) +
    ggplot2::geom_abline(data=se_line, ggplot2::aes(intercept=-.data$se, slope=1),
                colour="#808080", size=0.65, linetype=5) +
    ggplot2::geom_point(ggplot2::aes(x = .data$fitted, y = .data$implied_pctl)) +
    ggplot2::xlab("Expected Percentile") + ggplot2::ylab("Predicted Percentile") + #+ scale_y_continuous(labels=NULL)
    ggplot2::ggtitle("PP Plot - Predicted vs. Expected Percentiles", subtitle = paste0("Method: ", method_results_filtered$method[1]))

  if(by_line){
    gg_plot <- gg_plot +
      ggplot2::facet_wrap(.data$line)
  }

  gg_plot
}


#' Create histogram
#'
#' @param method_results a `tibble` output from [run_single_backtest()]
#' @param cv_limits a numeric vector with upper and lower bound used to filter estimated CVs. Default is c(0,1)
#' @param by_line a logical. Should graph be facetting by line. Default is TRUE
#' @param bin_number a numeric value giving the number of bins to use in the histogram.
#'
#' @return a ggplot2 object
#' @export
#'
create_histogram_plot <- function(method_results, cv_limits = c(0,1), by_line = TRUE, bin_number = NULL){

  if(!("tbl_df" %in% class(method_results))){
    stop("input `loss_data` isn't a tibble`. Please fix.")
  }
  if(!all.equal(names(method_results), c("line","group_id","company","method","actual_ultimate","actual_unpaid","mean_ultimate_est",
                                         "mean_unpaid_est", "stddev_est", "cv_unpaid_est", "implied_pctl"))){
    stop("input `method_results` is not a valid output from `reservetestr::run_single_method.")
  }

  method_results_filtered <-  method_results %>%
    dplyr::filter(!is.na(.data$cv_unpaid_est) & .data$cv_unpaid_est < cv_limits[2] & .data$cv_unpaid_est > cv_limits[1])

  if(by_line){
    method_results_filtered <- dplyr::group_by(method_results_filtered, .data$line)
  }

  gg_data <- method_results_filtered %>%
    dplyr::arrange(.data$implied_pctl) %>%
    dplyr::arrange(.data$line, .data$group_id)

  gg_plot <- ggplot2::ggplot(data = gg_data) +
    ggplot2::geom_histogram(ggplot2::aes(x = .data$implied_pctl), bins = bin_number) +
    ggplot2::xlab("Predicted Percentile") +
    ggplot2::ggtitle("Histogram of Predicted Percentiles", subtitle = paste0("Method: ", method_results_filtered$method[1]))

  if(by_line){
    gg_plot <- gg_plot +
      ggplot2::facet_wrap(.data$line)
  }

  gg_plot
}

