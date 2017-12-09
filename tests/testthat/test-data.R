context("test-data.R")

test_that("we can read in cas_loss_reserve_db", {

  data(cas_loss_reserve_db)

  tri_data_summary <- cas_loss_reserve_db %>% dplyr::group_by(line) %>%
    dplyr::summarise(ct_comp = length(unique(company)), ct_acc_yr = length(unique(acc_yr)), ct_obs = n())

  expect_equal(nrow(tri_data_summary), 6)
  expect_equal(sum(tri_data_summary$line %in% c("ppauto", "wkcomp", "comauto", "medmal", "prodliab", "othliab")), 6)
  expect_equal(sum(tri_data_summary[,2:4]), 78735)

})
