context("test-data.R")

test_that("we can read in cas_loss_reserve_db", {

  tri_data_summary <- cas_loss_reserve_db %>% dplyr::group_by(line) %>%
    dplyr::summarise(ct_comp = length(unique(company)))

  full_long_tri <- cas_loss_reserve_db %>% tidyr::unnest(full_long_tri)

  train_data <- cas_loss_reserve_db %>%
    dplyr::mutate(paid_sum_test = purrr::map_dbl(train_tri_set, ~ sum(.x$paid_tri, na.rm = TRUE)),
           case_sum_test = purrr::map_dbl(train_tri_set, ~ sum(.x$case_tri, na.rm = TRUE)),
           ult_sum_test = purrr::map_dbl(train_tri_set, ~ sum(.x$ult_tri, na.rm = TRUE)))

  test_data <- cas_loss_reserve_db %>%
    dplyr::mutate(paid_sum_test = purrr::map_dbl(test_tri_set, ~ sum(.x$paid_tri, na.rm = TRUE)),
           case_sum_test = purrr::map_dbl(test_tri_set, ~ sum(.x$case_tri, na.rm = TRUE)),
           ult_sum_test = purrr::map_dbl(test_tri_set, ~ sum(.x$ult_tri, na.rm = TRUE)))

  expect_equal(nrow(tri_data_summary), 6)
  expect_equal(sum(tri_data_summary$line %in% c("ppauto", "wkcomp", "comauto", "medmal", "prodliab", "othliab")), 6)

  expect_equal(sum(full_long_tri[,7:17]), 12528464178)

  expect_equal(sum(train_data[,7:9]), 2325471056)
  expect_equal(sum(test_data[,7:9]), 2215438647)


})


test_that("we can read in meyers_2016_wintereforum_appendix", {

  data_summary <- meyers_2016_appendix %>% dplyr::group_by(line) %>%
    dplyr::summarise(ct_comp = length(unique(group_id)), ct_obs = n(), avg_sd = mean(`Std Dev`))

  expect_equal(nrow(data_summary), 4)
  expect_equal(sum(data_summary$line %in% c("ppauto", "wkcomp", "comauto", "othliab")), 4)
  expect_equal(sum(data_summary$ct_comp), 200)
  expect_equal(sum(data_summary$avg_sd), 68941.62)

})
