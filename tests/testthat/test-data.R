context("test-data.R")

test_that("we can read in cas_loss_reserve_db", {

  tri_data_summary <- cas_loss_reserve_db %>% dplyr::group_by(line) %>%
    dplyr::summarise(ct_comp = length(unique(company)), ct_acc_yr = length(unique(acc_yr)), ct_obs = n())

  expect_equal(nrow(tri_data_summary), 6)
  expect_equal(sum(tri_data_summary$line %in% c("ppauto", "wkcomp", "comauto", "medmal", "prodliab", "othliab")), 6)
  expect_equal(sum(tri_data_summary[,2:4]), 78735)

})


test_that("we can read in meyers_2016_wintereforum_appendix", {

  data_summary <- meyers_2016_appendix %>% dplyr::group_by(line) %>%
    dplyr::summarise(ct_comp = length(unique(group_id)), ct_obs = n(), avg_sd = mean(`Std Dev`))

  expect_equal(nrow(data_summary), 4)
  expect_equal(sum(data_summary$line %in% c("ppauto", "wkcomp", "comauto", "othliab")), 4)
  expect_equal(sum(data_summary$ct_comp), 200)
  expect_equal(sum(data_summary$avg_sd), 68941.62)

})
