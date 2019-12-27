context("testr-functions")

test_that("testr_MackChainLadder works as expected on paid triangles", {

  train_data <- cas_loss_reserve_db %>%
    get_meyers_subset(edition = 1) %>%
    purrr::pluck("train_tri_set", 8)
  test_data <- cas_loss_reserve_db %>%
    get_meyers_subset(edition = 1) %>%
    purrr::pluck("test_tri_set", 8)

  testr_mack <- testr_MackChainLadder(train_data, test_data, loss_type = "paid")

  expect_is(testr_mack, "tbl_df")
  expect_equal(sum(testr_mack), 5292238, tolerance = 1)

})

test_that("testr_MackChainLadder works as expected on case-incurred triangles", {

  train_data <- cas_loss_reserve_db %>%
    get_meyers_subset(edition = 1) %>%
    purrr::pluck("train_tri_set", 8)
  test_data <- cas_loss_reserve_db %>%
    get_meyers_subset(edition = 1) %>%
    purrr::pluck("test_tri_set", 8)

  testr_mack <- testr_MackChainLadder(train_data, test_data, loss_type = "case")

  expect_is(testr_mack, "tbl_df")
  expect_equal(sum(testr_mack), 5212489, tolerance = 1)

})

test_that("testr_BootChainLadder works as expected on paid triangles", {

  train_data <- cas_loss_reserve_db %>%
    get_meyers_subset(edition = 1) %>%
    purrr::pluck("train_tri_set", 8)
  test_data <- cas_loss_reserve_db %>%
    get_meyers_subset(edition = 1) %>%
    purrr::pluck("test_tri_set", 8)

  testr_boot <- testr_BootChainLadder(train_data, test_data, loss_type = "paid")

  expect_is(testr_boot, "tbl_df")
  expect_equal(sum(testr_boot), 5296644, tolerance = 1)

})


test_that("testr_BootChainLadder works as expected on case-incurred triangles", {

  train_data <- cas_loss_reserve_db %>%
    get_meyers_subset(edition = 1) %>%
    purrr::pluck("train_tri_set", 8)
  test_data <- cas_loss_reserve_db %>%
    get_meyers_subset(edition = 1) %>%
    purrr::pluck("test_tri_set", 8)

  testr_boot <- testr_BootChainLadder(train_data, test_data, loss_type = "case")

  expect_is(testr_boot, "tbl_df")
  expect_equal(sum(testr_boot), 6027980, tolerance = 1)

})


test_that("testr_ClarkCapeCod works as expected on paid triangles", {

  train_data <- cas_loss_reserve_db %>%
    get_meyers_subset(edition = 1) %>%
    purrr::pluck("train_tri_set", 8)
  test_data <- cas_loss_reserve_db %>%
    get_meyers_subset(edition = 1) %>%
    purrr::pluck("test_tri_set", 8)

  testr <- testr_ClarkCapeCod(train_data, test_data, loss_type = "paid", maxage = 10)

  expect_is(testr, "tbl_df")
  expect_equal(sum(testr), 5455303, tolerance = 1)

})

test_that("testr_ClarkCapeCod works as expected on case-incurred triangles", {

  train_data <- cas_loss_reserve_db %>%
    get_meyers_subset(edition = 1) %>%
    purrr::pluck("train_tri_set", 8)
  test_data <- cas_loss_reserve_db %>%
    get_meyers_subset(edition = 1) %>%
    purrr::pluck("test_tri_set", 8)

  testr <- testr_ClarkCapeCod(train_data, test_data, loss_type = "case", maxage = 10)

  expect_is(testr, "tbl_df")
  expect_equal(sum(testr), 5169754, tolerance = 1)

})
