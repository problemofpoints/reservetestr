

#' Run reserve backtest for a single reserving method
#'
#' @param loss_data a nested `tibble` containing loss triangle data. See [cas_loss_reserve_db].
#' @param reserving_function a function that takes as input a loss triangle and outputs estimated reserve
#' @param lines_to_include a character vector with the lines of business to include
#' @param loss_type_to_backtest a character indicating whether to use paid, case-incurred, or ultimate losses
#' @param by_year logical, whether to estimate results by year (TRUE) or in total across all years (FALSE). Default is FALSE.
#' @param to_ultimate logical, whether to estimate results to ultimate (TRUE) or for the next calendar year (FALSE). Default is TRUE.
#' @param method_label a character giving the name given to method. Default is "results"
#' @param ... arguments passed on to the `reserving_function`
#'
#' @return a `tibble` with the results of the method and back-testing results as columns
#' @export
#'
#' @examples
#' data <- cas_loss_reserve_db %>%
#'  get_meyers_subset()
#' data <- data[1:3,]
#'
#' backtest_mack_paid <- run_single_backtest(data, testr_MackChainLadder, lines_to_include = "comauto",
#' method_label = "mack_paid")
#' @importFrom rlang .data
run_single_backtest <- function(loss_data,
                                reserving_function,
                                lines_to_include = c("comauto", "othliab", "ppauto", "wkcomp"),
                                loss_type_to_backtest = c("paid","case","ultimate"),
                                by_year = FALSE,
                                to_ultimate = TRUE,
                                method_label = NULL,
                                ...){

  if(!("data.frame" %in% class(loss_data))){
    stop("input `loss_data` isn't a data.frame. Please fix.")
  }
  # if(tryCatch(rlang::is_function(test_function), error = function(e) TRUE, finally = FALSE)){
  #   stop("input `reserving_function` is not a valid function. Please fix.")
  # }
  if(class(lines_to_include) != "character"){
    stop("input `lines_to_include` is not a character vector")
  }
  lines_to_include <- match.arg(lines_to_include, c("comauto", "othliab", "ppauto", "wkcomp"), several.ok = TRUE)
  loss_type_to_backtest <- match.arg(loss_type_to_backtest, c("paid","case","ultimate"))
  if(class(by_year) != "logical"){
    stop("input `by_year` must be TRUE or FALSE")
  }
  if(class(to_ultimate) != "logical"){
    stop("input `by_year` must be TRUE or FALSE")
  }
  if(!is.null(method_label)){
    if(class(method_label) != "character"){
      stop("input `method_label` must be a character string")
    }
  } else{
    method_label <- "method"
  }

  safe_reserving_function <- purrr::possibly(reserving_function, otherwise = NA_complex_)

  loss_data_filtered <- loss_data %>%
    dplyr::filter(.data$line %in% lines_to_include)

  pb <- dplyr::progress_estimated(nrow(loss_data_filtered))

  output <- loss_data_filtered %>%
    dplyr::mutate(result = purrr::map2(.data$train_tri_set, .data$test_tri_set, safe_reserving_function,
                                       loss_type = loss_type_to_backtest, .progress = pb, ...)) %>%
    dplyr::mutate(method = method_label)

  output <- output %>%
    dplyr::select(c(1:3, 8, 7)) %>%
    dplyr::filter(!is.na(.data$result)) %>%
    tidyr::unnest(.data$result)

  message(paste0(nrow(output), " of ", nrow(loss_data_filtered), " were triangles successfully run."))

  output

}
