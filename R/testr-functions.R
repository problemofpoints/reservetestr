

#' Back-test MackChainLadder method
#'
#' @param train_data a `triangle` object containing upper left of a loss triangle. Used as input to [ChainLadder::MackChainLadder()].
#' @param test_data a `triangle` object containing the lower right portion of loss triangle. Used to test model estimates.
#' @param loss_type a character indicating whether to use paid, case-incurred, or ultimate loss triangle
#' @param .progress a `Progress` object used to display a text based progress bar. Default is NULL.
#' @param ... additional arguments passed on to [ChainLadder::MackChainLadder()]
#' @return a `tibble` containing the true reserve, estimated mean, estimated coefficient of variation, and the implied
#' percentile of the actual outcome
#' @export
#'
#' @examples
#' train_data <- cas_loss_reserve_db %>%
#'  get_meyers_subset() %>%
#'  purrr::pluck("train_tri_set", 8)
#' test_data <- cas_loss_reserve_db %>%
#'  get_meyers_subset() %>%
#'  purrr::pluck("test_tri_set", 8)
#'
#' testr_mack <- testr_MackChainLadder(train_data, test_data, loss_type = "paid")
testr_MackChainLadder <- function(train_data, test_data, loss_type = c("paid","case","ultimate"), .progress = NULL, ...){

  if ((!is.null(.progress)) && inherits(.progress, "Progress") && (.progress$i < .progress$n)) .progress$tick()$print()

  # extract triangle based on `loss_type`
  loss_type <- match.arg(loss_type, c("paid","case","ultimate"))

  tri <- train_data[[loss_type]]
  tri_test <- test_data[[loss_type]]

  # run method and pull out key results
  method_result <- ChainLadder::MackChainLadder(tri, ...)
  method_se <- summary(method_result)$Totals[5,1]
  method_mean <- summary(method_result)$Totals[4,1]
  method_ultimate <- summary(method_result)$Totals[3,1]

  latest_paid <- sum(ChainLadder::getLatestCumulative(train_data[["paid"]]))
  actual_ultimate <- sum(ChainLadder::getLatestCumulative(tri_test))
  actual_unpaid <- actual_ultimate - latest_paid
  mean_unpaid_est <- method_ultimate - latest_paid

  # calculate implied percentile assuming lognormal distribution for reserves
  params <- .MomentsToParams(list(mean = method_ultimate, cv = method_se / method_ultimate, dist = "lnorm"))
  implied_pctl <- stats::plnorm(actual_ultimate, meanlog = params$meanlog, sdlog = params$sdlog)

  tibble::tibble(actual_ultimate = actual_ultimate,
                 actual_unpaid = actual_unpaid,
                 mean_ultimate_est = method_ultimate,
                 mean_unpaid_est = mean_unpaid_est,
                 stddev_est = method_se,
                 cv_unpaid_est = method_se / mean_unpaid_est,
                 implied_pctl = implied_pctl)

}


#' Back-test BootChainLadder method
#'
#' @param train_data a `triangle` object containing upper left of a loss triangle. Used as input to [ChainLadder::BootChainLadder()].
#' @param test_data a `triangle` object containing the lower right portion of loss triangle. Used to test model estimates.
#' @param loss_type a character indicating whether to use paid, case-incurred, or ultimate loss triangle
#' @param .progress a `Progress` object used to display a text based progress bar. Default is NULL.
#' @param ... additional arguments passed on to [ChainLadder::BootChainLadder()]
#' @return a `tibble` containing the true reserve, estimated mean, estimated coefficient of variation, and the implied
#' percentile of the actual outcome
#' @export
#'
#' @examples
#' train_data <- cas_loss_reserve_db %>%
#'  get_meyers_subset() %>%
#'  purrr::pluck("train_tri_set", 8)
#' test_data <- cas_loss_reserve_db %>%
#'  get_meyers_subset() %>%
#'  purrr::pluck("test_tri_set", 8)
#'
#' testr_bootstrap <- testr_BootChainLadder(train_data, test_data, loss_type = "paid")
testr_BootChainLadder <- function(train_data, test_data, loss_type = c("paid","case","ultimate"), .progress = NULL, ...){

  if ((!is.null(.progress)) && inherits(.progress, "Progress") && (.progress$i < .progress$n)) .progress$tick()$print()

  # extract triangle based on `loss_type`
  loss_type <- match.arg(loss_type, c("paid","case","ultimate"))

  tri <- train_data[[loss_type]]
  tri_test <- test_data[[loss_type]]

  # run method and pull out key results
  method_result <- ChainLadder::BootChainLadder(tri, ...)
  method_se <- summary(method_result)$Totals[4,1]
  method_mean <- summary(method_result)$Totals[3,1]
  method_ultimate <- summary(method_result)$Totals[2,1]

  latest_paid <- sum(ChainLadder::getLatestCumulative(train_data[["paid"]]))
  actual_ultimate <- sum(ChainLadder::getLatestCumulative(tri_test))
  actual_unpaid <- actual_ultimate - latest_paid
  mean_unpaid_est <- method_ultimate - latest_paid

  # calculate implied percentile using bootstrapped samples
  implied_pctl <- sum(method_result$IBNR.Totals <=
                        (actual_ultimate - sum(ChainLadder::getLatestCumulative(tri)))) / length(method_result$IBNR.Totals)

  tibble::tibble(actual_ultimate = actual_ultimate,
                 actual_unpaid = actual_unpaid,
                 mean_ultimate_est = method_ultimate,
                 mean_unpaid_est = mean_unpaid_est,
                 stddev_est = method_se,
                 cv_unpaid_est = method_se / mean_unpaid_est,
                 implied_pctl = implied_pctl)

}


