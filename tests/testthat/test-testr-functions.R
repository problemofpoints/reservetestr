context("testr-functions")

test_that("testr_MackChainLadder works as expected on paid triangles", {

  train_data <- cas_loss_reserve_db %>%
    get_meyers_subset() %>%
    purrr::pluck("train_tri_set", 8)
  test_data <- cas_loss_reserve_db %>%
    get_meyers_subset() %>%
    purrr::pluck("test_tri_set", 8)

  testr_mack <- testr_MackChainLadder(train_data, test_data, loss_type = "paid")

  expect_is(testr_mack, "tbl_df")
  expect_equal(sum(testr_mack), 5292238, tolerance = 1)

})

test_that("testr_MackChainLadder works as expected on case-incurred triangles", {

  train_data <- cas_loss_reserve_db %>%
    get_meyers_subset() %>%
    purrr::pluck("train_tri_set", 8)
  test_data <- cas_loss_reserve_db %>%
    get_meyers_subset() %>%
    purrr::pluck("test_tri_set", 8)

  testr_mack <- testr_MackChainLadder(train_data, test_data, loss_type = "case")

  expect_is(testr_mack, "tbl_df")
  expect_equal(sum(testr_mack), 5212489, tolerance = 1)

})
