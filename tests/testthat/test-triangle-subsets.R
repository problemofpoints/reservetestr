context("test-triangle-subsets.R")

test_that("we can get Glenn Meyers 200 triangles", {

  tri_subset <- cas_loss_reserve_db %>%
    get_meyers_subset()

  expect_equal(nrow(tri_subset), 20000)
  expect_equal(length(unique(tri_subset$line)), 4)
  expect_equal(sum(tri_subset[,7:14]), 6853898955)

})
