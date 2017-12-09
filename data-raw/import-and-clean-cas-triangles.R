
# Import the CAS loss reserve [database](http://www.casact.org/research/index.cfm?fa=loss_reserves_data) and make it tidy.

base_url <- "http://www.casact.org/research/reserve_data/"
lobs <-  c("ppauto", "wkcomp", "comauto", "medmal", "prodliab", "othliab")

import_and_clean_triangles <- function(lob, base_url){

  url <- paste0(base_url, lob, "_pos.csv")

  # import csv and rename columns
  df <- readr::read_csv(url, col_types = "iciiiddddddid", skip = 1,
                 col_names = c("group_id", "company", "acc_yr", "dev_yr", "dev_lag", "cum_incurred_loss", "cum_paid_loss",
                               "bulk_ibnr", "direct_ep", "ceded_ep", "net_ep", "single_entity", "posted_reserve_1997"))

  # add incremental losses
  df <- df %>% dplyr::group_by(group_id, acc_yr) %>% dplyr::arrange(group_id, acc_yr, dev_yr) %>%
    dplyr::mutate(increm_paid_loss = dplyr::if_else(dev_lag != 1, cum_paid_loss - dplyr::lag(cum_paid_loss), cum_paid_loss),
           increm_incurred_loss = dplyr::if_else(dev_lag != 1, cum_incurred_loss - dplyr::lag(cum_incurred_loss), cum_incurred_loss))

  # add lob name
  df <- df %>% dplyr::mutate(line = lob)

  df

}

# loop through list of files and run 'importAndCleanTriangles()'
tri_data <- purrr::map_df(lobs, import_and_clean_triangles, base_url)

cas_loss_reserve_db <- tri_data %>% dplyr::ungroup() %>%
  dplyr::select(line, 1:6, increm_incurred_loss, 7, increm_paid_loss, 8:12,14,13)

# write out data file
devtools::use_data(cas_loss_reserve_db, overwrite = TRUE)

# summary of db
tri_data_summary <- cas_loss_reserve_db %>% dplyr::group_by(line) %>%
  dplyr::summarise(ct_comp = length(unique(company)), ct_acc_yr = length(unique(acc_yr)), ct_obs = n())

knitr::kable(tri_data_summary, format = "pandoc", digits = c(0,0,0,0),
             col.names = c("Line", "Number of companies", "Number of accident years",
                           "Total number of observations"),
             format.args = list(big.mark = ","),
             caption = "Summary of CAS Loss Reserve Database")
