context("test-data.R")

test_that("we can read in cas_loss_reserve_db", {

  tri_data_summary <- cas_loss_reserve_db %>% dplyr::group_by(line) %>%
    dplyr::summarise(ct_comp = length(unique(company)))

  full_long_tri <- cas_loss_reserve_db %>% tidyr::unnest(full_long_tri)

  train_data <- cas_loss_reserve_db %>%
    dplyr::mutate(paid_sum_test = purrr::map_dbl(train_tri_set, ~ sum(.x$paid, na.rm = TRUE)),
           case_sum_test = purrr::map_dbl(train_tri_set, ~ sum(.x$case, na.rm = TRUE)),
           ult_sum_test = purrr::map_dbl(train_tri_set, ~ sum(.x$ultimate, na.rm = TRUE)))

  test_data <- cas_loss_reserve_db %>%
    dplyr::mutate(paid_sum_test = purrr::map_dbl(test_tri_set, ~ sum(.x$paid, na.rm = TRUE)),
           case_sum_test = purrr::map_dbl(test_tri_set, ~ sum(.x$case, na.rm = TRUE)),
           ult_sum_test = purrr::map_dbl(test_tri_set, ~ sum(.x$ultimate, na.rm = TRUE)))

  expect_equal(nrow(tri_data_summary), 6)
  expect_equal(sum(tri_data_summary$line %in% c("ppauto", "wkcomp", "comauto", "medmal", "prodliab", "othliab")), 6)

  expect_equal(sum(full_long_tri[,7:17]), 12276726887)

  expect_equal(sum(train_data[,7:9]), 2105912184)
  expect_equal(sum(test_data[,7:9]), 2218097678)


})


test_that("we can read in meyers_2016_wintereforum_appendix", {

  data_summary <- meyers_2016_appendix %>% dplyr::group_by(line) %>%
    dplyr::summarise(ct_comp = length(unique(group_id)), ct_obs = n(), avg_sd = mean(`Std Dev...5`))

  expect_equal(nrow(data_summary), 4)
  expect_equal(sum(data_summary$line %in% c("ppauto", "wkcomp", "comauto", "othliab")), 4)
  expect_equal(sum(data_summary$ct_comp), 200)
  expect_equal(sum(data_summary$avg_sd), 68941.62)

})


test_that("we can read in meyers_2019_appendix", {

  data_summary <- meyers_2019_appendix %>%
    dplyr::mutate(check = purrr::map_dbl(data, ~ .x %>% dplyr::summarise_if(is.numeric, sum, na.rm = TRUE) %>% sum(.)))

  expect_equal(nrow(meyers_2019_appendix), 15)
  expect_equal(sum(data_summary$check), 9445708668)
  expect_equal(nrow(meyers_2019_appendix$data[[1]]), 200)

})