#' Back-test ClarkCapeCode method
#'
#' @param train_data a `triangle` object containing upper left of a loss triangle. Used as input to [ChainLadder::ClarkCapeCod()].
#' @param test_data a `triangle` object containing the lower right portion of loss triangle. Used to test model estimates.
#' @param loss_type a character indicating whether to use paid, case-incurred, or ultimate loss triangle
#' @param .progress a `Progress` object used to display a text based progress bar. Default is NULL.
#' @param ... additional arguments passed on to [ChainLadder::ClarkCapeCod()]
#' @return a `tibble` containing the true reserve, estimated mean, estimated coefficient of variation, and the implied
#' percentile of the actual outcome
#' @export
#'
#' @examples
#' train_data <- cas_loss_reserve_db %>%
#'  get_meyers_subset() %>%
#'  purrr::pluck("train_tri_set", 8)
#' test_data <- cas_loss_reserve_db %>%
#'  get_meyers_subset() %>%
#'  purrr::pluck("test_tri_set", 8)
#'
#' testr_clark <- testr_ClarkCapeCod(train_data, test_data, loss_type = "paid")
testr_ClarkCapeCod <- function(train_data, test_data, loss_type = c("paid","case","ultimate"), .progress = NULL, ...){

  if ((!is.null(.progress)) && inherits(.progress, "Progress") && (.progress$i < .progress$n)) .progress$tick()$print()

  # extract triangle based on `loss_type`
  loss_type <- match.arg(loss_type, c("paid","case","ultimate"))

  tri <- train_data[[loss_type]]
  tri_test <- test_data[[loss_type]]
  premium <- attr(tri, "exposure")

  # run method and pull out key results
  method_result <- ChainLadder::ClarkCapeCod(tri, premium, ...)
  method_se <- summary(method_result)$StdError[nrow(tri)+1]
  method_mean <- summary(method_result)$FutureValue[nrow(tri)+1]
  method_ultimate <- summary(method_result)$UltimateValue[nrow(tri)+1]

  latest_paid <- sum(ChainLadder::getLatestCumulative(train_data[["paid"]]))
  actual_ultimate <- sum(ChainLadder::getLatestCumulative(tri_test))
  actual_unpaid <- actual_ultimate - latest_paid
  mean_unpaid_est <- method_ultimate - latest_paid

  # calculate implied percentile assuming lognormal distribution for reserves
  params <- .MomentsToParams(list(mean = method_ultimate, cv = method_se / method_ultimate, dist = "lnorm"))
  implied_pctl <- stats::plnorm(actual_ultimate, meanlog = params$meanlog, sdlog = params$sdlog)

  tibble::tibble(actual_ultimate = actual_ultimate,
                 actual_unpaid = actual_unpaid,
                 mean_ultimate_est = method_ultimate,
                 mean_unpaid_est = mean_unpaid_est,
                 stddev_est = method_se,
                 cv_unpaid_est = method_se / mean_unpaid_est,
                 implied_pctl = implied_pctl)

}
