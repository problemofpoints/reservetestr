context("test-triangle-subsets.R")

test_that("we can get Glenn Meyers 200 triangles - second edition", {

  tri_subset <- cas_loss_reserve_db %>%
    get_meyers_subset(edition = 2)

  full_long_tri <- tri_subset %>% tidyr::unnest(full_long_tri)

  train_data <- tri_subset %>%
    dplyr::mutate(paid_sum_test = purrr::map_dbl(train_tri_set, ~ sum(.x$paid, na.rm = TRUE)),
                  case_sum_test = purrr::map_dbl(train_tri_set, ~ sum(.x$case, na.rm = TRUE)),
                  ult_sum_test = purrr::map_dbl(train_tri_set, ~ sum(.x$ultimate, na.rm = TRUE)))

  test_data <- tri_subset %>%
    dplyr::mutate(paid_sum_test = purrr::map_dbl(test_tri_set, ~ sum(.x$paid, na.rm = TRUE)),
                  case_sum_test = purrr::map_dbl(test_tri_set, ~ sum(.x$case, na.rm = TRUE)),
                  ult_sum_test = purrr::map_dbl(test_tri_set, ~ sum(.x$ultimate, na.rm = TRUE)))

  expect_equal(nrow(tri_subset), 200)
  expect_equal(length(unique(tri_subset$line)), 4)

  expect_equal(sum(full_long_tri[,7:17]), 11056816781)

  expect_equal(sum(train_data[,7:9]), 2157032747)
  expect_equal(sum(test_data[,7:9]), 2075320634)

  expect_error(cas_loss_reserve_db %>% get_meyers_subset(edition = "blah"))
})

test_that("we can get Glenn Meyers 200 triangles - first edition", {

  tri_subset <- cas_loss_reserve_db %>%
    get_meyers_subset(edition = 1)

  full_long_tri <- tri_subset %>% tidyr::unnest(full_long_tri)

  train_data <- tri_subset %>%
    dplyr::mutate(paid_sum_test = purrr::map_dbl(train_tri_set, ~ sum(.x$paid, na.rm = TRUE)),
                  case_sum_test = purrr::map_dbl(train_tri_set, ~ sum(.x$case, na.rm = TRUE)),
                  ult_sum_test = purrr::map_dbl(train_tri_set, ~ sum(.x$ultimate, na.rm = TRUE)))

  test_data <- tri_subset %>%
    dplyr::mutate(paid_sum_test = purrr::map_dbl(test_tri_set, ~ sum(.x$paid, na.rm = TRUE)),
                  case_sum_test = purrr::map_dbl(test_tri_set, ~ sum(.x$case, na.rm = TRUE)),
                  ult_sum_test = purrr::map_dbl(test_tri_set, ~ sum(.x$ultimate, na.rm = TRUE)))

  expect_equal(nrow(tri_subset), 200)
  expect_equal(length(unique(tri_subset$line)), 4)

  expect_equal(sum(full_long_tri[,7:17]), 10923689866)

  expect_equal(sum(train_data[,7:9]), 2138199836)
  expect_equal(sum(test_data[,7:9]), 2053260013)

})

