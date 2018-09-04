
# Import the CAS loss reserve [database](http://www.casact.org/research/index.cfm?fa=loss_reserves_data) and make it tidy.

library(tidyverse)

base_url <- "http://www.casact.org/research/reserve_data/"
lobs <-  c("ppauto", "wkcomp", "comauto", "medmal", "prodliab", "othliab")

# import_and_clean_triangles <- function(lob, base_url){
#
#   url <- paste0(base_url, lob, "_pos.csv")
#
#   # import csv and rename columns
#   df <- readr::read_csv(url, col_types = "iciiiddddddid", skip = 1,
#                  col_names = c("group_id", "company", "acc_yr", "dev_yr", "dev_lag", "cum_incurred_loss", "cum_paid_loss",
#                                "bulk_ibnr", "direct_ep", "ceded_ep", "net_ep", "single_entity", "posted_reserve_1997"))
#
#   # add incremental losses
#   df <- df %>% dplyr::group_by(group_id, acc_yr) %>% dplyr::arrange(group_id, acc_yr, dev_yr) %>%
#     dplyr::mutate(increm_paid_loss = dplyr::if_else(dev_lag != 1, cum_paid_loss - dplyr::lag(cum_paid_loss), cum_paid_loss),
#            increm_incurred_loss = dplyr::if_else(dev_lag != 1, cum_incurred_loss - dplyr::lag(cum_incurred_loss), cum_incurred_loss))
#
#   # add lob name
#   df <- df %>% dplyr::mutate(line = lob)
#
#   df
#
# }

import_and_clean_triangles <- function(lob){

  file_name <- paste0("data-raw/", lob, "_pos.csv")

  # import csv and rename columns
  df <- readr::read_csv(file_name, col_types = "iciiiddddddid", skip = 1,
                        col_names = c("group_id", "company", "acc_yr", "dev_yr", "dev_lag", "cum_incurred_loss", "cum_paid_loss",
                                      "bulk_ibnr", "direct_ep", "ceded_ep", "net_ep", "single_entity", "posted_reserve_1997"))

  # add incremental losses
  df <- df %>% dplyr::group_by(group_id, acc_yr) %>% dplyr::arrange(group_id, acc_yr, dev_yr) %>%
    dplyr::mutate(increm_paid_loss = dplyr::if_else(dev_lag != 1, cum_paid_loss - dplyr::lag(cum_paid_loss), cum_paid_loss),
                  increm_incurred_loss = dplyr::if_else(dev_lag != 1, cum_incurred_loss - dplyr::lag(cum_incurred_loss), cum_incurred_loss),
                  booked_ult_loss = cum_incurred_loss + bulk_ibnr) %>%
    dplyr::ungroup()

  # add lob name
  df <- df %>% dplyr::mutate(line = lob)

  df

}

# loop through list of files and run 'import_and_clean_triangles()'
tri_data <- purrr::map_df(lobs, import_and_clean_triangles)

cas_loss_reserve_db <- tri_data %>%
  dplyr::select(line, 1:6, increm_incurred_loss, 7, increm_paid_loss, booked_ult_loss, 8:12,14,13)

# functions to create triangles from long triangle tibble
make_upper_triangle <- function(long_tri, loss_type){

  long_tri <- long_tri %>%
    dplyr::filter(acc_yr + dev_lag - 1 <= max(acc_yr))

  triangle <- ChainLadder::as.triangle(long_tri, origin = "acc_yr", dev = "dev_lag", value = loss_type)
  exposure <- long_tri %>%
    dplyr::arrange(acc_yr) %>%
    dplyr::distinct(acc_yr, net_ep) %>%
    dplyr::pull(net_ep)

  n_rows <- nrow(triangle)

  if (!is.vector(exposure) | !is.numeric(exposure))
    stop("exposure must be a numeric vector")

  if (length(exposure) == 1)
    exposure <- rep(exposure, n_rows)
  else if (length(exposure) != n_rows)
    stop("length of exposure must either be 1 or equal to nrow(triangle)")

  attr(triangle, "exposure") <- exposure
  triangle

}

make_lower_triangle <- function(long_tri, loss_type){

  long_tri <- long_tri %>%
    dplyr::filter(acc_yr + dev_lag - 1 > max(acc_yr))

  triangle <- ChainLadder::as.triangle(long_tri, origin = "acc_yr", dev = "dev_lag", value = loss_type)

  n_rows <- nrow(triangle)

  triangle

}


cas_loss_reserve_db <- cas_loss_reserve_db %>%
  dplyr::group_by(line, group_id, company) %>%
  tidyr::nest(.key = "full_long_tri") %>%
  dplyr::mutate(train_tri_set = map(full_long_tri, ~ list(paid_tri = make_upper_triangle(.x, "cum_paid_loss"),
                                                     case_tri = make_upper_triangle(.x, "cum_incurred_loss"),
                                                     ult_tri = make_upper_triangle(.x, "booked_ult_loss"))),
                test_tri_set = map(full_long_tri, ~ list(paid_tri = make_lower_triangle(.x, "cum_paid_loss"),
                                                 case_tri = make_lower_triangle(.x, "cum_incurred_loss"),
                                                 ult_tri = make_lower_triangle(.x, "booked_ult_loss"))))


cas_loss_reserve_db$train_tri_set[[10]]

# write out data file
devtools::use_data(cas_loss_reserve_db, overwrite = TRUE)


# summary of db
tri_data_summary <- cas_loss_reserve_db %>% dplyr::group_by(line) %>%
  dplyr::summarise(ct_comp = length(unique(company)))

knitr::kable(tri_data_summary, format = "pandoc",
             col.names = c("Line", "Number of companies"),
             format.args = list(big.mark = ","),
             caption = "Summary of CAS Loss Reserve Database")
