context("backtestr")

test_that("run_single_backtest works as expected on paid triangles using Mack", {

  cas_db_subset <- cas_loss_reserve_db %>%
    get_meyers_subset(edition = 1)

  backtestr_mack_paid <- run_single_backtest(cas_db_subset, testr_MackChainLadder,
                                             loss_type_to_backtest = "paid", method_label = "mack_paid")

  backtestr_mack_paid_wkcomp <- run_single_backtest(cas_db_subset, testr_MackChainLadder, lines_to_include = "wkcomp",
                                             loss_type_to_backtest = "paid", method_label = "mack_paid")


  expect_is(backtestr_mack_paid, "tbl_df")
  expect_equal(sum(backtestr_mack_paid[,5:11]), 321392144, tolerance = 1)

  expect_is(backtestr_mack_paid_wkcomp, "tbl_df")
  expect_equal(sum(backtestr_mack_paid_wkcomp[,5:11]), 28387468, tolerance = 1)

})
