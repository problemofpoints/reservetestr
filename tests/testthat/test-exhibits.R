context("exhibits")

test_that("we can create pp-plot", {

  cas_db_subset <- cas_loss_reserve_db %>%
    get_meyers_subset()

  backtestr_mack_paid <- run_single_backtest(cas_db_subset, testr_MackChainLadder, lines_to_include = "comauto",
                                             loss_type_to_backtest = "paid", method_label = "mack_paid")

  gg_plot <- create_pp_plot(backtestr_mack_paid)

  expect_is(gg_plot, "ggplot")

})


test_that("we can create histogram", {

  cas_db_subset <- cas_loss_reserve_db %>%
    get_meyers_subset()

  backtestr_mack_paid <- run_single_backtest(cas_db_subset, testr_MackChainLadder, lines_to_include = "comauto",
                                             loss_type_to_backtest = "paid", method_label = "mack_paid")

  gg_plot <- create_histogram_plot(backtestr_mack_paid)

  expect_is(gg_plot, "ggplot")

})
