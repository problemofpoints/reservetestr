



#' Create p-p plot
#'
#' @param method_results a `tibble` output from [run_single_method]
#' @param cv_limits a numeric vector with upper and lower bound used to filter estimated CVs. Default is c(0,1)
#' @param by_line a logical. Should graph be facetting by line. Default is TRUE
#' @param confidence_level a numeric value indicating what confidence level to use in graph. Default is 0.95. NOT WORKING!
#'
#' @return a ggplot2 object
#' @export
#'
#' @examples
create_pp_plot <- function(method_results, cv_limits = c(0,1), by_line = TRUE, confidence_level = 0.95){

  if(!("tbl_df" %in% class(method_results))){
    stop("input `loss_data` isn't a tibble`. Please fix.")
  }
  if(!all.equal(names(method_results), c("line","group_id","company","method","actual_ultimate","actual_unpaid","mean_ultimate_est",
                                "mean_unpaid_est", "stddev_est", "cv_unpaid_est", "implied_pctl"))){
    stop("input `method_results` is not a valid output from `reservetestr::run_single_method.")
  }

  method_results_filtered <-  method_results %>%
    filter(!is.na(.data$cv_unpaid_est) & .data$cv_unpaid_est < cv_limits[2] & .data$cv_unpaid_est > cv_limits[1])

  if(by_line){
    method_results_filtered <- group_by(method_results_filtered, .data$line)
  }

  se_line <- summarise(method_results_filtered, n = n(), se = 1.36 / sqrt(n))

  gg_data <- method_results_filtered %>%
    arrange(.data$implied_pctl) %>%
    mutate(fitted = cumsum(rep(1/(n()+1), n()))) %>%
    arrange(.data$line, .data$group_id)

  gg_plot <- ggplot(data = gg_data) +
    geom_abline(colour="#808080", size=0.65) +
    geom_abline(data=se_line, aes(intercept=se, slope=1),
                colour="#808080", size=0.65, linetype=5) +
    geom_abline(data=se_line, aes(intercept=-se, slope=1),
                colour="#808080", size=0.65, linetype=5) +
    geom_point(aes(x = fitted, y = implied_pctl)) +
    xlab("Expected Percentile") + ylab("Predicted Percentile") + #+ scale_y_continuous(labels=NULL)
    ggtitle("PP Plot - Predicted vs. Expected Percentiles", subtitle = paste0("Method: ", method_results_filtered$method[1]))

  if(by_line){
    gg_plot <- gg_plot +
      facet_wrap(~ line)
  }

  gg_plot
}


#' Create histogram
#'
#' @param method_results a `tibble` output from [run_single_method]
#' @param cv_limits a numeric vector with upper and lower bound used to filter estimated CVs. Default is c(0,1)
#' @param by_line a logical. Should graph be facetting by line. Default is TRUE
#' @param bin_number a numeric value giving the number of bins to use in the histogram.
#'
#' @return a ggplot2 object
#' @export
#'
#' @examples
create_histogram_plot <- function(method_results, cv_limits = c(0,1), by_line = TRUE, bin_number = NULL){

  if(!("tbl_df" %in% class(method_results))){
    stop("input `loss_data` isn't a tibble`. Please fix.")
  }
  if(!all.equal(names(method_results), c("line","group_id","company","method","actual_ultimate","actual_unpaid","mean_ultimate_est",
                                         "mean_unpaid_est", "stddev_est", "cv_unpaid_est", "implied_pctl"))){
    stop("input `method_results` is not a valid output from `reservetestr::run_single_method.")
  }

  method_results_filtered <-  method_results %>%
    filter(!is.na(.data$cv_unpaid_est) & .data$cv_unpaid_est < cv_limits[2] & .data$cv_unpaid_est > cv_limits[1])

  if(by_line){
    method_results_filtered <- group_by(method_results_filtered, .data$line)
  }

  gg_data <- method_results_filtered %>%
    arrange(.data$implied_pctl) %>%
    arrange(.data$line, .data$group_id)

  gg_plot <- ggplot(data = gg_data) +
    geom_histogram(aes(x = implied_pctl), bins = bin_number) +
    xlab("Predicted Percentile") +
    ggtitle("Histogram of Predicted Percentiles", subtitle = paste0("Method: ", method_results_filtered$method[1]))

  if(by_line){
    gg_plot <- gg_plot +
      facet_wrap(~ line)
  }

  gg_plot
}

