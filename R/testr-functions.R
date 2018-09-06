

#' Back-test MackChainLadder method
#'
#' @param train_data a `triangle` object containing upper left of a loss triangle. Used as input to `ChainLadder::MackChainLadder`.
#' @param test_data a `triangle` object containing the lower right portion of loss triangle. Used to test model estimates.
#' @param loss_type a character indicating whether to use paid, case-incurred, or ultimate loss triangle
#' @param ... additional arguments passed on to `ChainLadder::MackChainLadder`
#'
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
testr_MackChainLadder <- function(train_data, test_data, loss_type = c("paid","case","ultimate"), ...){

  # extract triangle based on `loss_type`
  loss_type <- match.arg(loss_type, c("paid","case","ultimate"))

  tri <- train_data[[loss_type]]
  tri_test <- test_data[[loss_type]]

  # run method and pull out key results
  mack_result <- ChainLadder::MackChainLadder(tri, ...)
  mack_cv <- summary(mack_result)$Totals[6,1]
  mack_se <- summary(mack_result)$Totals[5,1]
  mack_mean <- summary(mack_result)$Totals[4,1]
  mack_ultimate <- summary(mack_result)$Totals[3,1]

  latest_paid <- sum(ChainLadder::getLatestCumulative(train_data[["paid"]]))
  actual_unpaid <- sum(ChainLadder::getLatestCumulative(tri_test)) - latest_paid
  actual_ultimate <- sum(ChainLadder::getLatestCumulative(tri_test))
  mean_unpaid_est <- mack_ultimate - latest_paid

  # calculate implied percentile assuming lognormal distribution for reserves
  params <- .MomentsToParams(list(mean = mack_ultimate, cv = mack_se / mack_ultimate, dist = "lnorm"))
  implied_pctl <- stats::plnorm(actual_ultimate, meanlog = params$meanlog, sdlog = params$sdlog)

  tibble::tibble(actual_ultimate = actual_ultimate,
                 actual_unpaid = actual_unpaid,
                 mean_ultimate_est = mack_ultimate,
                 mean_unpaid_est = mean_unpaid_est,
                 stddev_est = mack_se,
                 cv_unpaid_est = mack_se / mean_unpaid_est,
                 implied_pctl = implied_pctl)

}
